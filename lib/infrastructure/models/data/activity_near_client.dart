class ActivityNearClient {
  String? activityName;
  List<GymDataMain>? gymdata;

  //
  ActivityNearClient({
    this.activityName,
    this.gymdata,
  });
}

class GymDataMain {
  int? id;
  String? name;
  String? address;
  String? latitude;
  String? longitude;

  GymDataMain(
      {this.id, this.name, this.address, this.latitude, this.longitude});

  GymDataMain.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['address'] = address;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    return data;
  }
}
