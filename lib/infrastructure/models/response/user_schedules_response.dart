class UserSchedulesResponse {
  String? calendarDate;
  DateTime? dateTime;
  bool? isPlusStateTriggered;
  List<ListOfSchedules>? listOfSchedules;

  UserSchedulesResponse(
      {this.calendarDate,
      this.dateTime,
      this.isPlusStateTriggered,
      this.listOfSchedules});

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
  String? lessonType;
  bool? canSignUp;
  String? lessonState;

  ListOfSchedules(
      {this.id,
      this.date,
      this.description,
      this.duration,
      this.gym,
      this.tag,
      this.lessonType,
      this.canSignUp,
      this.lessonState});

  ListOfSchedules.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    description = json['description'];
    duration = json['duration'];
    gym = json['gym'] != null ? Gym.fromJson(json['gym']) : null;
    if (json['tag'] != null) {
      tag = <Tag>[];
      json['tag'].forEach((v) {
        tag!.add(Tag.fromJson(v));
      });
    }
    lessonType = json['lessonType'] ?? "";
    canSignUp = json['canSignUp'] ?? "";
    lessonState = json['lessonState'] ?? "";
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
  List<String>? daysOfWeek;
  String? startTime;
  String? endTime;
  int? visitedCount;
  int? visitPerMonth;

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
      this.vk,
      this.daysOfWeek = const [],
      this.startTime,
      this.endTime,
      this.visitedCount,
      this.visitPerMonth});

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
    daysOfWeek = json['daysOfWeek'].cast<String>();
    startTime = json['startTime'];
    endTime = json['endTime'];
    visitedCount = json['visitedCount'];
    visitPerMonth = json['visitPerMonth'];
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
