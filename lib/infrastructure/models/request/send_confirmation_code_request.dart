class SendConfirmationCodeRequest {
  String? login;
  String? confirmToken;
  String? newNumber;

  SendConfirmationCodeRequest({this.login, this.confirmToken, this.newNumber});

  SendConfirmationCodeRequest.fromJson(Map<String, dynamic> json) {
    login = json['login'];
    confirmToken = json['confirmToken'];
    newNumber = json['newNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['login'] = login;
    data['confirmToken'] = confirmToken;
    data['newNumber'] = newNumber;
    return data;
  }
}