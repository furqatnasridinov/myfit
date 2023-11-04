class GetAdvantagesResponse {
  String? operationResult;
  List<BodyData>? bodyData;

  GetAdvantagesResponse({this.operationResult, this.bodyData});

  GetAdvantagesResponse.fromJson(Map<String, dynamic> json) {
    operationResult = json['operationResult'];
    if (json['object'] != null) {
      bodyData = <BodyData>[];
      json['object'].forEach((v) {
        bodyData!.add( BodyData.fromJson(v));
      });
    }
  }
}

class BodyData {
  int? id;
  String? heading;
  String? description;

  BodyData({this.id, this.heading, this.description});

  BodyData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    heading = json['heading'];
    description = json['description'];
  }


}