import 'package:flutter/material.dart';
import 'package:shop_app/models/cart_model.dart';
import 'package:shop_app/models/order_model.dart';

class OrdersProvider with ChangeNotifier {
  List<OrderModel> _orders = [];

  List<OrderModel> get orders => [..._orders];

  void addOrder(List<CartItemModel> products, double total) {
    final DateTime now = DateTime.now();
    _orders.insert(0, OrderModel(id: now.toString(), amount: total, products: products, date: now));
    notifyListeners();
  }
}