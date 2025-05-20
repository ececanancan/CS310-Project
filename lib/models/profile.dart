import 'package:cloud_firestore/cloud_firestore.dart';

class Profile {
  final String id;
  final String name;
  final String surname;
  final bool hasEvent;
  final String profilePhotoPath;
  final String createdBy;
  final DateTime createdAt;
  final int age;
  final String bio;
  final List<String> favoriteActivities;
  final List<String> favoritePlaces;

  Profile({
    required this.id,
    required this.name,
    required this.surname,
    required this.hasEvent,
    required this.profilePhotoPath,
    required this.createdBy,
    required this.createdAt,
    required this.age,
    required this.bio,
    required this.favoriteActivities,
    required this.favoritePlaces,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'surname': surname,
    'hasEvent': hasEvent,
    'profilePhotoPath': profilePhotoPath,
    'createdBy': createdBy,
    'createdAt': createdAt,
    'age': age,
    'bio': bio,
    'favoriteActivities': favoriteActivities,
    'favoritePlaces': favoritePlaces,
  };

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
    id: json['id'],
    name: json['name'],
    surname: json['surname'],
    hasEvent: json['hasEvent'],
    profilePhotoPath: json['profilePhotoPath'],
    createdBy: json['createdBy'],
    createdAt: (json['createdAt'] as Timestamp).toDate(),
    age: json['age'] ?? 0,
    bio: json['bio'] ?? '',
    favoriteActivities: List<String>.from(json['favoriteActivities'] ?? []),
    favoritePlaces: List<String>.from(json['favoritePlaces'] ?? []),
  );

  Profile copyWith({
    String? id,
    String? name,
    String? surname,
    bool? hasEvent,
    String? profilePhotoPath,
    String? createdBy,
    DateTime? createdAt,
    int? age,
    String? bio,
    List<String>? favoriteActivities,
    List<String>? favoritePlaces,
  }) {
    return Profile(
      id: id ?? this.id,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      hasEvent: hasEvent ?? this.hasEvent,
      profilePhotoPath: profilePhotoPath ?? this.profilePhotoPath,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      age: age ?? this.age,
      bio: bio ?? this.bio,
      favoriteActivities: favoriteActivities ?? this.favoriteActivities,
      favoritePlaces: favoritePlaces ?? this.favoritePlaces,
    );
  }
}
