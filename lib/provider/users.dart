import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../models/http_exception.dart';
import '../models/user_model.dart';
import '../utils/const.dart';
import '../utils/web_const.dart';

class Users with ChangeNotifier {
  List<User> _users = [];
  String? userName;
  List<User> get users {
    return [..._users];
  }

  String? selectedUser;
  User findById(int id) {
    return users.firstWhere((usr) => usr.id == id);
  }

  String findNameById(int? id) {
    String? name;
    users.forEach((element) {
      if (element.id == id) {
        name = element.userName;
        userName = element.userName;
      }
    });
    return name!;
  }

  Future<void> addUser(BuildContext context, User user) async {
    print("this is name -------${user.userName}");

    final url = Uri.parse(Constants.hostName + '/user');
    try {
      final response = await http.post(url,
          headers: BearerToken().hearders(context),
          body: json.encode({
            'UserName': user.userName,
            'Password': user.password,
            'Role': user.role,
            'Org': 1,
            'Email': user.emailId,
            'Status': user.status,
            'Mobile': user.mobile,
            'CreatedBy': user.createdBy,
            // 'CreatedOn': user.createdOn,
            // 'LastEdittedBy': user.lastEdittedBy,
            // 'LastEdittedOn': user.lastEdittedOn,
          }));
      print('body: ${json.decode(response.body)}');
      final newUser = User(
        id: user.id,
        userName: user.userName,
        password: user.password,
        role: user.role,
        emailId: user.emailId,
        status: user.status,

        mobile: user.mobile,

        // createdBy: user.createdBy,
        // createdOn: user.createdOn,
        // lastEdittedBy: user.lastEdittedBy,
        // lastEdittedOn: user.lastEdittedOn,
        // id: DateTime.now().toSt
        //id: json.decode(response.body)['Id'],
      );
      _users.add(newUser);
      // _items.insert(0, newProduct); // at the start of the list
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateUser(BuildContext context, int id, User newUser) async {
    final userIndex = _users.indexWhere((user) => user.id == id);
    print('user index ...$userIndex');
    print("items on    $_users");
    if (userIndex >= 0) {
      final url = Uri.parse(Constants.hostName + '/user/$id');
      try {
        await http.patch(
          url,
          headers: BearerToken().hearders(context),
          body: json.encode(
            {
              'Username': newUser.userName,
              'Password': newUser.password,
              'Role': newUser.role,
              'Email': newUser.emailId,
              'Status': newUser.status,
              'Mobile': newUser.mobile,
              // 'createdBy': newUser.createdBy,
              // 'createdOn': newUser.createdOn,
              // 'lastEdittedBy': newUser.lastEdittedBy,
              // 'lastEdittedOn': newUser.lastEdittedOn,
            },
          ),
        );
        var body = json.encode(
          {
            'Username': newUser.userName,
            'Password': newUser.password,
            'Role': newUser.role,
            'Email': newUser.emailId,
            'Status': newUser.status,
            'Mobile': newUser.mobile,
            // 'createdBy': newUser.createdBy,
            // 'createdOn': newUser.createdOn,
            // 'lastEdittedBy': newUser.lastEdittedBy,
            // 'lastEdittedOn': newUser.lastEdittedOn,
          },
        );
        print(body);
        _users[userIndex] = newUser;
        notifyListeners();
        print(
            '...........................................updating user was successfull....................................');
      } catch (error) {
        print("error in updating user $error");
      }
    } else {
      print('updating user was faild');
      print(userIndex);
    }

    notifyListeners();
  }

  Future<void> deleteUser(BuildContext context, int id) async {
    final url = Uri.parse(Constants.hostName + '/user/$id');
    final existingUserIndex = _users.indexWhere((prod) => prod.id == id);
    User? existingUser = _users[existingUserIndex];
    _users.removeAt(existingUserIndex);
    notifyListeners();
    final response = await http.delete(
      url,
      headers: BearerToken().hearders(context),
    );

    print(response.statusCode);

    if (response.statusCode >= 400) {
      _users.insert(existingUserIndex, existingUser);
      notifyListeners();
      throw HttpException('Could not delete user.');
    }
    existingUser = null;
  }

  Future<void> fetchAndSetUsers(BuildContext context) async {
    final url = Uri.parse(Constants.hostName + '/users');

    List<User> loadedUsers = [];

    try {
      final response = await http.get(
        url,
        headers: BearerToken().hearders(context),
      );

      print('status code :  ${response.statusCode}');
      var body = jsonDecode(response.body);
      print(jsonDecode(response.body));
      final extractedData = json.decode(response.body) as List<dynamic>;

      if (extractedData == null) {
        return;
      }

      for (var prodData in extractedData) {
        loadedUsers.add(
          User(
            id: prodData["Id"],
            userName: prodData['Username'],
            password: prodData['Password'],
            role: prodData['Role'],
            emailId: prodData['Email'],
            // status: prodData['Status'],
            mobile: prodData['Mobile'],
            // createdBy: prodData['Created_by'],
            // createdOn: DateTime.parse(prodData['Created_on']),
            // lastEdittedBy: prodData['Last_edited_by'],
            // lastEdittedOn: DateTime.parse(prodData['Last_edited_on']),
          ),
        );
      }
      _users = loadedUsers;

      _users = loadedUsers;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  void currentUser(dynamic id) {
    users.forEach((element) {
      if (element.id == int.parse(id)) {
        selectedUser = element.userName;
        notifyListeners();
      }
    });
  }
}
