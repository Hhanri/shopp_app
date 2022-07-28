import 'package:flutter/material.dart';
import 'package:shop_app/models/product_model.dart';
import 'package:shop_app/screens/product_detail_screen.dart';
import 'package:provider/provider.dart';

class ProductItemWidget extends StatelessWidget {
  const ProductItemWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final ProductModel product = context.watch<ProductModel>();
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: GridTile(
        footer: GridTileBar(
          title: Text(product.title),
          backgroundColor: Colors.black87,
          leading: IconButton(
            onPressed: () => product.toggleFavoriteStatus(),
            color: Theme.of(context).colorScheme.secondary,
            icon: Icon(product.isFavorite ? Icons.favorite : Icons.favorite_border),
          ),
          trailing: IconButton(
            onPressed: () => product.toggleFavoriteStatus(),
            color: Theme.of(context).colorScheme.secondary,
            icon: const Icon(Icons.shopping_cart),
          ),
        ),
        child: InkWell(
          onTap: () => Navigator.of(context).pushNamed(ProductDetailScreen.routeName, arguments: product.id),
          child: Image.network(product.imageUrl, fit: BoxFit.cover,),
        ),
      ),
    );
  }
}
