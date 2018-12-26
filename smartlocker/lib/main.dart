import 'package:flutter/material.dart';
import 'UI/page/Page.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Smart Locker",
      theme: ThemeData(
         primarySwatch: Colors.deepOrange,
      ),
      //combine those screens
      home: LoginPage(),
    );
  }
}