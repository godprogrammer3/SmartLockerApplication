import 'package:flutter/material.dart';
import 'UI/page/Page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:event_bus/event_bus.dart';
EventBus eventBus = EventBus();
void main(){
  FirebaseMessaging _firebaseMessaging= new FirebaseMessaging();
  _firebaseMessaging.configure( 
      onMessage: (Map<String,dynamic> message)  async {
        print('on message main $message');  
        Map data = new Map();
        data = message['data'];
        data['eventType'] = 'fcmUpdate';
        eventBus.fire(data);
      },
      onResume: (Map<String,dynamic> message) async  {
        print('on resume main $message');
         Map data = new Map();
        data = message['data'];
        data['eventType'] = 'fcmUpdate';
        eventBus.fire(data);
      },
      onLaunch: (Map<String,dynamic> message) async  {
        print('on resume main $message');
        Map data = new Map();
        data = message['data'];
        data['eventType'] = 'fcmUpdate';
        eventBus.fire(data);
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
      ),  //combine those screens
      home: LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}