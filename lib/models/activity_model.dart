import 'package:flutter/material.dart';

class ActivityModel with ChangeNotifier {
  int id;
  String? type;
  String? details;
  DateTime? date;
  int? lead;

  ActivityModel({
    required this.id,
    this.type,
    this.details,
    this.date,
    this.lead,
  });
}