// import 'dart:async';
// import 'dart:math';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../../../provider/leads_provider.dart';
// import '../../../utils/color_constants.dart';

// class BarChartSample1 extends StatefulWidget {
//   const BarChartSample1({Key? key}) : super(key: key);

//   @override
//   State<StatefulWidget> createState() => BarChartSample1State();
// }

// class BarChartSample1State extends State<BarChartSample1> {
//   final Color barBackgroundColor = ColorConstants.appBarGradientColor4;
//   final Duration animDuration = const Duration(milliseconds: 250);

//   int touchedIndex = -1;

//   @override
//   Widget build(BuildContext context) {
//     final leadData = Provider.of<LeadsProvider>(context);
//     return AspectRatio(
//       aspectRatio: 1,
//       child: Card(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
//         color: ColorConstants.appBarGradientColor3,
//         child: Stack(
//           children: <Widget>[
//             Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 mainAxisSize: MainAxisSize.max,
//                 children: <Widget>[
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Expanded(
//                         child: Text(
//                           'Leads stats',
//                           style: Theme.of(context).textTheme.headline1,
//                         ),
//                       ),
//                       Row(
//                         children: [
//                           IconButton(
//                               onPressed: () {
//                                 leadData.fetchAndSetleads(context,
//                                     year: leadData.selelctedYear - 1);
//                               },
//                               icon: Icon(
//                                 Icons.arrow_back_ios_rounded,
//                                 color: ColorConstants.elevetedCardColor,
//                               )),
//                           SizedBox(
//                             width: 1,
//                           ),
//                           Text(
//                             "${leadData.selelctedYear}",
//                             style: Theme.of(context).textTheme.headline1,
//                           ),
//                           SizedBox(
//                             width: 1,
//                           ),
//                           leadData.selelctedYear < DateTime.now().year
//                               ? IconButton(
//                                   onPressed: () {
//                                     leadData.fetchAndSetleads(context,
//                                         year: leadData.selelctedYear + 1);
//                                   },
//                                   icon: Icon(
//                                     Icons.arrow_forward_ios_rounded,
//                                     color: ColorConstants.elevetedCardColor,
//                                   ))
//                               : IconButton(
//                                   onPressed: () {},
//                                   icon: Icon(
//                                     Icons.arrow_forward_ios_rounded,
//                                     color: ColorConstants.elevetedCardColor
//                                         .withOpacity(.3),
//                                   ))
//                         ],
//                       )
//                     ],
//                   ),
//                   const SizedBox(
//                     height: 30,
//                   ),
//                   Expanded(
//                     child: leadData.totalRevenue != 0
//                         ? Padding(
//                             padding:
//                                 const EdgeInsets.symmetric(horizontal: 8.0),
//                             child: BarChart(
//                               //randomData(),
//                               mainBarData(),
//                               swapAnimationDuration: animDuration,
//                             ),
//                           )
//                         : Center(
//                             child: Text(
//                               "No Data",
//                               style: Theme.of(context).textTheme.headline1,
//                             ),
//                           ),
//                   ),
//                   const SizedBox(
//                     height: 12,
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   BarChartGroupData makeGroupData(
//     int x,
//     double y, {
//     bool isTouched = false,
//     Color barColor = Colors.white,
//     double width = 21,
//     List<int> showTooltips = const [],
//   }) {
//     final leadData = Provider.of<LeadsProvider>(context);
//     return BarChartGroupData(
//       x: x,
//       barRods: [
//         BarChartRodData(
//           y: isTouched ? y + 1 : y,
//           colors:
//               isTouched ? [ColorConstants.appBarGradientColor1] : [barColor],
//           width: width,
//           borderSide: isTouched
//               ? BorderSide(
//                   color: ColorConstants.appBarGradientColor4.withOpacity(0.9),
//                   width: 1)
//               : const BorderSide(color: Colors.white, width: 4),
//           backDrawRodData: BackgroundBarChartRodData(
//             show: true,
//             y: leadData.totalRevenue != 0
//                 ? leadData.totalRevenue.toDouble()
//                 : 1,
//             colors: [barBackgroundColor],
//           ),
//         ),
//       ],
//       showingTooltipIndicators: showTooltips,
//     );
//   }

//   List<BarChartGroupData> showingGroups() => List.generate(12, (i) {
//         final leadData = Provider.of<LeadsProvider>(context);
//         switch (i) {
//           case 0:
//             return makeGroupData(0, leadData.jan.toDouble(),
//                 isTouched: i == touchedIndex);
//           case 1:
//             return makeGroupData(1, leadData.feb.toDouble(),
//                 isTouched: i == touchedIndex);
//           case 2:
//             return makeGroupData(2, leadData.mar.toDouble(),
//                 isTouched: i == touchedIndex);
//           case 3:
//             return makeGroupData(3, leadData.apr.toDouble(),
//                 isTouched: i == touchedIndex);
//           case 4:
//             return makeGroupData(4, leadData.may.toDouble(),
//                 isTouched: i == touchedIndex);
//           case 5:
//             return makeGroupData(5, leadData.jun.toDouble(),
//                 isTouched: i == touchedIndex);
//           case 6:
//             return makeGroupData(6, leadData.jul.toDouble(),
//                 isTouched: i == touchedIndex);
//           case 7:
//             return makeGroupData(7, leadData.aug.toDouble(),
//                 isTouched: i == touchedIndex);
//           case 8:
//             return makeGroupData(8, leadData.sep.toDouble(),
//                 isTouched: i == touchedIndex);
//           case 9:
//             return makeGroupData(9, leadData.oct.toDouble(),
//                 isTouched: i == touchedIndex);
//           case 10:
//             return makeGroupData(10, leadData.nov.toDouble(),
//                 isTouched: i == touchedIndex);
//           case 11:
//             return makeGroupData(11, leadData.dec.toDouble(),
//                 isTouched: i == touchedIndex);
//           default:
//             return throw Error();
//         }
//       });

//   BarChartData mainBarData() {
//     return BarChartData(
//       barTouchData: BarTouchData(
//         touchTooltipData: BarTouchTooltipData(
//             tooltipBgColor: Colors.blueGrey,
//             getTooltipItem: (group, groupIndex, rod, rodIndex) {
//               String weekDay;
//               switch (group.x.toInt()) {
//                 case 0:
//                   weekDay = 'January';
//                   break;
//                 case 1:
//                   weekDay = 'February';
//                   break;
//                 case 2:
//                   weekDay = 'March';
//                   break;
//                 case 3:
//                   weekDay = 'April';
//                   break;
//                 case 4:
//                   weekDay = 'May';
//                   break;
//                 case 5:
//                   weekDay = 'June';
//                   break;
//                 case 6:
//                   weekDay = 'July';
//                   break;
//                 case 7:
//                   weekDay = 'August';
//                   break;
//                 case 8:
//                   weekDay = 'September';
//                   break;
//                 case 9:
//                   weekDay = 'October';
//                   break;
//                 case 10:
//                   weekDay = 'November';
//                   break;
//                 case 11:
//                   weekDay = 'December';
//                   break;
//                 default:
//                   throw Error();
//               }
//               return BarTooltipItem(
//                 weekDay + '\n',
//                 const TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 18,
//                 ),
//                 children: <TextSpan>[
//                   TextSpan(
//                     text: (rod.y - 1).toString(),
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 16,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ],
//               );
//             }),
//         touchCallback: (FlTouchEvent event, barTouchResponse) {
//           setState(() {
//             if (!event.isInterestedForInteractions ||
//                 barTouchResponse == null ||
//                 barTouchResponse.spot == null) {
//               touchedIndex = -1;
//               return;
//             }
//             touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
//           });
//         },
//       ),
//       titlesData: FlTitlesData(
//         show: true,
//         rightTitles: SideTitles(showTitles: false),
//         topTitles: SideTitles(showTitles: false),
//         bottomTitles: SideTitles(
//           showTitles: true,
//           getTextStyles: (context, value) => const TextStyle(
//               color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
//           margin: 16,
//           showTitles: (double value) {
//             switch (value.toInt()) {
//               case 0:
//                 return 'Jan';
//               case 1:
//                 return 'Feb';
//               case 2:
//                 return 'Mar';
//               case 3:
//                 return 'Apr';
//               case 4:
//                 return 'May';
//               case 5:
//                 return 'Jun';
//               case 6:
//                 return 'Jul';
//               case 7:
//                 return 'Aug';
//               case 8:
//                 return 'Sep';
//               case 9:
//                 return 'Oct';
//               case 10:
//                 return 'Nov';
//               case 11:
//                 return 'Dec';
//               default:
//                 return '';
//             }
//           },
//         ),
//         leftTitles: SideTitles(
//           showTitles: false,
//         ),
//       ),
//       borderData: FlBorderData(
//         show: false,
//       ),
//       barGroups: showingGroups(),
//       gridData: FlGridData(show: false),
//     );
//   }

//   // Future<dynamic> refreshState() async {
//   //   setState(() {});
//   //   await Future<dynamic>.delayed(
//   //       animDuration + const Duration(milliseconds: 50));
//   //   if (isPlaying) {
//   //     await refreshState();
//   //   }
//   // }
// }

//   // List<Map<String, dynamic>> get groupedTransactionValues {
//   //   return List.generate(7, (index) {
//   //     final weekDay = DateTime.now().subtract(
//   //       Duration(days: index),
//   //     );
//   //     var totalSum = 0.0;

//   //     for (var i = 0; i < recentTransactions.length; i++) {
//   //       if (recentTransactions[i].date!.day == weekDay.day &&
//   //           recentTransactions[i].date!.month == weekDay.month &&
//   //           recentTransactions[i].date!.year == weekDay.year) {
//   //         totalSum += recentTransactions[i].amount!;
//   //       }
//   //     }

//   //     return {
//   //       'day': DateFormat.E().format(weekDay).substring(0, 1),
//   //       'amount': totalSum,
//   //     };
//   //   }).reversed.toList();
//   // }

//   // double get totalSpending {
//   //   return groupedTransactionValues.fold(0.0, (sum, item) {
//   //     return sum + item['amount'];
//   //   });
//   // }

//   // @override
//   // Widget build(BuildContext context) {
//   //   return Card(
//   //     elevation: 6,
//   //     margin: EdgeInsets.all(20),
//   //     child: Padding(
//   //       padding: EdgeInsets.all(10),
//   //       child: Row(
//   //         mainAxisAlignment: MainAxisAlignment.spaceAround,
//   //         children: groupedTransactionValues.map((data) {
//   //           return Flexible(
//   //             fit: FlexFit.tight,
//   //             child: ChartBar(
//   //               data['day'],
//   //               data['amount'],
//   //               totalSpending == 0.0
//   //                   ? 0.0
//   //                   : (data['amount'] as double) / totalSpending,
