import 'package:flutter/material.dart';
import 'package:cs_projesi/models/profile.dart';
import 'package:cs_projesi/pages/ProfilePage.dart';
import 'package:cs_projesi/firebase/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FollowingsListPage extends StatefulWidget {
  const FollowingsListPage({Key? key}) : super(key: key);

  @override
  State<FollowingsListPage> createState() => _FollowingsListPageState();
}

class _FollowingsListPageState extends State<FollowingsListPage> {
  final FirebaseService _firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Followings'),
      ),
      body: StreamBuilder<List<Profile>>(
        stream: _firebaseService.getProfiles(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No users found.'));
          }

          final allProfiles = snapshot.data!;
          final currentUserId = FirebaseAuth.instance.currentUser?.uid;

          return StreamBuilder(
            stream: _firebaseService.firestore
                .collection('users')
                .doc(currentUserId)
                .collection('followings')
                .snapshots(),
            builder: (context, followingSnapshot) {
              if (!followingSnapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final followedIds = followingSnapshot.data!.docs.map((doc) => doc.id).toSet();
              final followedProfiles = allProfiles.where((p) => followedIds.contains(p.id)).toList();

              if (followedProfiles.isEmpty) {
                return const Center(child: Text('You are not following anyone.'));
              }

              return ListView.builder(
                itemCount: followedProfiles.length,
                itemBuilder: (context, index) {
                  final profile = followedProfiles[index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProfilePage(user: profile, isOwnProfile: false),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.green, width: 2),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: profile.profilePhotoPath.startsWith('http')
                                ? NetworkImage(profile.profilePhotoPath)
                                : AssetImage(profile.profilePhotoPath) as ImageProvider,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              profile.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const Text(
                            "Followed",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
