class ActivitiesListResponse {
  List<String>? object;

  ActivitiesListResponse({this.object});

  ActivitiesListResponse.fromJson(Map<String, dynamic> json) {
    object = json['object'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['object'] = object;
    return data;
  }
}