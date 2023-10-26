class GymResponse {
  int? id;
  String? name;
  String? address;
  String? description;
  String? mainPictureUrl;

  GymResponse(
      {this.id,
      this.name,
      this.address,
      this.description,
      this.mainPictureUrl});

  GymResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address = json['address'];
    description = json['description'];
    mainPictureUrl = json['mainPictureUrl'];
  }


}