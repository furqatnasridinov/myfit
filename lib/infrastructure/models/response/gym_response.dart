class GymResponse {
  int? id;
  String? name;
  String? address;
  String? latitude;
  String? longitude;
  String? description;
  String? mainPictureUrl;
  String? phone;
  String? telegram;
  String? email;
  String? vk;

  GymResponse(
      {this.id,
      this.name,
      this.address,
      this.latitude,
      this.longitude,
      this.description,
      this.mainPictureUrl,
      this.phone,
      this.telegram,
      this.email,
      this.vk});

  GymResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    description = json['description'];
    mainPictureUrl = json['mainPictureUrl'];
    phone = json['phone'];
    telegram = json['telegram'];
    email = json['email'];
    vk = json['vk'];
  }
}
