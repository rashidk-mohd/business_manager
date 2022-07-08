import 'dart:async';
import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/http_exception.dart';
import '../utils/const.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? state;
  String? _userId;
  String? bearerToken;
  String? userName;
  Timer? _authTimer;
  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  void stateType(String type) {
    state = type;
    notifyListeners();
  }

  Future<void> _authenticate(
      {required String userName,
      required String password,
      String? Organization,
      String? Email,
      String? Mobile,
      required String urlSegment}) async {
    final url = Uri.parse(Constants.hostName + '/$urlSegment');

    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'username': userName,
            'password': password,
            'organization': Organization,
            'Email': Email,
            'Mobile': Mobile,
          },
        ),
      );
      print(json.decode(response.body));

      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      // usertkn = responseData['idToken'];
      // AuthToken.authSave = usertkn!;
      _token = responseData['idToken'];
      _userId = responseData['localId'];

      //DateTime datetime = DateTime.parse("2006-01-02T15:04:05.000Z");

      _expiryDate = DateTime.parse(
        responseData['expiresAt'],
      );
      _autoLogout();
      // notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('bearerToken', responseData['idToken']);
      prefs.setString('userName', responseData['localId']);
      notifyListeners();
      print('here is the bearer token set ${responseData['idToken']}');
      final userData = json.encode(
        {
          'token': _token,
          'userId': _userId,
          'expiryDate': _expiryDate!.toIso8601String(),
        },
      );
      prefs.setString('userData', userData);
    } catch (error) {
      rethrow;
    }
  }

  getBearerToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bearerToken = prefs.getString('bearerToken');
    userName = prefs.getString('userName');
    print("again we call $bearerToken");
    print("userName is  $userName");
    notifyListeners();
  }

  Future<void> signup(String userName, String password, String organization,
      String Email, String Mobile) async {
    return _authenticate(
        userName: userName,
        password: password,
        Organization: organization,
        Email: Email,
        Mobile: Mobile,
        urlSegment: 'signup');
  }

  Future<void> login(String userName, String password) async {
    return _authenticate(
        userName: userName, password: password, urlSegment: 'login');
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString('userData').toString())
            as Map<String?, dynamic>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    print(extractedUserData);
    _expiryDate = expiryDate;
    notifyListeners();
    _autoLogout();
    return true;
  }

  void logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    // prefs.remove('userData');
    prefs.clear();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
