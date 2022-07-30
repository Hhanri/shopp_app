import 'package:shop_app/models/cart_model.dart';

class OrderModel {
  final String id;
  final double amount;
  final List<CartItemModel> products;
  final DateTime date;

  OrderModel({required this.id, required this.amount, required this.products, required this.date});

  static Map<String, dynamic> toMap(OrderModel order) {
    return {
      'amount': order.amount,
      'products': order.products.map((e) => CartItemModel.toMap(e)).toList(),
      'date': order.date.toIso8601String()
    };
  }

  factory OrderModel.fromMap({required Map<String, dynamic> json, required String id}) {
    return OrderModel(
      id: id,
      amount: json['amount'],
      products: (json['products'] as List<Map<String, dynamic>>).map((e) => CartItemModel.fromMap(e)).toList(),
      date: DateTime.parse(json['date'])
    );

  }
}