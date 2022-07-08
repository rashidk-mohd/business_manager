import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/auth.dart';

class BearerToken {
  Map<String, String> header = {};
  Map<String, String> hearders(BuildContext context) {
    final bearerToken = Provider.of<Auth>(context, listen: false).bearerToken;
    header = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $bearerToken',
    };
    return header;
  }
}
