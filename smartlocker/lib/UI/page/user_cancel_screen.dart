import 'package:flutter/material.dart';
import '../../model/Model.dart';
import '../widget/Widget.dart';
import '../page/Page.dart';
import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';

class UserCancle extends StatefulWidget {
  String token;
  int requestId;
  FirebaseMessaging _firebaseMessaging= new FirebaseMessaging();
  UserCancle(this.token,this.requestId,this._firebaseMessaging);
  @override
  State<StatefulWidget> createState() {
    return _UserCancelState(token,requestId,_firebaseMessaging);
  }
}

class _UserCancelState extends State<UserCancle> {
  String token;
  int requestId;
   FirebaseMessaging _firebaseMessaging= new FirebaseMessaging();
  _UserCancelState(this.token,this.requestId,this._firebaseMessaging);
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          alignment: Alignment.centerLeft,
          icon: Icon(
            Icons.menu,
            size: 30.0,
          ),
          onPressed: () => _scaffoldKey.currentState.openDrawer(),
        ),
        backgroundColor: Colors.deepOrange,
      ),
      drawer: SideMenuUser(this._firebaseMessaging,1,token),
      body:UserCancleBody(token),
    );
  }
}

class UserCancleBody extends StatefulWidget{
  String token;
  UserCancleBody(this.token);
  @override
  State<StatefulWidget> createState() {
    return UserCancleBodyState();
  }

}

class UserCancleBodyState extends State<UserCancleBody>{
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('คืนตู้')
          ],
        )
      ],
    );
  }

}


