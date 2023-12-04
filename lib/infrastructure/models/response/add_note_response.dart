class AddNoteResponse {
  String? description;
  int? id;
  String? tag;

  AddNoteResponse({this.description, this.id, this.tag});

  AddNoteResponse.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    id = json['id'];
    tag = json['tag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['description'] = description;
    data['id'] = id;
    data['tag'] = tag;
    return data;
  }
}