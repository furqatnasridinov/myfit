class GetCommentsResponse {
  String? operationResult;
  List<CommentsBody>? commentsBody;

  GetCommentsResponse({this.operationResult, this.commentsBody});

  GetCommentsResponse.fromJson(Map<String, dynamic> json) {
    operationResult = json['operationResult'];
    if (json['object'] != null) {
      commentsBody = <CommentsBody>[];
      json['object'].forEach((v) {
        commentsBody!.add(CommentsBody.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['operationResult'] = operationResult;
    if (commentsBody != null) {
      data['object'] = commentsBody!.map((v) => v.toJson()).toList();
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
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    message = json['message'];
    insertDate = json['insertDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['message'] = message;
    data['insertDate'] = insertDate;
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
    city = json['city'] != null ? City.fromJson(json['city']) : null;
    country =
        json['country'] != null ? Country.fromJson(json['country']) : null;
    firstEntry = json['firstEntry'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['login'] = login;
    data['confirmed'] = confirmed;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['patronymic'] = patronymic;
    data['birthdayDate'] = birthdayDate;
    data['contactPhone'] = contactPhone;
    data['gender'] = gender;
    if (city != null) {
      data['city'] = city!.toJson();
    }
    if (country != null) {
      data['country'] = country!.toJson();
    }
    data['firstEntry'] = firstEntry;
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
        json['country'] != null ? Country.fromJson(json['country']) : null;
    name = json['name'];
    regionName = json['regionName'];
    externalIdentifier = json['externalIdentifier'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (country != null) {
      data['country'] = country!.toJson();
    }
    data['name'] = name;
    data['regionName'] = regionName;
    data['externalIdentifier'] = externalIdentifier;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['externalIdentifier'] = externalIdentifier;
    data['showInApp'] = showInApp;
    return data;
  }
}