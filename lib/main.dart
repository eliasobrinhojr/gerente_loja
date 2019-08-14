import 'package:flutter/material.dart';
import 'package:gerente_loja/screens/login_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter demo",
      theme: ThemeData(primaryColor: Colors.pinkAccent),
      debugShowCheckedModeBanner: false,
      home: LoginScreen()
    );
  }
}
