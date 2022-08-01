import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shop_app/models/product_model.dart';
import 'package:http/http.dart' as http;

class ProductsProvider with ChangeNotifier {
  final String token;
  List<ProductModel> _products = [];

  ProductsProvider(this.token, this._products);



  String baseUrl = "https://shop-app-e09ab-default-rtdb.europe-west1.firebasedatabase.app/products.json?auth=";

  List<ProductModel> get products {
    return [..._products];
  }

  List<ProductModel> get favorites {
    return _products.where((element) => element.isFavorite).toList();
  }
  ProductModel productById(String id) => _products.firstWhere((element) => element.id == id);

  Future<void> addProduct(ProductModel newProduct) async {
    final ProductModel product = ProductModel(
      id: DateTime.now().toString(),
      title: newProduct.title,
      description: newProduct.description,
      price: newProduct.price,
      imageUrl: newProduct.imageUrl,
      isFavorite: false
    );
    try {
      await http.post(
        Uri.parse('$baseUrl$token'),
        body: jsonEncode(ProductModel.toMap(product: product, isFav: true))
      );
      _products.add(product);
      notifyListeners();
    } catch(error) {
      rethrow;
    }
  }

  Future<void> updateProduct({required String id, required ProductModel product}) async {
    final productIndex = _products.indexWhere((element) => element.id == id);
    if (productIndex >= 0) {
      final url = Uri.parse("https://shop-app-e09ab-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json");
      await http.patch(
        url, body: ProductModel.toMap(product: product, isFav: false)
      );
      _products[productIndex] = product;
    }
    notifyListeners();
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse("https://shop-app-e09ab-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json");
    final productIndex = _products.indexWhere((element) => element.id == id);
    final existingProduct = _products[productIndex];
    _products.removeAt(productIndex);

    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _products.insert(productIndex, existingProduct);
      throw const HttpException('Could not delete product');
    }
    notifyListeners();
  } 
  
  Future<void> fetchProducts() async {
    final response = await http.get(Uri.parse('$baseUrl$token'),);
    final Map<String, dynamic> body = jsonDecode(response.body);
    print(body);
    List<ProductModel> tempList = [];
    body.forEach((key, value) {
      tempList.add(ProductModel.fromMap(json: value, id: key));
    });
    _products = [...tempList];
    notifyListeners();
  }
}