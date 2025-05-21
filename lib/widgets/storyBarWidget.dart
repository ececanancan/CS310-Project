import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../pages/userProfilePage.dart';

class StoryBarWidget extends StatelessWidget {
  const StoryBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    return SizedBox(
      height: 130,
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: _getFollowingUsers(currentUserId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: \${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final users = snapshot.data!;
          if (users.isEmpty) {
            return const Center(child: Text('You are not following anyone yet.'));
          }

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
            child: Row(
              children: users.map((user) {
                final uid = user['uid'] as String;
                final name = user['name'] ?? 'Unknown';
                final hasEvent = user['hasEvent'] ?? false;
                final profilePhoto = user['profilePhotoUrl'] ?? '';

                return Padding(
                  padding: const EdgeInsets.only(right: 37),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => UserProfilePage(uid: uid)),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: hasEvent ? Colors.green : Colors.grey.shade300,
                              width: 3,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 35,
                            backgroundImage: profilePhoto.isNotEmpty
                                ? NetworkImage(profilePhoto)
                                : const AssetImage('assets/default_avatar.png') as ImageProvider,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      SizedBox(
                        width: 60,
                        child: Text(
                          name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _getFollowingUsers(String? currentUserId) async {
    if (currentUserId == null) return [];

    final followingsSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .collection('followings')
        .get();

    final followingIds = followingsSnapshot.docs.map((doc) => doc.id).toList();
    if (followingIds.isEmpty) return [];

    List<Map<String, dynamic>> users = [];

    for (final uid in followingIds) {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (userDoc.exists) {
        final data = userDoc.data()!;
        data['uid'] = uid; // store uid explicitly
        users.add(data);
      }
    }

    return users;
  }
}
