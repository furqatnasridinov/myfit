import 'package:myfit/infrastructure/services/app_constants.dart';

class Notification{
  final NotificationType type;
  final String lessonType;
  final bool unread;
  final String time;
  final String title;
  final String description;
  final String gymName;
  final int gymId;
  final Map<String, dynamic> body;
  final int? visitsLeft;
  final int? tottalVisits;
  String? reason;

  Notification({
    required this.type,
    required this.lessonType,
    required this.unread,
    required this.time,
    required this.title,
    required this.description,
    required this.gymName,
    required this.gymId,
    required this.body,
    required this.visitsLeft,
    required this.tottalVisits,
    this.reason,
  });
}