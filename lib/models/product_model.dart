import 'package:flutter/material.dart';

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

  void toggleFavoriteStatus() {
    isFavorite = !isFavorite;
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