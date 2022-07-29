import 'package:flutter/material.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/products_overview_screen.dart';
import 'package:shop_app/screens/user_product_screen.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text("Shop App"),
            automaticallyImplyLeading: false,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.shop),
            title: const Text("Shop"),
            onTap: () => Navigator.of(context).pushReplacementNamed(ProductsOverviewScreen.routeName),
          ),
          ListTile(
            leading: const Icon(Icons.shop),
            title: const Text("Shop"),
            onTap: () => Navigator.of(context).pushReplacementNamed(ProductsOverviewScreen.routeName),
          ),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text("Orders"),
            onTap: () => Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName),
          ),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text("Orders"),
            onTap: () => Navigator.of(context).pushReplacementNamed(UserProductScreen.routeName),
          )
        ],
      ),
    );
  }
}
