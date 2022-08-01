import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/product_model.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/widgets/drawer_widget.dart';
import 'package:shop_app/widgets/user_product_item_widget.dart';

class UserProductScreen extends StatelessWidget {
  const UserProductScreen({Key? key}) : super(key: key);

  static const String routeName = '/userProducts';

  Future<void> _refresh(BuildContext context) async {
    await context.read<ProductsProvider>().fetchProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    final productsProvider = context.read<ProductsProvider>();

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
      body: FutureBuilder<void>(
        future: _refresh(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(),);
          }
          return RefreshIndicator(
            onRefresh: () => _refresh(context),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Consumer<ProductsProvider>(
                  builder: (context, products, child) {
                    return ListView.builder(
                      itemCount: products.products.length,
                      itemBuilder: (context, index) {
                        final currentProduct = products.products[index];
                        return UserProductItemWidget(title: currentProduct.title, imageUrl: currentProduct.imageUrl, id: currentProduct.id);
                      },
                    );
                  }
              ),
            ),
          );
        }
      ),
    );
  }
}
