import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'package:cs_projesi/providers/user_provider.dart';

import 'package:cs_projesi/pages/personalPage.dart';
import 'package:cs_projesi/models/profile.dart';
import 'package:cs_projesi/models/event.dart';
import 'package:cs_projesi/pages/homePage.dart';
import 'package:cs_projesi/pages/eventPage.dart';
import 'package:cs_projesi/pages/profileCreation.dart';
import 'package:cs_projesi/pages/questionMarkPage.dart';
import 'package:cs_projesi/pages/ProfilePage.dart';
import 'package:cs_projesi/pages/SettingsPage.dart';
import 'package:cs_projesi/pages/sign_in_page.dart';
import 'package:cs_projesi/pages/sign_up_page.dart';
import 'package:cs_projesi/pages/mapPage.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print('Error initializing Firebase: $e');
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NatureSync',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'RobotoSerif',
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SignInPage(),
        '/SignUp': (context) => const SignUpPage(),
        '/ProfileCreation': (context) => ProfileCreationPage(),
        '/HomePage': (context) => HomePage(),
        '/EventPage': (context) =>
            EventPage(event: ModalRoute.of(context)!.settings.arguments as Event),
        '/SettingsPage': (context) => const SettingsPage(),
        '/PersonalPage': (context) => const PersonalPage(),
        '/MapPage': (context) => const MapPage(),
        '/QuestionMarkPage': (context) => const QuestionMarkPage(),
        '/ProfilePage': (context) {
          final args = ModalRoute.of(context)!.settings.arguments;
          if (args is Map && args['profile'] is Profile) {
            return ProfilePage(
              user: args['profile'],
              isOwnProfile: args['isOwnProfile'] ?? false,
            );
          }
          return const Scaffold(body: Center(child: Text('No profile data')));
        },
      },
    );
  }
}
