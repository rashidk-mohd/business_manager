import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'provider/activity_provider.dart';
import 'provider/auth.dart';
import 'provider/customer_provider.dart';
import 'provider/leads_provider.dart';
import 'provider/products.dart';
import 'provider/users.dart';
import 'ui/screens/activity_adding_screen.dart';
import 'ui/screens/activity_editting_screen.dart';
import 'ui/screens/cstmr_editting_screen.dart';
import 'ui/screens/customer_adding_screen.dart';
import 'ui/screens/customer_screen.dart';
import 'ui/screens/home_screen.dart';
import 'ui/screens/lead_detail_&_Activity_screen.dart';
import 'ui/screens/leads_adding_screen.dart';
import 'ui/screens/leads_editing_screen.dart';
import 'ui/screens/leadscreen.dart';
import 'ui/screens/product_adding_screen.dart';
import 'ui/screens/product_edit_screen.dart';
import 'ui/screens/products_screen.dart';
import 'ui/screens/user_adding_screen.dart';
import 'ui/screens/user_edit_screen.dart';
import 'ui/screens/user_screen.dart';
import 'ui/screens/wlcome_screen.dart';
import 'utils/color_constants.dart';
import 'utils/routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProvider.value(
          value: ActivityProvider(),
        ),
        ChangeNotifierProvider.value(
          value: Products(),
        ),
        ChangeNotifierProvider.value(
          value: Users(),
        ),
        ChangeNotifierProvider.value(
          value: Products(),
        ),
        ChangeNotifierProvider(
          create: (context) => CustomerProvider(),
        ),
        ChangeNotifierProvider.value(
          value: LeadsProvider(),
        )
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Business Manager',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            backgroundColor: ColorConstants.backGroundColor,
            buttonTheme: ButtonTheme.of(context).copyWith(
              buttonColor: ColorConstants.white,
              textTheme: ButtonTextTheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            colorScheme: ColorScheme.fromSwatch().copyWith(
                secondary: ColorConstants.elevetedCardColor,
                background: Color.fromARGB(255, 21, 90, 146)),
            fontFamily: GoogleFonts.roboto().fontFamily,
            textTheme: const TextTheme(
              headline1: TextStyle(
                fontSize: 22,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ), //app bar title,"Leads Status" text in leads chart of home screen
              headline2: TextStyle(
                fontSize: 18,
                color: Colors.black,
              ), //texts inside home card
              headline3: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ), // details screen "details" text,leads head texts eg:- 'New',"Qualified"...,"Leads chart "text in home screen
              headline4: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ), //details in lead detail screen
              subtitle1: TextStyle(
                fontSize: 19,
                color: ColorConstants.iconColor,
                // fontWeight: FontWeight.w600,
              ), //editScreenTextField
              headline5: TextStyle(
                  fontSize: 19,
                  color: Color.fromARGB(
                      255, 0, 147, 192)), //customeTextFields hint text
              headline6: TextStyle(
                  fontSize: 19,
                  color: Color.fromARGB(
                      255, 7, 71, 122)), //custome text field text color
            ),
            //custom buttion text
            // headline5: TextStyle(
            //   fontSize: 19,
            //   color: Colors.black,
            //   fontWeight: FontWeight.normal,
            // ),
          ),

          //home: WelcomeScreen(),
          home: auth.isAuth
              ? HomeScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      // authResultSnapshot.connectionState ==
                      //         ConnectionState.waiting
                      //     ?
                      AnimatedSplashScreen(
                        splash: Container(
                          height: 1200,
                          width: 800,
                          child: Image.asset(
                            'assets/qksplash.gif',
                            fit: BoxFit.cover,
                          ),
                        ),
                        nextScreen: WelcomeScreen(),
                        splashIconSize: 300,
                        splashTransition: SplashTransition.fadeTransition,
                        backgroundColor: ColorConstants.backGroundColor,
                      )
                  //  : WelcomeScreen(),
                  ),
          routes: {
            Routes.routeActivityAddingScreen: (context) =>
                const ActivityAddingScreen(),
            Routes.routeActivityEdittingScreen: (context) =>
                const ActivityEdittingScreen(),
            // Routes.routeActivityScreen: (context) =>  ActivityScreen(),
            Routes.homeScreen: (context) => HomeScreen(),

            Routes.routeActivityAddingScreen: (context) =>
                const ActivityAddingScreen(),
            Routes.routeActivityEdittingScreen: (context) =>
                const ActivityEdittingScreen(),
            Routes.routeCustomerScreen: (context) => const CustomerScreen(),
            Routes.routeUserScreen: (context) => UserScreen(),
            Routes.routeLeadsScreen: (context) => LeadScreen1(),
            Routes.routeProductsScreen: (context) => const ProductScreen(),
            Routes.routeCustomerAddingScreen: (context) =>
                const CustomerAddingScreen(),
            Routes.routeUserAddingScreen: (context) => UserAddingScreen(),
            Routes.routeProductAddingScreen: (context) =>
                const ProductAddingScreen(),
            Routes.routeProductEdittingScreen: (context) =>
                const ProductEditingScreen(),
            // Routes.routeUserEdittingScreen: (context) => UserEditingScreen(),
            Routes.routeWelcomeScreen: (context) => WelcomeScreen(),
            Routes.routeCustomerEdittingScreen: (context) =>
                const CustomerEdittingScreen(),
            Routes.routeLeadsAddingScreens: (context) => LeadsAddingScreens(),
            Routes.routeLeadsEditingScreen: (context) =>
                const LeadsEditingScreens(),
            Routes.routeUserEdittingScreen: (context) => UserEdittingScreen(),
            Routes.routeLeadsDetailScreen: (context) => leadDetailScreen(),
          },
        ),
      ),
    );
  }
}
