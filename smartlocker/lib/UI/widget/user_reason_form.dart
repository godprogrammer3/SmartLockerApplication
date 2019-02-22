import 'package:flutter/material.dart';
import 'Widget.dart';
import './../../model/Model.dart';

void showUserReasonForm(BuildContext context,String boxNumber,String slotNumber,String token) {
  showDialog(
      context: context, builder: (BuildContext context) => UserReasonForm(context,boxNumber,slotNumber,token));
}

class UserReasonForm extends StatelessWidget {
 var _requestController = new RequestController();
 String boxNumber,slotNumber;
 String token = '';
 int userId ;
  var _reasonController = new TextEditingController();
  UserReasonForm(BuildContext context,String boxNumber,String slotNumber,String token){
    this.boxNumber=boxNumber;
    this.slotNumber=slotNumber;
    this.token = token;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'เหตุผลในการเปิดตู้',
        style: TextStyle(fontFamily: 'Kanit'),
      ),
      content: Container(
        margin: EdgeInsets.only(bottom: 10.0),
        width: 200,
        height: 124,
        padding: EdgeInsets.all(10.0),
        decoration: new BoxDecoration(color: Colors.grey[100]),
        child: TextField(
            style: TextStyle(
              fontSize: 15.0,
              color: Colors.black,
            ),
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'ระบุ',
                hintStyle: TextStyle(fontFamily: 'Kanit')),
            keyboardType: TextInputType.text,
            controller: _reasonController,
            ),
            
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(
            'ยกเลิก',
            style:TextStyle(color: Colors.red,fontFamily: 'Kanit'),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text(
            'ส่งคำข้อร้อง',
            style: TextStyle(fontFamily: 'Kanit', color: Colors.blueAccent),
          ),
          onPressed: () async {
            showConfirmationDialog(context,token,this.boxNumber,this.slotNumber,_reasonController.text);
          },
        )
      ],
    );
  }
}
