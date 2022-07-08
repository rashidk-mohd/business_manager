import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/customer_model.dart';
import '../models/http_exception.dart';
import '../utils/const.dart';
import '../utils/web_const.dart';

class CustomerProvider with ChangeNotifier {
  String? selectedCustomer;
  List<CustomerModel> _customers = [];
  List<CustomerModel> get customers {
    return [..._customers];
  }

  CustomerModel findById(int id) {
    print('id===${id}');
    return customers.firstWhere((cstmr) => cstmr.id == id);
  }

  String findNameById(int? id) {
    String? name;
    customers.forEach((element) {
      if (element.id == id) {
        name = element.name;
      }
    });
    return name!;
  }

  Future<void> fetchAndSetCustomers(BuildContext context) async {
    List<CustomerModel> loadedCustomers = [];
    final url = Uri.parse(Constants.hostName + '/customers');
    final respose = await http.get(
      url,
      headers: BearerToken().hearders(context),
    );
    print(jsonDecode(respose.body));
    final extractedData = json.decode(respose.body) as List<dynamic>;
    extractedData.forEach((customerData) {
      loadedCustomers.add(
        CustomerModel(
          id: customerData["Id"],
          name: customerData['Name'],
          company: customerData['Company'],
          address: customerData['Address'],
          email: customerData['Email'],
          mobile: customerData['Mobile'],
          // createdBy: customerData['Created_by'],
          // createdOn: DateTime.parse(customerData['Created_on']),
          // lastEditedBy: customerData['Last_edited_by'],
          // lastEditedOn: DateTime.parse(customerData['Last_edited_on']),
        ),
      );
      // customerName.add(customerData['Name']);
    });
    _customers = loadedCustomers;
    notifyListeners();
  }

  Future<void> addCustomers(
      BuildContext context, CustomerModel customerModel) async {
    print("this is name -------${customerModel.name}");
    final url = Uri.parse(Constants.hostName + '/customer');
    try {
      final response = await http.post(
        url,
        headers: BearerToken().hearders(context),
        body: json.encode(
          {
            "Id": customerModel.id,
            "Name": customerModel.name,
            "Company": customerModel.company,
            "Address": customerModel.address,
            "Email": customerModel.email,
            "Mobile": customerModel.mobile,
            "Created_by": 6,
            "Created_by": 8,
            // "Created_on": customerModel.createdOn.toIso8601String() + ('Z'),
            // 'Last_edited_by': 11,
            // "Last_edited_on":
            //     customerModel.lastEditedOn.toIso8601String() + ('Z'),
          },
        ),
      );
      print('body: ${json.decode(response.body)}');
      final newCustomers = CustomerModel(
        id: customerModel.id,
        name: customerModel.name,
        company: customerModel.company,
        address: customerModel.address,
        email: customerModel.email,
        mobile: customerModel.mobile,
        // createdBy: customerModel.createdBy,
        // createdOn: DateTime.parse("2022-01-22T15:04:05.000Z"),
        // lastEditedBy: customerModel.lastEditedBy,
        // lastEditedOn: DateTime.parse("2022-01-22T15:04:05.000Z"),
      );
      _customers.add(newCustomers);
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<void> updateCustomer(
      BuildContext context, int id, CustomerModel newCstmr) async {
    // ignore: unrelated_type_equality_checks
    final cstmrIndex = _customers.indexWhere((cstmrs) => cstmrs.id == id);
    final url = Uri.parse(Constants.hostName + '/customer/$id');
    await http.patch(
      url,
      headers: BearerToken().hearders(context),
      body: json.encode(
        {
          'Id': newCstmr.id,
          'Name': newCstmr.name,
          'Company': newCstmr.company,
          'Address': newCstmr.address,
          'Email': newCstmr.email,
          'Mobile': newCstmr.mobile,
          'Created_by': 6,
          'Created_by': 8,
          // "Created_on": newCstmr.createdOn.toIso8601String() + ('Z'),
          // 'Last_edited_by': newCstmr.lastEditedBy,
          // "Last_edited_on": newCstmr.lastEditedOn.toIso8601String() + ('Z'),
        },
      ),
    );

    _customers[cstmrIndex] = newCstmr;
    notifyListeners();
  }

  Future<void> deleteCustomer(BuildContext context, int id) async {
    final url = Uri.parse(Constants.hostName + '/customer/$id');

    final existingCustomerIndex =
        _customers.indexWhere((cstmrs) => cstmrs.id == id);
    CustomerModel? existingCustomer = _customers[existingCustomerIndex];

    _customers.removeAt(existingCustomerIndex);
    notifyListeners();

    final response = await http.delete(
      url,
      headers: BearerToken().hearders(context),
    );
    if (response.statusCode >= 400) {
      _customers.insert(existingCustomerIndex, existingCustomer);
      notifyListeners();
      throw HttpException('Could Not Delete Customer');
    }

    existingCustomer = null;
    // _customers.removeWhere((cstmr) => cstmr.id == id);
    // notifyListeners();
  }

  // the below function is used in leads section.
  void currentCustomer(dynamic id) {
    customers.forEach((element) {
      if (element.id == int.parse(id)) {
        selectedCustomer = element.name;
        notifyListeners();
      }
    });
  }
}
