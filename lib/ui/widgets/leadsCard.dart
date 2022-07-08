import 'dart:ui';

import 'package:flutter/material.dart';

import '../../models/leads_model.dart';
import '../../utils/color_constants.dart';

class LeadsCard extends StatelessWidget {
  final Lead lead;
  final bool isFeedBack;

  LeadsCard(this.lead, this.isFeedBack);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.all(isFeedBack ? 0 : 4),
      padding: const EdgeInsets.all(8),
      height: 80,
      width: width * (isFeedBack ? .6 : .8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        // color: Theme.of(context).colorScheme.secondary,
        color: ColorConstants.backGroundColor,
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 5.0),
            blurRadius: 7.0,
            spreadRadius: 1.0,
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Title : ${lead.title}",
            style: TextStyle(color: ColorConstants.white),
          ),
          // Row(
          //   children: [
          //     Text(
          //       'Title :',
          //       style: Theme.of(context).textTheme.headline2,
          //     ),
          //     Expanded(
          //         child: Text(
          //       lead.title!,
          //       maxLines: 1,
          //       overflow: TextOverflow.ellipsis,
          //       style: Theme.of(context).textTheme.headline2,
          //     )),
          //   ],
          // ),
          Text(
            "Revenue : ₹${lead.revenue}",
            // style: Theme.of(context).textTheme.headline2,
            style: TextStyle(color: ColorConstants.white),
          ),

          Text("${lead.date!.year}",
              style: TextStyle(color: ColorConstants.white))
        ],
      ),
    );
  }
}
 
// TextStyle textStyle() =>
//     const TextStyle(fontSize: 18, fontWeight: FontWeight.normal);
// TextStyle textStylee() =>
//     const TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
 
