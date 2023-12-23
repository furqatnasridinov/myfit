class AddNoteRequest {
  String? tag;
  String? description;
  Lesson? lesson;

  AddNoteRequest({this.tag, this.description, this.lesson});

  AddNoteRequest.fromJson(Map<String, dynamic> json) {
    tag = json['tag'];
    description = json['description'];
    lesson =
        json['lesson'] != null ? Lesson.fromJson(json['lesson']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tag'] = tag;
    data['description'] = description;
    if (lesson != null) {
      data['lesson'] = lesson!.toJson();
    }
    return data;
  }
}

class Lesson {
  int? id;

  Lesson({this.id});

  Lesson.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    return data;
  }
}