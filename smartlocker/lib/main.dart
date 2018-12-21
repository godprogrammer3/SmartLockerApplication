import 'package:flutter/material.dart';
import 'UI/page/user_screen.dart';
import 'UI/page/admin_screen.dart';
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
      home: listPage(),
    );
  }
}

class listPage extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
              child: Text('ไปหน้าผู้ใช้'),
              onPressed: ((){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                    builder:(context) => HomeUser(),
                ),
                );
              }),
              ),
               RaisedButton(
              child: Text('ไปหน้าแอดมิน'),
              onPressed: ((){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                    builder:(context) => HomeAdmin(),
                ),
                );
              }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}