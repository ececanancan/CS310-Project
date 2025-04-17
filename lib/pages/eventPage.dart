import 'package:flutter/material.dart';
import 'package:cs_projesi/models/profile.dart';
import 'package:cs_projesi/models/event.dart';
import 'package:cs_projesi/data/profile_data.dart';
import 'package:cs_projesi/data/event_data.dart';
import 'package:cs_projesi/widgets/eventCardWidget.dart';
import 'package:cs_projesi/widgets/storyBarWidget.dart';
import 'package:cs_projesi/widgets/navigationBarWidget.dart';

class EventPage extends StatefulWidget {
  final Event event;

  const EventPage({super.key, required this.event});

  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  int _selectedIndex = 2;
  bool _isRequested = false;

  static const List<String> _routes = [
    '/SettingPage',
    'ProfilePage',
    '/HomePage',
    '/MapPage',
    '/QuestionMarkPage',
  ];

  void _onItemTapped(int index) {
    Navigator.pushReplacementNamed(context, _routes[index]);
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final event = widget.event;

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
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                          onPressed: (){
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.arrow_back)),
                      SizedBox(
                        width: 130,
                      ),
                      Text(
                        event.formattedDate,
                        overflow: TextOverflow.clip, //If the name is long (...)
                        style: TextStyle(
                          fontFamily: 'RobotoSerif',
                          fontSize: 18,
                          color: Colors.black45,),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 15, top: 10),
                        child: Container(
                          width: 300,
                          height: 80,
                          child: Text(
                            event.descriptionMini,
                            softWrap: true,
                            overflow: TextOverflow.clip, //If the name is long (...)
                            style: TextStyle(
                              fontFamily: 'RobotoSerif',
                              fontSize: 22,
                              color: Colors.black87,
                              letterSpacing: -1,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){},
                        child: Column(
                          children: [
                            CircleAvatar(
                              backgroundImage: AssetImage(event.createdBy.profilePhotoPath), radius: 35,),
                            SizedBox(height: 2,),
                            Text(
                              event.createdBy.name,
                              style: TextStyle(
                                fontFamily: 'RobotoSerif',
                                fontSize: 16,
                                color: Colors.black87,
                                letterSpacing: -1,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 8, left: 5,),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            event.eventPhotoPath,
                            height: 280,
                            width: 413,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            infoTile("", event.descriptionLarge,),
                            infoTile("When:", event.when),
                            infoTile("Where:", event.bring),
                            infoTile("What to bring:", event.bring),
                            infoTile("Goal:", event.goal),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15,),
                  Padding(
                    padding: EdgeInsets.only(left: 20, right: 20,),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isRequested = !_isRequested;
                            });
                          },
                          child: Container(
                            height: 65,
                            width: 130,
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                            decoration: BoxDecoration(
                              color: _isRequested ? Color(0xFF67C933).withOpacity(0.5) : Colors.white,
                              border: Border.all(color: Color(0xFF67C933), width: 3),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Text(
                              _isRequested ? "Sent" : "Request to join",
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

                        SizedBox(width: 10),

                        GestureDetector(
                          onTap: () {
                            print("Show on map clicked");
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                            height: 65,
                            width: 130,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Color(0xFF67C933), width: 3),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Text(
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
                  SizedBox(height: 3,)
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBarNature(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );

  }
}
Widget infoTile(String title, String content) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontFamily: 'RobotoSerif',
            fontSize: 21,
            color: Colors.black,
            letterSpacing: -0.7,
            fontWeight: FontWeight.w900,
          ),
        ),
        Text(
          content,
          style: TextStyle(
            fontFamily: 'RobotoSerif',
            fontSize: 20,
            color: Colors.black87,
            letterSpacing: -0.7,
            fontWeight: FontWeight.w500,
            height: 1.1,
          ),
        ),
        SizedBox(height: 1),
      ],
    ),
  );
}
