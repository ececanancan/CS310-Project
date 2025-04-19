import 'package:flutter/material.dart';
import 'package:cs_projesi/models/profile.dart';
import 'package:cs_projesi/models/event.dart';
import 'package:cs_projesi/data/profile_data.dart';
import 'package:cs_projesi/data/event_data.dart';
import 'package:cs_projesi/widgets/eventCardWidget.dart';
import 'package:cs_projesi/widgets/storyBarWidget.dart';
import 'package:cs_projesi/widgets/navigationBarWidget.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 2;

  static const List<String> _routes = [
    '/SettingPage',
    '/ProfilePage',
    '/HomePage',
    '/MapPage',
    '/QuestionMarkPage',
  ];

  void _onItemTapped(int index) {
    if (index != _selectedIndex) {
      Navigator.pushNamed(context, _routes[index]);
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context){
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
                          "Hi, Kiyan",
                          overflow: TextOverflow.clip, //If the name is long (...)
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
                    child: ListView.builder(
                      itemCount: events.length,
                      itemBuilder: (context, index){
                        return EventCardWidget(event: events[index]);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 0.1),
              child: IconButton(onPressed: (){} ,icon: Icon(Icons.notifications_none_sharp), iconSize: 25,),
            ),
          )
        ],
      ),
      bottomNavigationBar: NavigationBarNature(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}