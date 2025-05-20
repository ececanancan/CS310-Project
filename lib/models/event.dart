import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String id;
  final String createdBy; // UID olacak
  final String location;
  final LatLng coordinates;
  final DateTime date;
  final String descriptionMini;
  final String eventPhotoPath;
  final String descriptionLarge;
  final String where;
  final String bring;
  final String goal;
  final String when;
  final DateTime createdAt;

  Event({
    required this.id,
    required this.createdBy,
    required this.location,
    required this.coordinates,
    required this.date,
    required this.descriptionMini,
    required this.eventPhotoPath,
    required this.descriptionLarge,
    required this.where,
    required this.bring,
    required this.goal,
    required this.when,
    required this.createdAt,
  });

  String get formattedDate {
    final now = DateTime.now();
    final isToday = date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
    final isTomorrow = date.year == now.year &&
        date.month == now.month &&
        date.day == now.day + 1;
    final timePart = DateFormat('HH:mm').format(date);
    if (isToday) {
      return "Today $timePart";
    } else if (isTomorrow) {
      return "Tomorrow $timePart";
    } else {
      return DateFormat('dd MMM HH:mm').format(date);
    }
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'createdBy': createdBy,
    'location': location,
    'coordinates': GeoPoint(coordinates.latitude, coordinates.longitude),
    'date': date.toIso8601String(),
    'descriptionMini': descriptionMini,
    'eventPhotoPath': eventPhotoPath,
    'descriptionLarge': descriptionLarge,
    'where': where,
    'bring': bring,
    'goal': goal,
    'when': when,
    'createdAt': createdAt,
  };

  factory Event.fromJson(Map<String, dynamic> json) => Event(
    id: json['id'],
    createdBy: json['createdBy'],
    location: json['location'],
    coordinates: LatLng(
      json['coordinates'].latitude,
      json['coordinates'].longitude,
    ),
    date: DateTime.parse(json['date']),
    descriptionMini: json['descriptionMini'],
    eventPhotoPath: json['eventPhotoPath'],
    descriptionLarge: json['descriptionLarge'],
    where: json['where'],
    bring: json['bring'],
    goal: json['goal'],
    when: json['when'],
    createdAt: (json['createdAt'] as Timestamp).toDate(),
  );

  Event copyWith({
    String? id,
    String? createdBy,
    String? location,
    LatLng? coordinates,
    DateTime? date,
    String? descriptionMini,
    String? eventPhotoPath,
    String? descriptionLarge,
    String? where,
    String? bring,
    String? goal,
    String? when,
    DateTime? createdAt,
  }) {
    return Event(
      id: id ?? this.id,
      createdBy: createdBy ?? this.createdBy,
      location: location ?? this.location,
      coordinates: coordinates ?? this.coordinates,
      date: date ?? this.date,
      descriptionMini: descriptionMini ?? this.descriptionMini,
      eventPhotoPath: eventPhotoPath ?? this.eventPhotoPath,
      descriptionLarge: descriptionLarge ?? this.descriptionLarge,
      where: where ?? this.where,
      bring: bring ?? this.bring,
      goal: goal ?? this.goal,
      when: when ?? this.when,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
