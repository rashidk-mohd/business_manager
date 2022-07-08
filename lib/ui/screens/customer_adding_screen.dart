import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/customer_model.dart';
import '../../provider/customer_provider.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/home_widget.dart';

class CustomerAddingScreen extends StatefulWidget {
  const CustomerAddingScreen({Key? key}) : super(key: key);

  @override
  State<CustomerAddingScreen> createState() => _CustomerAddingScreenState();
}

class _CustomerAddingScreenState extends State<CustomerAddingScreen> {
  final form = GlobalKey<FormState>();
  final company = FocusNode();
  final adress = FocusNode();
  final emailId = FocusNode();
  final mobile = FocusNode();
  final add = FocusNode();
  var addedCustomers = CustomerModel(
    id: 0,
    name: "",
    company: "",
    address: "",
    email: "",
    mobile: "",
    // createdBy: 0,
    // createdOn: DateTime.now(),
    // lastEditedBy: "",
    // lastEditedOn: DateTime.parse("2022-01-22T15:04:05.000Z"),
  );
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        'ADD',
        actionButton: [
          Padding(
            padding: EdgeInsets.only(
                right: MediaQuery.of(context).size.width * 0.025),
          ),
        ],
      ),
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
                        CustomTextField(
                            horizontalPadding:
                                MediaQuery.of(context).size.width * 0.065,
                            hintext: 'Name',
                            onSaved: (value) {
                              addedCustomers = CustomerModel(
                                name: value,
                                company: addedCustomers.company,
                                address: addedCustomers.address,
                                email: addedCustomers.email,
                                mobile: addedCustomers.mobile,
                                id: addedCustomers.id,
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
                        CustomTextField(
                            horizontalPadding:
                                MediaQuery.of(context).size.width * 0.065,
                            hintext: 'Company',
                            onSaved: (value) {
                              addedCustomers = CustomerModel(
                                name: addedCustomers.name,
                                company: value,
                                address: addedCustomers.address,
                                email: addedCustomers.email,
                                mobile: addedCustomers.mobile,
                                id: addedCustomers.id,
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
                        CustomTextField(
                            horizontalPadding:
                                MediaQuery.of(context).size.width * 0.065,
                            hintext: 'Adress',
                            onSaved: (value) {
                              addedCustomers = CustomerModel(
                                name: addedCustomers.name,
                                company: addedCustomers.company,
                                address: value,
                                email: addedCustomers.email,
                                mobile: addedCustomers.mobile,
                                id: addedCustomers.id,
                              );
                            },
                            focusNode: adress,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context).requestFocus(emailId);
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please add a adress.';
                              }
                              return null;
                            }),
                        CustomTextField(
                          horizontalPadding:
                              MediaQuery.of(context).size.width * 0.065,
                          hintext: 'Email Id',
                          keyboardType: TextInputType.emailAddress,
                          onSaved: (value) {
                            addedCustomers = CustomerModel(
                              name: addedCustomers.name,
                              company: addedCustomers.company,
                              address: addedCustomers.address,
                              email: value,
                              mobile: addedCustomers.mobile,
                              id: addedCustomers.id,
                            );
                          },
                          focusNode: emailId,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(mobile);
                          },
                          validator: (value) {
                            if (value!.isEmpty || !value.contains('@')) {
                              return 'Invalid email!';
                            }
                            return null;
                          },
                        ),
                        CustomTextField(
                          horizontalPadding:
                              MediaQuery.of(context).size.width * 0.065,
                          hintext: 'Mobile',
                          onSaved: (value) {
                            addedCustomers = CustomerModel(
                              name: addedCustomers.name,
                              company: addedCustomers.company,
                              address: addedCustomers.address,
                              email: addedCustomers.email,
                              mobile: value,
                              id: addedCustomers.id,
                            );
                          },
                          focusNode: mobile,
                          validator: (value) {
                            if (value!.isEmpty || value.length != 10) {
                              return 'Please add a mobile number.';
                            }
                            if (int.tryParse(value) == null) {
                              return 'Please enter a valid number.';
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomeButton(
                    butionText: "ADD",
                    buttonTopPadding: MediaQuery.of(context).size.width * 0.06,
                    buttionColor: const Color(0xff2182BA),
                    onPressed: () {
                      saveForm();

                      // Navigator.of(context).pop();
                    },
                  ),
                  CustomeButton(
                    butionText: "CANCEL",
                    buttonTopPadding: MediaQuery.of(context).size.width * 0.06,
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

  Future<void> saveForm() async {
    final isValid = form.currentState?.validate();
    if (!isValid!) {
      return;
    }
    form.currentState?.save();
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<CustomerProvider>(context, listen: false)
          .addCustomers(context, addedCustomers);
      Navigator.of(context).pop();
    } catch (error) {
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('An error occurred!'),
          content: const Text('Something went wrong.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Okay'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            )
          ],
        ),
      );
    }
  }
}
