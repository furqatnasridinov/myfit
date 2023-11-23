class AddNoteRequest {
  String? tag;
  String? description;
  Lesson? lesson;

  AddNoteRequest({this.tag, this.description, this.lesson});

  AddNoteRequest.fromJson(Map<String, dynamic> json) {
    tag = json['tag'];
    description = json['description'];
    lesson =
        json['lesson'] != null ? new Lesson.fromJson(json['lesson']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tag'] = this.tag;
    data['description'] = this.description;
    if (this.lesson != null) {
      data['lesson'] = this.lesson!.toJson();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    return data;
  }
}