class Activity {
  int id;
  String? startingTime;
  String? finishingTime;
  String? duration;
  String? name;
  int? status;

  Activity(this.id,this.startingTime, this.finishingTime, this.duration, this.name,
      {this.status = 1});
}
