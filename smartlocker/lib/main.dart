import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'UI/page/Page.dart';
import 'model/Model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:event_bus/event_bus.dart';

EventBus eventBus = EventBus();
void main() async {
  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  _firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) async {
    print('on message main $message');
    Map data = new Map();
    data = message['data'];
    data['eventType'] = 'fcmUpdate';
    eventBus.fire(data);
  }, onResume: (Map<String, dynamic> message) async {
    print('on resume main $message');
    Map data = new Map();
    data = message['data'];
    data['eventType'] = 'fcmUpdate';
    eventBus.fire(data);
  }, onLaunch: (Map<String, dynamic> message) async {
    print('on resume main $message');
    Map data = new Map();
    data = message['data'];
    data['eventType'] = 'fcmUpdate';
    eventBus.fire(data);
  });

  var _userController = new UserController();
  Widget page;

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool state = prefs.getBool('stateAutoLogin');
  String user = prefs.getString('user');
  String password = prefs.getString('password');
//   print(state);
// print(user);
// print(password);
  if (state) {
    Map<String, dynamic> result =
        await _userController.login(user, password) as Map<String, dynamic>;
    print(result);
    
      if (result['success'] == true) {
        if (result['user']['RoleId'] == 2) {
          page=HomeUser(result['token']);
        } else if (result['user']['RoleId'] == 1) {
          page=HomeAdmin(result['token']);
        }
      }
    
  } else {
    page = LoginPage();
    
  }
  print(page);
  runApp(MyApp(page));
}

class MyApp extends StatefulWidget {
  Widget page;
  MyApp(this.page);
  @override
  State<StatefulWidget> createState() {
    return MyAppState(page);
  }
}

class MyAppState extends State<MyApp> {
  Widget page;

  MyAppState(this.page);
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Smart Locker",
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ), //combine those screens
      home: page,
      // home: LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
