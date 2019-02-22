import 'package:flutter/material.dart';
import '../widget/Widget.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../model/Model.dart';
import './Page.dart';
class HomeUser extends StatefulWidget {
  String token;
  HomeUser(this.token);
  @override
  State<StatefulWidget> createState() {
    return _HomeUserState(token);
  }
}

class _HomeUserState extends State<HomeUser> {
  _HomeUserState(this.token);
  String token;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  HomeUserBody _homeBody;
  FirebaseMessaging _firebaseMessaging= new FirebaseMessaging();
  var _userController = new UserController();
  var _requestController = new RequestController();
  
  int requestId;
  int userId;
  @override
  void initState() {
    prepare();
    super.initState();
    _homeBody = HomeUserBody(token);
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

  void prepare() async {
    Map userRecentRequest = await _userController.getRecentRequest(token) as Map;
    if(userRecentRequest['state'] == 'approve' && false){
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserCancel(token: this.token,requestId: this.requestId),
        )
      );
    }
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
      body:_homeBody,
    );
  }
}
class HomeUserBody extends StatefulWidget {
  String token;
  HomeUserBody(this.token);
  @override
  State<StatefulWidget> createState() {
    return _HomeUserBodyState(token);
  }
}

class _HomeUserBodyState extends State<HomeUserBody> {
  static GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  Key _k1 = new GlobalKey();
  Key _k2 = new GlobalKey();
  String token;
  _HomeUserBodyState(this.token);
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
                        return 'กรุณากรอกหมายเลขให้ถูกต้อง';
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
                          _inputSlotController.text,token);
                    }
                  },
                ),
              ],
            ),
          ],
        ));
  }
}