import 'package:flutter/material.dart';
import 'package:shop_app/providers/cart_provider.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/widgets/badge_widget.dart';
import 'package:shop_app/widgets/products_grid_widget.dart';
import 'package:provider/provider.dart';

enum FilterOptions {favorites, all}

class ProductsOverviewScreen extends StatefulWidget {
  const ProductsOverviewScreen({Key? key}) : super(key: key);

  static const String routeName = '/overview';

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {

  bool showFavs = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Shop"),
        actions: [
          PopupMenuButton(
            onSelected: (FilterOptions selectedOption) {
              setState(() {
                if (selectedOption == FilterOptions.favorites) {
                  showFavs = true;
                } else {
                  showFavs = false;
                }
              });
            },
            itemBuilder: (context) {
              return [
                const PopupMenuItem(value: FilterOptions.favorites, child: Text("Only Favorites")),
                const PopupMenuItem(value: FilterOptions.all, child: Text("All"))
              ];
            },
          ),
          Consumer<CartProvider>(
            builder: (context, cart, child) {
              return BadgeWidget(
                value: cart.itemCount.toString(),
                child: child!,
              );
            },
            child: IconButton(onPressed: () => Navigator.of(context).pushNamed(CartScreen.routeName), icon: const Icon(Icons.shopping_cart)),
          )
        ],
      ),
      body: ProductsGridWidget(showFavs: showFavs)
    );
  }
}

