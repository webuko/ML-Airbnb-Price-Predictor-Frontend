import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Flat {
  final int id;
  final String name;
  final String description;
  final String pictureUrl;
  final String neighbourhood;
  final double latitude;
  final double longitude;
  final int? accommodates;
  final double? bathrooms;
  final int? bedrooms;

  Flat({
    required this.id,
    required this.name,
    required this.description,
    required this.pictureUrl,
    required this.neighbourhood,
    required this.latitude,
    required this.longitude,
    this.accommodates,
    this.bathrooms,
    this.bedrooms,
  });
}
