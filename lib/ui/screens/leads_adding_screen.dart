import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/leads_model.dart';
import '../../provider/customer_provider.dart';
import '../../provider/leads_provider.dart';
import '../../provider/users.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/home_widget.dart';

class LeadsAddingScreens extends StatefulWidget {
  @override
  State<LeadsAddingScreens> createState() => _LeadsAddingScreenState();
}

class _LeadsAddingScreenState extends State<LeadsAddingScreens> {
  TextEditingController dateController = TextEditingController();
  DateTime currentDate = DateTime.now();
  final form = GlobalKey<FormState>();
  final customerNode = FocusNode();
  final revenueNode = FocusNode();
  final dateNode = FocusNode();
  final salesPersonNode = FocusNode();
  final detailsNode = FocusNode();
  final statusNode = FocusNode();
  String? currentStatus;
  var editedLead = Lead(
      title: '',
      customer: 0,
      date: DateTime.parse("2022-01-22T15:04:05.000Z"),
      revenue: 0,
      salesperson: 0,
      details: '',
      status: '');
  // var _initValues = {
  //   'title': '',
  //   'customer': '',
  //   //'date': '',
  //   'revenue': '',
  //   'salesperson': '',
  //   'details': '',
  //   'status': ''
  // };
  // var _isInit = true;

  // @override
  // void didChangeDependencies() {
  //   if (_isInit) {
  //     final leadId = ModalRoute.of(context)!.settings.arguments as int?;
  //     print("the dfjbsfgsdg ------ -- -- --- $leadId");
  //     if (leadId != null) {
  //       _editedLead =
  //           Provider.of<LeadsProvider>(context, listen: false).findById(leadId);
  //       _initValues = {
  //         'title': _editedLead.title!,
  //         'customer': _editedLead.customer.toString(),
  //         //'date': DateTime.now().toString(),
  //         'revenue': _editedLead.revenue.toString(),
  //         'salesperson': _editedLead.salesperson.toString(),
  //         'details': _editedLead.details!,
  //         'status': _editedLead.status!,
  //       };
  //     }
  //   }
  //   _isInit = false;
  //   super.didChangeDependencies();
  // }

