import 'package:flutter/material.dart';
import 'package:shop_app/providers/cart_provider.dart';
import 'package:provider/provider.dart';

class CartItemWidget extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;
  const CartItemWidget({Key? key, required this.id, required this.productId, required this.price, required this.quantity, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    void onDismissed(DismissDirection direction) => context.read<CartProvider>().removeItem(productId);

    Future<bool> confirmDismiss(DismissDirection direction) async {
       return await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Are you sure ?"),
          content: const Text("Do you want to remove this item from the cart ?"),
          actions: [
            TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text("No")),
            TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text("Yes")),
          ],
        )
      );
    }

    const EdgeInsets margin = EdgeInsets.symmetric(horizontal: 16, vertical: 4);
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        margin: margin,
        color: Theme.of(context).errorColor,
        alignment: Alignment.centerRight,
        child: const Icon(Icons.delete),
      ),
      confirmDismiss: confirmDismiss,
      onDismissed: onDismissed,
      direction: DismissDirection.endToStart,
      child: Card(
        margin: margin,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListTile(
            subtitle: Text('\$$price'),
            title: Text(title),
            leading: Text("Total \$${[price*quantity]}"),
            trailing: Text('Quantity: $quantity'),
          ),
        ),
      ),
    );
  }
}
