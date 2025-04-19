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
import 'package:cs_projesi/pages/sign_in_page.dart';
import 'package:cs_projesi/pages/sign_up_page.dart';

void main() {
  runApp(MaterialApp(
    title: 'NatureSync',
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    routes: {
      '/': (context) => const SignInPage(),
      '/SignUp': (context) => const SignUpPage(),
      '/ProfileCreation': (context) => ProfileCreationPage(),
      '/HomePage': (context) => HomePage(),
      '/EventPage': (context) => EventPage(event: ModalRoute.of(context)!.settings.arguments as Event),
      '/SettingsPage': (context) => const SettingsPage(),
      '/QuestionMarkPage': (context) => const QuestionMarkPage(),
      '/ProfilePage': (context) => ProfilePage(user: ModalRoute.of(context)!.settings.arguments as UserProfile),
    },
  ));
}
