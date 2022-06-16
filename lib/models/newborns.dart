// To parse this JSON data, do
//
//     final newBorns = newBornsFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

import 'datum.dart';

class Newborns {
  Newborns({
    required this.data,
  });

  List<Datum> data;

  factory Newborns.fromJson(Map<String, dynamic> json) => Newborns(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}
