import 'package:flutter/material.dart';

class UserProductItemWidget extends StatelessWidget {
  final String title;
  final String imageUrl;
  const UserProductItemWidget({Key? key, required this.title, required this.imageUrl}) : super(key: key);

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
          IconButton(onPressed: () {}, icon: Icon(Icons.edit, color: Theme.of(context).primaryColor,)),
          IconButton(onPressed: () {}, icon: Icon(Icons.delete, color: Theme.of(context).errorColor,))
        ],
      ),
    );
  }
}
