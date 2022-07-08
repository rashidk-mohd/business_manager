import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/customer_model.dart';
import '../../provider/customer_provider.dart';
import '../../utils/color_constants.dart';
import '../../utils/routes.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/customer_list.dart';

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({Key? key}) : super(key: key);
  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  bool isLoading = false;
  List<CustomerModel> loadedCustomer = [];
  @override
  Widget build(BuildContext context) {
    final custumersData = Provider.of<CustomerProvider>(context);
    final customer = custumersData.customers;
    return Scaffold(
      backgroundColor: ColorConstants.backGroundColor,
      appBar: CustomAppBar(
        'CUSTOMERS',
        actionButton: [
          Padding(
            padding: EdgeInsets.only(
                right: MediaQuery.of(context).size.width * 0.015),
            child: IconButton(
              icon: const Icon(Icons.add),
              iconSize: MediaQuery.of(context).size.width * 0.1,
              onPressed: () {
                Navigator.pushNamed(context, Routes.routeCustomerAddingScreen);
              },
            ),
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: Container(
                  height: 250,
                  width: 250,
                  child: Image.asset("assets/loading.gif")),
            )
          : CustomerList(),
    );
  }

  @override
  void initState() {
    Future.delayed(Duration.zero).then(
      (_) {
        setState(() {
          isLoading = true;
        });
        Provider.of<CustomerProvider>(context, listen: false)
            .fetchAndSetCustomers(context)
            .then(
              (value) => setState(() {
                isLoading = false;
              }),
            );
      },
    );
    super.initState();
  }
}
