import 'package:flutter/material.dart';
import 'package:cs_projesi/models/profile.dart';
import 'package:cs_projesi/utility_classes/app_colors.dart';
import 'package:cs_projesi/firebase/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:cs_projesi/providers/user_provider.dart';

class ProfilePage extends StatefulWidget {
  final Profile user;
  final bool isOwnProfile;

  const ProfilePage({Key? key, required this.user, this.isOwnProfile = false}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseService _firebaseService = FirebaseService();
  bool isFollowing = false;
  bool hasActiveActivity = false;
  Profile? _mergedProfile;

  @override
  void initState() {
    super.initState();
    _loadFollowAndActivityStatus();
    _loadMergedProfileData();
  }

  Future<void> _loadFollowAndActivityStatus() async {
    final following = await _firebaseService.isFollowing(widget.user.id);
    final active = await _firebaseService.userHasActiveActivity(widget.user.id);
    setState(() {
      isFollowing = following;
      hasActiveActivity = active;
    });
  }

  Future<void> _loadMergedProfileData() async {
    final profileDoc = await FirebaseFirestore.instance.collection('profiles').doc(widget.user.id).get();
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(widget.user.id).get();

    if (profileDoc.exists && userDoc.exists) {
      final profileData = profileDoc.data()!;
      final userData = userDoc.data()!;

      setState(() {
        _mergedProfile = Profile(
          id: profileData['id'],
          name: profileData['name'],
          surname: profileData['surname'],
          hasEvent: profileData['hasEvent'],
          profilePhotoPath: profileData['profilePhotoPath'],
          createdBy: profileData['createdBy'],
          createdAt: (profileData['createdAt'] as Timestamp).toDate(),
          age: userData['age'] ?? 0,
          bio: userData['bio'] ?? '',
          favoriteActivities: List<String>.from(userData['favoriteActivities'] ?? []),
          favoritePlaces: List<String>.from(userData['favoritePlaces'] ?? []),
        );
      });
    }
  }

  Future<void> _toggleFollow() async {
    if (isFollowing) {
      await _firebaseService.unfollowUser(widget.user.id);
    } else {
      await _firebaseService.followUser(widget.user.id);
    }
    _loadFollowAndActivityStatus();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = _mergedProfile ?? widget.user;

    final photoPath = widget.isOwnProfile && userProvider.profilePhoto != null && userProvider.profilePhoto!.isNotEmpty
        ? userProvider.profilePhoto!
        : user.profilePhotoPath;

    final ImageProvider imageProvider;
    if (photoPath.isEmpty) {
      imageProvider = const AssetImage('assets/default_avatar.png');
    } else if (photoPath.startsWith('http')) {
      imageProvider = NetworkImage(photoPath);
    } else {
      imageProvider = AssetImage(photoPath);
    }

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0, top: 16.0),
            child: Row(
              children: [
                if (hasActiveActivity)
                  const Icon(Icons.circle, color: Colors.green, size: 12),
                const SizedBox(width: 5),
                Text(
                  'Age: ${user.age}',
                  style: const TextStyle(fontSize: 16, fontFamily: 'RobotoSerif'),
                ),
              ],
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
                backgroundImage: imageProvider,
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                user.name,
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
                  style: const TextStyle(fontSize: 16, fontFamily: 'RobotoSerif'),
                ),
              ),
            const SizedBox(height: 24),
            if (user.favoriteActivities.isNotEmpty)
              _buildListSection('Favorite Activities', user.favoriteActivities),
            if (user.favoritePlaces.isNotEmpty)
              _buildListSection('Favorite Places', user.favoritePlaces),
            const SizedBox(height: 30),
            if (!widget.isOwnProfile)
              Center(
                child: OutlinedButton(
                  onPressed: _toggleFollow,
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
    );
  }

  Widget _buildListSection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            fontFamily: 'RobotoSerif',
          ),
        ),
        const SizedBox(height: 8),
        ...items.map((item) => Row(
          children: [
            const Text('• ', style: TextStyle(fontSize: 16)),
            Expanded(
              child: Text(
                item,
                style: const TextStyle(fontSize: 16, fontFamily: 'RobotoSerif'),
              ),
            ),
          ],
        )),
        const SizedBox(height: 18),
      ],
    );
  }
}