import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductModel with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.isFavorite
  });

  void toggleFavoriteStatus() async {
    final bool currentStatus = isFavorite;
    isFavorite = !isFavorite;
    final url = Uri.parse("https://shop-app-e09ab-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json");
    try {
      final response = await http.patch(url, body: jsonEncode({'isFavorite': isFavorite}));
      if (response.statusCode >= 400) {
        isFavorite = currentStatus;
      }
    } catch (error) {
      isFavorite = currentStatus;
    }
    notifyListeners();
  }

  static Map<String, dynamic> toMap({required ProductModel product, required bool isFav}) {
    return {
      'title': product.title,
      'description': product.description,
      'price': product.price,
      'imageUrl': product.imageUrl,
      if(isFav) 'isFavorite': product.isFavorite,
    };
  }

  factory ProductModel.fromMap({required Map<String, dynamic> json, required String id}) {
    return ProductModel(
      id: id,
      title: json['title'],
      description: json['description'],
      price: double.parse(json['price']),
      imageUrl: json['imageUrl'],
      isFavorite: json['isFavorite']
    );
  }
}