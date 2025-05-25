import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:cs_projesi/models/event.dart';
import 'package:cs_projesi/widgets/eventCardWidget.dart';
import 'package:cs_projesi/widgets/storyBarWidget.dart';
import 'package:cs_projesi/widgets/navigationBarWidget.dart';
import 'package:cs_projesi/firebase/firebase_service.dart';
import 'package:latlong2/latlong.dart';
import 'package:cs_projesi/pages/requestNotificationPage.dart';
import 'package:cs_projesi/providers/user_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 2;
  final FirebaseService _firebaseService = FirebaseService();
  bool _hasNewNotif = false;

  @override
  void initState() {
    super.initState();
    Provider.of<UserProvider>(context, listen: false).loadUserData();
    _checkForNewNotifications();
  }

  Future<void> _checkForNewNotifications() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    bool hasUnreadNotif = false;
    bool hasPendingRequest = false;

    final notifSnap = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('notifications')
        .where('read', isEqualTo: false)
        .get();

    hasUnreadNotif = notifSnap.docs.isNotEmpty;

    final eventsSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('your_activities')
        .get();

    for (final eventDoc in eventsSnapshot.docs) {
      final eventId = eventDoc.id;
      final requestsSnapshot = await FirebaseFirestore.instance
          .collection('events')
          .doc(eventId)
          .collection('requests')
          .get();

      for (final req in requestsSnapshot.docs) {
        final status = req.data()['status'];
        if (status == null) {
          hasPendingRequest = true;
          break;
        }
      }

      if (hasPendingRequest) break;
    }

    setState(() {
      _hasNewNotif = hasUnreadNotif || hasPendingRequest;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userName = Provider.of<UserProvider>(context).name ?? "Hi";

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.black),
          ),
          title: IconButton(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RequestNotificationPage()),
              );
              if (result == true) {
                _checkForNewNotifications();
              }

            },
            icon: Stack(
              children: [
                const Icon(Icons.notifications, color: Colors.black),
                if (_hasNewNotif)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                      constraints: const BoxConstraints(minWidth: 8, minHeight: 8),
                    ),
                  ),
              ],
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Center(
                child: Text(
                  "Hi, $userName",
                  style: const TextStyle(fontSize: 16, color: Colors.black45),
                ),
              ),
            )
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 20, bottom: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              StoryBarWidget(),
              const Padding(
                padding: EdgeInsets.only(left: 15, top: 10),
                child: Text(
                  "Activities",
                  style: TextStyle(
                    fontFamily: 'RobotoSerif',
                    fontSize: 24,
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -1,
                  ),
                ),
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(FirebaseAuth.instance.currentUser?.uid)
                      .collection('followings')
                      .snapshots(),
                  builder: (context, followingSnapshot) {
                    if (!followingSnapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return FutureBuilder<List<Event>>(
                      future: _loadFollowedActivities(),
                      builder: (context, eventSnapshot) {
                        if (!eventSnapshot.hasData) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        final events = eventSnapshot.data!;
                        if (events.isEmpty) {
                          return const Center(child: Text('No followed users have shared events'));
                        }

                        return ListView.builder(
                          itemCount: events.length,
                          itemBuilder: (context, index) {
                            return EventCardWidget(event: events[index]);
                          },
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

  Future<List<Event>> _loadFollowedActivities() async {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId == null) return [];
    final followingsSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .collection('followings')
        .get();
    final followedUserIds = followingsSnapshot.docs.map((doc) => doc.id).toList();
    List<Event> allEvents = [];
    for (final uid in followedUserIds) {
      final activitySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('your_activities')
          .get();
      for (final doc in activitySnapshot.docs) {
        final data = doc.data();
        final coord = data['coordinates'];
        final coordinates = coord is GeoPoint ? LatLng(coord.latitude, coord.longitude) : LatLng(0, 0);
        final whenStr = data['when'] ?? '';
        DateTime? whenDateTime;
        try {
          whenDateTime = DateTime.parse(whenStr);
        } catch (_) {
          continue;
        }
        if (whenDateTime.isAfter(DateTime.now())) {
          allEvents.add(Event(
            id: data['id'] ?? doc.id,
            createdBy: uid,
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
    }
    allEvents.sort((a, b) => DateTime.parse(a.when).compareTo(DateTime.parse(b.when)));
    return allEvents;
  }
}
