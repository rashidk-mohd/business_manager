import 'package:business_manager/ui/widgets/custom_button.dart';
import 'package:business_manager/ui/widgets/home_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/product.dart';
import '../../provider/products.dart';
import '../../utils/routes.dart';

class ProductItem extends StatelessWidget {
  final int? id;
  final String? name;
  final int? price;
  final int? tax;
  final String? unit;

  ProductItem(this.id, this.name, this.price, this.tax, this.unit);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);

    return Column(
      children: [
        HomeCard(
          childs: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Name  :',
                        style: Theme.of(context).textTheme.headline2,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Text(
                          '${product.name}',
                          style: Theme.of(context).textTheme.headline2,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: FittedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Price : ${product.price}',
                          style: Theme.of(context).textTheme.headline2,
                        ),
                        const SizedBox(
                          width: 38,
                        ),
                        Text(
                          'Unit : ${product.unit}',
                          style: Theme.of(context).textTheme.headline2,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          onPressededit: (ctx) {
            print('edit button pressed');
            Navigator.of(context)
                .pushNamed(Routes.routeProductEdittingScreen, arguments: id);
          },
          onPresseddelete: () async {
            try {
              await {
                Provider.of<Products>(context, listen: false)
                    .deleteProduct(context, id!),
                Navigator.of(context).pop()
              };
            } catch (error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text(
                    "Deleting failed!",
                    textAlign: TextAlign.center,
                  ),
                  backgroundColor: Theme.of(context).errorColor,
                  duration: const Duration(seconds: 2),
                ),
              );
            }
          },
          onTap: () {
            _showAboutDialog(context, product.name!, product.price!,
                product.tax!, product.unit!);
          },
        ),
      ],
    );
  }

  void _showAboutDialog(
      BuildContext context, String name, int price, int tax, String unit) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          //shape:
          // RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
          elevation: 16,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * .5,
            width: MediaQuery.of(context).size.width * 8,
            child: SingleChildScrollView(
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(18.0),
                    child: Center(
                      child: Text(
                        "Details",
                        style: Theme.of(context).textTheme.headline3,
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Name   :",
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.headline2,
                              ),
                              const SizedBox(
                                width: 13,
                              ),
                              Text(
                                name,
                                style: Theme.of(context).textTheme.headline2,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 13,
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Price   :",
                                style: Theme.of(context).textTheme.headline2,
                              ),
                              const SizedBox(
                                width: 13,
                              ),
                              Text(
                                "$price",
                                style: Theme.of(context).textTheme.headline2,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 13,
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Tax     :",
                                  style: Theme.of(context).textTheme.headline2,
                                ),
                                const SizedBox(
                                  width: 13,
                                ),
                                Text(
                                  "$tax%",
                                  style: Theme.of(context).textTheme.headline2,
                                ),
                              ]),
                        ),
                        const SizedBox(
                          height: 13,
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Unit    :",
                                  style: Theme.of(context).textTheme.headline2,
                                ),
                                const SizedBox(
                                  width: 13,
                                ),
                                Text(
                                  unit,
                                  style: Theme.of(context).textTheme.headline2,
                                ),
                              ]),
                        ),
                      ],
                    ),
                  ),

                  // Padding(
                  //   padding:
                  //       EdgeInsets.all(MediaQuery.of(context).size.width * 0.2),
                  //   child: Column(
                  //     children: [
                  //       RowText(keyText: 'Name          ', valueText: name),
                  //       SizedBox(
                  //           height: MediaQuery.of(context).size.width * 0.07),
                  //       RowText(
                  //           keyText: 'Price           ', valueText: '$price'),
                  //       SizedBox(
                  //           height: MediaQuery.of(context).size.width * 0.07),
                  //       RowText(
                  //         keyText: 'Tax              ',
                  //         valueText: '$tax',
                  //       ),
                  //       SizedBox(
                  //           height: MediaQuery.of(context).size.width * 0.07),
                  //       RowText(
                  //         keyText: 'Unit             ',
                  //         valueText: unit,
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  Center(
                    child: CustomeButton(
                      butionText: "close",
                      buttonTopPadding: 25,
                      buttionColor: const Color(0xff2182BA),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
