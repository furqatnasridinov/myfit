import 'package:myfit/infrastructure/services/app_constants.dart';

class NotificationModel{
  final int id;
  final NotificationType type;
  final String lessonType;
  final bool iSread;
  final DateTime date; // notification date
  DateTime lessonStartDate; // lesson start date
  final String title;
  final String description;
  final String gymName;
  int rateId;
  int grade;
  String lessonDescription;
  final int gymId;
  final Map<String, dynamic> updates;
  String commentContent;
  final int? visitedCount;
  final int? visitPerMonth;
  String? reason;

  NotificationModel({
    required this.id,
    required this.type,
    required this.lessonType,
    required this.iSread,
    required this.date,
    required this.lessonStartDate,
    required this.title,
    required this.description,
    required this.gymName,
    this.rateId = 0,
    this.grade = 0,
    this.lessonDescription = "",
    this.commentContent = "",
    required this.gymId,
    required this.updates,
    required this.visitedCount,
    required this.visitPerMonth,
    this.reason,
  });
}