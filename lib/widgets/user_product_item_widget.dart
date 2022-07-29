import 'package:flutter/material.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:provider/provider.dart';

class UserProductItemWidget extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;
  const UserProductItemWidget({Key? key, required this.title, required this.imageUrl, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pushNamed(EditProductScreen.routeName, arguments: id),
            icon: Icon(Icons.edit, color: Theme.of(context).primaryColor,)
          ),
          IconButton(
            onPressed: () => context.read<ProductsProvider>().deleteProduct(id),
            icon: Icon(Icons.delete, color: Theme.of(context).errorColor,)
          )
        ],
      ),
    );
  }
}
