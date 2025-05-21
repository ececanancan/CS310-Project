import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs_projesi/models/event.dart';
import '../pages/userProfilePage.dart';

class EventCardWidget extends StatelessWidget {
  final Event event;

  EventCardWidget({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 18),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 0,
      color: Colors.white54,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance.collection('users').doc(event.createdBy).get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Row(
                    children: const [
                      CircleAvatar(radius: 25, backgroundColor: Colors.grey),
                      SizedBox(width: 8),
                      Text('Loading...', style: TextStyle(fontSize: 15)),
                      SizedBox(width: 12),
                      Text('Fetching time...', style: TextStyle(fontSize: 13, color: Colors.black45)),
                      SizedBox(width: 12),
                      Icon(Icons.location_on_outlined, color: Colors.black45, size: 16),
                      SizedBox(width: 4),
                      Text('Loading...', style: TextStyle(fontSize: 13, color: Colors.black45)),
                    ],
                  );
                }

                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return Row(
                    children: const [
                      CircleAvatar(radius: 25, backgroundColor: Colors.grey, child: Icon(Icons.person)),
                      SizedBox(width: 8),
                      Text('Unknown', style: TextStyle(fontSize: 15)),
                      SizedBox(width: 12),
                      Text('No date', style: TextStyle(fontSize: 13, color: Colors.black45)),
                      SizedBox(width: 12),
                      Icon(Icons.location_on_outlined, color: Colors.black45, size: 16),
                      SizedBox(width: 4),
                      Text('Unknown', style: TextStyle(fontSize: 13, color: Colors.black45)),
                    ],
                  );
                }

                final userData = snapshot.data!.data() as Map<String, dynamic>;
                final userName = userData['name'] ?? 'Unknown';
                final userPhoto = userData['profilePhotoUrl'] ?? '';

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => UserProfilePage(uid: event.createdBy)),
                        );
                      },
                      child: CircleAvatar(
                        radius: 25,
                        backgroundImage: userPhoto.isNotEmpty
                            ? NetworkImage(userPhoto)
                            : const AssetImage('assets/default_avatar.png') as ImageProvider,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      userName,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      event.formattedDate,
                      style: const TextStyle(fontSize: 13, color: Colors.black45),
                    ),
                    const SizedBox(width: 12),
                    const Icon(Icons.location_on_outlined, color: Colors.black45, size: 16),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        event.location,
                        style: const TextStyle(fontSize: 13, color: Colors.black45),
                        overflow: TextOverflow.visible,
                        softWrap: true,
                        maxLines: 2,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          const SizedBox(height: 10),

          GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                '/EventPage',
                arguments: event,
              );
            },
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20), bottom: Radius.circular(20)),
              child: event.eventPhotoPath.isNotEmpty
                  ? Image.asset(
                event.eventPhotoPath,
                height: 100,
                width: double.infinity,
                fit: BoxFit.cover,
              )
                  : Image.asset(
                'assets/placeholder.jpg',
                height: 100,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),

          const SizedBox(height: 4),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Text(
              event.descriptionMini,
              softWrap: true,
              overflow: TextOverflow.visible,
              style: const TextStyle(
                fontFamily: 'RobotoSerif',
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
