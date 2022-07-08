import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../models/http_exception.dart';
import '../models/product.dart';
import '../utils/const.dart';
import '../utils/web_const.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];

  List<Product> get items {
    return [..._items];
  }

  Product findById(int id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> addProduct(BuildContext context, Product product) async {
    final url = Uri.parse(Constants.hostName + '/product');
    try {
      final response = await http.post(url,
          headers: BearerToken().hearders(context),
          body: json.encode({
            'Name': product.name,
            'Price': product.price,
            'Tax': product.tax,
            'Unit': product.unit,
          }));
      final newProduct = Product(
        name: product.name,
        price: product.price,
        tax: product.tax,
        unit: product.unit,
        id: product.id,
        // id: DateTime.now().toString(),
        // id: json.decode(response.body)['Id'],
      );
      _items.add(newProduct);
      // _items.insert(0, newProduct); // at the start of the list
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(
      BuildContext context, int id, Product newProduct) async {
    print('deleteproduct token :  ${BearerToken().hearders(context)}');
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url = Uri.parse(Constants.hostName + '/product/$id');
      await http.patch(url,
          headers: BearerToken().hearders(context),
          body: json.encode({
            'name': newProduct.name,
            'unit': newProduct.unit,
            'tax': newProduct.tax,
            'price': newProduct.price
          }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteProduct(BuildContext context, int id) async {
    final url = Uri.parse(Constants.hostName + '/product/$id');
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    Product? existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(
      url,
      headers: BearerToken().hearders(context),
    );
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
    existingProduct = null;
  }

  Future<void> fetchAndSetProducts(BuildContext context) async {
    // final bearerToken = Provider.of<Auth>(context, listen: false).bearerToken;
    final url = Uri.parse(Constants.hostName + '/products');
    List<Product> loadedProducts = [];

    try {
      final response = await http.get(
        url,
        headers: BearerToken().hearders(context),
      );

      print('status code :  ${response.statusCode}');
      var body = jsonDecode(response.body);
      print(jsonDecode(response.body));
      final extractedData = json.decode(response.body) as List<dynamic>;
      // ignore: unnecessary_null_comparison
      if (extractedData == null) {
        return;
      }

      for (var prodData in extractedData) {
        loadedProducts.add(Product(
          id: prodData["Id"],
          name: prodData['Name'],
          price: prodData['Price'],
          tax: prodData['Tax'],
          unit: prodData['Unit'],
        ));
      }
      _items = loadedProducts;

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
