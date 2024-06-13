import 'package:myfit/infrastructure/services/app_constants.dart';

class Promocode {
  int? id;
  Promotional? promotional;
  String? activateTime;
  PromocodeState? promotionalState;
  String? endTime;

  Promocode({this.id, this.promotional, this.activateTime});

  Promocode.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    promotional = json['promotional'] != null
        ? Promotional.fromJson(json['promotional'])
        : null;
    activateTime = json['activateTime'];
    promotionalState = json['promotionalState'] == "WAITING" ? PromocodeState.waiting : json['promotionalState'] == "USED" ? 
                          PromocodeState.used : PromocodeState.notUsed;
    endTime = json['endTime'];
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
  int? howMany;

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
    howMany = json['howMany'];
  }
}