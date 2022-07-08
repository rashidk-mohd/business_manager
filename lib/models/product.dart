import 'package:flutter/material.dart';

class Product with ChangeNotifier {
  Product({
    this.id,
    this.name,
    this.price,
    this.tax,
    this.unit,
  });

  int? id;
  String? name;
  int? price;
  int? tax;
  String? unit;
}
