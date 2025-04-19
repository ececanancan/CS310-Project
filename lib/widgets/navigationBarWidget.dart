import 'package:flutter/material.dart';

class NavigationBarNature extends StatelessWidget {
  final int selectedIndex;

  const NavigationBarNature({
    Key? key,
    required this.selectedIndex,
  }) : super(key: key);

  static const List<String> _routes = [
    '/SettingPage',
    '/ProfilePage',
    '/HomePage',
    '/MapPage',
    '/QuestionMarkPage',
  ];

  void _onItemTapped(BuildContext context, int index) {
    if (index != selectedIndex) {
      Navigator.pushNamed(context, _routes[index]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 80,
        padding: const EdgeInsets.only(left: 23, right: 23, bottom: 12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: selectedIndex,
            onTap: (index) => _onItemTapped(context, index),
            selectedItemColor: Colors.black54,
            unselectedItemColor: Colors.black54,
            backgroundColor: Color(0xFF67C933),
            showSelectedLabels: false,
            showUnselectedLabels: false,
            selectedFontSize: 0,
            unselectedFontSize: 0,
            iconSize: 0,
            items: [
              _buildNavItem(Icons.settings_outlined, 0),
              _buildNavItem(Icons.person_outline, 1),
              _buildNavItem(Icons.home_outlined, 2),
              _buildNavItem(Icons.route_outlined, 3),
              _buildNavItem(Icons.question_mark_outlined, 4),
            ],
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(IconData icon, int index) {
    bool isSelected = selectedIndex == index;

    return BottomNavigationBarItem(
      icon: Center(
        child: Container(
          height: 60,
          width: 60,
          decoration: isSelected
              ? BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          )
              : null,
          child: Center(
            child: Icon(
              icon,
              size: 40,
              color: isSelected ? Colors.black : Colors.black54,
            ),
          ),
        ),
      ),
      label: '',
    );
  }
}
