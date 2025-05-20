import 'package:flutter/material.dart';
import 'package:cs_projesi/widgets/storyBarWidget.dart';
import 'package:cs_projesi/widgets/navigationBarWidget.dart';
import 'package:cs_projesi/pages/addActivityPage.dart'; // Make sure this import path matches your project structure

class PersonalPage extends StatefulWidget {
  const PersonalPage({Key? key}) : super(key: key);

  @override
  _PersonalPageState createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {
  final int _selectedIndex = 1; // Profile icon selected

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(5),
        child: AppBar(),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 20, bottom: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top bar
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

                  // Followings
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

                  // Activities title + Add button
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Activities",
                          style: TextStyle(
                            fontFamily: 'RobotoSerif',
                            fontSize: 24,
                            color: Colors.black87,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -1,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AddActivityPage(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.add_circle_outline),
                          color: Colors.black87,
                          iconSize: 28,
                          tooltip: 'Add Activity',
                        ),
                      ],
                    ),
                  ),

                  // Empty state
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
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
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBarNature(selectedIndex: _selectedIndex),
    );
  }
}
