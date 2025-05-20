import 'package:flutter/material.dart';
import 'package:cs_projesi/models/event.dart';
import 'package:cs_projesi/models/profile.dart';
import 'package:cs_projesi/firebase/firebase_service.dart';
import 'package:cs_projesi/pages/ProfilePage.dart';

class EventCardWidget extends StatelessWidget {
  final Event event;
  final FirebaseService _firebaseService = FirebaseService();

  EventCardWidget({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(left: 10, right: 10, top: 18, bottom: 22),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 0,
      color: Colors.white54,

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              FutureBuilder<Profile?>(
                future: _firebaseService.getProfile(event.createdBy),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.grey[300],
                    );
                  }

                  if (snapshot.hasError || !snapshot.hasData) {
                    return CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.grey[300],
                      child: Icon(Icons.person, color: Colors.grey[600]),
                    );
                  }

                  final profile = snapshot.data!;
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfilePage(
                            user: profile,
                          ),
                        ),
                      );
                    },
                    child: CircleAvatar(
                      radius: 25,
                      backgroundImage: profile.profilePhotoPath.startsWith('http')
                          ? NetworkImage(profile.profilePhotoPath)
                          : AssetImage(profile.profilePhotoPath) as ImageProvider,
                    ),
                  );
                },
              ),
              SizedBox(width: 5,),
              FutureBuilder<Profile?>(
                future: _firebaseService.getProfile(event.createdBy),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData) {
                    return Text(
                      'Loading...',
                      style: TextStyle(
                        fontFamily: 'RobotoSerif',
                        fontSize: 15,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }

                  return Text(
                    snapshot.data!.name,
                    softWrap: true,
                    overflow: TextOverflow.visible,
                    style: TextStyle(
                      fontFamily: 'RobotoSerif',
                      fontSize: 15,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
              Spacer(),
              Text(
                event.formattedDate,
                overflow: TextOverflow.clip,
                style: TextStyle(
                  fontFamily: 'RobotoSerif',
                  fontSize: 15,
                  color: Colors.black45,
                ),
              ),
              Spacer(),
              Icon(Icons.location_on_outlined, size: 25, color: Colors.black45,),
              SizedBox(width: 2,),
              GestureDetector(
                onTap: (){},
                child: SizedBox(
                  width: 100,
                  child: Text(
                    event.location,
                    softWrap: true,
                    overflow: TextOverflow.visible,
                    style: TextStyle(
                      fontFamily: 'RobotoSerif',
                      fontSize: 15,
                      color: Colors.black45,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10,),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                '/EventPage',
                arguments: event,
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20), bottom: Radius.circular(20)),
              child: Image.asset(
                event.eventPhotoPath,
                height: 100,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 4,),
          Padding(
            padding: EdgeInsets.only(left: 10, right: 10, top: 3, bottom:10),
            child: Container(
              child: Text(
                event.descriptionMini,
                softWrap: true,
                overflow: TextOverflow.visible,
                style: TextStyle(
                  fontFamily: 'RobotoSerif',
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
