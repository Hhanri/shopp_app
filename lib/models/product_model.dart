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

  void toggleFavoriteStatus({required String token, required String userId}) async {
    final bool currentStatus = isFavorite;
    isFavorite = !isFavorite;
    final url = Uri.parse("https://shop-app-e09ab-default-rtdb.europe-west1.firebasedatabase.app/userFavorite/$userId/$id.json?auth=$token");
    try {
      final response = await http.put(url, body: jsonEncode(isFavorite));
      if (response.statusCode >= 400) {
        isFavorite = currentStatus;
      }
    } catch (error) {
      isFavorite = currentStatus;
    }
    notifyListeners();
  }

  static Map<String, dynamic> toMap({required ProductModel product, required String creatorId}) {
    return {
      'title': product.title,
      'description': product.description,
      'price': product.price,
      'imageUrl': product.imageUrl,
      'creatorId': creatorId
    };
  }

  factory ProductModel.fromMap({required Map<String, dynamic> json, required String id, required bool isFav}) {
    return ProductModel(
      id: id,
      title: json['title'],
      description: json['description'],
      price: json['price'],
      imageUrl: json['imageUrl'],
      isFavorite: isFav
    );
  }
}