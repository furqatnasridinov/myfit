class GetNotesResponse {
  List<Notes>? notes;

  GetNotesResponse({this.notes});

  GetNotesResponse.fromJson(Map<String, dynamic> json) {
    if (json['Notes'] != null) {
      notes = <Notes>[];
      json['Notes'].forEach((v) {
        notes!.add(new Notes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.notes != null) {
      data['Notes'] = this.notes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Notes {
  int? id;
  String? date;
  String? description;
  String? duration;
  Gym? gym;
  List<Tag>? tag;

  Notes(
      {this.id,
      this.date,
      this.description,
      this.duration,
      this.gym,
      this.tag});

  Notes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    description = json['description'];
    duration = json['duration'];
    gym = json['gym'] != null ? new Gym.fromJson(json['gym']) : null;
    if (json['tag'] != null) {
      tag = <Tag>[];
      json['tag'].forEach((v) {
        tag!.add(new Tag.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['date'] = this.date;
    data['description'] = this.description;
    data['duration'] = this.duration;
    if (this.gym != null) {
      data['gym'] = this.gym!.toJson();
    }
    if (this.tag != null) {
      data['tag'] = this.tag!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Gym {
  int? id;
  String? name;
  String? address;
  String? latitude;
  String? longitude;
  String? description;
  String? mainPictureUrl;

  Gym(
      {this.id,
      this.name,
      this.address,
      this.latitude,
      this.longitude,
      this.description,
      this.mainPictureUrl});

  Gym.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    description = json['description'];
    mainPictureUrl = json['mainPictureUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['address'] = this.address;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['description'] = this.description;
    data['mainPictureUrl'] = this.mainPictureUrl;
    return data;
  }
}

class Tag {
  int? id;
  String? tag;
  String? description;

  Tag({this.id, this.tag, this.description});

  Tag.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tag = json['tag'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['tag'] = this.tag;
    data['description'] = this.description;
    return data;
  }
}