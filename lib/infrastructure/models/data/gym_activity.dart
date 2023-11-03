// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';

class GymActivity {
  final String name;
  final String count;
  final IconData icon;
  GymActivity({
    required this.name,
    required this.count,
    required this.icon,
  });

  GymActivity copyWith({
    String? name,
    String? count,
    IconData? icon,
  }) {
    return GymActivity(
      name: name ?? this.name,
      count: count ?? this.count,
      icon: icon ?? this.icon,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'count': count,
      'icon': icon.codePoint,
    };
  }

  factory GymActivity.fromMap(Map<String, dynamic> map) {
    return GymActivity(
      name: map['name'] as String,
      count: map['count'] as String,
      icon: IconData(map['icon'] as int, fontFamily: 'MaterialIcons'),
    );
  }

  String toJson() => json.encode(toMap());

  factory GymActivity.fromJson(String source) => GymActivity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'GymActivity(name: $name, count: $count, icon: $icon)';

  @override
  bool operator ==(covariant GymActivity other) {
    if (identical(this, other)) return true;
  
    return 
      other.name == name &&
      other.count == count &&
      other.icon == icon;
  }

  @override
  int get hashCode => name.hashCode ^ count.hashCode ^ icon.hashCode;
}
