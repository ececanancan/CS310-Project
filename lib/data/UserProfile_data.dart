import 'package:cs_projesi/models/UserProfile.dart';


List<String> parseFavorites(String input) {
  return input
      .split('\n') // Split by new lines
      .map((line) {
    final trimmed = line.trim();
    if (trimmed.startsWith('*')) {
      return trimmed.substring(1).trim(); // Remove leading *
    }
    return trimmed; // In case no star
  })
      .where((item) => item.isNotEmpty)
      .toList();
}




final List<UserProfile> profs = [
  UserProfile(
    name: 'Eliz',
    age: 25,
    imagePath: "assets/profile_photos/eliz.jpg",
    description:
    '   Hi, I’m Eliz—a passionate stargazer and a lover of '
        'peaceful moments in nature. I find magic in the stillness of the night, '
        'gazing up at the stars and contemplating the mysteries of the universe. '
        'When I’m not exploring constellations, you’ll likely find me meditating in serene '
        'natural spots, listening to the rustling leaves and flowing streams.',
    favoriteActivities: parseFavorites('''
      *Hosting stargazing nights and sharing telescopic views with friends.
      *Meditation retreats.
      *Following meteor showers, lunar eclipses, and other cosmic events.
    '''),
    favoritePlaces: parseFavorites('''
    *Quiet hills or open fields for stargazing.
    *Forest clearings and riversides for meditation.
    *Coastal areas with minimal light pollution.
    *Parks and nature reserves with peaceful, secluded spots.
    '''),
  ),
  UserProfile(
    name: 'Demir',
    age: 28,
    imagePath: 'assets/profile_photos/demir.jpg',
    description:
    'Hi, I’m Demir a nature enthusiast passionate about preserving '
        'and protecting our natural environment. I believe that small actions'
        ' can make a big difference, whether it’s organizing clean-ups or '
        'enjoying water-based activities. Exploring lakes, forests, deserts, and '
        'coastal areas is where I find peace and purpose.',
    favoriteActivities: parseFavorites('''
      *Cleaning Nature
      *Water Sports
      *Hiking
      *Mindfulness & Meditation
      *Community Initiatives

    '''),
    favoritePlaces:parseFavorites('''

      *Lakes
      *Beaches
      *Forests
      *Deserts
      *Rivers
'''),
  ),
];
