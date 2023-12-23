class GymRequest {
  int? id;

  GymRequest({this.id});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['id'] = id;
    return data;
  }
}