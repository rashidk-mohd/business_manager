import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/auth.dart';
import '../../utils/color_constants.dart';
import '../../utils/routes.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(children: <Widget>[
      Row(
        children: [
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.height * .23,
              padding: EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.account_circle_outlined,
                        size: 60,
                        color: ColorConstants.iconSecondary,
                      ),
                      Consumer<Auth>(
                        builder: (context, value, child) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            value.userName != null ? value.userName! : '',
                            style: Theme.of(context).textTheme.headline1,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              color: Theme.of(context).backgroundColor,
            ),
          ),
        ],
      ),
      const SizedBox(
        height: 5,
      ),
      const SizedBox(
        height: 5,
      ),
      ListTile(
        title: Row(children: [
          Icon(Icons.account_circle_outlined),
          Text(
            'USERS',
            style: Theme.of(context).textTheme.headline2,
          )
        ]),
        onTap: () {
          Navigator.popAndPushNamed(context, Routes.routeUserScreen);
        },
      ),
      const Divider(
          // thickness: 1,
          ),
      ListTile(
        title: Row(children: [
          const Icon(Icons.people_alt_sharp),
          Text(
            'CUSTOMERS',
            style: Theme.of(context).textTheme.headline2,
          )
        ]),
        onTap: () {
          Navigator.popAndPushNamed(context, Routes.routeCustomerScreen);
        },
      ),
      const Divider(
          // thickness: 1,
          ),
      ListTile(
          title: Row(children: [
            const Icon(
              Icons.groups_sharp,
              size: 35,
            ),
            Text(
              ' LEADS',
              style: Theme.of(context).textTheme.headline2,
            )
          ]),
          onTap: () {
            Navigator.popAndPushNamed(context, Routes.routeLeadsScreen);
          }),
      const Divider(
          // thickness: 1,
          ),
      ListTile(
          title: Row(children: [
            const Icon(Icons.shopping_cart_rounded),
            Text(
              'PRODUCTS',
              style: Theme.of(context).textTheme.headline2,
            )
          ]),
          onTap: () {
            Navigator.popAndPushNamed(context, Routes.routeProductsScreen);
          }),
      const Divider(
          // thickness: 1,
          ),
      Column(
        children: [
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: Text(
              'Logout',
              style: Theme.of(context).textTheme.headline2,
            ),
            onTap: () {
              // Navigator.of(context).pop();
              Navigator.pushNamedAndRemoveUntil(
                  context, Routes.routeWelcomeScreen, (route) => false);

              // Navigator.of(context)
              //     .pushReplacementNamed(UserProductsScreen.routeName);
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
        ],
      ),
    ]));
  }
}
