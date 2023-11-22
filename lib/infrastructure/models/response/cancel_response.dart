class CancelellationResponse {
  String? operationResult;
  Null? cancellationBody;
  String? operationInfo;

  CancelellationResponse(
      {this.operationResult, this.cancellationBody, this.operationInfo});

  CancelellationResponse.fromJson(Map<String, dynamic> json) {
    operationResult = json['operationResult'];
    cancellationBody = json['object'];
    operationInfo = json['operationInfo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['operationResult'] = this.operationResult;
    data['object'] = this.cancellationBody;
    data['operationInfo'] = this.operationInfo;
    return data;
  }
}