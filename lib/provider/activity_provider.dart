import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../models/activity_model.dart';
import '../models/http_exception.dart';
import '../utils/const.dart';
import '../utils/web_const.dart';

class ActivityProvider with ChangeNotifier {
  List<ActivityModel> _activity = [];

  List<ActivityModel> get activity {
    return [..._activity];
  }

  ActivityModel findById(int id) {
    print('id===${id}');
    return activity.firstWhere((activity) => activity.id == id);
  }

  Future<void> fetchAndSetActivity(BuildContext context) async {
    final url = Uri.parse(Constants.hostName + '/activities');
    List<ActivityModel> loadedActivity = [];
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

      extractedData.forEach((activityData) {
        loadedActivity.add(ActivityModel(
          id: activityData['Id'],
          type: activityData['Type'],
          details: activityData['Details'],
          date: DateTime.parse(activityData['Date']),
          lead: 2,
        ));
      });
      _activity = loadedActivity;

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addActivity(BuildContext context, ActivityModel activity) async {
    final url = Uri.parse(Constants.hostName + '/activity');

    try {
      final response = await http.post(url,
          headers: BearerToken().hearders(context),
          body: json.encode({
            'Type': activity.type,
            'Details': activity.details,
            // 'Date': DateTime.parse("2022-01-22T15:04:05.000Z")
            'Date': activity.date!.toIso8601String() + 'Z',
            'Lead': 2,
          }));
      print("details....... ${activity.details}");
      print("activity........${json.decode(response.body)}");
      final newActivity = ActivityModel(
        type: activity.type,
        details: activity.details,
        // date: DateTime.now()
        date: DateTime.parse(activity.date!.toIso8601String()),
        lead: activity.lead,
        id: activity.id,
      );
      _activity.add(newActivity);
      // _items.insert(0, newProduct); // at the start of the list
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateActivity(
      BuildContext context, int id, ActivityModel newActivity) async {
    final activityIndex =
        _activity.indexWhere((activities) => activities.id == id);
    print(_activity);
    print("activity index      .....$activityIndex");
    print(activity[1].id);
    if (activityIndex >= 0) {
      final url = Uri.parse(Constants.hostName + '/activity/$id');
      await http.patch(
        url,
        headers: BearerToken().hearders(context),
        body: json.encode(
          {
            'Type': newActivity.type,
            'Details': newActivity.details,
            'Date': newActivity.date!.toIso8601String() + ("Z"),
            'Lead': newActivity.lead,
          },
        ),
      );
      _activity[activityIndex] = newActivity;
      notifyListeners();
    } else {
      print("update activity error");
      print(activityIndex);
    }
    notifyListeners();
  }

  Future<void> deleteActivity(BuildContext context, int id) async {
    final url = Uri.parse(Constants.hostName + '/activity/$id');
    final existingActivityIndex =
        _activity.indexWhere((activities) => activities.id == id);
    ActivityModel? existingActivity = _activity[existingActivityIndex];
    _activity.removeAt(existingActivityIndex);
    notifyListeners();
    final response = await http.delete(
      url,
      headers: BearerToken().hearders(context),
    );
    if (response.statusCode >= 400) {
      _activity.insert(existingActivityIndex, existingActivity);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
    existingActivity = null;
  }
}
