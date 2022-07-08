import 'package:business_manager/ui/widgets/custom_button.dart';
import 'package:business_manager/ui/widgets/home_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../models/user_model.dart';
import '../../provider/users.dart';
import '../../utils/routes.dart';

class UserItem extends StatelessWidget {
  dynamic id;
  final String? userName;
  final String? password;
  final String? role;
  final String? emailId;
  final String? status;
  final String? mobile;

  UserItem(
    this.id,
    this.userName,
    this.password,
    this.role,
    this.emailId,
    this.status,
    this.mobile,
  );

  @override
  Widget build(BuildContext context) {
    final users = Provider.of<User>(context, listen: false);
    final scaffold = Scaffold.of(context);

    return Column(children: [
      HomeCard(
        childs: Padding(
          padding: const EdgeInsets.all(13.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "UserName :",
                    style: Theme.of(context).textTheme.headline2,
                  ),
                  Expanded(
                    child: Text(
                      users.userName!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.headline2,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Role :',
                      style: Theme.of(context).textTheme.headline2,
                    ),
                    Expanded(
                      child: Text(
                        users.role!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.headline2,
                      ),
                    ),
                    Text(
                      'status : Active',
                      style: Theme.of(context).textTheme.headline2,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        onPressededit: (ctx) {
          print('edit button pressed');
          Navigator.of(context)
              .pushNamed(Routes.routeUserEdittingScreen, arguments: id);
        },
        onPresseddelete: () async {
          try {
            await {
              Provider.of<Users>(context, listen: false)
                  .deleteUser(context, id!),
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
        onTap: () {
          _showAboutDialog(context, users.userName, users.status, users.role,
              users.password, users.mobile, users.emailId);
        },
      )
    ]);
  }
}

void _showAboutDialog(
  BuildContext? context,
  String? userName,
  String? password,
  String? role,
  String? status,
  String? mobile,
  String? emailId,
) {
  showDialog(
      context: context!,
      builder: (context) {
        return Dialog(
            //shape:
            // RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
            // elevation: 16,
            child: SizedBox(
          height: MediaQuery.of(context).size.height * .5,
          width: MediaQuery.of(context).size.width * 7,
          child: SingleChildScrollView(
              child: Column(
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 18, right: 18, bottom: 10, top: 18),
                  child: Center(
                    child: Text(
                      "DETAILS",
                      style: Theme.of(context).textTheme.headline3,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "UserName :",
                              style: Theme.of(context).textTheme.headline2,
                            ),
                            Expanded(
                              child: Text(
                                "$userName",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.headline2,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 13,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Role            :",
                              style: Theme.of(context).textTheme.headline2,
                            ),
                            Expanded(
                              child: Text(
                                role!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.headline2,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 13,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Mobile        ",
                              style: Theme.of(context).textTheme.headline2,
                            ),
                            // SizedBox(
                            //   width: 32,
                            // ),
                            Text(
                              ":",
                              style: Theme.of(context).textTheme.headline2,
                            ),
                            Text(
                              "$mobile",
                              style: Theme.of(context).textTheme.headline2,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 13,
                        ),
                        Row(mainAxisAlignment: MainAxisAlignment.start,
                            // crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "EmailId      :",
                                style: Theme.of(context).textTheme.headline2,
                              ),
                              Expanded(
                                child: Text(
                                  emailId!,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.headline2,
                                ),
                              ),
                            ]),
                        Center(
                          child: CustomeButton(
                            butionText: "close",
                            buttonTopPadding: 20,
                            buttionColor: const Color(0xff2182BA),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      ]),
                )
              ])),
        ));
      });
}
