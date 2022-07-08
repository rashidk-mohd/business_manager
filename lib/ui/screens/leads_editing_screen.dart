import 'package:business_manager/ui/widgets/custom_appbar.dart';
import 'package:business_manager/ui/widgets/home_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/leads_model.dart';
import '../../provider/customer_provider.dart';
import '../../provider/leads_provider.dart';
import '../../provider/users.dart';
import '../../utils/routes.dart';
import '../widgets/custom_button.dart';
import '../widgets/edit_screen_textfields.dart';

class LeadsEditingScreens extends StatefulWidget {
  const LeadsEditingScreens({Key? key}) : super(key: key);

  @override
  _LeadsEditingScreensState createState() => _LeadsEditingScreensState();
}

class _LeadsEditingScreensState extends State<LeadsEditingScreens> {
  final form = GlobalKey<FormState>();
  TextEditingController dateController = TextEditingController();
  DateTime currentDate = DateTime.now();
  var inputFormat = DateFormat('dd/MM/yyyy');
  final customerNode = FocusNode();
  final revenueNode = FocusNode();
  final dateNode = FocusNode();
  final salesPersonNode = FocusNode();
  final detailsNode = FocusNode();
  final statusNode = FocusNode();
  String? currentStatus;
  @override
  void initState() {
    dateController.text = '';
    Future.delayed(Duration.zero).then(
      (_) {
        Provider.of<CustomerProvider>(context, listen: false)
            .fetchAndSetCustomers(context);

        Provider.of<Users>(context, listen: false).fetchAndSetUsers(context);
      },
    );
    super.initState();
  }

  var edittedLead = Lead(
      id: 0,
      title: "",
      customer: 0,
      date: DateTime.parse("2022-01-22T15:04:05.000Z"),
      //date: DateTime.now(),
      revenue: 0,
      salesperson: 0,
      details: "",
      status: "");

  var _initValues = {
    'Title': '',
    'Customer': '',
    'Date': DateTime.parse("2022-01-22T15:04:05.000Z").toIso8601String(),
    'Revenue': '',
    'Salesperson': '',
    'Details': '',
    'Status': ''
  };
  var customerName = '';
  var userName = '';

