class GetGymPhotosRequest {
  String? lessonType;

  GetGymPhotosRequest({this.lessonType});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['lessonType'] = lessonType;
    return data;
  }
}
