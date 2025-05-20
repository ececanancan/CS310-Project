import 'package:flutter/material.dart';
import 'package:cs_projesi/models/profile.dart';
import 'package:cs_projesi/models/event.dart';
import 'package:cs_projesi/firebase/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StoryBarWidget extends StatelessWidget {
  const StoryBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseService _firebaseService = FirebaseService();
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    final unwantedNames = {'Nina', 'Zeynep'};

    return SizedBox(
      height: 130,
      child: StreamBuilder<List<Profile>>(
        stream: _firebaseService.getProfiles(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No profiles found'));
          }

          final List<Profile> sortedProfiles = [
            ...snapshot.data!.where((p) => p.hasEvent && p.id != currentUserId && !unwantedNames.contains(p.name)),
            ...snapshot.data!.where((p) => !p.hasEvent && p.id != currentUserId && !unwantedNames.contains(p.name)),
          ];

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
            child: Row(
              children: sortedProfiles.map((profile) {
                return Padding(
                  padding: const EdgeInsets.only(right: 37),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          final fullProfile = await _firebaseService.getProfile(profile.id);
                          if (fullProfile != null) {
                            Navigator.pushNamed(
                              context,
                              '/ProfilePage',
                              arguments: {'profile': fullProfile, 'isOwnProfile': false},
                            );
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: profile.hasEvent
                                ? Border.all(color: Colors.green, width: 3)
                                : Border.all(color: Colors.white, width: 3),
                          ),
                          child: CircleAvatar(
                            radius: 35,
                            backgroundImage: profile.profilePhotoPath.startsWith('http')
                                ? NetworkImage(profile.profilePhotoPath)
                                : AssetImage(profile.profilePhotoPath) as ImageProvider,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 60,
                        child: Text(
                          profile.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 15),
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
}
