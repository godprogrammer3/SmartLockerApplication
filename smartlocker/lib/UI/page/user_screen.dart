import 'package:flutter/material.dart';
import '../widget/Widget.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../page/Page.dart';

class HomeUser extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeUserState();
  }
}

class _HomeUserState extends State<HomeUser> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  HomeUserBody _homeBody;

  FirebaseMessaging _firebaseMessaging= new FirebaseMessaging();


  @override
  void initState() {
    super.initState();
    _homeBody = HomeUserBody();
    _firebaseMessaging.configure(
      onMessage: (Map<String,dynamic> message){
        print('on message $message');
      },
      onLaunch: (Map<String,dynamic> message){
        print('on launch $message');
      },
      onResume: (Map<String,dynamic> message){
        print('on resume $message');
      }
    );
    _firebaseMessaging.getToken().then((token){print('token:'+token);});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          alignment: Alignment.centerLeft,
          icon: Icon(
            Icons.menu,
            size: 30.0,
          ),
          onPressed: () => _scaffoldKey.currentState.openDrawer(),
        ),
        backgroundColor: Colors.deepOrange,
      ),
      drawer: SideMenuUser(),
      body: _homeBody,
    );
  }
}
// ย้ายไปใน widget นะ แต่จะเอา comment ออกก็ได้

// class SideMenuUser extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: ListView(
//         padding: EdgeInsets.zero,
//         children: <Widget>[
//           DrawerHeader(
//             child: Align(
//                 alignment: Alignment.centerLeft,
//                 child: Row(
//                   children: <Widget>[
//                     Container(
//                         width: 100.0,
//                         height: 100.0,
//                         decoration: BoxDecoration(
//                             shape: BoxShape.circle, color: Colors.white),
//                         child: Icon(
//                           Icons.person,
//                           size: 60.0,
//                         )),
//                     Padding(
//                       padding: EdgeInsets.only(left: 15.0),
//                       child: Text(
//                         'นาย User',
//                         style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 16.0,
//                             fontFamily: 'Kanit'),
//                       ),
//                     )
//                   ],
//                 )),
//             decoration: BoxDecoration(
//               color: Colors.deepOrange,
//             ),
//           ),
//           ListTile(
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => LoginPage(),
//                 ),
//               );
//             }, //get back to login screen
//             leading: Icon(
//               Icons.exit_to_app,
//               size: 40.0,
//             ),
//             title: Text(
//               "ออกจากระบบ",
//               style: TextStyle(fontSize: 18.0, fontFamily: 'Kanit'),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class HomeUserBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeUserBodyState();
  }
}

class _HomeUserBodyState extends State<HomeUserBody> {
  static GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  Key _k1 = new GlobalKey();
  Key _k2 = new GlobalKey();

  final TextEditingController _inputLockerController =
      new TextEditingController();
  final TextEditingController _inputSlotController =
      new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 10.0),
                  width: 200,
                  padding: EdgeInsets.all(10.0),
                  decoration: new BoxDecoration(
                      border: new Border.all(color: Colors.black)),
                  child: TextFormField(
                    key: _k1,
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                        hintText: 'กรอกหมายเลขตู้',
                        hintStyle: TextStyle(fontFamily: 'Kanit')),
                    keyboardType:
                        TextInputType.numberWithOptions(signed: false),
                    controller: _inputLockerController,
                    validator: (value) {
                      if (value.isEmpty && int.tryParse(value) == null) {
                        return 'กรูณากรอกหมายเลขให้ถูกต้อง';
                      }
                    },
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 10.0),
                  width: 200,
                  padding: EdgeInsets.all(10.0),
                  decoration: new BoxDecoration(
                      border: new Border.all(color: Colors.black)),
                  child: TextFormField(
                    key: _k2,
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                        hintText: 'กรอกหมายเลขช่อง',
                        hintStyle: TextStyle(fontFamily: 'Kanit')),
                    keyboardType:
                        TextInputType.numberWithOptions(signed: false),
                    controller: _inputSlotController,
                    validator: (value) {
                      if (value.isEmpty && int.tryParse(value) == null) {
                        return 'กรูณากรอกหมายเลขให้ถูกต้อง';
                      }
                    },
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  child: Text(
                    'ขอเปิดตู้',
                    style: TextStyle(fontFamily: 'Kanit'),
                  ),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      showUserReasonForm(context, _inputLockerController.text,
                          _inputSlotController.text);
                    }
                  },
                ),
              ],
            ),
          ],
        ));
  }
}
