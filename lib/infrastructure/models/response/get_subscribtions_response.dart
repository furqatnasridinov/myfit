class GetSubscribtionsResponse {
  String? operationResult;
  List<BodyData>? bodyData;

  GetSubscribtionsResponse({this.operationResult, this.bodyData});

  GetSubscribtionsResponse.fromJson(Map<String, dynamic> json) {
    operationResult = json['operationResult'];
    if (json['object'] != null) {
      bodyData = <BodyData>[];
      json['object'].forEach((v) {
        bodyData!.add(BodyData.fromJson(v));
      });
    }
  }
}

class BodyData {
  int? id;
  String? type;
  int? price;
  String? description;

  BodyData({this.id, this.type, this.price, this.description});

  BodyData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    price = json['price'];
    description = json['description'];
  }

}