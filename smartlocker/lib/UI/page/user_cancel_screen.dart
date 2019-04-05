import 'package:flutter/material.dart';
import '../../model/Model.dart';
import '../widget/Widget.dart';
import '../page/Page.dart';
import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';

class UserCancle extends StatefulWidget {
  String token;
  int requestId;
  int lockerNumber;
  int boxNumber;
  FirebaseMessaging _firebaseMessaging= new FirebaseMessaging();
  UserCancle(this.token,this.requestId,this._firebaseMessaging,this.lockerNumber,this.boxNumber);
  @override
  State<StatefulWidget> createState() {
    return _UserCancelState(token,requestId,_firebaseMessaging,this.lockerNumber,this.lockerNumber);
  }
}

class _UserCancelState extends State<UserCancle> {
  String token;
  int requestId;
  int lockerNumber;
  int boxNumber;
   FirebaseMessaging _firebaseMessaging= new FirebaseMessaging();
  _UserCancelState(this.token,this.requestId,this._firebaseMessaging,this.lockerNumber,this.boxNumber);
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
      body:UserCancleBody(token,requestId,this.lockerNumber,this.boxNumber),
    );
  }
}

class UserCancleBody extends StatefulWidget{
  String token;
  int requestId;
  int lockerNumber;
  int boxNumber;
  UserCancleBody(this.token,this.requestId,this.lockerNumber,this.boxNumber);
  @override
  State<StatefulWidget> createState() {
    return UserCancleBodyState(token,requestId,this.lockerNumber,this.boxNumber);
  }

}

class UserCancleBodyState extends State<UserCancleBody>{
  String token;
  int requestId;
  int lockerNumber;
  int boxNumber;
  var _requestController = new RequestController();
  var _lockerController = new LockerController();
  UserCancleBodyState(this.token,this.requestId,this.lockerNumber,this.boxNumber);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
             Icon(
              Icons.exit_to_app,
              color:Colors.blueAccent,
              size: 120,
              ),
            RaisedButton(
                  child: Text(
                    'คืนอุปกรณ์',
                    style: TextStyle(fontFamily: 'Kanit',fontSize: 30),
                    
                  ),
                  onPressed: () {
                   _showAlertDialog(context);
                  },
                ),
          ],
        )
      ],
    );
  }
   void _showAlertDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
            title: Text(
              'ยืนยัน\nจะคืนอุปกรณ์ใช้หรือไม่',
              style: TextStyle(fontFamily: 'Kanit'),
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FlatButton(
                  child: Text(
                    'ไม่ใช่',
                    style: TextStyle(
                        fontFamily: 'Kanit', color: Colors.blueAccent),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text(
                    'ใช่',
                    style: TextStyle(
                        fontFamily: 'Kanit', color: Colors.blueAccent),
                  ),
                  onPressed: () async {  
                    print("requestId :"+requestId.toString());
                    Map result = await _lockerController.update(token, lockerNumber, boxNumber, 'close');
                    print(result);
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomeUser(token)));
                  },
                ),
              ],
            )));
  }
}


