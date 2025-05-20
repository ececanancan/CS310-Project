import 'package:flutter/material.dart';
import 'package:cs_projesi/models/profile.dart';
import 'package:cs_projesi/widgets/navigationBarWidget.dart';
import 'package:cs_projesi/utility_classes/app_colors.dart';

class ProfilePage extends StatefulWidget {
  final Profile user;
  final bool isOwnProfile;

  const ProfilePage({
    Key? key,
    required this.user,
    this.isOwnProfile = false,
  }) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late bool isFollowing;
  int _selectedIndex = 2;

  @override
  void initState() {
    super.initState();
    isFollowing = false; // Default to not following
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.user;

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0, top: 16.0),
            child: Text(
              'Age: ${user.age}',
              style: const TextStyle(fontSize: 16, fontFamily: 'RobotoSerif'),
            ),
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            Center(
              child: CircleAvatar(
                radius: 70,
                backgroundImage: user.profilePhotoPath.startsWith('http')
                    ? NetworkImage(user.profilePhotoPath)
                    : AssetImage(user.profilePhotoPath) as ImageProvider,
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                '${user.name} ${user.surname}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  fontFamily: 'RobotoSerif',
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (user.bio.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  user.bio,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'RobotoSerif',
                  ),
                ),
              ),
            const SizedBox(height: 24),
            if (user.favoriteActivities.isNotEmpty)
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Favorite Activities:',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    fontFamily: 'RobotoSerif',
                  ),
                ),
              ),
            if (user.favoriteActivities.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: user.favoriteActivities.map((activity) =>
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('• ', style: TextStyle(fontSize: 16)),
                        Expanded(
                          child: Text(
                            activity,
                            style: const TextStyle(fontSize: 16, fontFamily: 'RobotoSerif'),
                          ),
                        ),
                      ],
                    )
                  ).toList(),
                ),
              ),
            if (user.favoritePlaces.isNotEmpty) ...[
              const SizedBox(height: 18),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Favorite Places:',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    fontFamily: 'RobotoSerif',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: user.favoritePlaces.map((place) =>
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('• ', style: TextStyle(fontSize: 16)),
                        Expanded(
                          child: Text(
                            place,
                            style: const TextStyle(fontSize: 16, fontFamily: 'RobotoSerif'),
                          ),
                        ),
                      ],
                    )
                  ).toList(),
                ),
              ),
            ],
            const SizedBox(height: 30),
            if (!widget.isOwnProfile)
              Center(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      isFollowing = !isFollowing;
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
                    padding: const EdgeInsets.symmetric(horizontal: 40),
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
        selectedIndex: 1,
      ),
    );
  }
}
