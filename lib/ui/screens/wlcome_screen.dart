import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/auth.dart';
import '../../utils/color_constants.dart';
import '../widgets/rounded_button.dart';
import 'auth_screen.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool bx = true;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            ColorConstants.appBarGradientColor1,
            ColorConstants.appBarGradientColor2,
            ColorConstants.appBarGradientColor3,
            ColorConstants.appBarGradientColor4
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: size.height * 0.25),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        height: 120,
                        width: 120,
                        child: Image.asset('assets/logo.png')),
                    Text(
                      'qksales',
                      style: TextStyle(color: Colors.white, fontSize: 40),
                    ),
                  ],
                ),
              ),
              SizedBox(height: size.height * 0.15),
              RoundedButton(
                color: ColorConstants.white,
                textColor: ColorConstants.backGroundColor,
                text: "LOGIN",
                // color: bx ? Colors.transparent : Colors.white,
                onPressed: () {
                  Provider.of<Auth>(context, listen: false).stateType('login');
                  //  bx = !bx;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return AuthScreen();
                      },
                    ),
                  );
                },
              ),
              RoundedButton(
                text: "SIGN UP",
                color: ColorConstants.backGroundColor,
                textColor: ColorConstants.white,
                onPressed: () {
                  Provider.of<Auth>(context, listen: false).stateType('signup');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return AuthScreen();
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
