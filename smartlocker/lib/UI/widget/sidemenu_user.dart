import 'package:flutter/material.dart';
import '../page/Page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../model/Model.dart';

class SideMenuUser extends StatelessWidget {
  FirebaseMessaging _firebaseMessaging;
  int popTimes;
  String token;
  SideMenuUser(this._firebaseMessaging,this.popTimes,this.token);
  var _userController = new UserController();
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: <Widget>[
                    Container(
                        width: 100.0,
                        height: 100.0,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.white),
                        child: Icon(
                          Icons.person,
                          size: 60.0,
                        )),
                    Padding(
                      padding: EdgeInsets.only(left: 15.0),
                      child: Text(
                        'นาย User',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontFamily: 'Kanit'),
                      ),
                    )
                  ],
                )),
            decoration: BoxDecoration(
              color: Colors.deepOrange,
            ),
          ),
          ListTile(
            onTap: () {
              _firebaseMessaging.deleteInstanceID();
              _userController.updateFcmToken(token,'');
              for(int i=0;i<popTimes;i++){
                Navigator.of(context).pop();
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginPage(),
                ),
              );           
              
            }, //get back to login screen
            leading: Icon(
              Icons.exit_to_app,
              size: 40.0,
            ),
            title: Text(
              "ออกจากระบบ",
              style: TextStyle(fontSize: 18.0, fontFamily: 'Kanit'),
            ),
          ),
        ],
      ),
    );
  }
}