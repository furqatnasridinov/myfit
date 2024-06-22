class Referal {
  int? invitedUsers;
  String? refLink;
  int? bonus;
  int? receivedBonus;
  int? usedBonus;

  Referal({this.invitedUsers, this.refLink, this.bonus, this.receivedBonus});

  Referal.fromJson(Map<String, dynamic> json) {
    invitedUsers = json['invitedUsers'];
    refLink = json['refLink'];
    bonus = json['bonus'];
    receivedBonus = json['receivedBonus'];
    usedBonus = json["usedBonus"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['invitedUsers'] = invitedUsers;
    data['refLink'] = refLink;
    data['bonus'] = bonus;
    data['receivedBonus'] = receivedBonus;
    data["usedBonus"] = usedBonus;
    return data;
  }
}