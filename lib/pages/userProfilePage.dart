import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs_projesi/firebase/firebase_service.dart';

class UserProfilePage extends StatefulWidget {
  final String uid;
  const UserProfilePage({super.key, required this.uid});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final FirebaseService _firebaseService = FirebaseService();
  Map<String, dynamic>? _userData;
  bool _loading = true;
  bool isFollowing = false;
  bool hasActiveActivity = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final doc = await FirebaseFirestore.instance.collection('users').doc(widget.uid).get();
    final following = await _firebaseService.isFollowing(widget.uid);
    final active = await _firebaseService.userHasActiveActivity(widget.uid);

    if (mounted) {
      setState(() {
        _userData = doc.data();
        isFollowing = following;
        hasActiveActivity = active;
        _loading = false;
      });
    }
  }

  Future<void> _toggleFollow() async {
    if (isFollowing) {
      await _firebaseService.unfollowUser(widget.uid);
    } else {
      await _firebaseService.followUser(widget.uid);
    }
    _loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_userData == null) {
      return const Scaffold(
        body: Center(child: Text("User not found")),
      );
    }

    final name = _userData!["name"] ?? "Unknown";
    final age = _userData!["age"] ?? 0;
    final bio = _userData!["bio"] ?? "";
    final photo = _userData!["profilePhotoUrl"] ?? "";
    final favoriteActivities = List<String>.from(_userData!["favoriteActivities"] ?? []);
    final favoritePlaces = List<String>.from(_userData!["favoritePlaces"] ?? []);

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
                  'Age: $age',
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
                backgroundImage: photo.isNotEmpty
                    ? NetworkImage(photo)
                    : const AssetImage('assets/default_avatar.png') as ImageProvider,
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  fontFamily: 'RobotoSerif',
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (bio.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  bio,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, fontFamily: 'RobotoSerif'),
                ),
              ),
            const SizedBox(height: 24),
            if (favoriteActivities.isNotEmpty)
              _buildListSection('Favorite Activities', favoriteActivities),
            if (favoritePlaces.isNotEmpty)
              _buildListSection('Favorite Places', favoritePlaces),
            const SizedBox(height: 30),
            Center(
              child: OutlinedButton(
                onPressed: _toggleFollow,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: isFollowing ? Colors.red : Colors.green,
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
                    color: isFollowing ? Colors.red : Colors.green,
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
