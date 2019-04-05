import 'package:flutter/material.dart';
import 'Page.dart';
import 'dart:async';
import '../../model/Model.dart';
import 'package:flutter_svg/svg.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
class ResultUser extends StatefulWidget {
  ResultUser({Key key, this.token,this.requestId, this.boxNumber,this.slotNumber}) : super(key: key);
  final String boxNumber;
  final String slotNumber;
  final String token;
  final int requestId;
 
  @override
  State<StatefulWidget> createState() {
    return _ResultUserState(boxNumber: boxNumber,slotNumber: slotNumber,token:token,requestId:requestId);
  }
}
enum state{
    running,
    stop,
}
class _ResultUserState extends State<ResultUser> {
  int _result = 0;
  int requestId;
  state _currentState;
  IconData _showIcon;
  Color _iconColor ;
  String _displayText1 ;
  String _displayText2;
  String _displayText3;
  _ResultUserState({Key key, this.boxNumber,this.slotNumber,this.token,this.requestId});
  String boxNumber;
  String slotNumber;
  String token;
  FirebaseMessaging _firebaseMessaging= new FirebaseMessaging();
  var _requestController = new RequestController();
  var _userController = new UserController();
  @override
  void initState() {
    super.initState();
    _result = 0;
    _showIcon = Icons.query_builder;
    _iconColor = Colors.yellow;
    _displayText1 = 'ยังไม่ถูกอนุมัติ';
    _displayText2 = 'กรุณารอการอนุมัติจากแอดมิน';
    _displayText3 = 'ยกเลิกขอเปิดตู้';
     _firebaseMessaging.configure(
        onMessage: (Map<String,dynamic> message)  async {
          print('on message result $message');
          if(message['data']['requestState']=='wait'){
            _result = 0;
          }else if(message['data']['requestState']=='reject'){
            _result = 1;
          }else if(message['data']['requestState']=='approve'){
            _result = 2;
          }else if(message['data']['requestState']=='timeout'){
            _result = 3;
          }
          onChanged();
        },
        onResume: (Map<String,dynamic> message) async  {
          print('on resume result $message');
          if(message['data']['requestState']=='wait'){
            _result = 0;
          }else if(message['data']['requestState']=='reject'){
            _result = 1;
          }else if(message['data']['requestState']=='approve'){
            _result = 2;
          }else if(message['data']['requestState']=='timeout'){
            _result = 3;
          }
          onChanged();
        },
  );
  }
  @override
  void dispose(){
    super.dispose();
  }
  void onChanged() {
    if(this.mounted){
      setState(() {
      if (_result == 0) {
        _showIcon = Icons.query_builder;
        _iconColor = Colors.yellow;
        _displayText1 = 'ยังไม่ถูกอนุมัติ';
        _displayText2 = 'กรุณารอการอนุมัติจากแอดมิน';
        _displayText3 = 'ยกเลิกขอเปิดตู้';
      } else if (_result == 1) {
        _showIcon = Icons.highlight_off;
        _iconColor = Colors.red;
        _displayText1 = 'แอดมินไม่อนุมัติ';
        _displayText2 = '';
        _displayText3 = 'กลับสู่หน้าหลัก';
      } else if (_result == 2) {
        _showIcon = Icons.check_circle_outline;
        _iconColor = Colors.green;
        _displayText1 = 'ถูกอนุมัติแล้ว';
        _displayText2 = '';
        _displayText3 = 'กลับสู่หน้าหลัก';
      }else if( _result == 3){
        _showIcon = Icons.timer_off;
        _iconColor = Colors.red;
        _displayText1 = 'คำร้องขอหมดอายุ';
        _displayText2 = '';
        _displayText3 = 'กลับสู่หน้าหลัก';
      }
    });  
    }
  }

  

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
    onWillPop: (){
      _showAlertDialog(context);
    },
    child: Scaffold(
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: (){
            _showAlertDialog(context);
            }
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            Icon(
              _showIcon,
              color:_iconColor,
              size: 120,
              ),
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  child: Text(
                    'ตู้หมายเลข $boxNumber ช่องที่ $slotNumber',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontFamily: 'Kanit'
                    ),
                    overflow: TextOverflow.clip,
                  ),
                ),
              ],
            ),
          ]),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Flexible(
                child: Container(
                  child: Text(
                    _displayText1,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontFamily: 'Kanit'
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Flexible(
                child: Container(
                  child: Text(
                    _displayText2,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontFamily: 'Kanit'
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                child: Text(_displayText3,style: TextStyle(fontFamily: 'Kanit'),),
                onPressed: (){
                  if (_result == 0) {
                    _showAlertDialog(context);
                  }else{
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomeUser(token)));
                  }
                },
              ),
            ],
          ),
        ],
      ),
    ),
    );
  }

  void _showAlertDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
            title: Text(
              'ยืนยัน\nจะยกเลิกการเปิดตู้นี้ใช่หรือไม่',
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
                    await _requestController.update(token,requestId, 'cancel');
                    Navigator.of(context).pop();
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
