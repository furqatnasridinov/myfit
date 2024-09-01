
import 'package:myfit/infrastructure/models/response/user_schedules_response.dart';

class GymWithActivitiesData{
  Gym gym;
  List<ActivityWithAllInfos> activitiesWithAllInfos;

  GymWithActivitiesData({required this.gym, required this.activitiesWithAllInfos});

}



class ActivityWithAllInfos {
  String? activityName;
  InfoForType? infoForType;
  List? photos;
  List<Subs>? subs;

  ActivityWithAllInfos({this.activityName, this.infoForType, this.photos, this.subs});

  ActivityWithAllInfos.fromJson(Map<String, dynamic> json) {
    infoForType = json['infoForType'] != null
        ? InfoForType.fromJson(json['infoForType'])
        : null;
    photos = json['photos'].cast<String>();
    if (json['subs'] != null) {
      subs = <Subs>[];
      json['subs'].forEach((v) {
        subs!.add(Subs.fromJson(v));
      });
    }
  }
}

class InfoForType {
  String? typeDescription;
  String? peculiarities;

  InfoForType({this.typeDescription, this.peculiarities});

  InfoForType.fromJson(Map<String, dynamic> json) {
    typeDescription = json['typeDescription'];
    peculiarities = json['peculiarities'];
  }
}

class Subs {
  int? id;
  String? typeDescription;
  String? peculiarities;
  String? name;
  int? orderNumber;
  List<GymSubActivePictures>? gymSubActivePictures;
  bool? inheritance;

  Subs(
      {this.id,
      this.typeDescription,
      this.peculiarities,
      this.name,
      this.orderNumber,
      this.gymSubActivePictures,
      this.inheritance});

  Subs.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    typeDescription = json['typeDescription'];
    peculiarities = json['peculiarities'];
    name = json['name'];
    orderNumber = json['orderNumber'];
    if (json['gymSubActivePictures'] != null) {
      gymSubActivePictures = <GymSubActivePictures>[];
      json['gymSubActivePictures'].forEach((v) {
        gymSubActivePictures!.add(GymSubActivePictures.fromJson(v));
      });
    }
    inheritance = json['inheritance'];
  }
}

class GymSubActivePictures {
  int? id;
  String? pictureUrl;
  int? orderNumber;

  GymSubActivePictures({this.id, this.pictureUrl, this.orderNumber});

  GymSubActivePictures.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    pictureUrl = json['pictureUrl'];
    orderNumber = json['orderNumber'];
  }
}