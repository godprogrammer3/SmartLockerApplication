import 'package:flutter/material.dart';
import 'package:smartlocker/main.dart';
import 'Widget.dart';
import '../../model/Model.dart';

void showAdminConfirm(BuildContext context,String token ,String userName,String time,String reason,int requestId,int lockerNumber,int boxNumber) {
  showDialog(
      context: context, builder: (BuildContext context) => AddminConfirm(context,token,userName,time,reason,requestId,lockerNumber,boxNumber));
}

class AddminConfirm extends StatelessWidget {
  String token,userName,time,reason;
  int requestId,lockerNumber,boxNumber;
  AddminConfirm(BuildContext context,token,String userName,String time,String reason,int requestId,int lockerNumber,int boxNumber){
    this.token = token;
    this.userName = userName;
    this.time = time;
    this.reason = reason;
    this.requestId = requestId;
    this.lockerNumber = lockerNumber;
    this.boxNumber = boxNumber;
  }
  var _requestController = new RequestController();
  var _lockerController = new LockerController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('ชื่อผู้ใช้ : '+userName+'\n'+'เวลา : '+time.substring(0,10)+" "+time.substring(11,19)+'\n'+'เหตุผลในการเปิดตู้ : ',
        style: TextStyle(fontFamily: 'Kanit'),
      ),
      content: Container(
        margin: EdgeInsets.only(bottom: 10.0),
        width: 200,
        height: 124,
        padding: EdgeInsets.all(10.0),
        decoration: new BoxDecoration(color: Colors.grey[100]),
        child: Text(reason),
            
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(
            'ไม่อนุมัติ',
            style:TextStyle(color: Colors.red,fontFamily: 'Kanit'),
          ),
          onPressed: () async {

            Map requestResult = await _requestController.update(token,requestId,'reject') as Map;
            if(requestResult['success']== true){
              print(requestResult['message']);
            }else{
              print(requestResult['error']);
            }
            Map message = new Map();
            message['eventType'] = 'replyState';
            message['boxNumber'] = boxNumber.toString();
            message['boxState'] = 'close';
            message['lockerNumber'] = lockerNumber.toString();
            eventBus.fire(message);
            Navigator.of(context).pop();
            
          },
        ),
        FlatButton(
          child: Text(
            'อนุมัติ',
            style:TextStyle(color: Colors.green,fontFamily: 'Kanit'),
          ),
          onPressed: () async {
            Map requestResult = await _requestController.update(token,requestId,'approve') as Map;
            if(requestResult['success']== true){
              print(requestResult);
            }else{
              print(requestResult['error']);
            }
            Map lockerResult = await _lockerController.update(token,lockerNumber,boxNumber,'open') as Map;
            if(lockerResult['success']== true){
              print(lockerResult);
            }else{
              print(lockerResult['error']);
            }
             Map message = new Map();
            message['eventType'] = 'replyState';
            message['boxNumber'] = boxNumber.toString();
            message['boxState'] = 'open';
            message['lockerNumber'] = lockerNumber.toString();
            eventBus.fire(message);
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text(
            'ยกเลิก',
            style: TextStyle(fontFamily: 'Kanit', color: Colors.blueAccent),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}
