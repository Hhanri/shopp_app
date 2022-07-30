import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/order_model.dart';
import 'package:shop_app/providers/orders_provider.dart';
import 'package:shop_app/widgets/drawer_widget.dart';
import 'package:shop_app/widgets/order_item_widget.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  static const String routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your orders"),
      ),
      drawer: const DrawerWidget(),
      body: FutureBuilder<void>(
        future: context.read<OrdersProvider>().fetchOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(),);
          }
          return Consumer<OrdersProvider>(
            builder:(context, ordersProvider, child) {
              return  ListView.builder(
                itemCount: ordersProvider.orders.length,
                itemBuilder: (context, index) {
                  final currentOrder = ordersProvider.orders[index];
                  return OrderItemWidget(order: currentOrder);
                },
              );
            }
          );
        }
      )
    );
  }
}
