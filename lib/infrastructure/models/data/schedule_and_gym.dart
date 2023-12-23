class ScheduleAndGym {
  int? id;
  String? date;
  String? description;
  String? duration;
  Gymdata? gym;

  ScheduleAndGym(
      {this.id, this.date, this.description, this.duration, this.gym});

  ScheduleAndGym.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    description = json['description'];
    duration = json['duration'];
    gym = json['gym'] != null ? Gymdata.fromJson(json['gym']) : null;
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
    return data;
  }
}

class Gymdata {
  int? id;
  String? name;
  String? address;
  String? latitude;
  String? longitude;
  String? description;
  String? mainPictureUrl;

  Gymdata(
      {this.id,
      this.name,
      this.address,
      this.latitude,
      this.longitude,
      this.description,
      this.mainPictureUrl});

  Gymdata.fromJson(Map<String, dynamic> json) {
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