import 'package:flutter/material.dart';
import 'package:smartlocker/main.dart';
import '../../model/Model.dart';
import '../widget/Widget.dart';
import '../page/Page.dart';
import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';

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
  int totalLocker = 0;
  var _userController = new UserController();
  var _lockerController = new LockerController();
  
  _HomeAdminState(this.token);
  @override
  void initState(){
    super.initState();
     _firebaseMessaging.getToken().then((token) async {
      print('token:'+token);
      Map result = await _userController.updateFcmToken(this.token, token);
      if(result['success'] == true){
        print('put fcm token success');
      }else{
        print(result['error']);
      }
    });

  }
  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: (){
        Navigator.of(context).pop();
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
  var _lockerController = new LockerController();
  var _userController = new UserController();
  List<Map> lockerData;
  String token = '';
  FirebaseMessaging _firebaseMessaging= new FirebaseMessaging();
  _HomeAdminBodyState(this.token);
  bool firstUpdate = true;
  var loadingData;
  @override
  void initState(){
    super.initState();  
    eventBus.on<Map>().listen((event){update(event);});
  }
  void update(Map<dynamic,dynamic> data){
    print('Update in admin');
    print('data : '+data.toString());
    if(data['eventType'] == 'replyState'){
      print('admin replyState');
      if(this.mounted){
       setState(() {
        lockerData[int.parse(data['lockerNumber'])-1]['waitRequest']--;
       });
       print('admin mounted');
      }else{
        print('admin not mount');
      }
    }else if(data['eventType'] == 'fcmUpdate'){
      if(this.mounted){
       setState(() {
        lockerData[int.parse(data['lockerNumber'])-1]['waitRequest']++;
       });
      }
    }
    
   
  }
  Future<dynamic> prepare() async {
      Map result = await _lockerController.countLocker(token) as Map;
      if(result['success']==true){
        lockerData = new List<Map>(result['count']);
        print('total Locker:'+lockerData.length.toString());
        for(int i = 1 ; i <= lockerData.length ; i++){
          lockerData[i-1] = new Map();
          lockerData[i-1]['waitRequest'] = (await _lockerController.countLockerRequest(token, i) as Map)['count'];
          lockerData[i-1]['openBoxs'] = (await _lockerController.countOpenboxs(token, i) as Map)['count'];
        }
      }else{
        print(result['error']);
      }
    return _lockerController.countLocker(token);
  }
  

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(firstUpdate){
      loadingData = prepare();
      firstUpdate = false;
      return FutureBuilder(
              future: loadingData,
              builder: (context, asyncSnapshot) {
                switch (asyncSnapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return preLoading();
                    break;
                  default:{
                    if(asyncSnapshot.hasError){
                      return errorDisplay(Text('เกิดข้อผิดพลาด:'+asyncSnapshot.error));
                    }else if(asyncSnapshot.data['success'] == false){
                      return errorDisplay(Text('เกิดข้อผิดพลาด:'+asyncSnapshot.data[1]['error']));
                    }else if(asyncSnapshot.data.toString() == '[]' ){
                      return errorDisplay(Text('ไม่มีข้อมูล'));
                    }else if(asyncSnapshot.hasData){
                      print('LockerData length:'+lockerData.length.toString());
                      return  bodyComponent(context,lockerData.length);
                    }else{
                      return preLoading();
                    }
                  }

                }
              });
    }else{
      return bodyComponent(context, lockerData.length);
    }
    
  }

    Widget bodyComponent(BuildContext context,int totalLocker){
      return new Container(
          margin: EdgeInsets.only(top: 80.0),
          child: GridView.count(
            crossAxisCount: 3,
            children: List.generate(totalLocker, (index) {
              return GestureDetector(
                  onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Locker(token,index+1,_firebaseMessaging),
                        )
                      );
                  },
                  child: Column(
                    children: <Widget>[
                      Stack(
                          alignment: Alignment.topRight,
                          children: <Widget>[
                          new Container(
                            width: 100,
                            height: 70,
                            margin: EdgeInsets.all(10),
                            decoration: new BoxDecoration(
                              gradient: LinearGradient(colors: [Colors.yellow[700], Colors.redAccent],
                              begin: Alignment.topRight, end: Alignment.bottomLeft),
                              border: Border.all(color: Colors.red,width: 2.0)
                            ),
                          ),
                          ((lockerData[index]['waitRequest']>0)?new Align(alignment: Alignment.topRight,
                            child: new Container(
                              width: 27,
                              height: 27,
                              decoration: BoxDecoration(
                                color: Colors.yellow,
                                shape: BoxShape.circle
                              ),
                              alignment: Alignment.center,
                              child: new Text((lockerData[index]['waitRequest']>0)?lockerData[index]['waitRequest'].toString():'', style: new TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                            ),):Text(''))
                         
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

    Widget preLoading(){
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(),  
              Text('กำลังโหลดข้อมูล.....'),
            ],
          )
        ],
      );
      
    }
     Widget errorDisplay(Widget inside){
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              inside,
              RaisedButton(
                child: Text('ลองอีกครั้ง'),
                onPressed: (){
                  setState(() {
                     firstUpdate = true;
                  });
                },
              )
            ],
          )
        ],
      );
      
    }
}

