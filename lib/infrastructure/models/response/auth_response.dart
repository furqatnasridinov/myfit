class AuthResponse {
  String? operationResult;
  AuthResponseBody? authResponseBody;

  AuthResponse({this.operationResult, this.authResponseBody});

  AuthResponse.fromJson(Map<String, dynamic> json) {
    operationResult = json['operationResult'];
    authResponseBody = json['object'] != null
        ? new AuthResponseBody.fromJson(json['object'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['operationResult'] = this.operationResult;
    if (this.authResponseBody != null) {
      data['object'] = this.authResponseBody!.toJson();
    }
    return data;
  }
}

class AuthResponseBody {
  User? user;
  String? jwtToken;

  AuthResponseBody({this.user, this.jwtToken});

  AuthResponseBody.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    jwtToken = json['jwtToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['jwtToken'] = this.jwtToken;
    return data;
  }
}

class User {
  int? id;
  List<String>? roles;
  String? login;
  bool? confirmed;
  bool? errorConfirm;
  String? firstName;
  String? lastName;
  String? patronymic;
  String? gender;
  bool? firstEntry;

  User(
      {this.id,
      this.roles,
      this.login,
      this.confirmed,
      this.errorConfirm,
      this.firstName,
      this.lastName,
      this.patronymic,
      this.gender,
      this.firstEntry});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    roles = json['roles'].cast<String>();
    login = json['login'];
    confirmed = json['confirmed'];
    errorConfirm = json['errorConfirm'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    patronymic = json['patronymic'];
    gender = json['gender'];
    firstEntry = json['firstEntry'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['roles'] = this.roles;
    data['login'] = this.login;
    data['confirmed'] = this.confirmed;
    data['errorConfirm'] = this.errorConfirm;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['patronymic'] = this.patronymic;
    data['gender'] = this.gender;
    data['firstEntry'] = this.firstEntry;
    return data;
  }
}