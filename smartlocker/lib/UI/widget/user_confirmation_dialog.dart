import 'package:flutter/material.dart';
import '../page/Page.dart';
import '../../model/Model.dart';
void showConfirmationDialog(BuildContext context,String token,String boxNumber,String slotNumber,String reason) {
    showDialog(
        context: context,
        builder: (BuildContext context) => UserConfirmationDialog(context,token,boxNumber,slotNumber,reason));
}

class UserConfirmationDialog extends StatelessWidget{
  String token;
  String boxNumber;
  String slotNumber;
  String reason;
  UserConfirmationDialog(BuildContext context, String token,String boxNumber,String slotNumber,String reason){
    this.token = token;
    this.boxNumber=boxNumber;
    this.slotNumber=slotNumber;
    this.reason= reason;
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
              mainAxisAlignment:MainAxisAlignment.spaceBetween,
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
                      Map result = await _requestController.create(token,int.parse(boxNumber),int.parse(slotNumber),reason);
                      print(result);
                      if(result['success']==true){
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ResultUser(
                                  boxNumber: this.boxNumber,
                                  slotNumber: this.slotNumber,
                                  token: this.token,
                                  requestId: result['id'],
                                  )));
                      }else{
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        _showAlertDialog(context);
                      }
                        
                 
                    
                    
                  },
                ),
              ],
            ));
  }
  void _showAlertDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
            title: Text(
              'เกิดข้อผิดพลาดในการดำเนินการ !',
              style: TextStyle(fontFamily: 'Kanit'),
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlatButton(
                  child: Text(
                    'กลับสู่หน้าหลัก',
                    style: TextStyle(
                        fontFamily: 'Kanit', color: Colors.blueAccent),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            )));
  }
}
 