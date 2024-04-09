class SendPhoneNumberRequest {
  String? login;
  String? newNumber;

  SendPhoneNumberRequest({this.login, this.newNumber});

  SendPhoneNumberRequest.fromJson(Map<String, dynamic> json) {
    login = json['login'];
    newNumber = json['newNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['login'] = login;
    data['newNumber'] = newNumber;
    return data;
  }
}