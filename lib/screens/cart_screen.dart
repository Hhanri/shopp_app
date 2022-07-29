import 'package:flutter/material.dart';
import 'package:shop_app/providers/cart_provider.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/widgets/cart_item_widget.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  static const String routeName = "/cart";
  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text("Cart"),),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              margin: const EdgeInsets.all(16),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:[
                    const Text("Total"),
                    const SizedBox(width: 10,),
                    Chip(label: Text("\$ ${cartProvider.totalAmount}")),
                    TextButton(onPressed: () {}, child: const Text("Order"))
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10,),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: cartProvider.cartItems.length,
              itemBuilder: (context, index) {
                final currentCartItem = cartProvider.cartItems.values.toList()[index];
                return CartItemWidget(
                id: currentCartItem.id,
                price: currentCartItem.price,
                quantity: currentCartItem.quantity,
                title: currentCartItem.title
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
