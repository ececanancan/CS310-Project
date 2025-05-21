import 'package:flutter/material.dart';
import 'package:cs_projesi/models/profile.dart';
import 'package:cs_projesi/models/event.dart';
import 'package:cs_projesi/widgets/eventCardWidget.dart';
import 'package:cs_projesi/widgets/storyBarWidget.dart';
import 'package:cs_projesi/widgets/navigationBarWidget.dart';
import 'package:cs_projesi/firebase/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 2;
  final FirebaseService _firebaseService = FirebaseService();
  String? userName;

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final profile = await _firebaseService.getProfile(user.uid);
      setState(() {
        userName = profile?.name ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(5),
          child: AppBar()),
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: EdgeInsets.only(left:10, right: 20, bottom: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: (){
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.arrow_back)),
                      Padding(
                        padding: EdgeInsets.only(right: 2),
                        child: Text(
                          userName != null && userName!.isNotEmpty ? "Hi, $userName" : "Hi",
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                            fontFamily: 'RobotoSerif',
                            fontSize: 18,
                            color: Colors.black45,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
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
                      )
                    ],
                  ),
                  StoryBarWidget(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 15),
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
                    ],
                  ),
                  Expanded(
                    child: StreamBuilder<List<Event>>(
                      stream: _firebaseService.getEvents(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        }

                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }

                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Center(child: Text('No events found'));
                        }

                        return FutureBuilder<List<Event>>(
                          future: _getFollowedUserEvents(snapshot.data!),
                          builder: (context, filteredSnapshot) {
                            if (!filteredSnapshot.hasData) {
                              return Center(child: CircularProgressIndicator());
                            }

                            final filteredEvents = filteredSnapshot.data!;
                            if (filteredEvents.isEmpty) {
                              return Center(child: Text('No followed users have shared events'));
                            }

                            return ListView.builder(
                              itemCount: filteredEvents.length,
                              itemBuilder: (context, index) {
                                return EventCardWidget(event: filteredEvents[index]);
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
        ],
      ),
      bottomNavigationBar: NavigationBarNature(
        selectedIndex: _selectedIndex,
      ),
    );
  }

  Future<List<Event>> _getFollowedUserEvents(List<Event> allEvents) async {
    final followedUserIds = await _firebaseService.getFollowedUserIds();
    return allEvents
        .where((event) => followedUserIds.contains(event.createdBy))
        .toList();
  }


}
