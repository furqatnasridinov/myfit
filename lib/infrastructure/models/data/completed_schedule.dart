class CompletedSchedule {
  CompletedSchedule({
    required this.id,
    required this.gymName,
    required this.describtion,
    required this.time,
    required this.grade,
    required this.gymId,
    required this.comment,
    required this.visitedCount,
    required this.visitPerMonth,
  });

  final int id;
  final String gymName;
  final String describtion;
  final String time;
  final int grade;
  final int gymId;
  final String comment;
  final int visitedCount;
  final int visitPerMonth;
}
