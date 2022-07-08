

import 'package:flutter/material.dart';

class User with ChangeNotifier {
  int? id;
  String? userName;
  String? password;
  String? role;
  String? status;
  String? emailId;
  String? mobile;
  final String? createdBy;
  final DateTime? createdOn;
  final String? lastEdittedBy;
  final DateTime? lastEdittedOn;
  User({
    this.id,
    this.userName,
    this.password,
    this.role,
    this.emailId,
    this.status,
    this.mobile,
    this.createdBy,
    this.createdOn,
    this.lastEdittedBy,
    this.lastEdittedOn,
  });
}
