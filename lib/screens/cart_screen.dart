import 'package:flutter/material.dart';
import 'package:shop_app/providers/cart_provider.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders_provider.dart';
import 'package:shop_app/widgets/cart_item_widget.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  static const String routeName = "/cart";
  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();
    final ordersProvider = context.read<OrdersProvider>();
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
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:[
                    const Text("Total"),
                    const SizedBox(width: 10,),
                    Chip(label: Text("\$ ${cartProvider.totalAmount}")),
                    OrderButton(cartProvider: cartProvider, ordersProvider: ordersProvider)
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
                productId: cartProvider.cartItems.keys.toList()[index],
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

class OrderButton extends StatefulWidget {
  final CartProvider cartProvider;
  final OrdersProvider ordersProvider;
  const OrderButton({Key? key, required this.cartProvider, required this.ordersProvider}) : super(key: key);

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: widget.cartProvider.totalAmount <= 0
        ? () {}
        : () async {
          setState(() {
            isLoading = true;
          });
          await widget.ordersProvider.addOrder(widget.cartProvider.cartItems.values.toList(), widget.cartProvider.totalAmount);
          widget.cartProvider.clearCart();
          setState(() {
            isLoading = false;
          });
        },
        child: isLoading ? const Center(child: CircularProgressIndicator(),) : const Text("Order")
    )
    ;
  }
}
