import 'package:flutter/material.dart';

class Attributes {
  Attributes({
    required this.gender,
    required this.gestation,
    required this.firstCryPushDate,
    required this.name,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  String gender;
  DateTime gestation;
  dynamic firstCryPushDate;
  String name;
  int userId;
  DateTime createdAt;
  DateTime updatedAt;

  factory Attributes.fromJson(Map<String, dynamic> json) => Attributes(
        gender: json["gender"],
        gestation: DateTime.parse(json["gestation"]),
        firstCryPushDate: json["first_cry_push_date"],
        name: json["name"],
        userId: json["user_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "gender": gender,
        "gestation": gestation.toIso8601String(),
        "first_cry_push_date": firstCryPushDate,
        "name": name,
        "user_id": userId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
