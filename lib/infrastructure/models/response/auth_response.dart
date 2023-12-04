class AuthResponse {
  String? operationResult;
  AuthResponseBody? authResponseBody;

  AuthResponse({this.operationResult, this.authResponseBody});

  AuthResponse.fromJson(Map<String, dynamic> json) {
    operationResult = json['operationResult'];
    authResponseBody = json['object'] != null
        ? AuthResponseBody.fromJson(json['object'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['operationResult'] = operationResult;
    if (authResponseBody != null) {
      data['object'] = authResponseBody!.toJson();
    }
    return data;
  }
}

class AuthResponseBody {
  User? user;
  String? jwtToken;

  AuthResponseBody({this.user, this.jwtToken});

  AuthResponseBody.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    jwtToken = json['jwtToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['jwtToken'] = jwtToken;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['roles'] = roles;
    data['login'] = login;
    data['confirmed'] = confirmed;
    data['errorConfirm'] = errorConfirm;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['patronymic'] = patronymic;
    data['gender'] = gender;
    data['firstEntry'] = firstEntry;
    return data;
  }
}