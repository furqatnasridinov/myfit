class UserInstance {
  int? id;
  String? login;
  String? firstName;
  String? lastName;
  String? patronymic;
  String? gender;
  List<Roles>? roles;
  String? pictureUrl;
  CityInstance? city;
  int? age;
  int? weight;
  int? height;
  String? birthdayDate;
  String? changePhotoDate;

  UserInstance(
      {this.id,
      this.login,
      this.firstName,
      this.lastName,
      this.patronymic,
      this.gender,
      this.roles,
      this.pictureUrl,
      this.city,
      this.age,
      this.weight,
      this.height,
      this.birthdayDate});

  UserInstance.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    login = json['login'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    patronymic = json['patronymic'];
    gender = json['gender'];
    if (json['roles'] != null) {
      roles = <Roles>[];
      json['roles'].forEach((v) {
        roles!.add(Roles.fromJson(v));
      });
    }
    pictureUrl = json['pictureUrl'];
    city = json['city'] != null ? CityInstance.fromJson(json['city']) : null;
    age = json['age'];
    weight = json['weight'];
    height = json['height'];
    birthdayDate = json['birthdayDate'];
    changePhotoDate = json['changePhotoDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['login'] = login;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['patronymic'] = patronymic;
    data['gender'] = gender;
    if (roles != null) {
      data['roles'] = roles!.map((v) => v.toJson()).toList();
    }
    data['pictureUrl'] = pictureUrl;
    if (city != null) {
      data['city'] = city!.toJson();
    }
    data['age'] = age;
    data['weight'] = weight;
    data['height'] = height;
    data['birthdayDate'] = birthdayDate;
    data['changePhotoDate'] = changePhotoDate;
    return data;
  }
}

class Roles {
  int? id;
  String? code;
  String? name;
  List<Privileges>? privileges;

  Roles({this.id, this.code, this.name, this.privileges});

  Roles.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    name = json['name'];
    if (json['privileges'] != null) {
      privileges = <Privileges>[];
      json['privileges'].forEach((v) {
        privileges!.add(Privileges.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['code'] = code;
    data['name'] = name;
    if (privileges != null) {
      data['privileges'] = privileges!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Privileges {
  int? id;
  String? code;
  String? name;

  Privileges({this.id, this.code, this.name});

  Privileges.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['code'] = code;
    data['name'] = name;
    return data;
  }
}

class CityInstance {
  int? id;
  Country? country;
  String? name;
  String? regionName;
  String? externalIdentifier;
  String? latitude;
  String? longitude;

  CityInstance(
      {this.id,
      this.country,
      this.name,
      this.regionName,
      this.externalIdentifier,
      this.latitude,
      this.longitude});

  CityInstance.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    country =
        json['country'] != null ? Country.fromJson(json['country']) : null;
    name = json['name'];
    regionName = json['regionName'];
    externalIdentifier = json['externalIdentifier'];
    latitude = json['latitude'];
    longitude = json['longitude'];
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
    data['latitude'] = latitude;
    data['longitude'] = longitude;
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