import 'package:flutter/material.dart';

class PopUpCard extends StatelessWidget {
  bool padding;
  List<Widget>? childern;
  PopUpCard({this.childern,this.padding = true});
  //PopUpCard(this.childern, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 110),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height * 0.025),
      ),
      elevation: 0,
      child: Container(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding:  !padding? const EdgeInsets.all(0): EdgeInsets.only(left: 20, bottom: 20),
            child: Column(
              mainAxisAlignment:  MainAxisAlignment.spaceAround,
              children: childern!,
            ),
          ),
        ),
      ),
    );
  }
}
