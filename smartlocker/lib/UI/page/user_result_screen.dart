import 'package:flutter/material.dart';
import 'dart:async';

class ResultUser extends StatefulWidget{
  ResultUser({Key key,this.boxNumber}):super(key:key);
  String boxNumber;
  @override
  State<StatefulWidget> createState() {
    return _ResultUserState(boxNumber: boxNumber);
  }
}

class _ResultUserState extends State<ResultUser>{
  int _result = 0;
  IconData _showIcon = Icons.query_builder;
  Color _iconColor =  Colors.yellow;
  String _displayText1 = 'ยังไม่ถูกอนุมัติ';
  String _displayText2 = 'กรุณารอการอนุมัติจากแอดมิน';
  String _displayText3 = 'ยกเลิกขอเปิดตู้';
  _ResultUserState({Key key,this.boxNumber});
  String boxNumber;
  void onChanged(){
    _result++;
    _result%=3;
    setState(() {
      if(_result == 0) {
        _showIcon = Icons.query_builder;
        _iconColor = Colors.yellow;
        _displayText1 = 'ยังไม่ถูกอนุมัติ';
        _displayText2 = 'กรุณารอการอนุมัติจากแอดมิน';
        _displayText3 = 'ยกเลิกขอเปิดตู้';
      }
      else if(_result == 1){
        _showIcon = Icons.highlight_off;
        _iconColor = Colors.red;
        _displayText1 = 'แอดมินไม่อนุมัติ';
        _displayText2 = '';
        _displayText3 = 'กลับสู่หน้าแรก';
      }
      else if(_result == 2){
        _showIcon = Icons.check_circle_outline;
        _iconColor = Colors.green;
        _displayText1 = 'ถูกอนุมัติแล้ว';
        _displayText2 = '';
        _displayText3 = 'เปิดตู้';
      }
    });
  }
  Future time(int time2) async {
    Completer c = new Completer();
    new Timer(new Duration(seconds: time2), (){
      print('HelloTimeout');
      time(time2);
    });
    return c.future;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
         body: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           children: <Widget>[
             Row(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: <Widget>[
                   Icon(_showIcon,
                     size: 160.0,
                     color: _iconColor,
                   ),
                 ]
             ),
             Row(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: <Widget>[
                   Column(
                     children: <Widget>[
                       Container(
                         child:  Text('ตู้หมายเลข $boxNumber',
                           style:TextStyle(
                             fontSize: 20.0,
                           ),
                           overflow: TextOverflow.clip,
                         ),
                       ),
                     ],
                   ),
                 ]
             ),
             Row(
               mainAxisAlignment: MainAxisAlignment.center,
               children: <Widget>[
                 Flexible(
                   child:Container(
                     child: Text(_displayText1,
                       style:TextStyle(
                         fontSize: 20.0,
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
                   child:Container(
                     child: Text(_displayText2,
                       style:TextStyle(
                         fontSize: 20.0,
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
                   child: Text(_displayText3),
                   onPressed: onChanged,
                 ),
               ],
             ),
           ],
         ),
    );
  }
}