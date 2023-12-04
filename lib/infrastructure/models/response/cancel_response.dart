// ignore_for_file: prefer_void_to_null

class CancelellationResponse {
  String? operationResult;
  Null cancellationBody;
  String? operationInfo;

  CancelellationResponse(
      {this.operationResult, this.cancellationBody, this.operationInfo});

  CancelellationResponse.fromJson(Map<String, dynamic> json) {
    operationResult = json['operationResult'];
    cancellationBody = json['object'];
    operationInfo = json['operationInfo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['operationResult'] = operationResult;
    data['object'] = cancellationBody;
    data['operationInfo'] = operationInfo;
    return data;
  }
}