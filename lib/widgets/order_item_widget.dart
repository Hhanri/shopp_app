import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop_app/models/order_model.dart';
import 'package:intl/intl.dart';

class OrderItemWidget extends StatefulWidget {
  final OrderModel order;
  const OrderItemWidget({Key? key, required this.order}) : super(key: key);

  @override
  State<OrderItemWidget> createState() => _OrderItemWidgetState();
}

class _OrderItemWidgetState extends State<OrderItemWidget> {

  bool isExpanded = false;

  void toggleExpanded() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: isExpanded ? min(widget.order.products.length * 20.0 + 110, 200) : 95,
      child: Card(
        margin: const EdgeInsets.all(8),
        child: Column(
          children: [
            ListTile(
              title: Text('\$${widget.order.amount}'),
              subtitle: Text(DateFormat('dd MM yyyy hh:mm').format(widget.order.date)),
              trailing: IconButton(
                onPressed: toggleExpanded,
                icon: const Icon(Icons.expand_more)
              ),
            ),
            if (isExpanded)
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                height: isExpanded ? min(widget.order.products.length * 20.0 + 10, 130) : 0,
                child: ListView.builder(
                  itemCount: widget.order.products.length,
                  itemBuilder: (context, index) {
                    final currentItem = widget.order.products[index];
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          currentItem.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        Text(
                          '${currentItem.quantity}x \$${currentItem.price}',
                          style: const TextStyle(
                            fontSize: 18
                          ),
                        )
                      ],
                    );
                  },
                ),
              )
          ],
        ),
      ),
    );
  }
}
