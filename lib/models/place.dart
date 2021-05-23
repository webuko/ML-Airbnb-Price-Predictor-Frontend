import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Flat {
  final String id;
  final String name;
  final String description;
  final String pictureUrl;
  final String neighbourhood;
  final double latitude;
  final double longitude;
  final int accommodates;
  final int bathrooms;
  final int bedrooms;

  Flat({
    required this.id,
    required this.name,
    required this.description,
    required this.pictureUrl,
    required this.neighbourhood,
    required this.latitude,
    required this.longitude,
    required this.accommodates,
    required this.bathrooms,
    required this.bedrooms,
  });
}
