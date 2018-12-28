import 'package:flutter/material.dart';
import 'Widget.dart';
import '../../model/Model.dart';

void showAdminConfirm(BuildContext context,String boxNumber,String slotNumber,String userName,String time,String reason,String requestId) {
  showDialog(
      context: context, builder: (BuildContext context) => AddminConfirm(context,boxNumber,slotNumber,userName,time,reason,requestId));
}

class AddminConfirm extends StatelessWidget {
  String boxNumber,slotNumber,userName,time,reason,requestId;
  AddminConfirm(BuildContext context,String boxNumber,String slotNumber,String userName,String time,String reason,String requestId){
    this.boxNumber=boxNumber;
    this.slotNumber=slotNumber;
    this.userName = userName;
    this.time = time;
    this.reason = reason;
    this.requestId = requestId;
  }
  var _requestController = new RequestController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('ชื่อผู้ใช้ : '+userName+'\n'+'เวลา : '+time+'\n'+'เหตุผลในการเปิดตู้ : ',
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
          onPressed: () {
            _requestController.adminSent(requestId, 0);
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text(
            'อนุมัติ',
            style:TextStyle(color: Colors.green,fontFamily: 'Kanit'),
          ),
          onPressed: () {
            _requestController.adminSent(requestId, 2);
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
