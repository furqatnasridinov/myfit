class GetNearestLesson {
  String? operationResult;
  BodyData? bodyData;

  GetNearestLesson({this.operationResult, this.bodyData});

  GetNearestLesson.fromJson(Map<String, dynamic> json) {
    operationResult = json['operationResult'];
    bodyData = json['object'] != null
        ? BodyData.fromJson(json['object'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['operationResult'] = operationResult;
    if (bodyData != null) {
      data['object'] = bodyData!.toJson();
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
    gym = json['gym'] != null ? Gym.fromJson(json['gym']) : null;
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
