class GetNearestLesson {
  String? operationResult;
  BodyData? bodyData;

  GetNearestLesson({this.operationResult, this.bodyData});

  GetNearestLesson.fromJson(Map<String, dynamic> json) {
    operationResult = json['operationResult'];
    bodyData = json['object'] != null
        ? new BodyData.fromJson(json['object'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['operationResult'] = this.operationResult;
    if (this.bodyData != null) {
      data['object'] = this.bodyData!.toJson();
    }
    return data;
  }
}

class BodyData {
  int? id;
  String? date;
  String? description;
  String? duration;
  Gym? gym;

  BodyData({this.id, this.date, this.description, this.duration, this.gym});

  BodyData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    description = json['description'];
    duration = json['duration'];
    gym = json['gym'] != null ? new Gym.fromJson(json['gym']) : null;
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
