class GymActiveListResponse {
  String? operationResult;
  BodyData? bodyData;

  GymActiveListResponse({this.operationResult, this.bodyData});

  GymActiveListResponse.fromJson(Map<String, dynamic> json) {
    operationResult = json['operationResult'];
    bodyData = json['object'] != null
        ? BodyData.fromJson(json['object'])
        : null;
  }
}

class BodyData {
  List<POOL>? pOOL;
  List<GYM>? gYM;
  List<MASSAGE>? mASSAGE;

  BodyData({this.pOOL, this.gYM, this.mASSAGE});

  BodyData.fromJson(Map<String, dynamic> json) {
    if (json['POOL'] != null) {
      pOOL = <POOL>[];
      json['POOL'].forEach((v) {
        pOOL!.add(POOL.fromJson(v));
      });
    }
    if (json['GYM'] != null) {
      gYM = <GYM>[];
      json['GYM'].forEach((v) {
        gYM!.add(GYM.fromJson(v));
      });
    }
    if (json['MASSAGE'] != null) {
      mASSAGE = <MASSAGE>[];
      json['MASSAGE'].forEach((v) {
        mASSAGE!.add(MASSAGE.fromJson(v));
      });
    }
  }

 
}

class POOL {
  int? id;
  String? name;
  String? address;
  String? latitude;
  String? longitude;

  POOL({this.id, this.name, this.address, this.latitude, this.longitude});

  POOL.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }


}
class GYM {
  int? id;
  String? name;
  String? address;
  String? latitude;
  String? longitude;

  GYM({this.id, this.name, this.address, this.latitude, this.longitude});

  GYM.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }


}
class MASSAGE {
  int? id;
  String? name;
  String? address;
  String? latitude;
  String? longitude;

  MASSAGE({this.id, this.name, this.address, this.latitude, this.longitude});

  MASSAGE.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }


}