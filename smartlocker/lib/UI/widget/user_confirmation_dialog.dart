import 'package:flutter/material.dart';
import '../page/Page.dart';
import '../../model/Model.dart';
void showConfirmationDialog(BuildContext context,String boxNumber,String slotNumber,String description) {
    showDialog(
        context: context,
        builder: (BuildContext context) => UserConfirmationDialog(context,boxNumber,slotNumber,description));
}

class UserConfirmationDialog extends StatelessWidget{
  String boxNumber;
  String slotNumber;
  String description;
  UserConfirmationDialog(BuildContext context, String boxNumber,String slotNumber,String description){
    this.boxNumber=boxNumber;
    this.slotNumber=slotNumber;
    this.description = description;
  }
  var _requestController = new RequestController();
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
                  onPressed: () async {
                    Map result = await _requestController.userSent('user',boxNumber,slotNumber,description,0);
                    print(result);
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ResultUser(
                                boxNumber: this.boxNumber,
                                slotNumber: this.slotNumber,
                                requestId: result['request_id'],
                                )));
                  },
                ),
              ],
            ));
  }
}