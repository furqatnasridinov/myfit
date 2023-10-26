// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Calendar {
  final String weekDay;
  final String daysOfMonth;
  final String month;
  
  Calendar({
    required this.weekDay,
    required this.daysOfMonth,
    required this.month,
  });

  Calendar copyWith({
    String? weekDay,
    String? daysOfMonth,
    String? month,
  }) {
    return Calendar(
      weekDay: weekDay ?? this.weekDay,
      daysOfMonth: daysOfMonth ?? this.daysOfMonth,
      month: month ?? this.month,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'weekDay': weekDay,
      'daysOfMonth': daysOfMonth,
      'month': month,
    };
  }

  factory Calendar.fromMap(Map<String, dynamic> map) {
    return Calendar(
      weekDay: map['weekDay'] as String,
      daysOfMonth: map['daysOfMonth'] as String,
      month: map['month'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Calendar.fromJson(String source) => Calendar.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Calendar(weekDay: $weekDay, daysOfMonth: $daysOfMonth, month: $month)';

  @override
  bool operator ==(covariant Calendar other) {
    if (identical(this, other)) return true;
  
    return 
      other.weekDay == weekDay &&
      other.daysOfMonth == daysOfMonth &&
      other.month == month;
  }

  @override
  int get hashCode => weekDay.hashCode ^ daysOfMonth.hashCode ^ month.hashCode;
}
