import 'package:flutter/material.dart';
import 'package:shop_app/models/product_model.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/widgets/product_item_widget.dart';
import 'package:provider/provider.dart';

class ProductsGridWidget extends StatelessWidget {
  const ProductsGridWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<ProductModel> products = context.watch<ProductsProvider>().products;
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3/2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10
      ),
      itemBuilder: (context, index) {
        return ProductItemWidget(product: products[index]);
      }
    );
  }
}
