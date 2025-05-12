import 'package:latlong2/latlong.dart';
import 'package:cs_projesi/data/profile_data.dart';
import 'package:cs_projesi/models/profile.dart';

class MapLocation {
  final String name;
  final LatLng position;
  final Profile profile;
  final String eventDescription;

  MapLocation({
    required this.name,
    required this.position,
    required this.profile,
    required this.eventDescription,
  });
}

final List<MapLocation> istanbulLocations = [
  MapLocation(
    name: "Taksim Square",
    position: LatLng(41.0369, 28.9862),
    profile: profiles[0],
    eventDescription: "Live music event this weekend!",
  ),
  MapLocation(
    name: "Hagia Sophia",
    position: LatLng(41.0086, 28.9802),
    profile: profiles[1],
    eventDescription: "Cultural walk and group tour happening!",
  ),
  MapLocation(
    name: "Blue Mosque",
    position: LatLng(41.0056, 28.9768),
    profile: profiles[2],
    eventDescription: "Photography meetup at sunset.",
  ),
  MapLocation(
    name: "Galata Tower",
    position: LatLng(41.0256, 28.9744),
    profile: profiles[3],
    eventDescription: "Night view session & storytelling.",
  ),
  MapLocation(
    name: "Topkapi Palace",
    position: LatLng(41.0115, 28.9833),
    profile: profiles[4],
    eventDescription: "History trivia game hosted here.",
  ),
];
