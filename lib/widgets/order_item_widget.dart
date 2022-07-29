import 'package:flutter/material.dart';
import 'package:shop_app/models/order_model.dart';
import 'package:intl/intl.dart';

class OrderItemWidget extends StatelessWidget {
  final OrderModel order;
  const OrderItemWidget({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Column(
        children: [
          ListTile(
            title: Text('\$${order.amount}'),
            subtitle: Text(DateFormat('dd MM yyyy hh:mm').format(order.date)),
            trailing: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.expand_more)
            ),
          ),
        ],
      ),
    );
  }
}
