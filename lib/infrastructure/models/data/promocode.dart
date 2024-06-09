class Promocode {
  int? id;
  Promotional? promotional;
  String? activateTime;

  Promocode({this.id, this.promotional, this.activateTime});

  Promocode.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    promotional = json['promotional'] != null
        ? Promotional.fromJson(json['promotional'])
        : null;
    activateTime = json['activateTime'];
  }
}

class Promotional {
  int? id;
  String? code;
  String? description;
  String? promotionalType;
  String? activateData;
  String? prolongationData;
  String? endData;

  Promotional(
      {this.id,
      this.code,
      this.description,
      this.promotionalType,
      this.activateData,
      this.prolongationData,
      this.endData});

  Promotional.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    description = json['description'];
    promotionalType = json['promotionalType'];
    activateData = json['activateData'];
    prolongationData = json['prolongationData'];
    endData = json['endData'];
  }
}