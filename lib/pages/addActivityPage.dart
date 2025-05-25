import 'package:flutter/material.dart';
import 'package:cs_projesi/pages/mapSelectorPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';
import 'package:cs_projesi/providers/user_provider.dart';

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
  final _whereController = TextEditingController();
  final _bringController = TextEditingController();
  final _goalController = TextEditingController();

  DateTime? _whenDateTime;
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
      if (_whenDateTime == null || _selectedLocation == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select date/time and map location.")),
        );
        return;
      }

      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final creatorId = userProvider.uid;

      if (creatorId == null) return;

      final newEventData = {
        'title': _titleController.text,
        'explanation': _explanationController.text,
        'when': "${_whenDateTime!.year}-${_whenDateTime!.month.toString().padLeft(2, '0')}-${_whenDateTime!.day.toString().padLeft(2, '0')} "
            "${_whenDateTime!.hour.toString().padLeft(2, '0')}:${_whenDateTime!.minute.toString().padLeft(2, '0')}",
        'where': _whereController.text,
        'bring': _bringController.text,
        'goal': _goalController.text,
        'location': 'Selected on map',
        'coordinates': GeoPoint(_selectedLocation!.latitude, _selectedLocation!.longitude),
        'eventPhotoPath': _uploadedImageUrl ?? '',
        'createdAt': Timestamp.now(),
        'createdBy': creatorId,
        'descriptionMini': _titleController.text,
        'descriptionLarge': _explanationController.text,
        'date': Timestamp.now(),
      };

      await FirebaseFirestore.instance
          .collection('users')
          .doc(creatorId)
          .collection('your_activities')
          .add(newEventData);

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
              ElevatedButton(
                onPressed: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );

                  if (pickedDate != null) {
                    final pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );

                    if (pickedTime != null) {
                      setState(() {
                        _whenDateTime = DateTime(
                          pickedDate.year,
                          pickedDate.month,
                          pickedDate.day,
                          pickedTime.hour,
                          pickedTime.minute,
                        );
                      });
                    }
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF67C933)),
                child: Text(
                  _whenDateTime == null
                      ? "Select Date & Time"
                      : "${_whenDateTime!.year}-${_whenDateTime!.month.toString().padLeft(2, '0')}-${_whenDateTime!.day.toString().padLeft(2, '0')} "
                      "${_whenDateTime!.hour.toString().padLeft(2, '0')}:${_whenDateTime!.minute.toString().padLeft(2, '0')}",
                  style: const TextStyle(color: Colors.black),
                ),
              ),
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
