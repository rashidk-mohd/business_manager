import 'package:business_manager/ui/widgets/pop_up_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../provider/customer_provider.dart';
import '../../utils/routes.dart';
import 'custom_button.dart';
import 'details_text.dart';
import 'home_card.dart';

class CustomerItem extends StatelessWidget {
  final int id;
  final String? name;
  final String? company;
  final String? address;
  final String? email;
  final String? mobile;
  // int? createdBy;
  // DateTime createdOn;
  // String? lastEditedBy;
  // DateTime lastEditedOn;

  CustomerItem(
    this.id,
    this.name,
    this.company,
    this.address,
    this.email,
    this.mobile,
    // this.createdBy,
    // this.createdOn,
    // this.lastEditedBy,
    // this.lastEditedOn,
  );

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return InkWell(
      highlightColor: Colors.red,
      child: HomeCard(
        childs: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.01,
                  left: MediaQuery.of(context).size.height * 0.01),
              child: Row(children: [
                Text(
                  "User Name  : ",
                  style: Theme.of(context).textTheme.headline2,
                ),
                Expanded(
                  child: Text(
                    name!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headline2,
                  ),
                ),
              ]),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.height * 0.01,
                  top: MediaQuery.of(context).size.height * 0.015),
              child: Row(
                children: [
                  Text(
                    "Status  : ",
                    style: Theme.of(context).textTheme.headline2,
                  ),
                  Text(
                    "Active  ",
                    style: Theme.of(context).textTheme.headline2,
                  ),
                ],
              ),
            )
          ],
        ),
        onPressededit: (_) {
          Navigator.of(context)
              .pushNamed(Routes.routeCustomerEdittingScreen, arguments: id);

          print('object id.....${id}');
        },
        onPresseddelete: () async {
          try {
            await {
              Provider.of<CustomerProvider>(context, listen: false)
                  .deleteCustomer(context, id),
              Navigator.of(context).pop(),
            };
          } catch (error) {
            scaffold.showSnackBar(
              const SnackBar(
                content: Text(
                  'Deleting faild',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
        },
        // onPresseddelete: () {
        //   Provider.of<CustomerProvider>(context, listen: false)
        //       .deleteCustomer(id!);

        //   Navigator.of(context).pop();
        // },
      ),
      onTap: () {
        showDialog(
            context: context,
            builder: (context) {
              return PopUpCard(
                childern: [
                  RowText(
                    keyText: "ID                          :  ",
                    valueText: "$id",
                  ),
                  RowText(
                    keyText: "Name                   :  ",
                    valueText: "$name",
                  ),
                  RowText(
                    keyText: "Company             :  ",
                    valueText: "$company",
                  ),
                  RowText(
                    keyText: "Adress                 :  ",
                    valueText: "$address",
                  ),
                  RowText(
                    keyText: "Email Id               :  ",
                    valueText: "$email",
                  ),
                  RowText(
                    keyText: "Mobile                 :  ",
                    valueText: "$mobile",
                  ),
                  // RowText(
                  //   keyText: "Created By          :  ",
                  //   valueText: "$createdBy",
                  // ),
                  // RowText(
                  //   keyText: "Created On         :  ",
                  //   valueText: DateFormat.yMd().format(createdOn),
                  //   // valueText: "${createdOn}",
                  // ),
                  // RowText(
                  //   keyText: "Last Editted By  :  ",
                  //   valueText: "${lastEditedBy}",
                  // ),
                  // RowText(
                  //   keyText: "Last Editted On  :  ",
                  //   valueText: DateFormat.yMd().format(lastEditedOn),
                  //   // valueText: "${lastEditedOn}",
                  // ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  CustomeButton(
                    butionText: 'close',
                    buttionColor: const Color(0xff2182BA),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            });
      },
    );
  }
}
