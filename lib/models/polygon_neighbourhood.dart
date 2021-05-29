// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';

//How to convert into json
List<PolygonNeighbourhood> welcomeFromJson(String str) =>
    List<PolygonNeighbourhood>.from(
        json.decode(str).map((x) => PolygonNeighbourhood.fromJson(x)));

String welcomeToJson(List<PolygonNeighbourhood> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PolygonNeighbourhood {
  PolygonNeighbourhood({
    this.avgPrice,
    this.avgLatLng,
    this.neighbourhood,
    this.relAvgPrice,
    this.geometry,
  });

  double? avgPrice;
  LatLng? avgLatLng;
  String? neighbourhood;
  double? relAvgPrice;
  Geometry? geometry;

  factory PolygonNeighbourhood.fromJson(Map<String, dynamic> json) =>
      PolygonNeighbourhood(
        avgPrice: json["avgPrice"].toDouble(),
        neighbourhood: json["neighbourhood"],
        relAvgPrice: json["relAvgPrice"].toDouble(),
        geometry: Geometry.fromJson(json["geometry"]),
      );

  Map<String, dynamic> toJson() => {
        "avgPrice": avgPrice,
        "neighbourhood": neighbourhood,
        "relAvgPrice": relAvgPrice,
        "geometry": geometry!.toJson(),
      };
}

class Geometry {
  Geometry({
    this.type,
    this.coordinates,
  });

  Type? type;
  List<List<List<List<double>>>>? coordinates;

  factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
        type: typeValues.map?[json["type"]],
        coordinates: List<List<List<List<double>>>>.from(json["coordinates"]
            .map((x) => List<List<List<double>>>.from(x.map((x) =>
                List<List<double>>.from(x.map(
                    (x) => List<double>.from(x.map((x) => x.toDouble())))))))),
      );

  Map<String, dynamic> toJson() => {
        "type": typeValues.reverse[type],
        "coordinates": List<dynamic>.from(coordinates!.map((x) =>
            List<dynamic>.from(x.map((x) => List<dynamic>.from(
                x.map((x) => List<dynamic>.from(x.map((x) => x)))))))),
      };
}

enum Type { MULTI_POLYGON }

final typeValues = EnumValues({"MultiPolygon": Type.MULTI_POLYGON});

class EnumValues<T> {
  Map<String, T>? map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map!.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap!;
  }
}
