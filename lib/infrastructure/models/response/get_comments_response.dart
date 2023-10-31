class GetCommentsResponse {
  String? operationResult;
  List<BodyData>? bodyData;

  GetCommentsResponse({this.operationResult, this.bodyData});

  GetCommentsResponse.fromJson(Map<String, dynamic> json) {
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
  User? user;
  String? message;
  String? insertDate;

  BodyData({this.id, this.user, this.message, this.insertDate});

  BodyData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    message = json['message'];
    insertDate = json['insertDate'];
  }

}

class User {
  int? id;
  List<String>? roles;
  String? login;
  bool? confirmed;
  String? confirmToken;
  String? errorConfirm;
  String? firstName;
  String? lastName;
  String? patronymic;
  String? birthdayDate;
  String? contactPhone;
  String? gender;
  String? city;
  String? country;
  String? firstEntry;

  User(
      {this.id,
      this.roles,
      this.login,
      this.confirmed,
      this.confirmToken,
      this.errorConfirm,
      this.firstName,
      this.lastName,
      this.patronymic,
      this.birthdayDate,
      this.contactPhone,
      this.gender,
      this.city,
      this.country,
      this.firstEntry});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    roles = json['roles'].cast<String>();
    login = json['login'];
    confirmed = json['confirmed'];
    confirmToken = json['confirmToken'];
    errorConfirm = json['errorConfirm'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    patronymic = json['patronymic'];
    birthdayDate = json['birthdayDate'];
    contactPhone = json['contactPhone'];
    gender = json['gender'];
    city = json['city'];
    country = json['country'];
    firstEntry = json['firstEntry'];
  }

}