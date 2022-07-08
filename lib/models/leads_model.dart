import 'package:flutter/material.dart';

class Lead with ChangeNotifier {
  Lead({
    this.id,
    this.title,
    this.customer,
    this.revenue,
    this.date,
    this.salesperson,
    this.details,
    this.status,
  });

  final int? id;
  final String? title;
  final int? customer;
  final int? revenue;
  final DateTime? date;
  final int? salesperson;
  final String? details;
  final String? status;
}
