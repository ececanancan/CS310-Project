import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String id;
  final String name;
  final int age;
  final String description;
  final List<String> favoriteActivities;
  final List<String> favoritePlaces;
  final String imagePath;
  final bool isFollowing;
  final String createdBy;
  final DateTime createdAt;

  UserProfile({
    required this.id,
    required this.name,
    required this.age,
    required this.description,
    required this.favoriteActivities,
    required this.favoritePlaces,
    required this.imagePath,
    this.isFollowing = true,
    required this.createdBy,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'age': age,
    'description': description,
    'favoriteActivities': favoriteActivities,
    'favoritePlaces': favoritePlaces,
    'imagePath': imagePath,
    'isFollowing': isFollowing,
    'createdBy': createdBy,
    'createdAt': createdAt,
  };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    id: json['id'],
    name: json['name'],
    age: json['age'],
    description: json['description'],
    favoriteActivities: List<String>.from(json['favoriteActivities']),
    favoritePlaces: List<String>.from(json['favoritePlaces']),
    imagePath: json['imagePath'],
    isFollowing: json['isFollowing'],
    createdBy: json['createdBy'],
    createdAt: (json['createdAt'] as Timestamp).toDate(),
  );

  UserProfile copyWith({
    String? id,
    String? name,
    int? age,
    String? description,
    List<String>? favoriteActivities,
    List<String>? favoritePlaces,
    String? imagePath,
    bool? isFollowing,
    String? createdBy,
    DateTime? createdAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      description: description ?? this.description,
      favoriteActivities: favoriteActivities ?? this.favoriteActivities,
      favoritePlaces: favoritePlaces ?? this.favoritePlaces,
      imagePath: imagePath ?? this.imagePath,
      isFollowing: isFollowing ?? this.isFollowing,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
