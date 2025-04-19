import 'package:flutter/material.dart';
import 'package:cs_projesi/pages/UserProfile.dart';
import 'package:cs_projesi/widgets/navigationBarWidget.dart';
import 'package:cs_projesi/data/profile_data.dart';
import 'package:cs_projesi/utility_classes/app_colors.dart';

class ProfilePage extends StatefulWidget {
  final UserProfile user;
  final int selectedIndex;
  final Function(int) onItemTapped;

  const ProfilePage({
    Key? key,
    required this.user,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  late bool isFollowing;

  @override
  void initState() {
  super.initState();
  isFollowing = widget.user.isFollowing;
  }



  @override
  Widget build(BuildContext context) {
    final user = widget.user;

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Spacer(),
                Text(
                  'Age: ${user.age}',
                  style: const TextStyle(fontSize: 16, fontFamily: 'RobotoSerif'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage(user.imagePath),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    user.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        fontFamily: 'RobotoSerif'),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    user.description,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 15,
                      fontFamily: 'RobotoSerif',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Favorite Activities:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                fontFamily: 'RobotoSerif',
              ),
            ),
            const SizedBox(height: 8),
            ...user.favoriteActivities.map((activity) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '• ',
                    style: TextStyle(fontSize: 18, fontFamily: 'RobotoSerif'),
                  ),
                  Expanded(
                    child: Text(
                      activity.trim(),
                      style: const TextStyle(fontFamily: 'RobotoSerif'),
                    ),
                  ),
                ],
              ),
            )),
            const SizedBox(height: 20),
            const Text(
              'Favorite Places:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                fontFamily: 'RobotoSerif',
              ),
            ),
            const SizedBox(height: 8),
            ...user.favoritePlaces.map((place) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '• ',
                    style: TextStyle(fontSize: 18, fontFamily: 'RobotoSerif'),
                  ),
                  Expanded(
                    child: Text(
                      place.trim(),
                      style: const TextStyle(fontFamily: 'RobotoSerif'),
                    ),
                  ),
                ],
              ),
            )),
            const SizedBox(height: 30),
            Center(
              child: OutlinedButton(
                onPressed: () {
                  setState(() {
                    isFollowing = !isFollowing;
                    widget.user.isFollowing = isFollowing;
                  });
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: isFollowing ? AppColors.red : AppColors.green,
                    width: 3,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(300),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 40),
                ),
                child: Text(
                  isFollowing ? 'Unfollow' : 'Follow',
                  style: TextStyle(
                    color: isFollowing ? AppColors.red : AppColors.green,
                    fontFamily: 'RobotoSerif',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBarNature(
        selectedIndex: widget.selectedIndex,

      ),
    );
  }
}
