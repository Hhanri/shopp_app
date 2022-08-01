import 'package:flutter/material.dart';
import 'package:shop_app/providers/auth_provider.dart';
import 'package:shop_app/providers/cart_provider.dart';
import 'package:shop_app/providers/orders_provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/product_detail_screen.dart';
import 'package:shop_app/screens/products_overview_screen.dart';
import 'package:shop_app/screens/user_product_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    final ThemeData theme = ThemeData(
        primarySwatch: Colors.blue,
        colorScheme: const ColorScheme.light().copyWith(secondary: Colors.redAccent),
        fontFamily: "Lato"
    );
    
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, ProductsProvider>(
          create: (context) => ProductsProvider('', []),
          update: (context, auth, previousProducts) => ProductsProvider(auth.token!, previousProducts == null ? [] : previousProducts.products)
        ),
        ChangeNotifierProvider(create: (context) => CartProvider()),
        ChangeNotifierProvider(create: (context) => OrdersProvider())
      ],
      child: Consumer<AuthProvider>(
        builder: (context, auth, child) {
          return MaterialApp(
            title: 'Flutter Demo',
            theme: theme,
            home:  auth.isAuth ? const ProductsOverviewScreen() : const AuthScreen(),
            //initialRoute: auth.isAuth ? ProductsOverviewScreen.routeName : AuthScreen.routeName,
            routes: {
              ProductsOverviewScreen.routeName: (context) => const ProductsOverviewScreen(),
              ProductDetailScreen.routeName: (context) => const ProductDetailScreen(),
              CartScreen.routeName: (context) => const CartScreen(),
              OrdersScreen.routeName: (context) => const OrdersScreen(),
              UserProductScreen.routeName: (context) => const UserProductScreen(),
              EditProductScreen.routeName: (context) => const EditProductScreen(),
              AuthScreen.routeName: (context) => const AuthScreen()
            },
          );
        }
      ),
    );
  }
}
