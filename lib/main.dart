import 'package:flutter/material.dart';

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
    return MaterialApp(
      title: 'Flutter Demo',
      theme: theme,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

