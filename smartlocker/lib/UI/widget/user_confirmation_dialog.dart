import 'package:flutter/material.dart';
import '../page/user_result_screen.dart';

void showConfirmationDialog(BuildContext context,String boxNumber,String slotNumber) {
    showDialog(
        context: context,
        builder: (BuildContext context) => UserConfirmationDialog(context,boxNumber,slotNumber));
}

class UserConfirmationDialog extends StatelessWidget{

  String boxNumber;
  String slotNumber;

  UserConfirmationDialog(BuildContext context, String boxNumber,String slotNumber){
    this.boxNumber=boxNumber;
    this.slotNumber=slotNumber;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
            title: Text(
              'ยืนยัน\nจะขอเปิดตู้นี้ใช่หรือไม่',
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
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ResultUser(
                                boxNumber: this.boxNumber,
                                slotNumber: this.slotNumber)));
                  },
                ),
              ],
            ));
  }
}