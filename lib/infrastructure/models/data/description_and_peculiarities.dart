class DescribtionAndPeculiarities {
  String? typeDescription;
  String? peculiarities;

  DescribtionAndPeculiarities({this.typeDescription, this.peculiarities});

  DescribtionAndPeculiarities.fromJson(Map<String, dynamic> json) {
    typeDescription = json['typeDescription'];
    peculiarities = json['peculiarities'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['typeDescription'] = typeDescription;
    data['peculiarities'] = peculiarities;
    return data;
  }
}