import 'package:flutter/material.dart';
import 'Widget.dart';


void showUserReasonForm(BuildContext context,String boxNumber,String slotNumber) {
  showDialog(
      context: context, builder: (BuildContext context) => UserReasonForm(context,boxNumber,slotNumber));
}

class UserReasonForm extends StatelessWidget {

 String boxNumber,slotNumber;
  var _reasonController = new TextEditingController();
  UserReasonForm(BuildContext context,String boxNumber,String slotNumber){
    this.boxNumber=boxNumber;
    this.slotNumber=slotNumber;
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
          onPressed: () {
            showConfirmationDialog(context,this.boxNumber,this.slotNumber,_reasonController.text);
          },
        )
      ],
    );
  }
}
