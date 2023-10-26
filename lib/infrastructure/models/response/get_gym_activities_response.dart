class GetGymActivitiesResponse {
  String? operationResult;
  List<String>? object;

  GetGymActivitiesResponse({this.operationResult, this.object});

  GetGymActivitiesResponse.fromJson(Map<String, dynamic> json) {
    operationResult = json['operationResult'];
    object = json['object'].cast<String>();
  }
}