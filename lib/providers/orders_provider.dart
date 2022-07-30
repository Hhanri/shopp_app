import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_app/models/cart_model.dart';
import 'package:shop_app/models/order_model.dart';
import 'package:http/http.dart' as http;

class OrdersProvider with ChangeNotifier {
  List<OrderModel> _orders = [];

  List<OrderModel> get orders => [..._orders];
  final _url = Uri.parse("https://shop-app-e09ab-default-rtdb.europe-west1.firebasedatabase.app/products/orders.json");

  Future<void> addOrder(List<CartItemModel> products, double total) async {
    final DateTime now = DateTime.now();
    final newOrder = OrderModel(id: now.toString(), amount: total, products: products, date: now);
    final response = await http.post(_url, body: OrderModel.toMap(newOrder));
    _orders.insert(0, newOrder);
    final body = jsonDecode(response.body);

    notifyListeners();
  }

  Future<void> fetchOrders() async {
    final response = await http.get(_url);
    final Map<String, Map<String, dynamic>> body = jsonDecode(response.body);
    List<OrderModel> orders = [];
    body.forEach((key, value) {
      orders.add(OrderModel.fromMap(json: value, id: key));
    });
  }
}