import 'package:cs_projesi/models/profile.dart';
import 'package:cs_projesi/models/event.dart';
import 'package:cs_projesi/data/profile_data.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

Profile findProfileByName(String name) =>
    profiles.firstWhere((p) => p.name == name);

final List<Event> events = [

  Event(
      createdBy: findProfileByName("Demir"),
      location: "Polonezköy Nature Park",
      coordinates: LatLng(41.1186, 29.1307),
      date: DateTime.now().add(Duration(days: 1, hours: 3)),
      descriptionMini: "Forest Clean-Up at Polonezköy Nature Park!",
      eventPhotoPath: "assets/nature_photos/orman_photo.jpg",
      descriptionLarge: "Hello Nature Guardians! \nJoin us at the serene Polonezköy Nature Park for a "
          "meaningful forest clean-up event. This effort aims to raise awareness about land pollution in"
          " natural parks and promote collective responsibility for protecting our green spaces. Together, "
          "we’ll help preserve the purity of this beloved forest while building a stronger environmental community.",
      where: "Polonezköy Tabiat Parkı - We'll meet at the main entrance gate"
          " and head into one of the picnic areas where waste is most visible.",
      bring: "1-Gloves to safely collect litter. \n2-Trash bags (preferably eco-friendly). \n3-Sunscreen, insect repellent, hats, and reusable water bottles to stay safe and hydrated.",
      goal: "Our goal is to protect the forest by cleaning and educating. "
          "It's not just about picking up trash—it's about sparking awareness and action. \nLooking for Forest Friends! \nIf you're passionate about nature and want to make a difference, come join us! Let’s turn this clean-up into a positive memory together.",
      when: "${DateFormat('EEEE, MMMM d').format(DateTime.now().add(Duration(days: 1, hours: 3)))}, from ${DateFormat('h:mm a').format(DateTime.now().add(Duration(days: 1, hours: 3)))}"
  ),
  Event(
      createdBy: findProfileByName("Eliz"),
      location: "Çamlıca Hill",
      coordinates: LatLng(41.0201, 29.0666),
      date: DateTime.now().add(Duration(hours: 2)),
      descriptionMini: "Witness the Majestic Stork Migration Over Istanbul",
      eventPhotoPath: "assets/nature_photos/idk_wid.jpg",
      descriptionLarge: "Hello Nature Enthusiasts! \nEvery year, thousands of white storks (Ciconia ciconia) pass through Istanbul during their incredible migration journey between Europe and Africa. This weekend, let’s come together to witness this awe-inspiring natural event and learn more about these fascinating birds.",
      where: "Çamlıca Hill, one of the best spots in Istanbul to observe the storks riding thermal currents over the Bosphorus.",
      bring: "1-Binoculars or a camera for birdwatching and photography. \n2-Comfortable walking shoes and water. \n3-A notebook if you’d like to jot down observations!",
      goal: "This event is a great opportunity to marvel at one of nature's most breathtaking spectacles while connecting with fellow bird lovers. We'll also discuss how climate change impacts migration patterns and what we can do to protect these magnificent creatures. \nLooking for Nature Buddies! \nIf you’re interested, join the event. Let’s experience the beauty of the stork migration together and make it a day to remember!",
      when: "Today, from ${DateFormat('h:mm a').format(DateTime.now().add(Duration(hours: 2)))}"
  ),
  Event(
      createdBy: findProfileByName("Josef"),
      location: "Moda Coast, Kadıköy",
      coordinates: LatLng(40.9839, 29.0256),
      date: DateTime.now().add(Duration(days: 1, hours: 2)),
      descriptionMini: "Relaxing Picnic Gathering at Moda Coast!",
      eventPhotoPath: "assets/nature_photos/sahil_moda.jpg",
      descriptionLarge: "Hey Picnic Lovers! \nJoin us for a chill and breezy picnic at the beautiful Moda Coast. This will be a potluck-style hangout where everyone brings something to share—food, fun, and good vibes! It’s the perfect way to relax by the sea, watch the sunset, and connect with nature and new friends.",
      where: "Moda Sahili - We'll meet near the large tree close to the pier and pick a cozy seaside spot to lay down our blankets and enjoy the view.",
      bring: "1-Home-made or store-bought food to share. \n2-A picnic blanket or beach towel. \n3-Fun games like cards, frisbee, or beach ball. \n4-A small speaker or musical instrument if you'd like to create a vibe.",
      goal: "The goal is to slow down, share good food, laugh a lot, and enjoy the coastal breeze together. Whether you're coming solo or with friends, you're more than welcome. \nLooking for Chill Picnic Buddies! \nIf this sounds like your kind of Sunday, bring your smile and let’s make some memories!",
      when: "${DateFormat('EEEE, MMMM d').format(DateTime.now().add(Duration(days: 1, hours: 2)))}, from ${DateFormat('h:mm a').format(DateTime.now().add(Duration(days: 1, hours: 2)))}"
  ),


];


