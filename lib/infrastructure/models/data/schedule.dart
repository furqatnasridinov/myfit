// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Schedule {
  final String startingTime;
  final String title;
  final String finishingTime;
  Schedule({
    required this.startingTime,
    required this.title,
    required this.finishingTime,
  });

  Schedule copyWith({
    String? startingTime,
    String? title,
    String? finishingTime,
  }) {
    return Schedule(
      startingTime: startingTime ?? this.startingTime,
      title: title ?? this.title,
      finishingTime: finishingTime ?? this.finishingTime,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'startingTime': startingTime,
      'title': title,
      'finishingTime': finishingTime,
    };
  }

  factory Schedule.fromMap(Map<String, dynamic> map) {
    return Schedule(
      startingTime: map['startingTime'] as String,
      title: map['title'] as String,
      finishingTime: map['finishingTime'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Schedule.fromJson(String source) => Schedule.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Schedule(startingTime: $startingTime, title: $title, finishingTime: $finishingTime)';

  @override
  bool operator ==(covariant Schedule other) {
    if (identical(this, other)) return true;
  
    return 
      other.startingTime == startingTime &&
      other.title == title &&
      other.finishingTime == finishingTime;
  }

  @override
  int get hashCode => startingTime.hashCode ^ title.hashCode ^ finishingTime.hashCode;
}
