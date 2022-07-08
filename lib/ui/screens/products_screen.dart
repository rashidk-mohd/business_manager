import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/products.dart';
import '../../utils/color_constants.dart';
import '../../utils/routes.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/product_list.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    // Provider.of<Products>(context).fetchAndSetProducts(); // WON'T WORK!
    Future.delayed(Duration.zero).then((_) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context, listen: false)
          .fetchAndSetProducts(context)
          .then(
            (value) => setState(() {
              _isLoading = false;
            }),
          );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorConstants.backGroundColor,
        appBar: CustomAppBar(
          'Product',
          // centerTitle: true,
          actionButton: [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: IconButton(
                icon: const Icon(Icons.add),
                iconSize: 35,
                onPressed: () {
                  Navigator.pushNamed(context, Routes.routeProductAddingScreen);
                },
              ),
            ),
          ],
        ),
        body: _isLoading
            ? Center(
                child: Container(
                    height: 250,
                    width: 250,
                    child: Image.asset("assets/loading.gif")),
              )
            : const ProductsList());
  }
}
