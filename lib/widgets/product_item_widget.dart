import 'package:flutter/material.dart';
import 'package:shop_app/models/product_model.dart';

class ProductItemWidget extends StatelessWidget {
  final ProductModel product;
  const ProductItemWidget({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: GridTile(
        footer: GridTileBar(
          title: Text(product.title),
          backgroundColor: Colors.black87,
          leading: IconButton(
            onPressed: () {},
            color: Theme.of(context).colorScheme.secondary,
            icon: const Icon(Icons.favorite),
          ),
          trailing: IconButton(
            onPressed: () {},
            color: Theme.of(context).colorScheme.secondary,
            icon: const Icon(Icons.shopping_cart),
          ),
        ),
        child: Image.network(product.imageUrl, fit: BoxFit.cover,),
      ),
    );
  }
}
