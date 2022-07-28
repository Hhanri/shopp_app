import 'package:flutter/material.dart';
import 'package:shop_app/models/product_model.dart';
import 'package:shop_app/providers/cart_provider.dart';
import 'package:shop_app/screens/product_detail_screen.dart';
import 'package:provider/provider.dart';

class ProductItemWidget extends StatelessWidget {
  const ProductItemWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final ProductModel product = context.read<ProductModel>();
    final CartProvider cartProvider = context.read<CartProvider>();
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: GridTile(
        footer: GridTileBar(
          title: Text(product.title),
          backgroundColor: Colors.black87,
          leading: IconButton(
            onPressed: () => product.toggleFavoriteStatus(),
            color: Theme.of(context).colorScheme.secondary,
            icon: Consumer<ProductModel>(
              builder: (context, product, child) {
                return Icon(product.isFavorite ? Icons.favorite : Icons.favorite_border);
              },
            ),
          ),
          trailing: IconButton(
            onPressed: () => cartProvider.addCartItem(id: product.id, price: product.price, title: product.title),
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
