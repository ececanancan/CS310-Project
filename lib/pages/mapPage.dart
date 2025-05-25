import 'package:cs_projesi/pages/userProfilePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs_projesi/widgets/navigationBarWidget.dart';
import 'package:cs_projesi/pages/ProfilePage.dart';
import 'package:cs_projesi/pages/eventPage.dart';
import 'package:cs_projesi/models/event.dart';
import 'package:cs_projesi/firebase/firebase_service.dart';
import '../models/profile.dart';

class MapPage extends StatelessWidget {
  const MapPage({Key? key}) : super(key: key);

  void _navigateToEvent(BuildContext context, Event event) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventPage(event: event),
      ),
    );
  }

  void _navigateToProfile(BuildContext context, Profile profile) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfilePage(user: profile),
      ),
    );
  }

  Future<List<Event>> _fetchOtherUsersYourActivities() async {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId == null) return [];

    final usersSnapshot = await FirebaseFirestore.instance.collection('users').get();
    List<Event> events = [];

    for (var userDoc in usersSnapshot.docs) {
      if (userDoc.id == currentUserId) continue;

      final activitiesSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userDoc.id)
          .collection('your_activities')
          .get();

      for (var doc in activitiesSnapshot.docs) {
        final data = doc.data();
        final coord = data['coordinates'];
        LatLng coordinates;

        if (coord is GeoPoint) {
          coordinates = LatLng(coord.latitude, coord.longitude);
        } else if (coord is Map && coord.containsKey('_latitude')) {
          coordinates = LatLng(coord['_latitude'], coord['_longitude']);
        } else {
          coordinates = LatLng(0, 0);
        }

        final whenStr = data['when'] ?? '';
        DateTime? whenDateTime;
        try {
          whenDateTime = DateTime.parse(whenStr);
        } catch (_) {
          continue;
        }

        if (whenDateTime.isBefore(DateTime.now())) continue;

        events.add(Event(
          id: data['id'] ?? doc.id,
          createdBy: data['createdBy'] ?? userDoc.id,
          location: data['location'] ?? '',
          coordinates: coordinates,
          date: (data['date'] as Timestamp).toDate(),
          descriptionMini: data['descriptionMini'] ?? '',
          eventPhotoPath: data['eventPhotoPath'] ?? '',
          descriptionLarge: data['descriptionLarge'] ?? '',
          where: data['where'] ?? '',
          bring: data['bring'] ?? '',
          goal: data['goal'] ?? '',
          when: whenStr,
          createdAt: (data['createdAt'] as Timestamp).toDate(),
        ));
      }
    }

    return events;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Map of Istanbul"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: FutureBuilder<List<Event>>(
        future: _fetchOtherUsersYourActivities(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No events found from other users'));
          }

          final filteredEvents = snapshot.data!;
          return FlutterMap(
            options: MapOptions(
              initialCenter: LatLng(41.0082, 28.9784),
              maxZoom: 18.0,
              initialZoom: 13.0,
            ),
            children: [
              TileLayer(
                urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: const ['a', 'b', 'c'],
              ),
              MarkerLayer(
                markers: filteredEvents.map((event) {
                  return Marker(
                    point: event.coordinates,
                    width: 280,
                    height: 180,
                    child: FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance.collection('users').doc(event.createdBy).get(),
                      builder: (context, snapshot) {
                        final data = snapshot.data?.data() as Map<String, dynamic>?;

                        final name = data?['name'] ?? 'Unknown';
                        final profilePhotoUrl = data?['profilePhotoUrl'] ?? '';
                        final photoPath = profilePhotoUrl;

                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6)],
                          ),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: event.eventPhotoPath.isNotEmpty
                                    ? Image.asset(
                                  event.eventPhotoPath,
                                  width: 280,
                                  height: 180,
                                  fit: BoxFit.cover,
                                )
                                    : Container(
                                  width: 280,
                                  height: 180,
                                  color: Colors.grey[200],
                                  child: const Icon(Icons.image, size: 40, color: Colors.grey),
                                ),
                              ),
                              Container(
                                width: 280,
                                height: 180,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.black.withOpacity(0.25),
                                ),
                              ),
                              Positioned(
                                top: 10,
                                right: 10,
                                child: Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (_) => UserProfilePage(uid: event.createdBy)),
                                        );
                                      },
                                      child: CircleAvatar(
                                        radius: 28,
                                        backgroundColor: Colors.white,
                                        child: CircleAvatar(
                                          radius: 25,
                                          backgroundImage: photoPath.startsWith('http')
                                              ? NetworkImage(photoPath)
                                              : AssetImage(photoPath.isNotEmpty ? photoPath : 'assets/default_avatar.png') as ImageProvider,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Container(
                                      width: 60,
                                      alignment: Alignment.center,
                                      child: Text(
                                        name,
                                        style: const TextStyle(color: Colors.white, fontSize: 12),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                bottom: 10,
                                left: 10,
                                right: 10,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      event.descriptionMini,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 6),
                                    Center(
                                      child: GestureDetector(
                                        onTap: () => _navigateToEvent(context, event),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.9),
                                            borderRadius: BorderRadius.circular(30),
                                          ),
                                          child: const Text(
                                            "More",
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                }).toList(),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: const NavigationBarNature(selectedIndex: 3),
    );
  }
}
