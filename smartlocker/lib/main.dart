import 'package:flutter/material.dart';
import 'UI/page/Page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
void main(){
  FirebaseMessaging _firebaseMessaging= new FirebaseMessaging();
  _firebaseMessaging.configure(
      onMessage: (Map<dynamic,dynamic> message)  async {
        print('on message main $message');
      },
      onResume: (Map<dynamic,dynamic> message) async  {
        print('on resume main $message');
      },
      onLaunch: (Map<dynamic,dynamic> message)  async {
        print('on launch main $message');
      }
  );
  runApp(MyApp());
} 
class MyApp extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
 
}

class MyAppState extends State<MyApp>{
  void initState(){
    super.initState();
  }
    
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Smart Locker",
      theme: ThemeData(
         primarySwatch: Colors.deepOrange,
      ),
      //combine those screens
      home: LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}