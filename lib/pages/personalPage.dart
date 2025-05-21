import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';
import 'package:cs_projesi/models/event.dart';
import 'package:cs_projesi/widgets/storyBarWidget.dart';
import 'package:cs_projesi/widgets/navigationBarWidget.dart';
import 'package:cs_projesi/pages/addActivityPage.dart';
import 'package:cs_projesi/pages/showOnMapPage.dart';
import 'package:cs_projesi/pages/myEventDetailPage.dart';

class PersonalPage extends StatefulWidget {
  const PersonalPage({Key? key}) : super(key: key);

  @override
  _PersonalPageState createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {
  final int _selectedIndex = 1;
  final userId = FirebaseAuth.instance.currentUser?.uid;
  late Future<List<Event>> _activitiesFuture;

  @override
  void initState() {
    super.initState();
    _activitiesFuture = _fetchYourActivities();
  }

  void _refreshActivities() {
    setState(() {
      _activitiesFuture = _fetchYourActivities();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(5),
        child: AppBar(),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 20, bottom: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(left: 15, top: 5),
                child: Text(
                  "Followings",
                  style: TextStyle(
                    fontFamily: 'RobotoSerif',
                    fontSize: 18,
                    color: Colors.black87,
                    letterSpacing: -1,
                  ),
                ),
              ),
              const StoryBarWidget(),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Your Activities",
                      style: TextStyle(
                        fontFamily: 'RobotoSerif',
                        fontSize: 24,
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -1,
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddActivityPage(),
                          ),
                        );
                        _refreshActivities();
                      },
                      icon: const Icon(Icons.add_circle_outline),
                      color: Colors.black87,
                      iconSize: 28,
                      tooltip: 'Add Activity',
                    ),
                  ],
                ),
              ),
              Expanded(
                child: FutureBuilder<List<Event>>(
                  future: _activitiesFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.sentiment_dissatisfied_outlined, size: 60, color: Colors.grey),
                            SizedBox(height: 10),
                            Text(
                              "There is no activity yet",
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'RobotoSerif',
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    final activities = snapshot.data!;
                    return ListView.builder(
                      itemCount: activities.length,
                      itemBuilder: (context, index) {
                        final event = activities[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MyEventDetailPage(event: event),
                              ),
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      event.formattedDate,
                                      style: const TextStyle(fontSize: 13, color: Colors.black45),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              const Icon(Icons.location_on_outlined, color: Colors.black45, size: 16),
                                              const SizedBox(width: 4),
                                              Flexible(
                                                child: Text(
                                                  event.where.isNotEmpty ? event.where : event.location,
                                                  style: const TextStyle(fontSize: 13, color: Colors.black45),
                                                  textAlign: TextAlign.center,
                                                  softWrap: true,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                                      onPressed: () => _confirmDelete(event.id),
                                    ),
                                  ],
                                ),
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.asset(
                                  event.eventPhotoPath.isNotEmpty
                                      ? event.eventPhotoPath
                                      : 'assets/placeholder.jpg',
                                  height: 100,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  event.descriptionMini,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'RobotoSerif',
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavigationBarNature(selectedIndex: _selectedIndex),
    );
  }

  Future<List<Event>> _fetchYourActivities() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return [];

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('your_activities')
        .get();

    return snapshot.docs.map((doc) {
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

      return Event(
        id: data['id'] ?? doc.id,
        createdBy: data['createdBy'] ?? userId,
        location: data['location'] ?? '',
        coordinates: coordinates,
        date: (data['date'] as Timestamp).toDate(),
        descriptionMini: data['descriptionMini'] ?? '',
        eventPhotoPath: data['eventPhotoPath'] ?? '',
        descriptionLarge: data['descriptionLarge'] ?? '',
        where: data['where'] ?? '',
        bring: data['bring'] ?? '',
        goal: data['goal'] ?? '',
        when: data['when'] ?? '',
        createdAt: (data['createdAt'] as Timestamp).toDate(),
      );
    }).toList();
  }

  Future<void> _deleteActivity(String eventId) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('your_activities')
        .doc(eventId)
        .delete();

    _refreshActivities();
  }

  void _confirmDelete(String eventId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Activity'),
        content: const Text('Are you sure you want to delete this activity?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _deleteActivity(eventId);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
