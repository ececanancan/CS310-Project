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

//main function to run the app
void main(){
  runApp(MaterialApp(
      title: 'NatureSync',
      initialRoute: '/HomePage',
      routes: {
        '/HomePage': (context) => HomePage(),
        '/EventPage': (context) => EventPage(event: ModalRoute.of(context)!.settings.arguments as Event),
      }
  ));
}










