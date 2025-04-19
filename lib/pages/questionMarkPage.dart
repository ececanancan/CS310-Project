import 'package:flutter/material.dart';
import 'package:cs_projesi/widgets/navigationBarWidget.dart';


class QuestionMarkPage extends StatefulWidget {
  const QuestionMarkPage({super.key});

  @override
  _QuestionMarkPageState createState() => _QuestionMarkPageState();
}

class _QuestionMarkPageState extends State<QuestionMarkPage> {

  int _selectedIndex = 4;

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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Welcome to NatureSync 🌿',
                style: TextStyle(
                  fontFamily: 'RobotoSerif',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12),
              Text(
                'NatureSync is more than just an app—it’s a vibrant social platform designed to bring people closer to nature and foster meaningful connections.\n\n'
                    'Whether you’re:\n'
                    '• A seasoned adventurer,\n'
                    '• A nature enthusiast, or\n'
                    '• Someone looking for a peaceful escape,\n\n'
                    'NatureSync is your go-to companion for outdoor exploration and community engagement.',
                style: TextStyle(fontFamily: 'RobotoSerif', fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                'Our Mission 🌎',
                style: TextStyle(
                  fontFamily: 'RobotoSerif',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'We aim to:\n'
                    '1. Inspire people to discover and cherish the natural beauty around them.\n'
                    '2. Build a community of like-minded individuals passionate about the environment.\n\n'
                    'From tranquil parks to breathtaking coastal areas, explore Istanbul’s stunning green spaces like never before.',
                style: TextStyle(fontFamily: 'RobotoSerif', fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                'Discover Perfect Spots, Anytime 🕰️',
                style: TextStyle(
                  fontFamily: 'RobotoSerif',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'One of NatureSync’s standout features is its ability to guide you to green spots in Istanbul based on:\n'
                    '• The time of day, and\n'
                    '• The activities you enjoy.\n\n'
                    'Examples:\n'
                    '• Start your morning with a serene yoga session in quiet, sunlit parks.\n'
                    '• Find ideal spots for hiking, meditating, or just unwinding.\n'
                    '• Get informed if a place might be quiet or busy to help plan your visit better.',
                style: TextStyle(fontFamily: 'RobotoSerif', fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                'Connect Through Activities 🤝',
                style: TextStyle(
                  fontFamily: 'RobotoSerif',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'NatureSync empowers you to:\n'
                    '• Organize or join activities like hiking trips, yoga sessions, beach clean-ups, and birdwatching events.\n'
                    '• Share your favorite spots and invite others to participate.\n\n'
                    'Collaboration is at the heart of NatureSync—make new friends and enjoy shared passions!',
                style: TextStyle(fontFamily: 'RobotoSerif', fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                'Sustainability & Giving Back 🌱',
                style: TextStyle(
                  fontFamily: 'RobotoSerif',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'We believe in:\n'
                    '• Promoting sustainability and environmental stewardship.\n'
                    '• Encouraging users to give back through clean-ups and educational events.\n\n'
                    'Together, we can create a greener, healthier world—one activity at a time.',
                style: TextStyle(fontFamily: 'RobotoSerif', fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                'Let’s Explore, Connect, and Protect Nature Together!',
                style: TextStyle(
                  fontFamily: 'RobotoSerif',
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                ),
              ),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavigationBarNature(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),

    );
  }
}
