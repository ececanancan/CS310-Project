import 'package:flutter/material.dart';
import 'package:cs_projesi/models/event.dart';
import 'package:cs_projesi/utility_classes/eventPage_utility.dart';
import 'package:cs_projesi/utility_classes/app_colors.dart';
import 'package:cs_projesi/pages/showOnMapPage.dart';

class MyEventDetailPage extends StatelessWidget {
  final Event event;

  const MyEventDetailPage({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                event.descriptionMini,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'RobotoSerif',
                ),
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: event.eventPhotoPath.isNotEmpty
                    ? Image.asset(
                  event.eventPhotoPath,
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                )
                    : Container(
                  height: 250,
                  width: double.infinity,
                  color: Colors.grey[300],
                  child: const Center(child: Text('No Image')),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
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
              const SizedBox(height: 10),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                      side: BorderSide(color: AppColors.green, width: 3),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ShowOnMapPage(event: event),
                      ),
                    );
                  },
                  child: const Text(
                    "Show on map",
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'RobotoSerif',
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
