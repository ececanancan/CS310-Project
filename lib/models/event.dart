import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:cs_projesi/models/profile.dart';

class Event {
  Profile createdBy;
  String location;
  LatLng coordinates; // <-- New field for map markers
  DateTime date;
  String descriptionMini;
  String eventPhotoPath;
  String descriptionLarge;
  String where;
  String bring;
  String goal;
  String when;

  Event({
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
}
