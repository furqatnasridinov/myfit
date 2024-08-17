import 'package:myfit/infrastructure/models/data/lesson.dart';

import '../response/user_schedules_response.dart';

class MemberShip {
  int? id;
  List<Gym>? gyms;
  List<String>? lessonTypes;
  List<Subcategory>? lessonSubTypes;
  int? price;
  String? type;
  List<String>? daysOfWeek;
  String? startTime;
  String? endTime;
  String? name;
  String? description;
  String? privileges;
  String? restrictions;
  String? freezingCancellation;

  MemberShip(
      {this.id,
      this.gyms,
      this.lessonTypes,
      this.lessonSubTypes,
      this.price,
      this.type,
      this.daysOfWeek,
      this.startTime,
      this.endTime,
      this.name,
      this.description,
      this.privileges,
      this.restrictions,
      this.freezingCancellation});

  MemberShip.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['gyms'] != null) {
      gyms = <Gym>[];
      json['gyms'].forEach((v) {
        gyms!.add(Gym.fromJson(v));
      });
    }
    lessonTypes = json['lessonTypes'].cast<String>();
    if (json['lessonSubTypes'] != null) {
      lessonSubTypes = <Subcategory>[];
      json['lessonSubTypes'].forEach((v) {
        lessonSubTypes!.add(Subcategory.fromJson(v));
      });
    }
    price = json['price'];
    type = json['type'];
    daysOfWeek = json['daysOfWeek'].cast<String>();
    startTime = json['startTime'];
    endTime = json['endTime'];
    name = json['name'];
    description = json['description'];
    privileges = json['privileges'];
    restrictions = json['restrictions'];
    freezingCancellation = json['freezingCancellation'];
  }

}