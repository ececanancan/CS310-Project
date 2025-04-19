import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:cs_projesi/widgets/navigationBarWidget.dart';

class SettingsPage extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const SettingsPage({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  Widget _buildTile(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        child: Row(
          children: [
            Icon(icon, color: Colors.black, size: 24),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontFamily: 'RobotoSerif',
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          _buildTile(MdiIcons.accountMultiple, 'Followings', () {
            // Navigate to followings
          }),
          _buildTile(MdiIcons.accountEdit, 'Edit Profile', () {
            // Navigate to edit profile
          }),
          _buildTile(MdiIcons.lock, 'Privacy', () {
            // Navigate to privacy settings
          }),
          _buildTile(MdiIcons.phone, 'Contact Us', () {
            // Navigate to contact page
          }),
        ],
      ),
      bottomNavigationBar: NavigationBarNature(
        selectedIndex: selectedIndex,

      ),
    );
  }
}
