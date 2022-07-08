import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/product.dart';
import '../../provider/products.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/home_widget.dart';

class ProductAddingScreen extends StatefulWidget {
  const ProductAddingScreen({Key? key}) : super(key: key);

  @override
  State<ProductAddingScreen> createState() => _ProductAddingScreenState();
}

class _ProductAddingScreenState extends State<ProductAddingScreen> {
  final form = GlobalKey<FormState>();
  final _priceFocusNode = FocusNode();
  final _taxFocusNode = FocusNode();
  final _unitFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: null,
    name: '',
    price: 0,
    tax: 0,
    unit: '',
  );
  // var _initValues = {
  //   'name': '',
  //   'price': '',
  //   'tax': '',
  //   'unit': '',
  // };

  var _isInit = true;
  var _isLoading = false;

  Future<void> _refreshproducts(BuildContext context) async {}

  Future<void> _saveForm() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<Products>(context, listen: false)
          .addProduct(context, _editedProduct);
      await Provider.of<Products>(context, listen: false)
          .fetchAndSetProducts(context);
    } catch (error) {
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('An error occurred!'),
          content: const Text('Something went wrong.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Okay'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            )
          ],
        ),
      );
    }

    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        'ADD PRODUCT',
        centerTitle: true,
        actionButton: const [
          Padding(
            padding: EdgeInsets.only(right: 8),
          ),
        ],
      ),
      body: HomeWidget(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _form,
                  child: ListView(
                    children: [
                      Column(
                        children: [
                          CustomTextField(
                            // initialValue: _initValues['name'],
                            horizontalPadding: 27,
                            hintext: 'name',
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_priceFocusNode);
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please provide a value.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _editedProduct = Product(
                                name: value,
                                price: _editedProduct.price,
                                unit: _editedProduct.unit,
                                tax: _editedProduct.tax,
                                id: _editedProduct.id,
                              );
                            },
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          CustomTextField(
                            // initialValue: _initValues['price'],
                            horizontalPadding: 27,
                            hintext: 'price',
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            focusNode: _priceFocusNode,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_taxFocusNode);
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter a price.';
                              }
                              if (int.tryParse(value) == null) {
                                return 'Please enter a valid number.';
                              }
                              if (int.parse(value) <= 0) {
                                return 'Please enter a number greater than zero.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _editedProduct = Product(
                                name: _editedProduct.name,
                                price: int.parse(value!),
                                tax: _editedProduct.tax,
                                unit: _editedProduct.unit,
                                id: _editedProduct.id,
                              );
                            },
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          CustomTextField(
                            // initialValue: _initValues['tax'],
                            horizontalPadding: 27,
                            hintext: 'tax',
                            keyboardType: TextInputType.number,
                            focusNode: _taxFocusNode,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_unitFocusNode);
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter a tax.';
                              }
                              if (int.tryParse(value) == null) {
                                return 'Please enter a valid number.';
                              }
                              if (int.parse(value) <= 0) {
                                return 'Please enter a number greater than zero.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _editedProduct = Product(
                                name: _editedProduct.name,
                                price: _editedProduct.price,
                                tax: int.parse(value!),
                                unit: _editedProduct.unit,
                                id: _editedProduct.id,
                              );
                            },
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          CustomTextField(
                            // initialValue: _initValues['unit'],
                            horizontalPadding: 27,
                            hintext: 'unit',
                            textInputAction: TextInputAction.done,
                            // controller: _imageUrlController,
                            focusNode: _unitFocusNode,
                            onFieldSubmitted: (_) {
                              _saveForm();
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please provide a value.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _editedProduct = Product(
                                name: _editedProduct.name,
                                price: _editedProduct.price,
                                tax: _editedProduct.tax,
                                unit: value,
                                id: _editedProduct.id,
                              );
                            },
                          ),
                          SizedBox(
                            height: 12,
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CustomeButton(
                                butionText: "ADD",
                                buttonTopPadding: 25,
                                buttionColor: const Color(0xff2182BA),
                                onPressed: _saveForm,
                              ),
                              CustomeButton(
                                butionText: "CANCEL",
                                buttonTopPadding: 25,
                                buttionColor: const Color(0xff2182BA),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 33,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
