// ignore_for_file: unnecessary_new

class UserSubscription {
  Subscription? subscription;
  String? firstBuyData;
  String? prolongationData;
  String? endData;
  bool? autoRenewal;

  UserSubscription(
      {this.subscription,
      this.firstBuyData,
      this.prolongationData,
      this.endData,
      this.autoRenewal});

  UserSubscription.fromJson(Map<String, dynamic> json) {
    subscription = json['subscription'] != null
        ? new Subscription.fromJson(json['subscription'])
        : null;
    firstBuyData = json['firstBuyData'];
    prolongationData = json['prolongationData'];
    endData = json['endData'];
    autoRenewal = json['autoRenewal'];
  }
}

class Subscription {
  int? id;
  String? type;
  String? description;
  int? durationInMonth;
  int? freezingDays;
  int? price;

  Subscription(
      {this.id,
      this.type,
      this.description,
      this.durationInMonth,
      this.freezingDays,
      this.price});

  Subscription.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    description = json['description'];
    durationInMonth = json['duration'];
    freezingDays = json['freezingDays'];
    price = json['price'];
  }

}