import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cs_projesi/utility_classes/app_colors.dart';


class ProfileCreationPage extends StatefulWidget {
  @override
  _ProfileCreationPageState createState() => _ProfileCreationPageState();
}

class _ProfileCreationPageState extends State<ProfileCreationPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final List<String> _favoriteActivities = [];
  final List<String> _favoritePlaces = [];
  File? _selectedImage;

  final List<String> _activityOptions = [
    'Stargazing',
    'Hiking',
    'Mountain Climbing',
    'Swimming in a quiet place',
    'Beach cleaning',
  ];

  final List<String> _placeOptions = [
    'Forests',
    'Mountains',
    'Beaches',
    'Parks',
    'Lakes',
  ];

  bool get _isFormFilled =>
      _nameController.text.isNotEmpty &&
          _bioController.text.isNotEmpty &&
          _ageController.text.isNotEmpty;

  Future<void> _pickImage() async {
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _selectedImage = File(pickedFile.path));
    }
  }

  InputDecoration _greenBorderDecoration() {
    return InputDecoration(
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.green, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.green, width: 2.0),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'RobotoSerif',
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    );
  }

  void _showOptionsDialog(
      List<String> options, List<String> targetList, String title) {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text(title),
          children: options
              .where((opt) => !targetList.contains(opt))
              .map(
                (opt) => SimpleDialogOption(
              onPressed: () {
                setState(() => targetList.add(opt));
                Navigator.pop(context);
              },
              child: Text(opt),
            ),
          )
              .toList(),
        );
      },
    );
  }

  Widget _buildChip(String label, List<String> targetList) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: Chip(
        label: Text(label),
        deleteIcon: Icon(Icons.close),
        onDeleted: () => setState(() => targetList.remove(label)),
      ),
    );
  }

  void _showCustomInputDialog(List<String> targetList, String title) {
    final TextEditingController _customController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Add Custom $title',
          style: TextStyle(
            fontFamily: 'RobotoSerif',
            fontWeight: FontWeight.bold,
          ),
        ),
        content: TextField(
          controller: _customController,
          style: TextStyle(
            fontFamily: 'RobotoSerif',
          ),
          decoration: InputDecoration(
            hintText: 'Enter custom $title',
            hintStyle: TextStyle(
              fontFamily: 'RobotoSerif',
              color: Colors.grey,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                fontFamily: 'RobotoSerif',
                color: AppColors.green,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.green,
            ),
            onPressed: () {
              if (_customController.text.trim().isNotEmpty) {
                setState(() => targetList.add(_customController.text.trim()));
              }
              Navigator.pop(context);
            },
            child: Text(
              'Add',
              style: TextStyle(
                fontFamily: 'RobotoSerif',
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(leading: BackButton()),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: screenHeight * 0.3,
                width: screenHeight * 0.3,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: _selectedImage != null
                        ? FileImage(_selectedImage!)
                        : AssetImage('assets/profile_photos/icon.jpg')
                    as ImageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
                child: _selectedImage == null
                    ? Center(
                  child: Text(
                    'Upload a photo',
                    style: TextStyle(color: Colors.black, fontFamily: 'RobotoSerif', fontSize: 16),
                  ),
                )
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: screenHeight * 0.5,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('Name:'),
                    TextField(
                      controller: _nameController,
                      textAlign: TextAlign.center,
                      decoration: _greenBorderDecoration().copyWith(
                        hintText: 'Nima',
                        hintStyle: TextStyle(
                          color: Colors.grey.shade400,
                          fontFamily: 'RobotoSerif',
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                    SizedBox(height: 10),
                    _buildLabel('Bio:'),
                    TextField(
                      controller: _bioController,
                      maxLines: 4,
                      decoration: _greenBorderDecoration(),
                      onChanged: (_) => setState(() {}),
                    ),
                    SizedBox(height: 10),
                    _buildLabel('Age:'),
                    TextField(
                      controller: _ageController,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      decoration: _greenBorderDecoration().copyWith(
                        hintText: '27',
                        hintStyle: TextStyle(
                          color: Colors.grey.shade400,
                          fontFamily: 'RobotoSerif',
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      style: TextStyle(fontFamily: 'RobotoSerif'),
                      onChanged: (_) => setState(() {}),
                    ),
                    SizedBox(height: 20),
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      margin: const EdgeInsets.only(top: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Favorite Activities',
                                style: TextStyle(
                                  fontFamily: 'RobotoSerif',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                )),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 6,
                              runSpacing: 4,
                              children: _favoriteActivities
                                  .map((activity) => Chip(
                                label: Text(activity),
                                deleteIcon: Icon(Icons.close),
                                onDeleted: () {
                                  setState(() => _favoriteActivities.remove(activity));
                                },
                              ))
                                  .toList(),
                            ),
                            const SizedBox(height: 10),
                            Center(
                              child: ElevatedButton.icon(

                                icon: Icon(Icons.add),
                                label: Text('Add Activity',
                                  style: TextStyle(
                                    fontFamily: 'RobotoSerif',
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                                onPressed: () => _showOptionsDialog(
                                  _activityOptions,
                                  _favoriteActivities,
                                  'Select an Activity',
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.green,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: 5),
                            Center(
                              child: TextButton(
                                onPressed: () => _showCustomInputDialog(_favoriteActivities, 'Activity'),
                                child: Text(
                                  'Add Custom Activity',
                                  style: TextStyle(
                                    color: AppColors.green,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'RobotoSerif',
                                  ),
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 10),
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      margin: const EdgeInsets.only(top: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Favorite Places',
                                style: TextStyle(
                                  fontFamily: 'RobotoSerif',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                )),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 6,
                              runSpacing: 4,
                              children: _favoritePlaces
                                  .map((place) => Chip(
                                label: Text(place),
                                deleteIcon: Icon(Icons.close),
                                onDeleted: () {
                                  setState(() => _favoritePlaces.remove(place));
                                },
                              ))
                                  .toList(),
                            ),
                            const SizedBox(height: 10),
                            Center(
                              child: ElevatedButton.icon(
                                icon: Icon(Icons.add),
                                label: Text('Add Place',
                                  style: TextStyle(
                                    fontFamily: 'RobotoSerif',
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                                onPressed: () => _showOptionsDialog(
                                  _placeOptions,
                                  _favoritePlaces,
                                  'Select a Place',
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.green,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 5),
                            Center(
                              child: TextButton(
                                onPressed: () => _showCustomInputDialog(_favoritePlaces, 'Place'),
                                child: Text(
                                  'Add Custom Place',
                                  style: TextStyle(
                                    color: AppColors.green,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'RobotoSerif',
                                  ),
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: _isFormFilled
                            ? () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AdditionalProfilePrompt()),
                        )
                            : null,
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                (states) {
                              if (states.contains(MaterialState.disabled)) {
                                return AppColors.paleGreen; // Pale green when disabled
                              }
                              return AppColors.green; // Green when enabled
                            },
                          ),
                          padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(horizontal: 40, vertical: 12)),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                        child: Text(
                          'Next',
                          style: TextStyle(
                            fontFamily: 'RobotoSerif',
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),

                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AdditionalProfilePrompt extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Would you like to add anything else to your profile before finalizing?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, fontFamily: 'RobotoSerif',),
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.green,
                      shape: StadiumBorder(),
                      padding:
                      EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    onPressed: () {
                      Navigator.pop(context); // Go back to profile creation
                    },

                    child: Text('Yes', style: TextStyle(color: Colors.black, fontFamily: 'RobotoSerif')),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.green,
                      shape: StadiumBorder(),
                      padding:
                      EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FinalProfileReadyScreen()),
                      );
                    },

                    child: Text('No', style: TextStyle(color: Colors.black, fontFamily: 'RobotoSerif')),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class FinalProfileReadyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Now you are ready to use the app',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'RobotoSerif',
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.green,
                  shape: StadiumBorder(),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/HomePage');
                },
                child: Text(
                  "Let's start",
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'RobotoSerif',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
