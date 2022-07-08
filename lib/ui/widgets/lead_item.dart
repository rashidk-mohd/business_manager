// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:qksales_frontend/models/leads_model.dart';
// import 'package:qksales_frontend/provider/leads_provider.dart';
// import 'package:qksales_frontend/provider/leads_provider.dart';

// import 'package:qksales_frontend/ui/screens/lead_detail_screen.dart';

// class LeadItem extends StatelessWidget {
//   final int? id;
//   final String? title;
//   final int? customer;
//   final int? revenue;
//   final DateTime? date;
//   final int? salesperson;
//   final String? details;
//   final String? status;

//   LeadItem(
//     this.id,
//     this.title,
//     this.customer,
//     this.revenue,
//     this.date,
//     this.salesperson,
//     this.details,
//     this.status,
//   );

//   @override
//   Widget build(BuildContext context) {
//     final LeadProvider = Provider.of<Lead>(context, listen: false);
//     final scaffold = Scaffold.of(context);
//     return Column(
//       children: [
//         leadDetailScreen(
//           onPresseddelete: () async {
//             try {
//               Provider.of<LeadsProvider>(context, listen: false)
//                   .deleteLead(id!);
//               Navigator.of(context).pop();
//             } catch (error) {
//               scaffold.showSnackBar(
//                 const SnackBar(
//                   content: Text(
//                     'Deleting failed!',
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//               );
//             }
//           },
//         )
//       ],
//     );
//   }
// }
