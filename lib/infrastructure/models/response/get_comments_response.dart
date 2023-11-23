class GetCommentsResponse {
  String? operationResult;
  List<CommentsBody>? commentsBody;

  GetCommentsResponse({this.operationResult, this.commentsBody});

  GetCommentsResponse.fromJson(Map<String, dynamic> json) {
    operationResult = json['operationResult'];
    if (json['object'] != null) {
      commentsBody = <CommentsBody>[];
      json['object'].forEach((v) {
        commentsBody!.add(new CommentsBody.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['operationResult'] = this.operationResult;
    if (this.commentsBody != null) {
      data['object'] = this.commentsBody!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CommentsBody {
  int? id;
  User? user;
  String? message;
  String? insertDate;

  CommentsBody({this.id, this.user, this.message, this.insertDate});

  CommentsBody.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    message = json['message'];
    insertDate = json['insertDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['message'] = this.message;
    data['insertDate'] = this.insertDate;
    return data;
  }
}

class User {
  int? id;
  String? login;
  bool? confirmed;
  String? firstName;
  String? lastName;
  String? patronymic;
  String? birthdayDate;
  int? contactPhone;
  String? gender;
  City? city;
  Country? country;
  String? firstEntry;

  User(
      {this.id,
      this.login,
      this.confirmed,
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
    login = json['login'];
    confirmed = json['confirmed'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    patronymic = json['patronymic'];
    birthdayDate = json['birthdayDate'];
    contactPhone = json['contactPhone'];
    gender = json['gender'];
    city = json['city'] != null ? new City.fromJson(json['city']) : null;
    country =
        json['country'] != null ? new Country.fromJson(json['country']) : null;
    firstEntry = json['firstEntry'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['login'] = this.login;
    data['confirmed'] = this.confirmed;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['patronymic'] = this.patronymic;
    data['birthdayDate'] = this.birthdayDate;
    data['contactPhone'] = this.contactPhone;
    data['gender'] = this.gender;
    if (this.city != null) {
      data['city'] = this.city!.toJson();
    }
    if (this.country != null) {
      data['country'] = this.country!.toJson();
    }
    data['firstEntry'] = this.firstEntry;
    return data;
  }
}

class City {
  int? id;
  Country? country;
  String? name;
  String? regionName;
  String? externalIdentifier;

  City(
      {this.id,
      this.country,
      this.name,
      this.regionName,
      this.externalIdentifier});

  City.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    country =
        json['country'] != null ? new Country.fromJson(json['country']) : null;
    name = json['name'];
    regionName = json['regionName'];
    externalIdentifier = json['externalIdentifier'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.country != null) {
      data['country'] = this.country!.toJson();
    }
    data['name'] = this.name;
    data['regionName'] = this.regionName;
    data['externalIdentifier'] = this.externalIdentifier;
    return data;
  }
}

class Country {
  int? id;
  String? name;
  String? externalIdentifier;
  bool? showInApp;

  Country({this.id, this.name, this.externalIdentifier, this.showInApp});

  Country.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    externalIdentifier = json['externalIdentifier'];
    showInApp = json['showInApp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['externalIdentifier'] = this.externalIdentifier;
    data['showInApp'] = this.showInApp;
    return data;
  }
}