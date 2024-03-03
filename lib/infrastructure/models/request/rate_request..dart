class RateRequest {
  LessonUser? lessonUser;
  String? message;
  int? grade;

  RateRequest({this.lessonUser, this.message, this.grade});

  RateRequest.fromJson(Map<String, dynamic> json) {
    lessonUser = json['lessonUser'] != null
        ? LessonUser.fromJson(json['lessonUser'])
        : null;
    message = json['message'];
    grade = json['grade'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (lessonUser != null) {
      data['lessonUser'] = lessonUser!.toJson();
    }
    data['message'] = message;
    data['grade'] = grade;
    return data;
  }
}

class LessonUser {
  int? id;

  LessonUser({this.id});

  LessonUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    return data;
  }
}