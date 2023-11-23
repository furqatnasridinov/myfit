class ComModel {
  int? id;
  String? name;
  String? address;
  String? latitude;
  String? longitude;
  double? kmR;

  ComModel({
    this.id,
    this.name,
    this.address,
    this.latitude,
    this.longitude,
    this.kmR,
  });

  ComModel.fromJson(Map<String, dynamic> json) {
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
