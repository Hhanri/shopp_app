import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/widgets/drawer_widget.dart';
import 'package:shop_app/widgets/user_product_item_widget.dart';

class UserProductScreen extends StatelessWidget {
  const UserProductScreen({Key? key}) : super(key: key);

  static const String routeName = '/userProducts';

  @override
  Widget build(BuildContext context) {
    final productsProvider = context.watch<ProductsProvider>();

    return Scaffold(
      drawer: const DrawerWidget(),
      appBar: AppBar(
        title: const Text("Your products"),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).pushNamed(EditProductScreen.routeName),
            icon: const Icon(Icons.add)
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: productsProvider.products.length,
          itemBuilder: (context, index) {
            final currentProduct = productsProvider.products[index];
            return UserProductItemWidget(title: currentProduct.title, imageUrl: currentProduct.imageUrl, id: currentProduct.id);
          },
        ),
      ),
    );
  }
}
