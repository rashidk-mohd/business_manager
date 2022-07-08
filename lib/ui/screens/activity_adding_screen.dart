import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/activity_model.dart';
import '../../provider/activity_provider.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/home_widget.dart';

class ActivityAddingScreen extends StatefulWidget {
  const ActivityAddingScreen({Key? key}) : super(key: key);

  @override
  State<ActivityAddingScreen> createState() => _ActivityAddingScreenState();
}

class _ActivityAddingScreenState extends State<ActivityAddingScreen> {
  TextEditingController dateinput = TextEditingController();
  final form = GlobalKey<FormState>();
  DateTime currentDate = DateTime.now();
  final detailsFocusNode = FocusNode();
  final dateFocusNode = FocusNode();

  @override
  void initState() {
    dateinput.text = '';
    super.initState();
  }

  var addedActivity = ActivityModel(
    id: 0,
    type: "",
    details: "",
    date: DateTime.parse("2022-01-22T15:04:05.000Z"),
    lead: 0,
  );
  var _dropDownValue;
  var types = ['Meeting', 'PhoneCall', "E-mail", "Direct Meeting"];
  var inputFormat = DateFormat('dd/MM/yyyy');

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
                        Padding(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.height * 0.025),
                          child: Row(
                            children: [
                              Text(
                                'Type',
                                style: Theme.of(context).textTheme.headline2,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * .09,
                              ),
                              Container(
                                padding: EdgeInsets.all(
                                    MediaQuery.of(context).size.height * 0.01),
                                width: MediaQuery.of(context).size.width * .45,
                                height: MediaQuery.of(context).size.width * .1,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        MediaQuery.of(context).size.height *
                                            0.025),
                                    border: Border.all()),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                    hint: _dropDownValue == null
                                        ? Text(
                                            'Dropdown',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline5,
                                          )
                                        : Text(
                                            _dropDownValue,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline5,
                                          ),
                                    isExpanded: true,
                                    iconSize:
                                        MediaQuery.of(context).size.height *
                                            0.03,
                                    icon: const Icon(Icons.keyboard_arrow_down),
                                    items: [
                                      'Meeting',
                                      'Phone Call',
                                      'E-mail',
                                      'Direct Meeting'
                                    ].map(
                                      (val) {
                                        return DropdownMenuItem<String>(
                                          value: val,
                                          child: Text(val),
                                        );
                                      },
                                    ).toList(),
                                    onChanged: (val) {
                                      setState(
                                        () {
                                          _dropDownValue = val;
                                        },
                                      );

                                      addedActivity = ActivityModel(
                                        id: addedActivity.id,
                                        type: val.toString(),
                                        details: addedActivity.details,
                                        date: addedActivity.date,
                                        lead: addedActivity.lead,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        CustomTextField(
                            icon: const Icon(
                              Icons.list,
                            ),
                            horizontalPadding:
                                MediaQuery.of(context).size.width * 0.06,
                            hintext: 'Details',
                            onSaved: (value) {
                              addedActivity = ActivityModel(
                                id: addedActivity.id,
                                type: addedActivity.type,
                                details: value,
                                date: addedActivity.date,
                                lead: addedActivity.lead,
                              );
                            },
                            focusNode: detailsFocusNode,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(dateFocusNode);
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please add activity details.';
                              }
                              return null;
                            }),
                        CustomTextField(
                            icon: const Icon(Icons.calendar_today),
                            controller: dateinput,
                            readOnly: true,
                            horizontalPadding:
                                MediaQuery.of(context).size.width * 0.06,
                            hintext: 'Date',
                            keyboardType: TextInputType.datetime,
                            onTap: () => _selectDate(context),
                            onSaved: (value) {
                              addedActivity = ActivityModel(
                                id: addedActivity.id,
                                type: addedActivity.type,
                                details: addedActivity.details,
                                date: DateTime.parse(value!),
                                lead: addedActivity.lead,
                              );
                              print("date  ...${value}");
                            },
                            focusNode: dateFocusNode,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please add a date.';
                              }
                              return null;
                            }),
                        // SizedBox(
                        //   height: MediaQuery.of(context).size.height * 0.1,
                        // ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomeButton(
                      butionText: "ADD",
                      buttonTopPadding:
                          MediaQuery.of(context).size.width * 0.05,
                      buttionColor: const Color(0xff2182BA),
                      onPressed: () {
                        saveForm();
                      },
                    ),
                    CustomeButton(
                      butionText: "CANCEL",
                      buttonTopPadding:
                          MediaQuery.of(context).size.width * 0.05,
                      buttionColor: const Color(0xff2182BA),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
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

    Provider.of<ActivityProvider>(context, listen: false)
        .addActivity(context, addedActivity);

    Navigator.of(context).pop();
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
        dateinput.text = formattedDate;
      });
    } else {
      print("Date is not selected");
    }
  }
}
