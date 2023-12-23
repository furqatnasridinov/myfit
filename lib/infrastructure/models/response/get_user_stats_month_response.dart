class GetUserStatsMonthResponse {
  String? operationResult;
  List<UserStats>? bodyData;

  GetUserStatsMonthResponse({this.operationResult, this.bodyData});

  GetUserStatsMonthResponse.fromJson(Map<String, dynamic> json) {
    operationResult = json['operationResult'];
    if (json['object'] != null) {
      bodyData = <UserStats>[];
      json['object'].forEach((v) {
        bodyData!.add(UserStats.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['operationResult'] = operationResult;
    if (bodyData != null) {
      data['object'] = bodyData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UserStats {
  int? count;
  String? lessonType;

  UserStats({this.count, this.lessonType});

  UserStats.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    lessonType = json['lessonType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    data['lessonType'] = lessonType;
    return data;
  }
}