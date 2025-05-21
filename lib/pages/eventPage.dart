import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs_projesi/models/event.dart';
import 'package:cs_projesi/models/profile.dart';
import 'package:cs_projesi/firebase/firebase_service.dart';
import 'package:cs_projesi/pages/ProfilePage.dart';
import 'package:cs_projesi/pages/showOnMapPage.dart';
import 'package:cs_projesi/utility_classes/eventPage_utility.dart';
import 'package:cs_projesi/utility_classes/app_colors.dart';
import 'package:cs_projesi/widgets/navigationBarWidget.dart';

class EventPage extends StatefulWidget {
  final Event event;
  final bool showOnlyMap;

  const EventPage({super.key, required this.event, this.showOnlyMap = false});

  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  int _selectedIndex = 2;
  bool _isRequested = false;
  final FirebaseService _firebaseService = FirebaseService();
  late final String? currentUserId;

  @override
  void initState() {
    super.initState();
    currentUserId = FirebaseAuth.instance.currentUser?.uid;
    _checkJoinRequest();
  }

  Future<void> _checkJoinRequest() async {
    if (currentUserId == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('events')
        .doc(widget.event.id)
        .collection('requests')
        .doc(currentUserId)
        .get();

    setState(() {
      _isRequested = doc.exists;
    });
  }

  Future<void> _toggleJoinRequest() async {
    if (currentUserId == null) return;

    final ref = FirebaseFirestore.instance
        .collection('events')
        .doc(widget.event.id)
        .collection('requests')
        .doc(currentUserId);

    if (_isRequested) {
      await ref.delete();
    } else {
      await ref.set({'isRequested': true});
    }

    setState(() {
      _isRequested = !_isRequested;
    });
  }

  @override
  Widget build(BuildContext context) {
    final event = widget.event;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(5),
        child: AppBar(),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 20, bottom: 15),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back),
                  ),
                  const SizedBox(width: 130),
                  Text(
                    event.formattedDate,
                    style: const TextStyle(
                      fontFamily: 'RobotoSerif',
                      fontSize: 18,
                      color: Colors.black45,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15, top: 10),
                    child: SizedBox(
                      width: 300,
                      height: 80,
                      child: Text(
                        event.descriptionMini,
                        style: const TextStyle(
                          fontFamily: 'RobotoSerif',
                          fontSize: 22,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  FutureBuilder<Profile?>(
                    future: _firebaseService.getProfile(event.createdBy),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const CircleAvatar(radius: 25, backgroundColor: Colors.grey);
                      }
                      final profile = snapshot.data!;
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProfilePage(user: profile),
                            ),
                          );
                        },
                        child: CircleAvatar(
                          radius: 25,
                          backgroundImage: profile.profilePhotoPath.startsWith("http")
                              ? NetworkImage(profile.profilePhotoPath)
                              : AssetImage(profile.profilePhotoPath) as ImageProvider,
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  event.eventPhotoPath.isNotEmpty
                      ? event.eventPhotoPath
                      : 'assets/placeholder.jpg',
                  height: 280,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        EventPageUtility.infoTile("", event.descriptionLarge),
                        EventPageUtility.infoTile("When:", event.when),
                        EventPageUtility.infoTile("Where:", event.where),
                        EventPageUtility.infoTile("What to bring:", event.bring),
                        EventPageUtility.infoTile("Goal:", event.goal),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (!widget.showOnlyMap)
                      GestureDetector(
                        onTap: _toggleJoinRequest,
                        child: Container(
                          height: 65,
                          width: 130,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: _isRequested
                                ? AppColors.green.withOpacity(0.5)
                                : Colors.white,
                            border: Border.all(color: AppColors.green, width: 3),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Text(
                            _isRequested ? "Sent" : "Request to join",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.black87,
                              letterSpacing: -0.7,
                              height: 1.1,
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ShowOnMapPage(event: event),
                          ),
                        );
                      },
                      child: Container(
                        height: 65,
                        width: 130,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: AppColors.green, width: 3),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Text(
                          "Show on map",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black87,
                            letterSpacing: -0.7,
                            height: 1.1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavigationBarNature(selectedIndex: _selectedIndex),
    );
  }
}
