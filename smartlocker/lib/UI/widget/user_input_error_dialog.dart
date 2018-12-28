import 'package:flutter/material.dart';

void showUserInputErrorDialog(BuildContext context){
  showDialog(
    context: context,
    builder: (BuildContext context)=> UserInputErrorDialog()
  );
}

class UserInputErrorDialog extends StatelessWidget{
 
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
            title: Text(
              'ท่านกรอกข้อมูลไม่ครบถ้วน',
              style: TextStyle(fontFamily: 'Kanit',fontSize: 17.0),
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlatButton(
                  child: Text(
                    'ตกลง',
                    style: TextStyle(
                        fontFamily: 'Kanit', color: Colors.blueAccent),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }
}