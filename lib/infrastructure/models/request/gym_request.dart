class GymRequest {
  int? id;

  GymRequest({this.id});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['id'] = this.id;
    return data;
  }
}