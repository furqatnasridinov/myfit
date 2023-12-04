class GetNotesResponse {
  List<Notes>? notes;

  GetNotesResponse({this.notes});

  GetNotesResponse.fromJson(Map<String, dynamic> json) {
    if (json['Notes'] != null) {
      notes = <Notes>[];
      json['Notes'].forEach((v) {
        notes!.add(Notes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (notes != null) {
      data['Notes'] = notes!.map((v) => v.toJson()).toList();
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
    gym = json['gym'] != null ? Gym.fromJson(json['gym']) : null;
    if (json['tag'] != null) {
      tag = <Tag>[];
      json['tag'].forEach((v) {
        tag!.add(Tag.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['date'] = date;
    data['description'] = description;
    data['duration'] = duration;
    if (gym != null) {
      data['gym'] = gym!.toJson();
    }
    if (tag != null) {
      data['tag'] = tag!.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['address'] = address;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['description'] = description;
    data['mainPictureUrl'] = mainPictureUrl;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['tag'] = tag;
    data['description'] = description;
    return data;
  }
}