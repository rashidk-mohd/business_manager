import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/auth.dart';
import '../../provider/leads_provider.dart';
import '../../provider/users.dart';
import '../../utils/color_constants.dart';
import '../widgets/app_drawer.dart';
import '../widgets/chartWidget/bar_chart_sample1.dart';
import '../widgets/custom_appbar.dart';
import 'customer_screen.dart';
import 'leadscreen.dart';
import 'products_screen.dart';
import 'user_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   Provider.of<Auth>(context, listen: false).getBearerToken();
  //   Provider.of<LeadsProvider>(context, listen: false)
  //       .fetchAndSetleads(context);
  //   super.initState();
  // }

  int pageIndex = 0;

  final pages = [
    UserScreen(),
    CustomerScreen(),
    LeadScreen1,
    ProductScreen(),
  ];

  @override
  void didChangeDependencies() async {
    await Provider.of<Auth>(context, listen: false).getBearerToken();
    Provider.of<LeadsProvider>(context, listen: false)
        .fetchAndSetleads(context);
    Provider.of<Users>(context, listen: false).fetchAndSetUsers(context);

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CustomAppBar(
        'Home Screen',
        isLead: true,
        leadWidget: Builder(builder: (context) {
          return InkWell(
            onTap: () => Scaffold.of(context).openDrawer(),
            child: const drawerWidget(),
          );
        }),
      ),
      drawer: const AppDrawer(),
      //drawer: const AppDrawer(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Leads Chart",
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Container(
            //       height: 400,
            //       width: width * .95,
            //       decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(20),
            //         color: Theme.of(context).colorScheme.secondary,
            //         boxShadow: const [
            //           BoxShadow(
            //             color: Colors.grey,
            //             offset: Offset(0, 5.0),
            //             blurRadius: 15.0,
            //             spreadRadius: 2.0,
            //           )
            //         ],
            //       ),
            //     ),
            //   ],
            // ),
            // BarChartSample1(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 60,
        decoration: const BoxDecoration(
          color: ColorConstants.backGroundColor,
          borderRadius:  BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              enableFeedback: false,
              onPressed: () {
                setState(() {
                  pageIndex = 0;
                });
              },
              icon: pageIndex == 0
                  ? const Icon(
                      Icons.home_filled,
                      color: Colors.white,
                      size: 35,
                    )
                  : const Icon(
                      Icons.home_outlined,
                      color: Colors.white,
                      size: 35,
                    ),
            ),
            IconButton(
              enableFeedback: false,
              onPressed: () {
                setState(() {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => UserScreen()));
                });
              },
              icon: pageIndex == 1
                  ? const Icon(
                      Icons.work_rounded,
                      color: Colors.white,
                      size: 35,
                    )
                  : const Icon(
                      Icons.work_outline_outlined,
                      color: Colors.white,
                      size: 35,
                    ),
            ),
            IconButton(
              enableFeedback: false,
              onPressed: () {
                setState(() {
                  Navigator.push(
                      // context,
                      // CustomPageRoute(
                      //     child: CustomerScreen(),
                      //     direction: AxisDirection.right)
                      context,
                      MaterialPageRoute(
                          builder: (context) => CustomerScreen()));
                });
              },
              icon: pageIndex == 2
                  ? const Icon(
                      Icons.widgets_rounded,
                      color: Colors.white,
                      size: 35,
                    )
                  : const Icon(
                      Icons.widgets_outlined,
                      color: Colors.white,
                      size: 35,
                    ),
            ),
            IconButton(
              enableFeedback: false,
              onPressed: () {
                setState(() {
                  Navigator.push(
                      context,
                      // CustomPageRoute(
                      //     child: LeadScreen1(), direction: AxisDirection.right)
                      MaterialPageRoute(builder: (context) => LeadScreen1()));
                });
              },
              icon: pageIndex == 3
                  ? const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 35,
                    )
                  : const Icon(
                      Icons.person_outline,
                      color: Colors.white,
                      size: 35,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class drawerWidget extends StatelessWidget {
  const drawerWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          drawerline(context, 22),
          drawerline(context, 22),
          drawerline(context, 16),
        ],
      ),
    );
  }

  Container drawerline(BuildContext context, double width) {
    return Container(
      margin: const EdgeInsets.only(bottom: 3),
      height: 3,
      width: width,
      color: Theme.of(context).cardColor,
    );
  }
}