  @override
  void initState() {
    // Future.delayed(Duration.zero).then(
    //   (_) {
    Provider.of<CustomerProvider>(context, listen: false)
        .fetchAndSetCustomers(context);

    Provider.of<Users>(context, listen: false).fetchAndSetUsers(context);
    //   },
    // );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final customerData = Provider.of<CustomerProvider>(context);
    final userData = Provider.of<Users>(context);
    final leadsData = Provider.of<LeadsProvider>(context);
    return Scaffold(
      appBar: CustomAppBar(
        'ADD LEAD',
        actionButton: const [
          Padding(
            padding: EdgeInsets.only(right: 8),
          ),
        ],
        isLead: true,
        leadWidget: IconButton(
          icon: Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Navigator.pop(context);
            Provider.of<CustomerProvider>(context, listen: false)
                .selectedCustomer = null;
            Provider.of<Users>(context, listen: false).selectedUser = null;
          },
        ),
      ),
      body: HomeWidget(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: form,
            child: ListView(
              children: [
                Column(
                  children: [
                    CustomTextField(
                      horizontalPadding: 27,
                      hintext: 'Title',
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(customerNode);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please add a name.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        editedLead = Lead(
                          title: value,
                          customer: editedLead.customer,
                          date: editedLead.date,
                          details: editedLead.details,
                          revenue: editedLead.revenue,
                          salesperson: editedLead.salesperson,
                          status: editedLead.status,
                        );
                      },
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    CustomTextField(
                      horizontalPadding: 27,
                      hintext: 'Customer',
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: customerNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(revenueNode);
                      },
                      // validator: (value) {
                      //   if (value!.isEmpty) {
                      //     return 'Please select a customer.';
                      //   }
                      //   if (int.tryParse(value) == null) {
                      //     return 'Please enter a valid customer.';
                      //   }
                      //   if (int.parse(value) <= 0) {
                      //     return 'Please enter a number greater than zero.';
                      //   }
                      //   return null;
                      // },
                      // onSaved: (value) {
                      //   editedLead = Lead(
                      //     title: editedLead.title,
                      //     customer: int.parse(value!),
                      //     date: editedLead.date,
                      //     details: editedLead.details,
                      //     revenue: editedLead.revenue,
                      //     salesperson: editedLead.salesperson,
                      //     status: editedLead.status,
                      //   );
                      // },
                      isSuffixIcon: true,
                      suffixIcon: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          hint: customerData.selectedCustomer == null
                              ? Text(
                                  'Customer',
                                  style: Theme.of(context).textTheme.headline5,
                                )
                              : Text(
                                  customerData.selectedCustomer!,
                                  style: Theme.of(context).textTheme.headline5,
                                ),
                          isExpanded: true,
                          iconSize: 30.0,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items: customerData.customers.map(
                            (val) {
                              return DropdownMenuItem<String>(
                                value: val.id.toString(),
                                child: Text(val.name!),
                              );
                            },
                          ).toList(),
                          onChanged: (val) {
                            print("the customer id $val");
                            customerData.currentCustomer(val);
                            editedLead = Lead(
                              title: editedLead.title,
                              customer: int.parse(val.toString()),
                              date: editedLead.date,
                              details: editedLead.details,
                              revenue: editedLead.revenue,
                              salesperson: editedLead.salesperson,
                              status: editedLead.status,
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    CustomTextField(
                      horizontalPadding: 27,
                      hintext: 'Revenue',
                      keyboardType: TextInputType.number,
                      focusNode: revenueNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(dateNode);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a tax.';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Please enter a valid number.';
                        }
                        if (int.parse(value) <= 0) {
                          return 'Please enter a number greater than zero.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        editedLead = Lead(
                          title: editedLead.title,
                          customer: editedLead.customer,
                          date: editedLead.date,
                          details: editedLead.details,
                          revenue: int.parse(value!),
                          salesperson: editedLead.salesperson,
                          status: editedLead.status,
                        );
                      },
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    CustomTextField(
                      horizontalPadding:
                          MediaQuery.of(context).size.width * 0.06,
                      hintext: 'Date',
                      controller: dateController,
                      readOnly: true,
                      keyboardType: TextInputType.datetime,
                      focusNode: dateNode,
                      onTap: () => _selectDate(context),
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(salesPersonNode);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please add a Date.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        editedLead = Lead(
                          title: editedLead.title,
                          customer: editedLead.customer,
                          date: DateTime.parse(value!),
                          details: editedLead.details,
                          revenue: editedLead.revenue,
                          salesperson: editedLead.salesperson,
                          status: editedLead.status,
                        );
                      },
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    CustomTextField(
                      horizontalPadding: 27,
                      hintext: 'Sales Person',
                      keyboardType: TextInputType.number,
                      focusNode: salesPersonNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(detailsNode);
                      },
                      // validator: (value) {
                      //   if (value!.isEmpty) {
                      //     return 'Please provide a value.';
                      //   }
                      //   return null;
                      // },
                      isSuffixIcon: true,
                      suffixIcon: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          hint: userData.selectedUser == null
                              ? Text(
                                  'Sales Person',
                                  style: Theme.of(context).textTheme.headline5,
                                )
                              : Text(
                                  userData.selectedUser!,
                                  style: Theme.of(context).textTheme.headline5,
                                ),
                          isExpanded: true,
                          iconSize: 30.0,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items: userData.users.map(
                            (val) {
                              return DropdownMenuItem<String>(
                                value: val.id.toString(),
                                child: Text(val.userName!),
                              );
                            },
                          ).toList(),
                          onChanged: (val) {
                            print("the user id $val");
                            userData.currentUser(val);
                            editedLead = Lead(
                              title: editedLead.title,
                              customer: editedLead.customer,
                              date: editedLead.date,
                              details: editedLead.details,
                              revenue: editedLead.revenue,
                              salesperson: int.parse(val.toString()),
                              status: editedLead.status,
                            );
                          },
                        ),
                      ),
                      // onSaved: (value) {
                      //   editedLead = Lead(
                      //     title: editedLead.title,
                      //     customer: editedLead.customer,
                      //     date: editedLead.date,
                      //     details: editedLead.details,
                      //     revenue: editedLead.revenue,
                      //     salesperson: int.parse(value!),
                      //     status: editedLead.status,
                      //   );
                      // },
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    CustomTextField(
                      horizontalPadding: 27,
                      hintext: 'Details',
                      keyboardType: TextInputType.name,
                      // controller: _imageUrlController,
                      focusNode: detailsNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(statusNode);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please provide a value.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        editedLead = Lead(
                          title: editedLead.title,
                          customer: editedLead.customer,
                          date: editedLead.date,
                          details: value,
                          revenue: editedLead.revenue,
                          salesperson: editedLead.salesperson,
                          status: editedLead.status,
                        );
                      },
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    CustomTextField(
                      horizontalPadding: 27,
                      hintext: 'Status',
                      textInputAction: TextInputAction.done,
                      // controller: _imageUrlController,
                      focusNode: statusNode,
                      onFieldSubmitted: (_) {
                        _saveForm();
                      },
                      // validator: (value) {
                      //   if (value!.isEmpty) {
                      //     return 'Please provide a value.';
                      //   }
                      //   return null;
                      // },
                      // onSaved: (value) {
                      //   editedLead = Lead(
                      //     title: editedLead.title,
                      //     customer: editedLead.customer,
                      //     date: editedLead.date,
                      //     details: editedLead.details,
                      //     revenue: editedLead.revenue,
                      //     salesperson: editedLead.salesperson,
                      //     status: value,
                      //   );
                      // },
                      isSuffixIcon: true,
                      suffixIcon: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          hint: currentStatus == null
                              ? Text(
                                  'Status',
                                  style: Theme.of(context).textTheme.headline5,
                                )
                              : Text(
                                  currentStatus!,
                                  style: Theme.of(context).textTheme.headline5,
                                ),
                          isExpanded: true,
                          iconSize: 30.0,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items: leadsData.status.map(
                            (val) {
                              return DropdownMenuItem<String>(
                                value: val,
                                child: Text(val),
                              );
                            },
                          ).toList(),
                          onChanged: (val) {
                            setState(() {
                              currentStatus = val.toString();
                            });

                            editedLead = Lead(
                              title: editedLead.title,
                              customer: editedLead.customer,
                              date: editedLead.date,
                              details: editedLead.details,
                              revenue: editedLead.revenue,
                              salesperson: editedLead.salesperson,
                              status: val.toString(),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CustomeButton(
                          butionText: "ADD",
                          buttonTopPadding: 25,
                          buttionColor: const Color(0xff2182BA),
                          onPressed: _saveForm,
                        ),
                        CustomeButton(
                          butionText: "CANCEL",
                          buttonTopPadding: 25,
                          buttionColor: const Color(0xff2182BA),
                          onPressed: () {
                            Navigator.of(context).pop();
                            Provider.of<CustomerProvider>(context,
                                    listen: false)
                                .selectedCustomer = null;
                            Provider.of<Users>(context, listen: false)
                                .selectedUser = null;
                          },
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 33,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _saveForm() async {
    final isValid = form.currentState!.validate();
    if (!isValid) {
      return;
    }
    form.currentState!.save();
    print(
        "title :${editedLead.title} customer : ${editedLead.customer} revenue :${editedLead.revenue} salesperson :${editedLead.salesperson} details :${editedLead.details} status :${editedLead.status}");
    try {
      await Provider.of<LeadsProvider>(context, listen: false)
          .addLead(context, editedLead);
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

    Navigator.of(context).pop();
    Provider.of<CustomerProvider>(context, listen: false).selectedCustomer =
        null;
    Provider.of<Users>(context, listen: false).selectedUser = null;
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2050));

    if (pickedDate != null) {
      print(pickedDate);
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      print(formattedDate);

      setState(() {
        dateController.text = formattedDate;
      });
    } else {
      print("Date is not selected");
    }
  }
}
