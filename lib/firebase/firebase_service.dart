import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cs_projesi/models/profile.dart';
import 'package:cs_projesi/models/event.dart';
import 'package:latlong2/latlong.dart';
import 'dart:io';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Profile Operations
  Future<void> createProfile(Profile profile) async {
    await _firestore.collection('profiles').doc(profile.id).set({
      'id': profile.id,
      'name': profile.name,
      'surname': profile.surname,
      'hasEvent': profile.hasEvent,
      'profilePhotoPath': profile.profilePhotoPath,
      'createdBy': profile.createdBy,
      'createdAt': profile.createdAt,
      'age': profile.age,
      'bio': profile.bio,
      'favoriteActivities': profile.favoriteActivities,
      'favoritePlaces': profile.favoritePlaces,
    });
  }

  Future<Profile?> getProfile(String id) async {
    DocumentSnapshot doc = await _firestore.collection('profiles').doc(id).get();
    if (doc.exists) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return Profile(
        id: data['id'],
        name: data['name'],
        surname: data['surname'],
        hasEvent: data['hasEvent'],
        profilePhotoPath: data['profilePhotoPath'],
        createdBy: data['createdBy'],
        createdAt: (data['createdAt'] as Timestamp).toDate(),
        age: data['age'] ?? 0,
        bio: data['bio'] ?? '',
        favoriteActivities: List<String>.from(data['favoriteActivities'] ?? []),
        favoritePlaces: List<String>.from(data['favoritePlaces'] ?? []),
      );
    }
    return null;
  }

  Stream<List<Profile>> getProfiles() {
    return _firestore.collection('profiles').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        return Profile(
          id: data['id'],
          name: data['name'],
          surname: data['surname'],
          hasEvent: data['hasEvent'],
          profilePhotoPath: data['profilePhotoPath'],
          createdBy: data['createdBy'],
          createdAt: (data['createdAt'] as Timestamp).toDate(),
          age: data['age'] ?? 0,
          bio: data['bio'] ?? '',
          favoriteActivities: List<String>.from(data['favoriteActivities'] ?? []),
          favoritePlaces: List<String>.from(data['favoritePlaces'] ?? []),
        );
      }).toList();
    });
  }

  // Event Operations
  Future<void> createEvent(Event event) async {
    await _firestore.collection('events').doc(event.id).set({
      'id': event.id,
      'createdBy': event.createdBy,
      'location': event.location,
      'coordinates': GeoPoint(event.coordinates.latitude, event.coordinates.longitude),
      'date': event.date,
      'descriptionMini': event.descriptionMini,
      'eventPhotoPath': event.eventPhotoPath,
      'descriptionLarge': event.descriptionLarge,
      'where': event.where,
      'bring': event.bring,
      'goal': event.goal,
      'when': event.when,
      'createdAt': event.createdAt,
    });
  }

  Stream<List<Event>> getEvents() {
    return _firestore.collection('events').snapshots().map((snapshot) {
      List<Event> events = [];
      for (final doc in snapshot.docs) {
        try {
          Map<String, dynamic> data = doc.data();
          // Flexible coordinates parsing - prioritize GeoPoint
          LatLng coordinates;
          final coord = data['coordinates'];
          if (coord is GeoPoint) {
            coordinates = LatLng(coord.latitude, coord.longitude);
          } else if (coord is List && coord.length == 2) {
            coordinates = LatLng(coord[0], coord[1]);
          } else if (coord is Map && coord.containsKey('_latitude') && coord.containsKey('_longitude')) {
            coordinates = LatLng(coord['_latitude'], coord['_longitude']);
          } else {
            print('Event ${data['id'] ?? 'unknown'} skipped: invalid coordinates format');
            continue;
          }
          // Check for required fields
          final requiredFields = [
            'id', 'createdBy', 'location', 'date', 'descriptionMini',
            'eventPhotoPath', 'descriptionLarge', 'where', 'bring', 'goal', 'when', 'createdAt',
          ];
          bool hasNull = false;
          for (final field in requiredFields) {
            if (!data.containsKey(field) || data[field] == null) {
              print('Event ${data['id'] ?? 'unknown'} skipped: missing $field');
              hasNull = true;
              break;
            }
          }
          if (hasNull) continue;
          events.add(Event(
            id: data['id'],
            createdBy: data['createdBy'],
            location: data['location'],
            coordinates: coordinates,
            date: (data['date'] is Timestamp)
                ? (data['date'] as Timestamp).toDate()
                : DateTime.tryParse(data['date'].toString()) ?? DateTime.now(),
            descriptionMini: data['descriptionMini'],
            eventPhotoPath: data['eventPhotoPath'],
            descriptionLarge: data['descriptionLarge'],
            where: data['where'],
            bring: data['bring'],
            goal: data['goal'],
            when: data['when'],
            createdAt: (data['createdAt'] is Timestamp)
                ? (data['createdAt'] as Timestamp).toDate()
                : DateTime.tryParse(data['createdAt'].toString()) ?? DateTime.now(),
          ));
        } catch (e) {
          print('Error parsing event: $e');
          continue;
        }
      }
      return events;
    });
  }

  // Image Upload
  Future<String> uploadImage(File imageFile, String path) async {
    Reference ref = _storage.ref().child(path);
    await ref.putFile(imageFile);
    return await ref.getDownloadURL();
  }

  // Upload Dummy Data
  Future<void> uploadDummyData() async {
    // Create dummy profiles
    final List<Profile> dummyProfiles = [
      Profile(
        id: '1',
        name: "Demir",
        surname: "Demir",
        hasEvent: true,
        profilePhotoPath: "assets/profile_photos/demir.jpg",
        createdBy: 'system',
        createdAt: DateTime.now(),
        age: 28,
        bio: "Hi, I'm Demir—a passionate hiker and nature lover. I enjoy exploring new trails and organizing group hikes in the forests around Istanbul.",
        favoriteActivities: ["Hiking", "Organizing group hikes"],
        favoritePlaces: ["Belgrad Forest", "Polonezköy Nature Park"],
      ),
      Profile(
        id: '2',
        name: "Eliz",
        surname: "Eliz",
        hasEvent: true,
        profilePhotoPath: "assets/profile_photos/eliz.jpg",
        createdBy: 'system',
        createdAt: DateTime.now(),
        age: 25,
        bio: "Hi, I'm Eliz—a passionate stargazer and a lover of peaceful moments in nature. I find magic in the stillness of the night, gazing up at the stars and contemplating the mysteries of the universe. When I'm not exploring constellations, you'll likely find me meditating in serene natural spots, listening to the rustling leaves and flowing streams.",
        favoriteActivities: ["Hosting stargazing nights and sharing telescopic views with friends."],
        favoritePlaces: ["Çamlıca Hill", "Parks"],
      ),
      Profile(
        id: '3',
        name: "James",
        surname: "James",
        hasEvent: false,
        profilePhotoPath: "assets/profile_photos/james.jpg",
        createdBy: 'system',
        createdAt: DateTime.now(),
        age: 30,
        bio: "James is a beach lover and environmentalist. He enjoys organizing clean-up events and swimming in quiet places.",
        favoriteActivities: ["Beach cleaning", "Swimming in a quiet place"],
        favoritePlaces: ["Kilyos Beach", "Beaches"],
      ),
      Profile(
        id: '4',
        name: "Josef",
        surname: "Josef",
        hasEvent: true,
        profilePhotoPath: "assets/profile_photos/josef.jpg",
        createdBy: 'system',
        createdAt: DateTime.now(),
        age: 27,
        bio: "Josef is a mountain climber and adventure seeker. He loves the thrill of reaching new heights and sharing his experiences with friends.",
        favoriteActivities: ["Mountain Climbing", "Adventure trips"],
        favoritePlaces: ["Mountains", "Forests"],
      ),
      Profile(
        id: '5',
        name: "Mert",
        surname: "Aslan",
        hasEvent: false,
        profilePhotoPath: "https://media.licdn.com/dms/image/v2/D4D03AQGvnrxP1zWDRA/profile-displayphoto-shrink_800_800/profile-displayphoto-shrink_800_800/0/1724950492844?e=1750291200&v=beta&t=x7BBW-_fXvPoolZVsC-bLpe3ZqJwQgJkgzm85BjVbfY",
        createdBy: 'system',
        createdAt: DateTime.now(),
        age: 24,
        bio: "Mert is a park enthusiast who enjoys relaxing in green spaces and playing frisbee with friends.",
        favoriteActivities: ["Playing frisbee", "Relaxing in parks"],
        favoritePlaces: ["Parks", "Lakes"],
      ),
    ];

    // Upload profiles
    for (var profile in dummyProfiles) {
      await createProfile(profile);
    }

    // Create dummy events
    final List<Event> dummyEvents = [
      Event(
        id: '1',
        createdBy: '1', // Demir's ID
        location: "Polonezköy Nature Park",
        coordinates: LatLng(41.1186, 29.1307),
        date: DateTime.now().add(Duration(days: 1, hours: 3)),
        descriptionMini: "Forest Clean-Up at Polonezköy Nature Park!",
        eventPhotoPath: "assets/nature_photos/orman_photo.jpg",
        descriptionLarge: "Hello Nature Guardians! \nJoin us at the serene Polonezköy Nature Park for a "
            "meaningful forest clean-up event. This effort aims to raise awareness about land pollution in"
            " natural parks and promote collective responsibility for protecting our green spaces. Together, "
            "we'll help preserve the purity of this beloved forest while building a stronger environmental community.",
        where: "Polonezköy Tabiat Parkı - We'll meet at the main entrance gate"
            " and head into one of the picnic areas where waste is most visible.",
        bring: "1-Gloves to safely collect litter. \n2-Trash bags (preferably eco-friendly). \n3-Sunscreen, insect repellent, hats, and reusable water bottles to stay safe and hydrated.",
        goal: "Our goal is to protect the forest by cleaning and educating. "
            "It's not just about picking up trash—it's about sparking awareness and action. \nLooking for Forest Friends! \nIf you're passionate about nature and want to make a difference, come join us! Let's turn this clean-up into a positive memory together.",
        when: "${DateTime.now().add(Duration(days: 1, hours: 3)).toString()}",
        createdAt: DateTime.now(),
      ),
      Event(
        id: '2',
        createdBy: '2', // Eliz's ID
        location: "Çamlıca Hill",
        coordinates: LatLng(41.0201, 29.0666),
        date: DateTime.now().add(Duration(hours: 2)),
        descriptionMini: "Witness the Majestic Stork Migration Over Istanbul",
        eventPhotoPath: "assets/nature_photos/idk_wid.jpg",
        descriptionLarge: "Hello Nature Enthusiasts! \nEvery year, thousands of white storks (Ciconia ciconia) pass through Istanbul during their incredible migration journey between Europe and Africa. This weekend, let's come together to witness this awe-inspiring natural event and learn more about these fascinating birds.",
        where: "Çamlıca Hill, one of the best spots in Istanbul to observe the storks riding thermal currents over the Bosphorus.",
        bring: "1-Binoculars or a camera for birdwatching and photography. \n2-Comfortable walking shoes and water. \n3-A notebook if you'd like to jot down observations!",
        goal: "This event is a great opportunity to marvel at one of nature's most breathtaking spectacles while connecting with fellow bird lovers. We'll also discuss how climate change impacts migration patterns and what we can do to protect these magnificent creatures. \nLooking for Nature Buddies! \nIf you're interested, join the event. Let's experience the beauty of the stork migration together and make it a day to remember!",
        when: "${DateTime.now().add(Duration(hours: 2)).toString()}",
        createdAt: DateTime.now(),
      ),
      Event(
        id: '3',
        createdBy: '4', // Josef's ID
        location: "Moda Coast, Kadıköy",
        coordinates: LatLng(40.9839, 29.0256),
        date: DateTime.now().add(Duration(days: 1, hours: 2)),
        descriptionMini: "Relaxing Picnic Gathering at Moda Coast!",
        eventPhotoPath: "assets/nature_photos/sahil_moda.jpg",
        descriptionLarge: "Hey Picnic Lovers! \nJoin us for a chill and breezy picnic at the beautiful Moda Coast. This will be a potluck-style hangout where everyone brings something to share—food, fun, and good vibes! It's the perfect way to relax by the sea, watch the sunset, and connect with nature and new friends.",
        where: "Moda Sahili - We'll meet near the large tree close to the pier and pick a cozy seaside spot to lay down our blankets and enjoy the view.",
        bring: "1-Home-made or store-bought food to share. \n2-A picnic blanket or beach towel. \n3-Fun games like cards, frisbee, or beach ball. \n4-A small speaker or musical instrument if you'd like to create a vibe.",
        goal: "The goal is to slow down, share good food, laugh a lot, and enjoy the coastal breeze together. Whether you're coming solo or with friends, you're more than welcome. \nLooking for Chill Picnic Buddies! \nIf this sounds like your kind of Sunday, bring your smile and let's make some memories!",
        when: "${DateTime.now().add(Duration(days: 1, hours: 2)).toString()}",
        createdAt: DateTime.now(),
      ),
    ];

    // Upload events
    for (var event in dummyEvents) {
      await createEvent(event);
    }

    // Upload map locations as events
    await uploadMapLocations();
  }

  Future<void> clearAndUploadDummyProfiles() async {
    // Delete all documents in 'profiles' collection
    final batch = _firestore.batch();
    final profilesSnapshot = await _firestore.collection('profiles').get();
    for (final doc in profilesSnapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
    // Upload dummy data
    await uploadDummyData();
  }

  Future<void> uploadMapLocations() async {
    // Delete old map events (id starts with 'map_')
    final mapEventsSnapshot = await _firestore.collection('events').where(FieldPath.documentId, isGreaterThanOrEqualTo: 'map_').where(FieldPath.documentId, isLessThan: 'map`').get();
    for (final doc in mapEventsSnapshot.docs) {
      await doc.reference.delete();
    }

    // Get all profiles first
    final profilesSnapshot = await _firestore.collection('profiles').get();
    final profiles = profilesSnapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data();
      return Profile(
        id: data['id'],
        name: data['name'],
        surname: data['surname'],
        hasEvent: data['hasEvent'],
        profilePhotoPath: data['profilePhotoPath'],
        createdBy: data['createdBy'],
        createdAt: (data['createdAt'] as Timestamp).toDate(),
        age: data['age'] ?? 0,
        bio: data['bio'] ?? '',
        favoriteActivities: List<String>.from(data['favoriteActivities'] ?? []),
        favoritePlaces: List<String>.from(data['favoritePlaces'] ?? []),
      );
    }).toList();

    // Filter profiles that have events
    final profilesWithEvents = profiles.where((profile) => profile.hasEvent).toList();

    // Create map events only for profiles that have events
    final List<Event> mapEvents = [
      if (profilesWithEvents.isNotEmpty) ...[
        Event(
          id: 'map_1',
          createdBy: profilesWithEvents[0].id,
          location: "Taksim Square",
          coordinates: LatLng(41.0369, 28.9862),
          date: DateTime.now().add(Duration(days: 1)),
          descriptionMini: "Live music event this weekend!",
          eventPhotoPath: "assets/nature_photos/istanbul_photo.jpg",
          descriptionLarge: "Join us for an amazing live music event at Taksim Square this weekend! Experience the vibrant atmosphere of Istanbul's heart while enjoying great music.",
          where: "Taksim Square, Istanbul",
          bring: "1-Your enthusiasm and good vibes\n2-Comfortable shoes for dancing\n3-A camera to capture memories",
          goal: "To bring people together through music and create unforgettable moments in the heart of Istanbul.",
          when: DateTime.now().add(Duration(days: 1)).toString(),
          createdAt: DateTime.now(),
        ),
      ],
      if (profilesWithEvents.length > 1) ...[
        Event(
          id: 'map_2',
          createdBy: profilesWithEvents[1].id,
          location: "Hagia Sophia",
          coordinates: LatLng(41.0086, 28.9802),
          date: DateTime.now().add(Duration(days: 2)),
          descriptionMini: "Cultural walk and group tour happening!",
          eventPhotoPath: "assets/nature_photos/istanbul_photo.jpg",
          descriptionLarge: "Explore the magnificent Hagia Sophia with our guided cultural tour. Learn about its rich history and architectural marvels.",
          where: "Hagia Sophia, Sultanahmet, Istanbul",
          bring: "1-Comfortable walking shoes\n2-Camera for photos\n3-Water bottle",
          goal: "To share the cultural heritage of Istanbul and create an educational experience for participants.",
          when: DateTime.now().add(Duration(days: 2)).toString(),
          createdAt: DateTime.now(),
        ),
      ],
      if (profilesWithEvents.length > 2) ...[
        Event(
          id: 'map_3',
          createdBy: profilesWithEvents[2].id,
          location: "Blue Mosque",
          coordinates: LatLng(41.0056, 28.9768),
          date: DateTime.now().add(Duration(days: 3)),
          descriptionMini: "Photography meetup at sunset.",
          eventPhotoPath: "assets/nature_photos/istanbul_photo.jpg",
          descriptionLarge: "Join our photography meetup at the Blue Mosque during the magical sunset hours. Perfect for both amateur and professional photographers.",
          where: "Blue Mosque, Sultanahmet, Istanbul",
          bring: "1-Camera equipment\n2-Tripod (optional)\n3-Enthusiasm for photography",
          goal: "To capture the beauty of Istanbul's iconic landmarks and share photography techniques.",
          when: DateTime.now().add(Duration(days: 3)).toString(),
          createdAt: DateTime.now(),
        ),
      ],
      if (profilesWithEvents.length > 3) ...[
        Event(
          id: 'map_4',
          createdBy: profilesWithEvents[3].id,
          location: "Galata Tower",
          coordinates: LatLng(41.0256, 28.9744),
          date: DateTime.now().add(Duration(days: 4)),
          descriptionMini: "Night view session & storytelling.",
          eventPhotoPath: "assets/nature_photos/istanbul_photo.jpg",
          descriptionLarge: "Experience the breathtaking night views of Istanbul from Galata Tower while sharing stories and making new friends.",
          where: "Galata Tower, Beyoğlu, Istanbul",
          bring: "1-Camera for night photography\n2-Warm clothes\n3-Your favorite stories to share",
          goal: "To create a magical evening of storytelling and city views while building connections.",
          when: DateTime.now().add(Duration(days: 4)).toString(),
          createdAt: DateTime.now(),
        ),
      ],
      if (profilesWithEvents.length > 4) ...[
        Event(
          id: 'map_5',
          createdBy: profilesWithEvents[4].id,
          location: "Topkapi Palace",
          coordinates: LatLng(41.0115, 28.9833),
          date: DateTime.now().add(Duration(days: 5)),
          descriptionMini: "History trivia game hosted here.",
          eventPhotoPath: "assets/nature_photos/istanbul_photo.jpg",
          descriptionLarge: "Join us for an exciting history trivia game at Topkapi Palace. Test your knowledge about Ottoman history and win prizes!",
          where: "Topkapi Palace, Sultanahmet, Istanbul",
          bring: "1-Notebook for taking notes\n2-Comfortable walking shoes\n3-Your historical knowledge",
          goal: "To make history fun and interactive while exploring one of Istanbul's most important landmarks.",
          when: DateTime.now().add(Duration(days: 5)).toString(),
          createdAt: DateTime.now(),
        ),
      ],
    ];

    // Upload map events
    for (var event in mapEvents) {
      await createEvent(event);
    }
  }
} 