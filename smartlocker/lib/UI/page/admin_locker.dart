import 'package:flutter/material.dart';
import 'package:smartlocker/main.dart';
import '../../model/Model.dart';
import '../widget/Widget.dart';
import '../page/Page.dart';
import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';

class Locker extends StatefulWidget {
  String token;
  int lockerNumber;
  FirebaseMessaging _firebaseMessaging= new FirebaseMessaging();
  Locker(this.token,this.lockerNumber,this._firebaseMessaging);
  @override
  State<StatefulWidget> createState() {
    return _LockerState(token,lockerNumber,_firebaseMessaging);
  }
}

class _LockerState extends State<Locker> {
  String token;
  int lockerNumber;
  _LockerState(this.token,this.lockerNumber,this._firebaseMessaging);
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  FirebaseMessaging _firebaseMessaging= new FirebaseMessaging();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('ตู้หมายเลข '+lockerNumber.toString()),
        leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }),
            
      ),
      body: LockerBody(token,lockerNumber,_firebaseMessaging),
    );
  }
}



class LockerBody extends StatefulWidget {
  String token;
  int lockerNumber;
  FirebaseMessaging _firebaseMessaging= new FirebaseMessaging();
  LockerBody(this.token,this.lockerNumber,this._firebaseMessaging);
  _LockerBodyState createState() => _LockerBodyState(this.token,lockerNumber,this._firebaseMessaging);
}

class _LockerBodyState extends State<LockerBody> {
  var _requestController = new RequestController();
  var _lockerController = new LockerController();
  var _userController = new UserController();
  int totalBox = 0;
  String token = '';
  int lockerNumber;
  FirebaseMessaging _firebaseMessaging= new FirebaseMessaging();
  _LockerBodyState(this.token,this.lockerNumber,this._firebaseMessaging);
  var lockerStatus;
  List<Color> lockerColor; 
  List<String> requestId ;
  var loadingData;
  bool firstUpdate = true;
  @override
  void initState(){
   super.initState();
    eventBus.on<Map>().listen((event){update(event);});
  }
  void update(Map<dynamic,dynamic> data){
    print('Update in adminLocker');
    print(data['eventType']);
    if(data['eventType']=='fcmUpdate'){
      print('type fcmUpdate');
      if(this.mounted){
        setState(() {
          if(data['boxState']=='request'){
            lockerStatus[int.parse(data['boxNumber'])-1] = 0;
            lockerColor[int.parse(data['boxNumber'])-1] = Colors.yellowAccent;
          }else if(data['boxState']=='close'){
            lockerStatus[int.parse(data['boxNumber'])-1] = 1;
            lockerColor[int.parse(data['boxNumber'])-1] = Colors.green;
          }else if(data['boxState']=='open'){
            lockerStatus[int.parse(data['boxNumber'])-1] = 2;
            lockerColor[int.parse(data['boxNumber'])-1] = Colors.red;
          }
        });
      }
       
    }else if(data['eventType']=='replyState'){
      if(this.mounted){
         setState(() {
          if(data['boxState']=='request'){
            lockerStatus[int.parse(data['boxNumber'])-1] = 0;
            lockerColor[int.parse(data['boxNumber'])-1] = Colors.yellowAccent;
          }else if(data['boxState']=='close'){
            lockerStatus[int.parse(data['boxNumber'])-1] = 1;
            lockerColor[int.parse(data['boxNumber'])-1] = Colors.green;
          }else if(data['boxState']=='open'){
            lockerStatus[int.parse(data['boxNumber'])-1] = 2;
            lockerColor[int.parse(data['boxNumber'])-1] = Colors.red;
          }
        });
      }
    }
   
    
  }
 
  void onChanged(index) async {
      if (lockerStatus[index] == 0) {
        Map lockerRecentRequestResult = await _lockerController.getRecentRequest(token,lockerNumber,index+1) as Map;
        print(lockerRecentRequestResult['id']);
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

  @override
  void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(firstUpdate){
      loadingData  = _lockerController.getAllBoxState(token, lockerNumber); 
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
                  }else if(asyncSnapshot.data[0]['success'] == false){
                    return errorDisplay(Text('เกิดข้อผิดพลาด:'+asyncSnapshot.data[1]['error']));
                  }else if(asyncSnapshot.data[1].toString() == '[]' ){
                    return errorDisplay(Text('ไม่มีข้อมูล'));
                  }else if(asyncSnapshot.hasData){
                    lockerStatus = List<int>.generate(asyncSnapshot.data[1].length, (i) => 0);
                    lockerColor = List.generate(asyncSnapshot.data[1].length, (i) {
                    return Colors.green; 
                    }); 
                    for(int i=0 ; i < asyncSnapshot.data[1].length ; i++){
                      if(asyncSnapshot.data[1][i]['state']=='request'){
                        lockerStatus[i] = 0;
                        lockerColor[i] = Colors.yellowAccent;
                      }else if(asyncSnapshot.data[1][i]['state']=='close'){
                        lockerStatus[i] = 1;
                        lockerColor[i] = Colors.green;
                      }else if(asyncSnapshot.data[1][i]['state']=='open'){
                        lockerStatus[i] = 2;
                        lockerColor[i] = Colors.red;
                      }else{
                        lockerStatus[i] = 1;
                        lockerColor[i] = Colors.green;
                      }
                        
                    }
                    return bodyComponent(context,asyncSnapshot.data[1].length);
                  }else{
                     return preLoading();
                  }
                }

              }
            });
    }else{
      return bodyComponent(context, lockerStatus.length);
    }
    
  }

  Widget bodyComponent(BuildContext context,int totalBox){
    return Container(
      margin: EdgeInsets.only(top: 80.0),
      child: GridView.count(
        crossAxisCount: 3,
        children: List.generate(totalBox, (index) {
          return GestureDetector(
              onTap: () {
                onChanged(index);
              },
              child: Column(
                children: <Widget>[
                  Icon(
                    Icons.branding_watermark,
                    size: 90.0,
                    color: lockerColor[index],
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