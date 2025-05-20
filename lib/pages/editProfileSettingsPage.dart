
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs_projesi/utility_classes/app_colors.dart';

class EditProfileSettingsPage extends StatefulWidget {
  const EditProfileSettingsPage({super.key});

  @override
  State<EditProfileSettingsPage> createState() => _EditProfileSettingsPageState();
}

class _EditProfileSettingsPageState extends State<EditProfileSettingsPage> {
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  final _ageController = TextEditingController();
  final List<String> _favoriteActivities = [];
  final List<String> _favoritePlaces = [];
  File? _selectedImage;
  String? _photoUrl;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    if (doc.exists) {
      final data = doc.data()!;
      setState(() {
        _nameController.text = data['name'] ?? '';
        _bioController.text = data['bio'] ?? '';
        _ageController.text = data['age']?.toString() ?? '';
        _favoriteActivities.addAll(List<String>.from(data['favoriteActivities'] ?? []));
        _favoritePlaces.addAll(List<String>.from(data['favoritePlaces'] ?? []));
        _photoUrl = data['profilePhotoUrl'];
      });
    }
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
      });
    }
  }

  Future<void> _saveChanges() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    String? downloadUrl = _photoUrl;
    if (_selectedImage != null) {
      final ref = FirebaseStorage.instance.ref('profile_photos/${user.uid}.jpg');
      await ref.putFile(_selectedImage!);
      downloadUrl = await ref.getDownloadURL();
    }

    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'name': _nameController.text.trim(),
      'bio': _bioController.text.trim(),
      'age': int.tryParse(_ageController.text.trim()),
      'favoriteActivities': _favoriteActivities,
      'favoritePlaces': _favoritePlaces,
      'profilePhotoUrl': downloadUrl,
    }, SetOptions(merge: true));

    Navigator.pop(context); // Go back to settings
  }

  void _showMultiChoiceDialog(String title, List<String> options, List<String> targetList) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: Column(
              children: options.map((item) => CheckboxListTile(
                value: targetList.contains(item),
                onChanged: (bool? selected) {
                  setState(() {
                    if (selected == true && !targetList.contains(item)) {
                      targetList.add(item);
                    } else if (selected == false) {
                      targetList.remove(item);
                    }
                  });
                  Navigator.pop(context);
                  _showMultiChoiceDialog(title, options, targetList);
                },
                title: Text(item),
              )).toList(),
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Done'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  final _activityOptions = ['Stargazing', 'Hiking', 'Mountain Climbing', 'Swimming', 'Beach cleaning'];
  final _placeOptions = ['Forests', 'Mountains', 'Beaches', 'Parks', 'Lakes'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: _selectedImage != null
                      ? FileImage(_selectedImage!)
                      : (_photoUrl != null && _photoUrl!.isNotEmpty
                      ? NetworkImage(_photoUrl!)
                      : const AssetImage('assets/profile_photos/icon.jpg')) as ImageProvider,
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildLabel('Name:'),
            TextField(controller: _nameController),
            const SizedBox(height: 10),
            _buildLabel('Bio:'),
            TextField(controller: _bioController, maxLines: 3),
            const SizedBox(height: 10),
            _buildLabel('Age:'),
            TextField(controller: _ageController, keyboardType: TextInputType.number),
            const SizedBox(height: 20),
            _buildLabel('Favorite Activities:'),
            Wrap(
              children: _favoriteActivities
                  .map((e) => Chip(
                label: Text(e),
                deleteIcon: const Icon(Icons.close),
                onDeleted: () => setState(() => _favoriteActivities.remove(e)),
              ))
                  .toList(),
            ),
            ElevatedButton(
              onPressed: () => _showMultiChoiceDialog('Activities', _activityOptions, _favoriteActivities),
              child: const Text('Edit Activities'),
            ),
            const SizedBox(height: 20),
            _buildLabel('Favorite Places:'),
            Wrap(
              children: _favoritePlaces
                  .map((e) => Chip(
                label: Text(e),
                deleteIcon: const Icon(Icons.close),
                onDeleted: () => setState(() => _favoritePlaces.remove(e)),
              ))
                  .toList(),
            ),
            ElevatedButton(
              onPressed: () => _showMultiChoiceDialog('Places', _placeOptions, _favoritePlaces),
              child: const Text('Edit Places'),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: _saveChanges,
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.green),
                child: const Text('Save Changes', style: TextStyle(color: Colors.black)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontFamily: 'RobotoSerif',
        fontSize: 16,
      ),
    );
  }
}
