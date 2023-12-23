class GymData {
  int? id;
  String? name;
  double? latitude;
  double? longitude;
  String? address;
  double? distanceFromClient;
  List<String>? activitiesOfGym;

  GymData({
    this.id,
    this.name,
    this.latitude,
    this.longitude,
    this.address,
    this.distanceFromClient,
    this.activitiesOfGym,
  });
}
