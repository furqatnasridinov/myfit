class UserSchedulesResponse {
  String? calendarDate;
  DateTime? dateTime;
  bool? isPlusStateTriggered;
  List<ListOfSchedules>? listOfSchedules;

  UserSchedulesResponse(
      {this.calendarDate, this.dateTime, this.isPlusStateTriggered, this.listOfSchedules});

  UserSchedulesResponse.fromJson(Map<String, dynamic> json) {
    calendarDate = json['calendarDate'];
    dateTime = json['dateTime'];
    if (json['listOfSchedules'] != null) {
      listOfSchedules = <ListOfSchedules>[];
      json['listOfSchedules'].forEach((v) {
        listOfSchedules!.add(ListOfSchedules.fromJson(v));
      });
    }
  }
}

class ListOfSchedules {
  int? id;
  String? date;
  String? description;
  String? duration;
  Gym? gym;
  List<Tag>? tag;

  ListOfSchedules(
      {this.id,
      this.date,
      this.description,
      this.duration,
      this.gym,
      this.tag});

  ListOfSchedules.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    description = json['description'];
    duration = json['duration'];
    gym = json['gym'] != null ?  Gym.fromJson(json['gym']) : null;
    if (json['tag'] != null) {
      tag = <Tag>[];
      json['tag'].forEach((v) {
        tag!.add(Tag.fromJson(v));
      });
    }
  }
}

class Gym {
  int? id;
  String? name;
  String? address;
  String? latitude;
  String? longitude;
  String? description;
  String? mainPictureUrl;
  String? phone;
  String? telegram;
  String? email;
  String? vk;

  Gym(
      {this.id,
      this.name,
      this.address,
      this.latitude,
      this.longitude,
      this.description,
      this.mainPictureUrl,
      this.phone,
      this.telegram,
      this.email,
      this.vk});

  Gym.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    description = json['description'];
    mainPictureUrl = json['mainPictureUrl'];
    phone = json['phone'];
    telegram = json['telegram'];
    email = json['email'];
    vk = json['vk'];
  }
}

class Tag {
  int? id;
  String? tag;
  String? description;

  Tag({this.id, this.tag, this.description});

  Tag.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tag = json['tag'];
    description = json['description'];
  }
}
