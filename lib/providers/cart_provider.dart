import 'package:flutter/material.dart';
import 'package:shop_app/models/cart_model.dart';

class CartProvider with ChangeNotifier {
  Map<String, CartItemModel> _cartItems = {};

  Map<String, CartItemModel> get cartItems => {..._cartItems};

  int get itemCount => _cartItems.length;

  double get totalAmount {
    return _cartItems.values.map((item) => item.price * item.quantity).reduce((value, element) => value + element);
  }

  void removeItem(String productId) {
    _cartItems.remove(productId);
    notifyListeners();
  }

  void addCartItem({required String id, required double price, required String title}) {
    if (_cartItems.containsKey(id)) {
    _cartItems.update(id, (value) => CartItemModel(id: value.id, title: value.title, quantity: value.quantity+1, price: value.price));
    } else {
      _cartItems.putIfAbsent(id, () => CartItemModel(id: DateTime.now().toString(), title: title, quantity: 1, price: price));
    }
    notifyListeners();
  }
}

