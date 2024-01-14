class AuthResponse {
  User? user;
  String? jwtToken;

  AuthResponse({this.user, this.jwtToken});

  AuthResponse.fromJson(Map<String, dynamic> json) {
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
  String? login;
  String? firstName;
  String? lastName;
  String? patronymic;
  String? gender;
  String? backgroundPictureUrl;
  City? city;
  int? age;
  int? weight;
  int? height;

  User(
      {this.id,
      this.login,
      this.firstName,
      this.lastName,
      this.patronymic,
      this.gender,
      this.backgroundPictureUrl,
      this.city,
      this.age,
      this.weight,
      this.height});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    login = json['login'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    patronymic = json['patronymic'];
    gender = json['gender'];
    backgroundPictureUrl = json['backgroundPictureUrl'];
    city = json['city'] != null ? City.fromJson(json['city']) : null;
    age = json['age'];
    weight = json['weight'];
    height = json['height'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['login'] = login;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['patronymic'] = patronymic;
    data['gender'] = gender;
    data['backgroundPictureUrl'] = backgroundPictureUrl;
    if (city != null) {
      data['city'] = city!.toJson();
    }
    data['age'] = age;
    data['weight'] = weight;
    data['height'] = height;
    return data;
  }
}

class City {
  int? id;
  Country? country;
  String? name;
  String? regionName;
  String? externalIdentifier;
  String? latitude;
  String? longitude;

  City(
      {this.id,
      this.country,
      this.name,
      this.regionName,
      this.externalIdentifier,
      this.latitude,
      this.longitude});

  City.fromJson(Map<String, dynamic> json) {
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