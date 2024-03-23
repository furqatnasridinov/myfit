class Lesson {
  int? id;
  String? date;
  String? calendarDate;
  String? startTime;
  String? endTime;
  String? description;
  String? duration;
  String? lessonType;
  Owner? owner;
  List<int>? repeat;
  bool? canSignUp;
  String? lessonState;
  bool? showInCalendar;

  Lesson({
    this.id,
    this.date,
    this.calendarDate,
    this.startTime,
    this.endTime,
    this.description,
    this.duration,
    this.lessonType,
    this.owner,
    this.repeat,
    this.canSignUp,
    this.lessonState,
    this.showInCalendar,
  });

  Lesson.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    calendarDate = json['calendarDate'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    description = json['description'];
    duration = json['duration'];
    lessonType = json['lessonType'];
    owner = json['owner'] != null ? Owner.fromJson(json['owner']) : null;
    repeat = json['repeat'].cast<int>();
    canSignUp = json['canSignUp'];
    lessonState = json['lessonState'];
  }
}

class Owner {
  int? id;
  String? login;
  String? firstName;
  String? lastName;
  String? patronymic;
  String? gender;

  Owner(
      {this.id,
      this.login,
      this.firstName,
      this.lastName,
      this.patronymic,
      this.gender});

  Owner.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    login = json['login'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    patronymic = json['patronymic'];
    gender = json['gender'];
  }
}