  var isInit = true;
  @override
  void didChangeDependencies() async {
    if (isInit) {
      var leadId = ModalRoute.of(context)?.settings.arguments as int?;
      print("here is the customer id $leadId");

      if (leadId != null) {
        edittedLead =
            Provider.of<LeadsProvider>(context, listen: false).findById(leadId);

        _initValues = {
          'Title': edittedLead.title!,
          'Customer': edittedLead.customer.toString(),
          'Revenue': edittedLead.revenue.toString(),
          'Salesperson': edittedLead.salesperson.toString(),
          'Details': edittedLead.details!,
          'Status': edittedLead.status!
        };
        // customerDetail = Provider.of<CustomerProvider>(context, listen: false)
        //     .findById(edittedLead.customer!);
        customerName = Provider.of<CustomerProvider>(context, listen: false)
            .findNameById(edittedLead.customer!);
        userName = Provider.of<Users>(context, listen: false)
            .findNameById(edittedLead.salesperson!);
        dateController.text =
            DateFormat('yyyy-MM-dd').format(edittedLead.date!);
      }
    }
    isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final customerData = Provider.of<CustomerProvider>(context);
    final userData = Provider.of<Users>(context);
    final leadsData = Provider.of<LeadsProvider>(context);
    return Scaffold(
      appBar: CustomAppBar(
        "Lead Editing Screen",
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
        child: Form(
          key: form,
          child: ListView(
            children: [
              Column(
                children: [
                  EditScreentextFields(
                      initialValue: _initValues["Title"],
                      title: "Title",
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(customerNode);
                      },
                      onSaved: (value) {
                        edittedLead = Lead(
                            title: value,
                            customer: edittedLead.customer,
                            date: edittedLead.date,
                            revenue: edittedLead.revenue,
                            salesperson: edittedLead.salesperson,
                            details: edittedLead.details,
                            status: edittedLead.status,
                            id: edittedLead.id);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please add a name.';
                        }
                        return null;
                      }),
                  const SizedBox(
                    height: 12,
                  ),
                  EditScreentextFields(
                    // initialValue: _initValues["Customer"],
                    title: "Customer",
                    focusNode: customerNode,

                    // onSaved: (value) {
                    //   edittedLead = Lead(
                    //       title: edittedLead.title,
                    //       customer: int.parse(value!),
                    //       date: edittedLead.date,
                    //       revenue: edittedLead.revenue,
                    //       salesperson: edittedLead.salesperson,
                    //       details: edittedLead.details,
                    //       status: edittedLead.status,
                    //       id: edittedLead.id);
                    // },
                    isSuffixIcon: true,
                    suffixIcon: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        hint: customerData.selectedCustomer == null
                            ? Padding(
                                padding: const EdgeInsets.only(left: 6),
                                child: Text(
                                  customerName,
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.only(left: 6),
                                child: Text(
                                  customerData.selectedCustomer!,
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
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
                          edittedLead = Lead(
                              title: edittedLead.title,
                              customer: int.parse(val.toString()),
                              date: edittedLead.date,
                              details: edittedLead.details,
                              revenue: edittedLead.revenue,
                              salesperson: edittedLead.salesperson,
                              status: edittedLead.status,
                              id: edittedLead.id);
                        },
                      ),
                    ),
                    // validator: (value) {
                    //   if (value!.isEmpty) {
                    //     return 'Please add a name.';
                    //   }
                    //   return null;
                    // }
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  EditScreentextFields(
                      initialValue: _initValues["Revenue"],
                      title: "Revenue",
                      focusNode: revenueNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(dateNode);
                      },
                      onSaved: (value) {
                        edittedLead = Lead(
                            title: edittedLead.title,
                            customer: edittedLead.customer,
                            date: edittedLead.date,
                            revenue: int.parse(value!),
                            salesperson: edittedLead.salesperson,
                            details: edittedLead.details,
                            status: edittedLead.status,
                            id: edittedLead.id);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please add a name.';
                        }
                        return null;
                      }),
                  const SizedBox(
                    height: 12,
                  ),
                  EditScreentextFields(
                    title: 'Date',
                    focusNode: dateNode,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(salesPersonNode);
                    },
                    keyboardType: TextInputType.datetime,
                    controller: dateController,
                    // onFieldSubmitted: (_) {
                    //   FocusScope.of(context)
                    //       .requestFocus(salesPersonNode);
                    // },
                    onTap: () => _selectDate(context),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please add a Date.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      edittedLead = Lead(
                          title: edittedLead.title,
                          customer: edittedLead.customer,
                          date: DateTime.parse(value!),
                          details: edittedLead.details,
                          revenue: edittedLead.revenue,
                          salesperson: edittedLead.salesperson,
                          status: edittedLead.status,
                          id: edittedLead.id);
                    },
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  EditScreentextFields(
                    initialValue: _initValues["Salesperson"],
                    title: "Salesperson",
                    focusNode: salesPersonNode,
                    // onSaved: (value) {
                    //   edittedLead = Lead(
                    //       title: edittedLead.title,
                    //       customer: int.parse(value!),
                    //       date: edittedLead.date,
                    //       revenue: edittedLead.revenue,
                    //       salesperson: edittedLead.salesperson,
                    //       details: edittedLead.details,
                    //       status: edittedLead.status,
                    //       id: edittedLead.id);
                    // },
                    isSuffixIcon: true,
                    suffixIcon: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        hint: userData.selectedUser == null
                            ? Padding(
                                padding: const EdgeInsets.only(left: 6),
                                child: Text(
                                  userName,
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.only(left: 6),
                                child: Text(
                                  userData.selectedUser!,
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
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
                          print("the sale id $val");
                          userData.currentUser(val);
                          edittedLead = Lead(
                              title: edittedLead.title,
                              customer: int.parse(val.toString()),
                              date: edittedLead.date,
                              details: edittedLead.details,
                              revenue: edittedLead.revenue,
                              salesperson: edittedLead.salesperson,
                              status: edittedLead.status,
                              id: edittedLead.id);
                        },
                      ),
                    ),
                    // validator: (value) {
                    //   if (value!.isEmpty) {
                    //     return 'Please add a.';
                    //   }
                    //   return null;
                    // }
                  ),
                  // EditScreentextFields(
                  //     initialValue: _initValues["Salesperson"],
                  //     title: "Sales Person",
                  //     onSaved: (value) {
                  //       edittedLead = Lead(
                  //           title: edittedLead.title,
                  //           customer: edittedLead.customer,
                  //           date: edittedLead.date,
                  //           revenue: edittedLead.revenue,
                  //           salesperson: int.parse(value!),
                  //           details: edittedLead.details,
                  //           status: edittedLead.status,
                  //           id: edittedLead.id);
                  //     },
                  //     validator: (value) {
                  //       if (value!.isEmpty) {
                  //         return 'Please add a name.';
                  //       }
                  //       return null;
                  //     }),
                  const SizedBox(
                    height: 12,
                  ),
                  EditScreentextFields(
                      initialValue: _initValues["Details"],
                      title: "Details",
                      focusNode: detailsNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(statusNode);
                      },
                      onSaved: (value) {
                        edittedLead = Lead(
                            title: edittedLead.title,
                            customer: edittedLead.customer,
                            date: edittedLead.date,
                            revenue: edittedLead.revenue,
                            salesperson: edittedLead.salesperson,
                            details: value,
                            status: edittedLead.status,
                            id: edittedLead.id);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please add a name.';
                        }
                        return null;
                      }),
                  const SizedBox(
                    height: 12,
                  ),
                  EditScreentextFields(
                    initialValue: _initValues["Status"],
                    title: "Status",
                    focusNode: statusNode,
                    // onSaved: (value) {
                    //   edittedLead = Lead(
                    //       title: edittedLead.title,
                    //       customer: edittedLead.customer,
                    //       date: edittedLead.date,
                    //       revenue: edittedLead.revenue,
                    //       salesperson: edittedLead.salesperson,
                    //       details: edittedLead.details,
                    //       status: value,
                    //       id: edittedLead.id);
                    // },
                    // validator: (value) {
                    //   if (value!.isEmpty) {
                    //     return 'Please add a name.';
                    //   }
                    //   return null;
                    // },
                    isSuffixIcon: true,
                    suffixIcon: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        hint: currentStatus == null
                            ? Padding(
                                padding: const EdgeInsets.only(left: 6),
                                child: Text(
                                  "${_initValues["Status"]}",
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.only(left: 6),
                                child: Text(
                                  currentStatus!,
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
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

                          edittedLead = Lead(
                              title: edittedLead.title,
                              customer: edittedLead.customer,
                              date: edittedLead.date,
                              details: edittedLead.details,
                              revenue: edittedLead.revenue,
                              salesperson: edittedLead.salesperson,
                              status: val.toString(),
                              id: edittedLead.id);
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomeButton(
                        butionText: "SAVE",
                        buttonTopPadding: 25,
                        buttionColor: const Color(0xff2182BA),
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(context,
                              Routes.routeLeadsScreen, (route) => false);
                          saveFormEditting();

                          //Navigator.of(context).pushNamed(Routes.homeScreen);
                        },
                      ),
                      CustomeButton(
                        butionText: "CANCEL",
                        buttonTopPadding: 25,
                        buttionColor: const Color(0xff2182BA),
                        onPressed: () {
                          Navigator.of(context).pop();
                          Provider.of<CustomerProvider>(context, listen: false)
                              .selectedCustomer = null;
                          Provider.of<Users>(context, listen: false)
                              .selectedUser = null;
                        },
                      ),
                    ],
                  ),
                ],
              ),
              // Column(
              //   mainAxisAlignment: MainAxisAlignment.end,
              //   children: [
              //     Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //       children: [
              //         CustomeButton(
              //           butionText: "ADD",
              //           buttonTopPadding: 25,
              //           buttionColor: const Color(0xff2182BA),
              //           onPressed: _saveForm,
              //         ),
              //         CustomeButton(
              //           butionText: "CANCEL",
              //           buttonTopPadding: 25,
              //           buttionColor: const Color(0xff2182BA),
              //           onPressed: () {
              //             Navigator.of(context).pop();
              //           },
              //         ),
              //       ],
              //     ),
              //     SizedBox(
              //       height: 33,
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2050));
    // if (pickedDate != null && pickedDate != currentDate) {
    //   setState(() {
    //     currentDate = pickedDate;
    //   });
    // }
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

  Future<void> saveFormEditting() async {
    print("lead id is ${edittedLead.id}");
    final isValid = form.currentState?.validate();
    if (!isValid!) {
      return;
    }
    form.currentState?.save();
    //  setState(() {
    //   _isLoading = true;
    // });
    await Provider.of<LeadsProvider>(context, listen: false)
        .updateLead(context, edittedLead.id, edittedLead);
    Future.delayed(Duration(milliseconds: 20), () {
      Provider.of<CustomerProvider>(context, listen: false).selectedCustomer =
          null;
      Provider.of<Users>(context, listen: false).selectedUser = null;
    });

    // Navigator.of(context).pushReplacementNamed(Routes.routeLeadsScreen);
  }
}
