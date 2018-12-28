import 'package:flutter/material.dart';
import 'Page.dart';
import 'dart:async';
import '../../model/Model.dart';
Timer userResultTimerController;
class ResultUser extends StatefulWidget {
  ResultUser({Key key, this.boxNumber,this.slotNumber,this.requestId}) : super(key: key);
  final String boxNumber;
  final String slotNumber;
  final String requestId;
  @override
  State<StatefulWidget> createState() {
    return _ResultUserState(boxNumber: boxNumber,slotNumber: slotNumber,requestId:requestId);
  }
}
enum state{
    running,
    stop,
}
class _ResultUserState extends State<ResultUser> {
  int _result;
  state _currentState;
  int _countState;
  IconData _showIcon;
  Color _iconColor ;
  String _displayText1 ;
  String _displayText2;
  String _displayText3;
  _ResultUserState({Key key, this.boxNumber,this.slotNumber,this.requestId});
  String boxNumber;
  String slotNumber;
  String requestId;
  var _requestController = new RequestController();
  @override
  void initState(){
    _result = 0;
    _showIcon = Icons.query_builder;
    _iconColor = Colors.yellow;
    _displayText1 = 'ยังไม่ถูกอนุมัติ';
    _displayText2 = 'กรุณารอการอนุมัติจากแอดมิน';
    _displayText3 = 'ยกเลิกขอเปิดตู้';
    _currentState = state.running;
    _countState = 0;
    const millis = const Duration(milliseconds: 500);
    userResultTimerController = new Timer.periodic(millis,(Timer t)=>updateState(t));  
  }
  void onChanged() {
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
        _displayText3 = 'กลับสู่หน้าแรก';
      } else if (_result == 2) {
        _showIcon = Icons.check_circle_outline;
        _iconColor = Colors.green;
        _displayText1 = 'ถูกอนุมัติแล้ว';
        _displayText2 = '';
        _displayText3 = 'เปิดตู้';
      }
    });
  }

  updateState(Timer t) async {
    if(_currentState == state.running)
    {
      print(_countState++);
      Map result = await _requestController.userGet(requestId,0) as Map;
      print(result);
      if(result['status']=='1')
      {
        _result = 2;
        onChanged();
        userResultTimerController.cancel();
      }
      else if(result['status']=='-1')
      {
        _result = 1;
        onChanged();
        userResultTimerController.cancel();
      }
    }
    else
    {
      userResultTimerController.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
    onWillPop: () async {
      await userResultTimerController.cancel();
      Navigator.of(context).pop();
    },
    child: Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            Icon(
              _showIcon,
              size: 160.0,
              color: _iconColor,
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
                onPressed: () async {
                  if (_result == 0) {
                    _showAlertDialog(context,0);
                  }else if(_result == 1)
                  {
                    timerController.cancel();
                    await _requestController.userGet(requestId, 5);
                    _currentState = state.stop;
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomeUser()));
                  }else if(_result == 2){
                    _showAlertDialog(context,1);
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

  void _showAlertDialog(BuildContext context,int query) {
    String _displayText;
    if(query==0)
    {
      _displayText = 'ยืนยัน\nจะยกเลิกการเปิดตู้นี้ใช่หรือไม่';
    }else if(query == 1){
      _displayText = 'ยืนยัน\nจะเปิดตู้นี้ใช่หรือไม่';
    }
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
            title: Text(
              _displayText,
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
                    userResultTimerController.cancel();
                    await _requestController.userGet(requestId, 5);
                    _currentState = state.stop;
                    await _requestController.adminSent(requestId, 5);
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomeUser()));

                  },
                ),
              ],
            )));
  }
}
