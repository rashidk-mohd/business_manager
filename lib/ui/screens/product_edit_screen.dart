import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/product.dart';
import '../../provider/products.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_button.dart';
import '../widgets/edit_screen_textfields.dart';
import '../widgets/home_widget.dart';

class ProductEditingScreen extends StatefulWidget {
  const ProductEditingScreen({Key? key}) : super(key: key);

  @override
  _ProductEditingScreenState createState() => _ProductEditingScreenState();
}

class _ProductEditingScreenState extends State<ProductEditingScreen> {
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
  var _initValues = {
    'name': '',
    'price': '',
    'tax': '',
    'unit': '',
  };
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context)!.settings.arguments as int?;
      print(productId);
      if (productId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initValues = {
          'name': _editedProduct.name!,
          'unit': _editedProduct.unit!,
          'price': _editedProduct.price.toString(),
          'tax': _editedProduct.tax.toString(),
        };
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> _saveForm() async {
    final isValid = form.currentState?.validate();
    if (!isValid!) {
      return;
    }
    form.currentState?.save();
    //  setState(() {
    //   _isLoading = true;
    // });
    Provider.of<Products>(context, listen: false)
        .updateProduct(context, _editedProduct.id!, _editedProduct);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar('EDIT'),
      body: HomeWidget(
        child: Form(
          key: form,
          child: ListView(
            children: [
              Column(
                children: [
                  EditScreentextFields(
                    initialValue: _initValues['name'],
                    // horizontalPadding: 27,
                    // hintext: 'name',
                    title: 'Name',
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_priceFocusNode);
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
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  EditScreentextFields(
                    initialValue: _initValues['price'],
                    title: 'Price',
                    //  horizontalPadding: 27,
                    //  hintext: 'price',
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    focusNode: _priceFocusNode,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_taxFocusNode);
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
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  EditScreentextFields(
                    initialValue: _initValues['tax'],
                    title: 'Tax',
                    // horizontalPadding: 27,
                    // hintext: 'tax',
                    keyboardType: TextInputType.number,
                    focusNode: _taxFocusNode,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_unitFocusNode);
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
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  EditScreentextFields(
                    initialValue: _initValues['unit'],
                    // horizontalPadding: 27,
                    // hintext: 'unit',
                    title: 'Unit',
                    textInputAction: TextInputAction.done,

                    focusNode: _unitFocusNode,
                    onFieldSubmitted: (_) {
                      _saveForm();
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
                        tax: _editedProduct.tax,
                        unit: value,
                        id: _editedProduct.id,
                      );
                    },
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.11),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomeButton(
                          butionText: "SAVE",
                          buttonTopPadding:
                              MediaQuery.of(context).size.width * 0.065,
                          buttionColor: const Color(0xff2182BA),
                          onPressed: _saveForm),
                      CustomeButton(
                        butionText: "CANCEL",
                        buttonTopPadding:
                            MediaQuery.of(context).size.width * 0.065,
                        buttionColor: const Color(0xff2182BA),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
