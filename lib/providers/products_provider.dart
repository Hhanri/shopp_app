import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_app/models/product_model.dart';
import 'package:http/http.dart' as http;

class ProductsProvider with ChangeNotifier {

  List<ProductModel> _products = [
    ProductModel(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
      'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
      isFavorite: false
    ),
    ProductModel(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
      'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
      isFavorite: false
    ),
    ProductModel(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
      'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
      isFavorite: false
    ),
    ProductModel(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
      'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
      isFavorite: false
    ),
  ];
  final _url = Uri.parse("https://shop-app-e09ab-default-rtdb.europe-west1.firebasedatabase.app/products.json");

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
        _url,
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
    http.delete(url).catchError((_) {
      _products.insert(productIndex, existingProduct);
    });
    _products.removeAt(productIndex);
    notifyListeners();
  } 
  
  Future<void> fetchProducts() async {
    final response = await http.get(_url);
    final Map<String, Map<String, dynamic>> body = jsonDecode(response.body);
    List<ProductModel> tempList = [];
    body.forEach((key, value) {
      tempList.add(ProductModel.fromMap(json: value, id: key));
    });
    _products = [...tempList];
    notifyListeners();
  }
}