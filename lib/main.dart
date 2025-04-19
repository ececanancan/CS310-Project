import 'package:flutter/material.dart';
import 'package:cs_projesi/models/profile.dart';
import 'package:cs_projesi/models/event.dart';
import 'package:cs_projesi/data/profile_data.dart';
import 'package:cs_projesi/data/event_data.dart';
import 'package:cs_projesi/widgets/eventCardWidget.dart';
import 'package:cs_projesi/widgets/storyBarWidget.dart';
import 'package:cs_projesi/widgets/navigationBarWidget.dart';
import 'package:cs_projesi/pages/homePage.dart';
import 'package:cs_projesi/pages/eventPage.dart';
import 'package:cs_projesi/pages/profileCreation.dart';
import 'package:cs_projesi/pages/questionMarkPage.dart';
import 'package:cs_projesi/pages/ProfilePage.dart';
import 'package:cs_projesi/data/UserProfile_data.dart';
import 'package:cs_projesi/models/UserProfile.dart';
import 'package:cs_projesi/pages/SettingsPage.dart';



//main function to run the app
void main(){
  runApp(MaterialApp(
      title: 'NatureSync',
      initialRoute: '/',
      routes: {
        '/': (context) => ProfileCreationPage(),
        '/HomePage': (context) => HomePage(),
        '/EventPage': (context) => EventPage(event: ModalRoute.of(context)!.settings.arguments as Event),
        '/SettingsPage': (context) => const SettingsPage(),
        '/QuestionMarkPage': (context) => const QuestionMarkPage(),
      }
  ));
}










