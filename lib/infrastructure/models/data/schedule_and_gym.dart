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
    gym = json['gym'] != null ? new Gymdata.fromJson(json['gym']) : null;
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