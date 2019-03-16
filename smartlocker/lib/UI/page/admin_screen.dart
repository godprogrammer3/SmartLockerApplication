import 'package:flutter/material.dart';
import '../../model/Model.dart';
import '../widget/Widget.dart';
import '../page/Page.dart';
import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';

Timer timerController;

class HomeAdmin extends StatefulWidget {
  String token;
  HomeAdmin(this.token);
  @override
  State<StatefulWidget> createState() {
    return _HomeAdminState(this.token);
  }
}

class _HomeAdminState extends State<HomeAdmin> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String token;
  FirebaseMessaging _firebaseMessaging= new FirebaseMessaging();
  var _userController = new UserController();
  _HomeAdminState(this.token);
  @override
  void initState(){
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
     _firebaseMessaging.getToken().then((token) async {
      print('token:'+token);
      Map result = await _userController.updateFcmToken(this.token, token);
      if(result['success'] == true){
        print(result);
      }else{
        print(result['error']);
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async {
        await timerController.cancel();
        await Navigator.of(context).pop();
      },
      child: new Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
            alignment: Alignment.centerLeft,
            icon: Icon(
              Icons.menu,
              size: 30.0,
            ),
            onPressed: () async {
               _scaffoldKey.currentState.openDrawer();
            },
          ),
          backgroundColor: Colors.deepOrange,
        ),
        drawer: SideMenuAdmin(this._firebaseMessaging,this.token),
        body: HomeAdminBody(this.token),
      ),
    );
  }
}
class HomeAdminBody extends StatefulWidget {
  String token;
  HomeAdminBody(this.token);
  _HomeAdminBodyState createState() => _HomeAdminBodyState(this.token);
}

class _HomeAdminBodyState extends State<HomeAdminBody> {
  var _requestController = new RequestController();
  var _lockerController = new LockerController();
  var _userController = new UserController();
  
  String token = '';
  _HomeAdminBodyState(this.token);
  final lockerStatus = List<int>.generate(9, (i) => 0);
  List<Color> lockerColor = List.generate(9, (i) {
    return Colors.green;
  });
  List<String> requestId = List.generate(9, (i) => '');
  bool firstUpdate = false;
  @override
  void initState(){
    const millis = const Duration(milliseconds: 500);
    timerController = new Timer.periodic(millis, (Timer t) => updateState(t));
    
  }

  updateState(Timer t) async {
    if(token==''){
      Map userLoginResult = await _userController.login('admin', 'admin') as Map;
      //print(userLoginResult);
      if(userLoginResult['success']==true){
        //print(userLoginResult['user']);
        token = userLoginResult['token'];
        //print(token);
      
      }else{
        print(userLoginResult['error']);
      }
    }

     for(int i=1 ; i<=9 ; i++){
      Map lockerBoxStateResult = await _lockerController.getBoxState(token,1,i) as Map;
      if(lockerBoxStateResult['state']=='close'){
        if(this.mounted){
          setState(() {
            lockerColor[i-1] = Colors.green;     
            lockerStatus[i-1] = 0;    
                });
        }
        
      }else if(lockerBoxStateResult['state']=='request'){
        if(this.mounted){
          setState(() {
            lockerColor[i-1] = Colors.yellow;
            lockerStatus[i-1] = 1;            
                });
        }
      }else{
        if(this.mounted){
           setState(() {
            lockerColor[i-1] = Colors.red;
            lockerStatus[i-1] = 2;            
                });
        }
      }

    }
    
    if (firstUpdate == false) {
      firstUpdate = true;
    }
  }

  void onChanged(index) async {
    if (firstUpdate == true) {
      if (lockerStatus[index] == 1) {
        Map lockerRecentRequestResult = await _lockerController.getRecentRequest(token,1,1) as Map;
        showAdminConfirm(
            context,
            token,
            lockerRecentRequestResult['requestUser']['username'],
            lockerRecentRequestResult['createdAt'],
            lockerRecentRequestResult['reason'],
            lockerRecentRequestResult['id'],
            1,
            index+1
            );
        
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 80.0),
      child: GridView.count(
        crossAxisCount: 3,
        children: List.generate(9, (index) {
          return GestureDetector(
              onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Locker(token,index+1),
                    )
                  );
              },
              child: Column(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      new Icon(
                        Icons.chrome_reader_mode,
                        size: 80,
                      ),
                      new Positioned(
                        right: 0,
                        child: new Container(
                          padding: EdgeInsets.all(1),
                          decoration: new BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          constraints: BoxConstraints(
                            minWidth: 12,
                            minHeight: 12,
                          ),
                          child: new Text(
                            '10',
                            style: new TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    ],
                  ),
              
                  Text(
                    (index+1).toString(),
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                ],
              ));
        }),
      ),
    );
  }
}

