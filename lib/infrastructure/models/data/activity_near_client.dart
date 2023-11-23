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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['address'] = this.address;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}
