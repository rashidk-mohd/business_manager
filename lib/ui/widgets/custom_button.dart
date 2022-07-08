import 'package:flutter/material.dart';

import '../../utils/color_constants.dart';

class CustomeButton extends StatelessWidget {
  bool needicon;
  String? butionText;
  double buttonRightPadding, buttonLeftPadding, buttonTopPadding;
  Color buttionColor;
  void Function()? onPressed;
  IconData? icons;

  CustomeButton({
    this.butionText,
    this.buttonRightPadding = 0,
    this.buttonLeftPadding = 0,
    this.buttonTopPadding = 0,
    required this.buttionColor,
    this.onPressed,
    this.needicon = false,
    this.icons,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          right: buttonRightPadding,
          left: buttonLeftPadding,
          top: buttonTopPadding),
      child: SizedBox(
        width: 130,
        height: 40,
        child: RaisedButton(
          elevation: 15,
          color: ColorConstants.iconColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (needicon) Icon(icons),
              Text(
                butionText!,
                style: Theme.of(context).textTheme.headline4,
              ),
            ],
          ),
          onPressed: onPressed,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }
}
