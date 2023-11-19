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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    data['id'] = this.id;
    data['tag'] = this.tag;
    return data;
  }
}