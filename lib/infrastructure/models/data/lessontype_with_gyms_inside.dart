// ignore_for_file: public_member_api_docs, sort_constructors_first
class LessonTypeWithGymsInside {
  String? lessontype;
  List<Gymdata>? listOfGyms;
  bool isOpened = false;

  LessonTypeWithGymsInside(
    this.isOpened, {
    this.lessontype,
    this.listOfGyms,
  });

  LessonTypeWithGymsInside.fromJson(Map<String, dynamic> json) {
    lessontype = json['lessontype'];
    if (json['gymdata'] != null) {
      listOfGyms = <Gymdata>[];
      json['gymdata'].forEach((v) {
        listOfGyms!.add(Gymdata.fromJson(v));
      });
    }
  }
}

class Gymdata {
  int? id;
  String? name;
  String? address;
  String? latitude;
  String? longitude;
  double? distanceFromClient;
  bool isSelected = false;

  Gymdata(this.isSelected,
      {this.id,
      this.name,
      this.address,
      this.latitude,
      this.longitude,
      this.distanceFromClient});

  Gymdata.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Gymdata copyWith({
    int? id,
    String? name,
    String? address,
    String? latitude,
    String? longitude,
    double? distanceFromClient,
    bool? isSelected,
  }) {
    return Gymdata(
      false,
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      distanceFromClient: distanceFromClient ?? this.distanceFromClient,
    );
  }
}
