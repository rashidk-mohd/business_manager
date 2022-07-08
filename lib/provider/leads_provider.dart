import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../models/http_exception.dart';
import '../models/leads_model.dart';
import '../utils/const.dart';
import '../utils/web_const.dart';

class LeadsProvider with ChangeNotifier {
  List<Lead> _items = [];
  List<Lead> newItem = [];
  List<Lead> qualifiedItem = [];
  List<Lead> wonItem = [];
  List<Lead> propositionItem = [];

  //sample code
  int jan = 0;
  int feb = 0;
  int mar = 0;
  int apr = 0;
  int may = 0;
  int jun = 0;
  int jul = 0;
  int aug = 0;
  int sep = 0;
  int oct = 0;
  int nov = 0;
  int dec = 0;
  int selelctedYear = 2022;
  int totalRevenue = 0;

  List<String> status = ["New", "Qualified", "Proposition", "Won"];
  List<Lead> get items {
    return [..._items];
  }

  void removeAll(BuildContext context, Lead toReomove) {
    newItem.removeWhere((lead) => lead.id == toReomove.id);
    qualifiedItem.removeWhere((lead) => lead.id == toReomove.id);
    wonItem.removeWhere((lead) => lead.id == toReomove.id);
    propositionItem.removeWhere((lead) => lead.id == toReomove.id);
    notifyListeners();
  }

////end

  Lead findById(int id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchAndSetleads(BuildContext context, {int year = 2022}) async {
    final url = Uri.parse(Constants.hostName + '/leads');
    selelctedYear = year;
    List<Lead> loadedLeads = [];
    newItem = [];
    qualifiedItem = [];
    wonItem = [];
    propositionItem = [];
    jan = 0;
    feb = 0;
    mar = 0;
    apr = 0;
    may = 0;
    jun = 0;
    jul = 0;
    aug = 0;
    sep = 0;
    oct = 0;
    nov = 0;
    dec = 0;
    totalRevenue = 0;
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

      extractedData.forEach((prodData) {
        var newLead = Lead(
          id: prodData["Id"],
          title: prodData['Title'],
          customer: prodData['Customer'],
          revenue: prodData['Revenue'],
          date: DateTime.parse(prodData['Date']),
          salesperson: prodData['Sales_person'],
          details: prodData['Details'],
          status: prodData['Status'],
        );
        if (prodData['Status'] == "New") {
          newItem.add(newLead);
        }
        if (prodData['Status'] == "Qualified") {
          qualifiedItem.add(newLead);
        }
        if (prodData['Status'] == "Proposition") {
          propositionItem.add(newLead);
        }
        if (prodData['Status'] == "Won") {
          wonItem.add(newLead);
        }

        /// here is the sample code
        var moonLand = DateTime.parse(prodData['Date']);
        if (moonLand.year == year) {
          totalRevenue = totalRevenue + newLead.revenue!;
          print("here ==================== $year");
          if (moonLand.month == 01) {
            jan = jan + newLead.revenue!;
          }
          if (moonLand.month == 02) {
            feb = feb + newLead.revenue!;
          }
          if (moonLand.month == 03) {
            mar = mar + newLead.revenue!;
          }
          if (moonLand.month == 04) {
            apr = apr + newLead.revenue!;
          }
          if (moonLand.month == 05) {
            may = may + newLead.revenue!;
          }
          if (moonLand.month == 06) {
            jun = jun + newLead.revenue!;
          }
          if (moonLand.month == 07) {
            jul = jul + newLead.revenue!;
          }
          if (moonLand.month == 08) {
            aug = aug + newLead.revenue!;
          }
          if (moonLand.month == 09) {
            sep = sep + newLead.revenue!;
          }
          if (moonLand.month == 10) {
            oct = oct + newLead.revenue!;
          }
          if (moonLand.month == 11) {
            nov = nov + newLead.revenue!;
          }
          if (moonLand.month == 12) {
            dec = dec + newLead.revenue!;
          }
        }
        loadedLeads.add(newLead);
      });

      _items = loadedLeads;

      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addLead(BuildContext context, Lead lead) async {
    print("call lead adding section");
    final url = Uri.parse(Constants.hostName + '/lead');
    try {
      print("here the lead api post");
      final response = await http.post(url,
          headers: BearerToken().hearders(context),
          body: json.encode({
            'Title': lead.title,
            'Customer': lead.customer,
            'Sales_person': lead.salesperson,
            'Revenue': lead.revenue,
            'Date': lead.date!.toIso8601String() + 'Z',
            'Details': lead.details,
            'Status': lead.status
          }));
      print(response);
      final newLead = Lead(
        title: lead.title,
        customer: lead.customer,
        date: DateTime.parse(lead.date!.toIso8601String()),
        details: lead.details,
        revenue: lead.revenue,
        salesperson: lead.salesperson,
        status: lead.status,
        id: lead.id,
      );
      _items.add(newLead);
      notifyListeners();
      fetchAndSetleads(context);
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateLeadStatus(BuildContext context, int? id, Lead newLead,
      String? status, DateTime? date) async {
    print("leads update screen");
    print(
        "here the passing value $id ${newLead.title} $status, ${newLead.date!.toIso8601String() + 'Z'}");
    final leadIndex = _items.indexWhere((element) => element.id == id);
    if (leadIndex >= 0) {
      final url = Uri.parse(Constants.hostName + '/leadstatus/$id');
      try {
        await http.patch(url,
            headers: BearerToken().hearders(context),
            body: json.encode({
              //'Title': newLead.title,
              //'Customer': newLead.customer,
              //'Revenue': newLead.revenue,
              //'Date': date!.toIso8601String() + 'Z',
              //'Sales_person': newLead.salesperson,
              //'Details': newLead.details,
              'Status': status
            }));
        _items[leadIndex] = newLead;
        notifyListeners();
      } catch (e) {
        print(e);
      }
    } else {
      print('.....');
    }
  }

  Future<void> updateLead(BuildContext context, int? id, Lead newLead) async {
    final leadIndex = _items.indexWhere((element) => element.id == id);
    if (leadIndex >= 0) {
      final url = Uri.parse(Constants.hostName + '/lead/$id');
      await http.patch(url,
          headers: BearerToken().hearders(context),
          body: json.encode({
            'Title': newLead.title,
            'Customer': newLead.customer,
            'Revenue': newLead.revenue,
            'Date': newLead.date!.toIso8601String() + 'Z',
            'Sales_person': newLead.salesperson,
            'Details': newLead.details,
            'Status': newLead.status
          }));
      _items[leadIndex] = newLead;
      notifyListeners();
    } else {
      print('.....');
    }
  }

  Future<void> deleteLead(BuildContext context, int id) async {
    final url = Uri.parse(Constants.hostName + '/lead/$id');
    final existingLeadIndex = _items.indexWhere((prod) => prod.id == id);
    Lead? existingUser = _items[existingLeadIndex];
    _items.removeAt(existingLeadIndex);
    notifyListeners();
    final response = await http
        .delete(
      url,
      headers: BearerToken().hearders(context),
    )
        .then((response) {
      print(response.statusCode);
    });
    if (response.statusCode >= 400) {
      _items.insert(existingLeadIndex, existingUser);
      notifyListeners();
      throw HttpException('Could not delete Leads.');
    }
    existingUser = null;
  }
}
