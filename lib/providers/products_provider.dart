import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shop_app/models/product_model.dart';
import 'package:http/http.dart' as http;

class ProductsProvider with ChangeNotifier {
  final String? token;
  final String? userId;
  List<ProductModel> _products = [];

  ProductsProvider(this.token, this.userId, this._products);

  String productsUrl = "https://shop-app-e09ab-default-rtdb.europe-west1.firebasedatabase.app/products.json?auth=";

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
        Uri.parse('$productsUrl$token'),
        body: jsonEncode(
          ProductModel.toMap(product: product, creatorId: userId!)
        )
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
      final url = Uri.parse("https://shop-app-e09ab-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json?auth=$token");
      await http.patch(
        url, body: ProductModel.toMap(product: product, creatorId: userId!)
      );
      _products[productIndex] = product;
    }
    notifyListeners();
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse("https://shop-app-e09ab-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json?auth=$token");
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
  
  Future<void> fetchProducts([bool filterByUser = false]) async {
    final String filter = filterByUser ? '&orderBy="creatorId"&equalTo="$userId"' : '';
    final http.Response response = await http.get(Uri.parse('$productsUrl$token$filter'),);
    final Map<String, dynamic>? body = jsonDecode(response.body);
    final http.Response favoriteResponse = await http.get(Uri.parse("https://shop-app-e09ab-default-rtdb.europe-west1.firebasedatabase.app/userFavorite/$userId.json?auth=$token"));
    final Map<String, dynamic>? favorites = jsonDecode(favoriteResponse.body);
    List<ProductModel> tempList = [];
    if (body != null) {
      print(body);
      body.forEach((key, value) {
        tempList.add(
          ProductModel.fromMap(json: value, id: key, isFav: favorites == null ? false : favorites[key] ?? false)
        );
      });
    }
    _products = [...tempList];
    if (hasListeners) {
      notifyListeners();
    }
  }
}