import 'package:business_manager/ui/widgets/customer_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/customer_provider.dart';

class CustomerList extends StatelessWidget {
  Future<void> _refreshactivity(BuildContext context) async {
    await Provider.of<CustomerProvider>(context, listen: false)
        .fetchAndSetCustomers(context);
  }

  @override
  Widget build(BuildContext context) {
    final customerData = Provider.of<CustomerProvider>(context);
    final customer = customerData.customers;
    return RefreshIndicator(
      onRefresh: () => _refreshactivity(context),
      child: ListView.builder(
        padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.01),
        itemCount: customer.length,
        itemBuilder: (_, i) => ChangeNotifierProvider.value(
          value: customer[i],
          child: CustomerItem(
            customer[i].id,
            customer[i].name,
            customer[i].company,
            customer[i].address,
            customer[i].email,
            customer[i].mobile,
            // customer[i].createdBy,
            // customer[i].createdOn,
            // customer[i].lastEditedBy,
            // customer[i].lastEditedOn,
          ),
        ),
      ),
    );
  }
}
