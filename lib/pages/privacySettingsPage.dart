
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PrivacySettingsPage extends StatefulWidget {
  const PrivacySettingsPage({super.key});

  static const Color green = Color(0xFF67C933);

  @override
  State<PrivacySettingsPage> createState() => _PrivacySettingsPageState();
}

class _PrivacySettingsPageState extends State<PrivacySettingsPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    emailController.text = user?.email ?? '';

    FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get()
        .then((doc) {
      if (doc.exists) {
        phoneController.text = doc['phoneNumber'] ?? '';
        locationController.text = doc['homeLocation'] ?? '';
      }
    });
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      try {
        if (emailController.text.trim() != user.email) {
          await user.updateEmail(emailController.text.trim());
        }

        if (passwordController.text.trim().isNotEmpty) {
          await user.updatePassword(passwordController.text.trim());
        }

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set({
          'phoneNumber': phoneController.text.trim(),
          'homeLocation': locationController.text.trim(),
        }, SetOptions(merge: true));

        Navigator.pop(context); // Return to Settings

      } on FirebaseAuthException catch (e) {
        String message = 'Failed to update profile.';
        if (e.code == 'requires-recent-login') {
          message = 'Please log out and sign in again to update sensitive data.';
        }
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Update Error"),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          ),
        );
      } catch (e) {
        print("⚠️ Unexpected error: $e");
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Unexpected Error"),
            content: const Text("Something went wrong. Please try again."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Privacy Settings"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  _buildRowField('Email', 'Someone@gmail.com', emailController,
                      TextInputType.emailAddress, false, null, (value) {
                        if (value == null || value.isEmpty) return 'Email is required';
                        if (!value.contains('@')) return 'Enter a valid email';
                        return null;
                      }),
                  const SizedBox(height: 30),
                  _buildRowField('Password', '**************', passwordController,
                      TextInputType.text, true,
                      _obscurePassword ? Icons.visibility_off : Icons.visibility, (value) {
                        if (value != null && value.isNotEmpty && value.length < 6) {
                          return 'At least 6 characters';
                        }
                        return null;
                      },
                      onToggle: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      obscureText: _obscurePassword),
                  const SizedBox(height: 30),
                  _buildRowField('Confirm Password', '**************', confirmPasswordController,
                      TextInputType.text, true,
                      _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                          (value) {
                        if (passwordController.text.isNotEmpty && value != passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                      onToggle: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                      obscureText: _obscureConfirmPassword),
                  const SizedBox(height: 30),
                  _buildRowField('Phone Number', '+90 | 555-567 53 88', phoneController,
                      TextInputType.phone, false, null, (value) {
                        return null;
                      }),
                  const SizedBox(height: 30),
                  _buildRowField('Home location', 'Maltepe, kucukyali...', locationController,
                      TextInputType.text, false, null, (value) {
                        return null;
                      }, obscureText: false),
                  const SizedBox(height: 40),
                  Center(
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: PrivacySettingsPage.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 14),
                        elevation: 4,
                      ),
                      child: const Text(
                        'Save',
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRowField(
      String label,
      String hint,
      TextEditingController controller,
      TextInputType keyboardType,
      bool hasIcon,
      IconData? icon,
      String? Function(String?) validator, {
        VoidCallback? onToggle,
        bool obscureText = false,
        List<TextInputFormatter>? inputFormatters,
      }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 130,
          child: Text(
            label,
            style: const TextStyle(fontSize: 16),
          ),
        ),
        Expanded(
          child: TextFormField(
            controller: controller,
            validator: validator,
            obscureText: obscureText,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey[300]),
              filled: true,
              fillColor: PrivacySettingsPage.green,
              suffixIcon: hasIcon && icon != null
                  ? IconButton(
                icon: Icon(icon, color: Colors.black),
                onPressed: onToggle,
              )
                  : null,
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
