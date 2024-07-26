class SubCategory {
  int? id;
  String? typeDescription;
  String? peculiarities;
  String? name;
  int? orderNumber;
  List<String>? gymSubActivePictures;
  bool? inheritance;

  SubCategory(
      {this.id,
      this.typeDescription,
      this.peculiarities,
      this.name,
      this.orderNumber,
      this.gymSubActivePictures,
      this.inheritance});

  SubCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    typeDescription = json['typeDescription'];
    peculiarities = json['peculiarities'];
    name = json['name'];
    orderNumber = json['orderNumber'];
    gymSubActivePictures = json['gymSubActivePictures'].cast<String>();
    inheritance = json['inheritance'];
  }

}