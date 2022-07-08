import 'package:business_manager/ui/widgets/pop_up_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/activity_model.dart';
import '../../provider/activity_provider.dart';
import '../../utils/color_constants.dart';
import '../../utils/routes.dart';
import 'custom_button.dart';
import 'details_text.dart';
import 'home_card.dart';

class ActivityItem2 extends StatelessWidget {
  final int? id;
  final String? type;
  String? details;
  DateTime? date;
  int? lead;

  ActivityItem2(this.id, this.type, this.details, this.date, this.lead,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final activity = Provider.of<ActivityModel>(context, listen: false);
    final scaffold = Scaffold.of(context);
    var inputFormat = DateFormat('dd/MM/yyyy');

    return Column(
      children: [
        HomeCard(
          childs: Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.025),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.02,
                      right: MediaQuery.of(context).size.width * 0.025),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Type :',
                        style: Theme.of(context).textTheme.headline2,
                      ),
                      Text(
                        '${activity.type}',
                        style: Theme.of(context).textTheme.headline2,
                      ),
                      Text(
                        inputFormat.format(
                          (activity.date!),
                        ),
                        style: Theme.of(context).textTheme.headline2,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.02,
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.02),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          'Details : ${activity.details}',
                          style: Theme.of(context).textTheme.headline2,
                          softWrap: false,
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          onPressededit: (_) {
            Navigator.of(context)
                .pushNamed(Routes.routeActivityEdittingScreen, arguments: id);

            print('object id.....${id}');
          },
          onPresseddelete: () async {
            try {
              await {
                Provider.of<ActivityProvider>(context, listen: false)
                    .deleteActivity(context, id!),
                Navigator.of(context).pop(),
              };
            } catch (error) {
              scaffold.showSnackBar(
                const SnackBar(
                  content: Text(
                    'Deleting failed!',
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }
          },
          visiblEdit: true,
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return FittedBox(
                  child: PopUpCard(
                    padding: false,
                    childern: [
                      Container(
                        height: MediaQuery.of(context).size.width * 0.18,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: ColorConstants.backGroundColor,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(
                                    MediaQuery.of(context).size.height * 0.025),
                                topRight: Radius.circular(
                                    MediaQuery.of(context).size.height *
                                        0.025))),
                      ),
                      Padding(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width * 0.1),
                        child: Column(
                          children: [
                            RowText(
                                keyText: 'Type             ',
                                valueText: '$type'),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.width * 0.07),
                            RowText(
                                keyText: 'Date             ',
                                valueText: inputFormat.format(date!)),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.width * 0.07),
                            SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: RowText(
                                keyText: 'Details         ',
                                valueText: '$details',
                              ),
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.width * 0.07),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                CustomeButton(
                                  butionText: 'OK',
                                  buttionColor: ColorConstants.backGroundColor,
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                CustomeButton(
                                  needicon: true,
                                  icons: Icons.edit,
                                  butionText: 'EDIT',
                                  buttionColor: ColorConstants.backGroundColor,
                                  onPressed: () {
                                    Navigator.of(context).pushNamed(
                                      Routes.routeActivityEdittingScreen,
                                      arguments: id,
                                    );
                                  },
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
