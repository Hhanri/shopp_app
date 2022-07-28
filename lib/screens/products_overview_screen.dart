import 'package:flutter/material.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/widgets/products_grid_widget.dart';
import 'package:provider/provider.dart';

enum FilterOptions {favorites, all}

class ProductsOverviewScreen extends StatefulWidget {
  const ProductsOverviewScreen({Key? key}) : super(key: key);

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {

  bool showFavs = false;

  @override
  Widget build(BuildContext context) {
    final productsProvider = context.read<ProductsProvider>();
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
          )
        ],
      ),
      body: ProductsGridWidget(showFavs: showFavs)
    );
  }
}

