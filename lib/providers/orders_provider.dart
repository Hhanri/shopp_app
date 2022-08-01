import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_app/models/cart_model.dart';
import 'package:shop_app/models/order_model.dart';
import 'package:http/http.dart' as http;

class OrdersProvider with ChangeNotifier {
  final String token;
  final String userId;
  List<OrderModel> _orders = [];

  OrdersProvider(this.token, this.userId, this._orders);

  List<OrderModel> get orders => [..._orders];
  final String _url = "https://shop-app-e09ab-default-rtdb.europe-west1.firebasedatabase.app/orders/";

  Future<void> addOrder(List<CartItemModel> products, double total) async {
    final DateTime now = DateTime.now();
    final newOrder = OrderModel(id: now.toString(), amount: total, products: products, date: now);
    final response = await http.post(
      Uri.parse("$_url$userId.json?auth=$token"),
      body: jsonEncode(OrderModel.toMap(newOrder))
    );
    _orders.insert(0, newOrder);
    notifyListeners();
  }

  Future<void> fetchOrders() async {
    final response = await http.get(Uri.parse("$_url$userId.json?auth=$token"));
    final Map<String, Map<String, dynamic>> body = jsonDecode(response.body);
    List<OrderModel> orders = [];
    body.forEach((key, value) {
      orders.add(OrderModel.fromMap(json: value, id: key));
    });
  }
}