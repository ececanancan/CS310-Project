import 'package:flutter/material.dart';
import 'package:cs_projesi/pages/mapSelectorPage.dart'; // Use this instead of MapPage
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;




class AddActivityPage extends StatefulWidget {
  const AddActivityPage({Key? key}) : super(key: key);

  @override
  State<AddActivityPage> createState() => _AddActivityPageState();
}

class _AddActivityPageState extends State<AddActivityPage> {
  File? _selectedImage;
  String? _uploadedImageUrl;

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _explanationController = TextEditingController();
  final _whenController = TextEditingController();
  final _whereController = TextEditingController();
  final _bringController = TextEditingController();
  final _goalController = TextEditingController();

  LatLng? _selectedLocation;

  void _navigateToMap() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MapSelectorPage()),
    );
    if (result is LatLng) {
      setState(() {
        _selectedLocation = result;
      });
    }
  }


  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      // Ensure user document exists and doesn't overwrite existing data
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set({
        'uid': user.uid,
        'email': user.email,
        'name': user.displayName ?? '',
        'profilePhotoUrl': user.photoURL ?? '',
        'lastLogin': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true)); //  merges with existing fields like age, bio, etc.

      // Build event/activity data
      final newEventData = {
        'title': _titleController.text,
        'explanation': _explanationController.text,
        'when': _whenController.text,
        'where': _whereController.text,
        'bring': _bringController.text,
        'goal': _goalController.text,
        'location': 'Selected on map',
        'coordinates': _selectedLocation != null
            ? GeoPoint(_selectedLocation!.latitude, _selectedLocation!.longitude)
            : null,
        'eventPhotoPath': _uploadedImageUrl ?? '',
        'createdAt': Timestamp.now(),
        'createdBy': user.uid,
        'descriptionMini': _titleController.text,
        'descriptionLarge': _explanationController.text,
        'date': Timestamp.now(),
      };

      // Add activity under the user's personal document
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('your_activities')
          .add(newEventData);

      // Add to global events collection too
      await FirebaseFirestore.instance
          .collection('events')
          .add(newEventData);


      Navigator.pop(context);
    }
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
      });

      final fileName = path.basename(picked.path);
      final destination = 'activity_photos/$fileName';

      try {
        final ref = FirebaseStorage.instance.ref(destination);
        await ref.putFile(_selectedImage!);
        final url = await ref.getDownloadURL();

        setState(() {
          _uploadedImageUrl = url;
        });
      } catch (e) {
        print('Image upload error: $e');
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel("Title:"),
              _buildTextField(_titleController, "Enter title"),
              _buildLabel("Upload a photo:"),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFF67C933)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: _selectedImage == null
                        ? const Text("Tap to upload a photo")
                        : Image.file(_selectedImage!, fit: BoxFit.cover),
                  ),
                ),
              ),

              _buildLabel("Explanations:"),
              _buildTextField(_explanationController, "Enter explanation"),
              _buildLabel("When:"),
              _buildTextField(_whenController, "Enter date/time"),
              _buildLabel("Where:"),
              _buildTextField(_whereController, "Enter location"),
              _buildLabel("What to Bring:"),
              _buildTextField(_bringController, "Enter items"),
              _buildLabel("Goal:"),
              _buildTextField(_goalController, "Enter goal"),
              _buildLabel("Location:"),
              Row(
                children: [
                  const Icon(Icons.map, color: Colors.green),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: _navigateToMap,
                    icon: const Icon(Icons.location_on),
                    label: const Text("Show on Google Map"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF67C933),
                      foregroundColor: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    side: const BorderSide(color: Color(0xFF67C933), width: 2),
                  ),
                  child: const Text("Share"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String label) => Padding(
    padding: const EdgeInsets.only(top: 12.0),
    child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
  );

  Widget _buildTextField(TextEditingController controller, String hint) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: controller,
        validator: (value) => value == null || value.isEmpty ? "Required" : null,
        decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}
