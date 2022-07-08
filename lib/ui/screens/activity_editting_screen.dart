import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/activity_model.dart';
import '../../provider/activity_provider.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_button.dart';
import '../widgets/edit_screen_textfields.dart';
import '../widgets/home_widget.dart';

class ActivityEdittingScreen extends StatefulWidget {
  const ActivityEdittingScreen({Key? key}) : super(key: key);

  @override
  _ActivityEdittingScreenState createState() => _ActivityEdittingScreenState();
}

class _ActivityEdittingScreenState extends State<ActivityEdittingScreen> {
  final form = GlobalKey<FormState>();
  TextEditingController dateinput = TextEditingController();
  DateTime currentDate = DateTime.now();

  @override
  void initState() {
    dateinput.text = '';
    super.initState();
  }

  var _edittedActivity = ActivityModel(
    id: 0,
    type: "",
    details: "",
    date: DateTime.parse("2022-01-22T15:04:05.000Z"),
    lead: 0,
  );

  var _initValues = {
    'Id': '',
    'Type': '',
    'Details': '',
    'Date': DateTime.parse("2022-01-22T15:04:05.000Z").toIso8601String(),
    'Lead': '',
  };

  var isInIt = true;
  var inputFormat = DateFormat('dd/MM/yyyy');

  @override
  void didChangeDependencies() {
    if (isInIt) {
      var cstmrId = ModalRoute.of(context)?.settings.arguments as int?;
      print('didchange id......$cstmrId');
      if (cstmrId != null) {
        _edittedActivity = Provider.of<ActivityProvider>(context, listen: false)
            .findById(cstmrId);
        _initValues = {
          'Type': _edittedActivity.type!,
          'Details': _edittedActivity.details!,
          // 'Date': DateFormat.yMd().format((_edittedActivity.date!)),
          'Lead': _edittedActivity.lead.toString(),
        };
        dateinput.text =
            DateFormat('yyyy-MM-dd').format(_edittedActivity.date!);
      }
    }
    isInIt = false;
    super.didChangeDependencies();
  }

  var _dropDownValue;
  var types = ['Meeting', 'PhoneCall', "E-mail", "Direct Meeting"];

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
                        Row(
                          children: [
                            Text('Type',
                                style: Theme.of(context).textTheme.headline2),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .21,
                            ),
                            Container(
                              padding: EdgeInsets.all(
                                  MediaQuery.of(context).size.height * 0.01),
                              width: MediaQuery.of(context).size.width * .45,
                              height: MediaQuery.of(context).size.width * .1,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all()),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  hint: _dropDownValue == null
                                      ? Text('${_initValues['Type']}')
                                      : Text(_dropDownValue,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline2),
                                  isExpanded: true,
                                  iconSize:
                                      MediaQuery.of(context).size.height * 0.03,
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
                                    _edittedActivity = ActivityModel(
                                      type: val.toString(),
                                      details: _edittedActivity.details,
                                      date: _edittedActivity.date,
                                      lead: _edittedActivity.lead,
                                      id: _edittedActivity.id,
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03),
                        EditScreentextFields(
                            controller: dateinput,
                            // initialValue: _initValues['Date'],
                            title: "Date",
                            onTap: () {
                              _selectDate(context);
                            },
                            onSaved: (value) {
                              _edittedActivity = ActivityModel(
                                type: _edittedActivity.type,
                                details: _edittedActivity.details,
                                date: DateTime.parse(value!),
                                lead: _edittedActivity.lead,
                                id: _edittedActivity.id,
                              );
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please add a Date.';
                              }
                              return null;
                            }),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03),
                        EditScreentextFields(
                            initialValue: _initValues['Details'],
                            title: "Details",
                            onSaved: (value) {
                              _edittedActivity = ActivityModel(
                                type: _edittedActivity.type,
                                details: value,
                                date: _edittedActivity.date,
                                lead: _edittedActivity.lead,
                                id: _edittedActivity.id,
                              );
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please add a Details.';
                              }
                              return null;
                            }),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.06),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomeButton(
                    butionText: "SAVE",
                    buttonTopPadding: MediaQuery.of(context).size.width * 0.06,
                    buttionColor: const Color(0xff2182BA),
                    onPressed: () {
                      saveFormEditting();
                      Navigator.of(context).pop();
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

  Future<void> saveFormEditting() async {
    print("activity id${_edittedActivity.id}");
    final isValid = form.currentState?.validate();
    if (!isValid!) {
      return;
    }
    form.currentState?.save();
    //  setState(() {
    //   _isLoading = true;
    // });
    Provider.of<ActivityProvider>(context, listen: false)
        .updateActivity(context, _edittedActivity.id, _edittedActivity);
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
        dateinput.text = formattedDate;
      });
    } else {
      print("Date is not selected");
    }
  }
}
