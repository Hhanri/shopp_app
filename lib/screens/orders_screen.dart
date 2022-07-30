import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders_provider.dart';
import 'package:shop_app/widgets/drawer_widget.dart';
import 'package:shop_app/widgets/order_item_widget.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  static const String routeName = '/orders';

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {

  bool loading = false;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) async {
      setState(() {
        loading = true;
      });
      await context.read<OrdersProvider>().fetchOrders();
      setState(() {
        loading = false;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ordersProvider = context.read<OrdersProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your orders"),
      ),
      drawer: const DrawerWidget(),
      body: loading
       ? const Center(child: CircularProgressIndicator(),)
       : ListView.builder(
           itemCount: ordersProvider.orders.length,
           itemBuilder: (context, index) {
             final currentOrder = ordersProvider.orders[index];
             return OrderItemWidget(order: currentOrder);
         },
      ),
    );
  }
}
