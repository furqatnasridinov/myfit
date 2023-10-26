class GetGymPhotosResponse {
  String? operationResult;
  List<GymObject>? object;

  GetGymPhotosResponse({this.operationResult, this.object,});

  GetGymPhotosResponse.fromJson(Map<String, dynamic> json) {
    operationResult = json['operationResult'];
    if (json['object'] != null) {
      object = <GymObject>[];
      json['object'].forEach((v) {
        object!.add( GymObject.fromJson(v));
      });
    }
  }


}

class GymObject {
  int? id;
  String? pictureUrl;
  String? lessonType;

  GymObject({this.id, this.pictureUrl, this.lessonType});

  GymObject.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    pictureUrl = json['pictureUrl'];
    lessonType = json['lessonType'];
  }


}