import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/products.dart';
import './product_item.dart';

class ProductsList extends StatelessWidget {
  const ProductsList({Key? key}) : super(key: key);

  Future<void> _refreshproducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts(context);
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = productsData.items;
    return RefreshIndicator(
      onRefresh: () => _refreshproducts(context),
      child: ListView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: products.length,
        itemBuilder: (_, i) => ChangeNotifierProvider.value(
          value: products[i],
          child: ProductItem(
            products[i].id,
            products[i].name,
            products[i].price,
            products[i].tax,
            products[i].unit,
          ),
        ),
      ),
    );
  }
}
