class GymWithTags {
  int? id;
  String? date;
  String? description;
  String? duration;
  Gym? gym;
  List<Tag>? tag;

  GymWithTags(
      {this.id,
      this.date,
      this.description,
      this.duration,
      this.gym,
      this.tag});

  GymWithTags.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    description = json['description'];
    duration = json['duration'];
    gym = json['gym'] != null ?  Gym.fromJson(json['gym']) : null;
    if (json['tag'] != null) {
      tag = <Tag>[];
      json['tag'].forEach((v) {
        tag!.add( Tag.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
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

  GymWithTags copyWith({
    String? date,
    int? id,
    String? description,
    String? duration,
    Gym? gym,
    List<Tag>? tag,
  }) {
    return GymWithTags(
      date: date ?? this.date,
      id: id ?? this.id,
      description: description ?? this.description,
      duration: duration ?? this.duration,
      gym: gym ?? this.gym,
      tag: tag ?? this.tag,
    );
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
