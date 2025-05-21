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
  FirebaseFirestore get firestore => _firestore;

  // Follow logic using followings only
  Future<void> followUser(String targetId) async {
    final currentUserId = _auth.currentUser?.uid;
    if (currentUserId == null || currentUserId == targetId) return;

    final followingsRef = _firestore.collection('users').doc(currentUserId).collection('followings');
    final exists = (await followingsRef.doc(targetId).get()).exists;
    if (!exists) {
      await followingsRef.doc(targetId).set({'followedAt': FieldValue.serverTimestamp()});
    }
  }

  Future<void> unfollowUser(String targetId) async {

    final currentUserId = _auth.currentUser?.uid;
    if (currentUserId == null || currentUserId == targetId) return;
    await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('followings')
        .doc(targetId)
        .delete();
  }

  Future<List<String>> getFollowedUserIds() async {
    final currentUserId = _auth.currentUser?.uid;
    if (currentUserId == null) return [];

    final snapshot = await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('followings')
        .get();

    return snapshot.docs.map((doc) => doc.id).toList();
  }


  Future<bool> isFollowing(String targetId) async {
    final currentUserId = _auth.currentUser?.uid;
    if (currentUserId == null) return false;
    final doc = await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('followings')
        .doc(targetId)
        .get();
    return doc.exists;
  }

  Future<bool> userHasActiveActivity(String userId) async {
    final now = DateTime.now();
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('your_activities')
        .where('date', isGreaterThan: Timestamp.fromDate(now))
        .limit(1)
        .get();
    return snapshot.docs.isNotEmpty;
  }



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
  Future<Profile?> getUserFromUsersCollection(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (!doc.exists) return null;

    final data = doc.data()!;
    return Profile(
      id: data['uid'],
      name: data['name'],
      surname: '',
      hasEvent: false,
      profilePhotoPath: data['profilePhotoUrl'] ?? '',
      createdBy: data['createdBy'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      age: data['age'] ?? 0,
      bio: data['bio'] ?? '',
      favoriteActivities: List<String>.from(data['favoriteActivities'] ?? []),
      favoritePlaces: List<String>.from(data['favoritePlaces'] ?? []),
    );
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
          LatLng coordinates;
          final coord = data['coordinates'];
          if (coord is GeoPoint) {
            coordinates = LatLng(coord.latitude, coord.longitude);
          } else if (coord is List && coord.length == 2) {
            coordinates = LatLng(coord[0], coord[1]);
          } else if (coord is Map && coord.containsKey('_latitude')) {
            coordinates = LatLng(coord['_latitude'], coord['_longitude']);
          } else {
            continue;
          }
          final requiredFields = ['id', 'createdBy', 'location', 'date', 'descriptionMini', 'eventPhotoPath', 'descriptionLarge', 'where', 'bring', 'goal', 'when', 'createdAt'];
          bool hasNull = requiredFields.any((field) => !data.containsKey(field) || data[field] == null);
          if (hasNull) continue;

          events.add(Event(
            id: data['id'],
            createdBy: data['createdBy'],
            location: data['location'],
            coordinates: coordinates,
            date: (data['date'] as Timestamp).toDate(),
            descriptionMini: data['descriptionMini'],
            eventPhotoPath: data['eventPhotoPath'],
            descriptionLarge: data['descriptionLarge'],
            where: data['where'],
            bring: data['bring'],
            goal: data['goal'],
            when: data['when'],
            createdAt: (data['createdAt'] as Timestamp).toDate(),
          ));
        } catch (_) {
          continue;
        }
      }
      return events;
    });
  }

  Future<String> uploadImage(File imageFile, String path) async {
    Reference ref = _storage.ref().child(path);
    await ref.putFile(imageFile);
    return await ref.getDownloadURL();
  }
}
