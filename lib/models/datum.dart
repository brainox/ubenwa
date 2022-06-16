import 'package:flutter/material.dart';
import 'attributes.dart';

class Datum {
  Datum({
    required this.id,
    required this.attributes,
  });

  String id;
  Attributes attributes;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        attributes: Attributes.fromJson(json["attributes"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "attributes": attributes.toJson(),
      };
}
