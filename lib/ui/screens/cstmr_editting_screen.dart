import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/customer_model.dart';
import '../../provider/customer_provider.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_button.dart';
import '../widgets/edit_screen_textfields.dart';
import '../widgets/home_widget.dart';

class CustomerEdittingScreen extends StatefulWidget {
  const CustomerEdittingScreen({Key? key}) : super(key: key);

  @override
  _CustomerEdittingScreenState createState() => _CustomerEdittingScreenState();
}

class _CustomerEdittingScreenState extends State<CustomerEdittingScreen> {
  final form = GlobalKey<FormState>();
  final company = FocusNode();
  final adress = FocusNode();
  final emailId = FocusNode();
  final mobile = FocusNode();
  final add = FocusNode();
  var _edittedCustomers = CustomerModel(
    id: 0,
    name: "",
    company: "",
    address: "",
    email: "",
    mobile: "",
    // createdBy: 0,
    // createdOn: DateTime.parse("2022-01-22T15:04:05.000Z"),
    // lastEditedBy: "",
    // lastEditedOn: DateTime.now(),
  );
  var _initValues = {
    'Name': '',
    'Company': '',
    'Address': '',
    'Email': '',
    'Mobile': '',
  };
  var isInIt = true;
  //int? cstmrId;
  @override
  void didChangeDependencies() {
    if (isInIt) {
      var cstmrId = ModalRoute.of(context)?.settings.arguments as int?;
      print("here is the customer id $cstmrId");
      print('didchange id......${cstmrId}');
      if (cstmrId != null) {
        _edittedCustomers =
            Provider.of<CustomerProvider>(context, listen: false)
                .findById(cstmrId);
        _initValues = {
          'Name': _edittedCustomers.name!,
          'Company': _edittedCustomers.company!,
          'Address': _edittedCustomers.address!,
          'Email': _edittedCustomers.email!,
          'Mobile': _edittedCustomers.mobile!,
        };
      }
    }
    isInIt = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar('EDIT'),
      body: HomeWidget(
        child: Form(
          key: form,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    Column(
                      children: [
                        EditScreentextFields(
                            initialValue: _initValues['Name'],
                            title: "Name",
                            onSaved: (value) {
                              _edittedCustomers = CustomerModel(
                                name: value,
                                company: _edittedCustomers.company,
                                address: _edittedCustomers.address,
                                email: _edittedCustomers.email,
                                mobile: _edittedCustomers.mobile,
                                id: _edittedCustomers.id,
                              );
                            },
                            onFieldSubmitted: (_) {
                              FocusScope.of(context).requestFocus(company);
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please add a name.';
                              }
                              return null;
                            }),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05),
                        EditScreentextFields(
                            initialValue: _initValues['Company'],
                            title: 'Company',
                            onSaved: (value) {
                              _edittedCustomers = CustomerModel(
                                name: _edittedCustomers.name,
                                company: value,
                                address: _edittedCustomers.address,
                                email: _edittedCustomers.email,
                                mobile: _edittedCustomers.mobile,
                                id: _edittedCustomers.id,
                              );
                            },
                            focusNode: company,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context).requestFocus(adress);
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please add a company name.';
                              }
                              return null;
                            }),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05),
                        EditScreentextFields(
                            initialValue: _initValues['Address'],
                            title: 'Adress',
                            onSaved: (value) {
                              _edittedCustomers = CustomerModel(
                                name: _edittedCustomers.name,
                                company: _edittedCustomers.company,
                                address: value,
                                email: _edittedCustomers.email,
                                mobile: _edittedCustomers.mobile,
                                id: _edittedCustomers.id,
                              );
                            },
                            focusNode: adress,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context).requestFocus(emailId);
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please add an adress.';
                              }
                              return null;
                            }),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05),
                        EditScreentextFields(
                            initialValue: _initValues['Email'],
                            title: 'Email Id',
                            onSaved: (value) {
                              _edittedCustomers = CustomerModel(
                                name: _edittedCustomers.name,
                                company: _edittedCustomers.company,
                                address: _edittedCustomers.address,
                                email: value,
                                mobile: _edittedCustomers.mobile,
                                id: _edittedCustomers.id,
                              );
                            },
                            focusNode: emailId,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context).requestFocus(mobile);
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please add an email id.';
                              }
                              return null;
                            }),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05),
                        EditScreentextFields(
                            initialValue: _initValues['Mobile'],
                            title: 'Mobile',
                            onSaved: (value) {
                              _edittedCustomers = CustomerModel(
                                name: _edittedCustomers.name,
                                company: _edittedCustomers.company,
                                address: _edittedCustomers.address,
                                email: _edittedCustomers.email,
                                mobile: value,
                                id: _edittedCustomers.id,
                              );
                            },
                            focusNode: mobile,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please add a mobile number.';
                              }
                              return null;
                            }),
                      ],
                    ),
                  ],
                ),
              ),
              // SizedBox(height: MediaQuery.of(context).size.height * 0.11),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomeButton(
                    butionText: "SAVE",
                    buttonTopPadding: MediaQuery.of(context).size.width * 0.065,
                    buttionColor: const Color(0xff2182BA),
                    onPressed: () {
                      saveFormEditting();

                      //Navigator.of(context).pushNamed(Routes.homeScreen);
                    },
                  ),
                  CustomeButton(
                    butionText: "CANCEL",
                    buttonTopPadding: MediaQuery.of(context).size.width * 0.065,
                    buttionColor: const Color(0xff2182BA),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> saveFormEditting() async {
    print("sdfsdfgsdghsghsg${_edittedCustomers.id}");
    final isValid = form.currentState?.validate();
    if (!isValid!) {
      return;
    }
    form.currentState?.save();
    //  setState(() {
    //   _isLoading = true;
    // });
    Provider.of<CustomerProvider>(context, listen: false)
        .updateCustomer(context, _edittedCustomers.id, _edittedCustomers);
    Navigator.of(context).pop();
  }
}
