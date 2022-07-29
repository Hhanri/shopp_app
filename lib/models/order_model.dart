import 'package:shop_app/models/cart_model.dart';

class OrderModel {
  final String id;
  final double amount;
  final List<CartItemModel> products;
  final DateTime date;

  OrderModel({required this.id, required this.amount, required this.products, required this.date});
}