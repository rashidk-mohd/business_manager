// To parse this JSON data, do
//
//     final customerModel = customerModelFromJson(jsonString);

import 'package:flutter/material.dart';

// List<CustomerModel> customerModelFromJson(String str) => List<CustomerModel>.from(json.decode(str).map((x) => CustomerModel.fromJson(x)));

// String customerModelToJson(List<CustomerModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CustomerModel with ChangeNotifier {
  CustomerModel({
    required this.id,
    this.name,
    this.company,
    this.address,
    this.email,
    this.mobile,
    // required this.createdBy,
    // required  this.createdOn,
    // required this.lastEditedBy,
    //  required this.lastEditedOn,
  });

  int id;
  String? name;
  String? company;
  String? address;
  String? email;
  String? mobile;
  // int? createdBy;
  // DateTime createdOn;
  // String lastEditedBy;
  // DateTime lastEditedOn;

  factory CustomerModel.fromJson(Map<String, dynamic> json) => CustomerModel(
        id: json["Id"],
        name: json["Name"],
        company: json["Company"],
        address: json["Address"],
        email: json["Email"],
        mobile: json["Mobile"],
        // createdBy: json["Created_by"],
        // createdOn: DateTime.parse(json["Created_on"]),
        // lastEditedBy: json["Last_edited_by"],
        // lastEditedOn: DateTime.parse(json["Last_edited_on"]),
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "Name": name,
        "Company": company,
        "Address": address,
        "Email": email,
        "Mobile": mobile,
        // "Created_by": createdBy,
        // "Created_on": createdOn?.toIso8601String(),
        // "Last_edited_by": lastEditedBy,
        // "Last_edited_on": lastEditedOn?.toIso8601String(),
      };
}
