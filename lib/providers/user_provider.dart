import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProvider extends ChangeNotifier {
  String? _uid;
  String? _name;
  String? _profilePhoto;

  String? get uid => _uid;
  String? get name => _name;
  String? get profilePhoto => _profilePhoto;

  bool get isLoaded => _name != null;

  Future<void> loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    _uid = user.uid;

    final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    final data = doc.data();
    _name = data?['name'];
    _profilePhoto = data?['profilePhotoUrl'];
    notifyListeners();
  }
}
