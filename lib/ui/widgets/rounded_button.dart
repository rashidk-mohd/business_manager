import 'package:flutter/material.dart';

import '../../utils/color_constants.dart';

class RoundedButton extends StatelessWidget {
  final String? text;
  final void Function()? onPressed;
  final Color? color, textColor;
  MaterialStateProperty<Color?>? backgroundColor;
  RoundedButton({
    Key? key,
    this.text,
    this.onPressed,
    this.color,
    this.backgroundColor,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: size.width * 0.8,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(29),
        child: newElevatedButton(),
      ),
    );
  }

  Widget newElevatedButton() {
    return ElevatedButton(
      child: Text(
        text!,
        style: TextStyle(color: textColor),
      ),
      onPressed: onPressed,

      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(color),
          padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(18)),
          foregroundColor:
              MaterialStateProperty.all<Color>(ColorConstants.backGroundColor),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(48.0),
                  side: BorderSide(color: Colors.white)))),
      // style: ElevatedButton.styleFrom(
      //     primary: color,
      //     padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      //     textStyle: TextStyle(
      //         color: textColor, fontSize: 14, fontWeight: FontWeight.w500)),
    );
  }
}
