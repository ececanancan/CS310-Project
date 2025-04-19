class UserProfile {
  final String name;
  final int age;
  final String description;
  final List<String> favoriteActivities;
  final List<String> favoritePlaces;
  final String imagePath;
  bool isFollowing; //

  UserProfile({
    required this.name,
    required this.age,
    required this.description,
    required this.favoriteActivities,
    required this.favoritePlaces,
    required this.imagePath,
    this.isFollowing = true, //Default to not following
  });
}
