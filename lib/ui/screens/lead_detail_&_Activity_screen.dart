import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/activity_provider.dart';
import '../../provider/customer_provider.dart';
import '../../provider/leads_provider.dart';
import '../../provider/users.dart';
import '../../utils/routes.dart';
import '../widgets/activity_list.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_button.dart';
import '../widgets/lead_details_widget.dart';
import 'activity_adding_screen.dart';

class leadDetailScreen extends StatefulWidget {
  void Function()? onTap;
  void Function()? onPresseddelete;
  final int? id;
  final String? title;
  final int? customer;
  final int? revenue;
  final int? salesperson;
  final String? details;
  final String? status;

  leadDetailScreen({
    this.onPresseddelete,
    this.id,
    this.title,
    this.customer,
    this.revenue,
    this.salesperson,
    this.details,
    this.status,
    this.onTap,
  });

  @override
  State<leadDetailScreen> createState() => _leadDetailScreenState();
}

class _leadDetailScreenState extends State<leadDetailScreen> {
  bool activity = true;
  bool addActivityButtion = false;
  int detailsSelected = 1;
  int activitySelected = -1;
  var customerName = '';
  var userName = '';
  @override
  void initState() {
    Provider.of<ActivityProvider>(context, listen: false)
        .fetchAndSetActivity(context);
    customerName = Provider.of<CustomerProvider>(context, listen: false)
        .findNameById(widget.customer);
    userName = Provider.of<Users>(context, listen: false)
        .findNameById(widget.salesperson);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final customerData = Provider.of<CustomerProvider>(context);
    final userData = Provider.of<Users>(context);
    final leads = Provider.of<LeadsProvider>(context);
    return Scaffold(
      appBar: CustomAppBar('Details', actionButton: const [
        Padding(
          padding: EdgeInsets.only(right: 8),
        ),
      ]),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            addActivityButtion
                ? Padding(
                    padding: const EdgeInsets.only(left: 230),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ActivityAddingScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "ADD ACTIVITY",
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                  )
                : Container(),
            Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * 0.1),
              child: LeadDetailsdWidget(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              activity = true;
                              addActivityButtion = false;
                              detailsSelected = 1;
                              activitySelected = 1;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(18),
                            height: 60,
                            width: MediaQuery.of(context).size.width * 0.44,
                            child: Text(
                              'Details',
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: detailsSelected == 1
                                      ? Colors.white
                                      : Color.fromARGB(255, 21, 90, 146)),
                            ),
                            decoration: BoxDecoration(
                              color: detailsSelected == 1
                                  ? Color.fromARGB(255, 21, 90, 146)
                                  : Colors.white,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),

                                bottomRight: Radius.circular(20),
                                // bottomRight: Radius.circular(20),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              print('activity btn pressed ......');
                              activity = false;
                              addActivityButtion = true;
                              activitySelected = 0;
                              detailsSelected = 0;
                              print(activity);
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(18),
                            height: 60,
                            width: MediaQuery.of(context).size.width * 0.44,
                            child: Text(
                              'Activity',
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: activitySelected == 0
                                      ? Colors.white
                                      : Color.fromARGB(255, 21, 90, 146)),
                            ),
                            decoration: BoxDecoration(
                                color: activitySelected == 0
                                    ? Color.fromARGB(255, 21, 90, 146)
                                    : Colors.white,
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  bottomLeft: Radius.circular(20),
                                )),
                          ),
                        ),
                      ],
                    ),
                    // Text("${leads.items[widget.id!].title}",
                    //     style: const TextStyle(
                    //         fontSize: 20, fontWeight: FontWeight.bold)),
                    activity
                        ? Padding(
                            padding: const EdgeInsets.only(top: 40, right: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(padding: EdgeInsets.only(left: 30)),
                                    Text("₹${widget.revenue}",
                                        style: TextStyle(
                                            fontSize: 25, color: Colors.white)),
                                  ],
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(padding: EdgeInsets.only(left: 30)),
                                    Text(
                                      "Title                :",
                                      style:
                                          Theme.of(context).textTheme.headline4,
                                    ),
                                    Expanded(
                                      child: Text(
                                        widget.title!,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline4,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(padding: EdgeInsets.only(left: 30)),
                                    Text(
                                      "Customer       :",
                                      style:
                                          Theme.of(context).textTheme.headline4,
                                    ),
                                    Expanded(
                                      child: Text(
                                        customerName,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline4,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(padding: EdgeInsets.only(left: 30)),
                                    Text(
                                      "Salesperson  :",
                                      style:
                                          Theme.of(context).textTheme.headline4,
                                    ),
                                    Expanded(
                                      child: Text(
                                        userName,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline4,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(padding: EdgeInsets.only(left: 30)),
                                    Text(
                                      "Details            :",
                                      style:
                                          Theme.of(context).textTheme.headline4,
                                    ),
                                    Expanded(
                                      child: Text(
                                        widget.details!,
                                        maxLines: 6,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline4,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    // Padding(padding: EdgeInsets.only(top: 270)),
                                    CustomeButton(
                                      butionText: "DELETE",
                                      buttonTopPadding: 25,
                                      buttionColor: const Color(0xff2182BA),
                                      onPressed: () => {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            // borderRadius:
                                            // BorderRadius.all(Radius.zero);
                                            return AlertDialog(
                                              title: Column(
                                                children: [
                                                  const Icon(
                                                    Icons.delete,
                                                    size: 80,
                                                    color: Colors.red,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: const [
                                                      Text(
                                                        'Are You Sure?',
                                                        style: TextStyle(
                                                            fontSize: 25),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              content: const Text(
                                                "Are you sure you want to delete this file? you can't undo this actions.",
                                                textAlign: TextAlign.center,
                                              ),
                                              actions: <Widget>[
                                                Column(
                                                  children: [
                                                    ElevatedButton(
                                                      // onPressed: () {
                                                      //   // print(
                                                      //   //     "button is ctive");
                                                      //   widget.onPresseddelete;
                                                      // },
                                                      onPressed: () async {
                                                        try {
                                                          await {
                                                            Provider.of<LeadsProvider>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .deleteLead(
                                                                    context,
                                                                    widget.id!),
                                                            await Provider.of<
                                                                        LeadsProvider>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .fetchAndSetleads(
                                                                    context),
                                                            Navigator.pushNamed(
                                                                context,
                                                                Routes
                                                                    .routeLeadsScreen)
                                                          };
                                                        } catch (error) {
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            SnackBar(
                                                              content:
                                                                  const Text(
                                                                "Deleting failed!",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              ),
                                                              backgroundColor:
                                                                  Theme.of(
                                                                          context)
                                                                      .errorColor,
                                                              duration:
                                                                  const Duration(
                                                                      seconds:
                                                                          2),
                                                            ),
                                                          );
                                                        }
                                                      },
                                                      child: const Text(
                                                        'Delete',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      style: ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all(
                                                                    Colors.red),
                                                      ),
                                                    ),
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: const Text(
                                                          'Cancel',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black),
                                                        )),
                                                  ],
                                                ),
                                              ],
                                              actionsAlignment:
                                                  MainAxisAlignment.center,
                                            );
                                          },
                                        ),
                                      },
                                    ),
                                    CustomeButton(
                                      butionText: "EDIT",
                                      buttonTopPadding: 25,
                                      buttionColor: Colors.white,
                                      onPressed: () {
                                        Navigator.pushNamed(context,
                                            Routes.routeLeadsEditingScreen,
                                            arguments: widget.id);
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        : ActivityList2(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
