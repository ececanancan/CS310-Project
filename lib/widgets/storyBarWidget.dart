import 'package:flutter/material.dart';
import 'package:cs_projesi/data/profile_data.dart';
import 'package:cs_projesi/models/profile.dart';
import 'package:cs_projesi/models/event.dart';
import 'package:cs_projesi/data/event_data.dart';

class StoryBarWidget extends StatelessWidget {
  const StoryBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Profile> sortedProfiles = [
      ...profiles.where((p) => p.hasEvent), //add all the profiles that hasEvent = true
      ...profiles.where((p) => !p.hasEvent), // add all the profiles that hasEvent = false
    ];

    return SizedBox(
      height: 130,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.only(left: 10, top:10, bottom: 10),
        child: Row(
          children: sortedProfiles.map((profile) {
            return Padding(
              padding: const EdgeInsets.only(right:37),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (profile.hasEvent) {
                        final event = events.firstWhere((e) => e.createdBy.name == profile.name);

                        Navigator.pushNamed(
                          context,
                          '/EventPage',
                          arguments: event,
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
                      style: TextStyle(fontSize: 15,),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
