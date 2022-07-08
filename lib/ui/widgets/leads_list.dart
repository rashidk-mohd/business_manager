// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:qksales_frontend/provider/leads_provider.dart';
// import 'package:qksales_frontend/ui/widgets/home_widget.dart';
// import 'package:qksales_frontend/ui/widgets/leads_widget.dart';
// import 'leads_item.dart';

// class LeadsList extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final leadsData = Provider.of<LeadsProvider>(context, listen: false);
//     final leads = leadsData.items;

//     return LeadsWidget(
//       title: 'New',
//       child: ListView.builder(
//         padding: const EdgeInsets.all(10.0),
//         itemCount: leads.length,
//         itemBuilder: (_, i) => ChangeNotifierProvider.value(
//           value: leads[i],
//           child: LeadItem(
//             leads[i].id,
//             leads[i].title,
//             leads[i].customer,
//             leads[i].revenue,
//             leads[i].date,
//             leads[i].salesperson,
//             leads[i].status,
//             leads[i].details,
//           ),
//         ),
//       ),
//     );
//   }
// }
