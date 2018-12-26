import 'package:flutter/material.dart';
import 'Page.dart';

class LoginPage extends StatelessWidget {
  final logo = Container(
    child: Text(
      'SmartLocker',
      style: TextStyle(
          fontSize: 40, color: Colors.orange, fontWeight: FontWeight.bold),
    ),
    margin: const EdgeInsets.only(top: 105),
  );

  final username = Container(
    child: Column(
      children: <Widget>[
        Text(
          "ชื่อผู้ใช้งาน",
          style: TextStyle(fontSize: 14, color: Colors.orange),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: TextFormField(
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white70,
              contentPadding: EdgeInsets.fromLTRB(10.0, 8.0, 10.0, 8.0),
              border: OutlineInputBorder(
                  borderSide:
                      BorderSide(width: 1.0, color: Color(0xFFFFDFDFDF))),
            ),
          ),
        )
      ],
      crossAxisAlignment: CrossAxisAlignment.start,
    ),
    margin: EdgeInsets.only(top: 77),
    width: 296.23,
  );

  final password = Container(
    child: Column(
      children: <Widget>[
        Text(
          "รหัสผ่าน",
          style: TextStyle(fontSize: 14, color: Colors.orange),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: TextFormField(
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white70,
              contentPadding: EdgeInsets.fromLTRB(10.0, 8.0, 10.0, 8.0),
              border: OutlineInputBorder(
                  borderSide:
                      BorderSide(width: 1.0, color: Color(0xFFFFDFDFDF))),
            ),
          ),
        )
      ],
      crossAxisAlignment: CrossAxisAlignment.start,
    ),
    margin: EdgeInsets.only(top: 7.54),
    width: 296.23,
  );

  final signInButton = Container(
    child: RaisedButton(

      child: Text(
        "เข้าสู่ระบบ",
        style: TextStyle(color: Colors.white, fontSize: 14),
      ),
      color: Colors.orange,
      onPressed: () {},
    ),
    margin: EdgeInsets.only(top: 52),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[100],
      body: Center(
        child:Container(
          padding: EdgeInsets.symmetric(horizontal: 64),

          child: ListView(
            children: <Widget>[
              logo,
              username,
              password,
              signInButton,
              RaisedButton(
              child: Text('ไปหน้าผู้ใช้'),
              onPressed: ((){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                    builder:(context) => HomeUser(),
                ),
                );
              }),
              ),
               RaisedButton(
              child: Text('ไปหน้าแอดมิน'),
              onPressed: ((){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                    builder:(context) => HomeAdmin(),
                ),
                );
              }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}