import 'package:flutter/material.dart';
import 'package:shop_app/models/cart_model.dart';

class CartProvider with ChangeNotifier {
  Map<String, CartItemModel> _cartItems;

  Map<String, CartItemModel> get cartItems => {..._cartItems};

  void addCartItem({required String id, required double price, required String title}) {
    if (_cartItems.containsKey(id)) {
    _cartItems.update(id, (value) => CartItemModel(id: value.id, title: value.title, quantity: value.quantity+1, price: value.price));
    } else {
      _cartItems.putIfAbsent(id, () => CartItemModel(id: DateTime.now().toString(), title: title, quantity: 1, price: price));
    }
  }
}

