import 'package:flutter/material.dart';

class CartItemWidget extends StatelessWidget {
  final String id;
  final double price;
  final int quantity;
  final String title;
  const CartItemWidget({Key? key, required this.id, required this.price, required this.quantity, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: ListTile(
          subtitle: Text('\$$price'),
          title: Text(title),
          leading: Text("Total \$${[price*quantity]}"),
          trailing: Text('Quantity: $quantity'),
        ),
      ),
    );
  }
}
