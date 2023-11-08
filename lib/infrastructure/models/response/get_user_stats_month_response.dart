class GetUserStatsMonthResponse {
  String? operationResult;
  List<BodyData>? bodyData;

  GetUserStatsMonthResponse({this.operationResult, this.bodyData});

  GetUserStatsMonthResponse.fromJson(Map<String, dynamic> json) {
    operationResult = json['operationResult'];
    if (json['bodyData'] != null) {
      bodyData = <BodyData>[];
      json['bodyData'].forEach((v) {
        bodyData!.add(new BodyData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['operationResult'] = this.operationResult;
    if (this.bodyData != null) {
      data['bodyData'] = this.bodyData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BodyData {
  int? count;
  String? lessonType;

  BodyData({this.count, this.lessonType});

  BodyData.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    lessonType = json['lessonType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['lessonType'] = this.lessonType;
    return data;
  }
}