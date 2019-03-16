import 'package:flutter/material.dart';
import '../../model/Model.dart';
import '../widget/Widget.dart';
import '../page/Page.dart';
import 'dart:async';


class Locker extends StatefulWidget {
  String token;
  int lockerNumber;
  Locker(this.token,this.lockerNumber);
  @override
  State<StatefulWidget> createState() {
    return _LockerState(token,lockerNumber);
  }
}

class _LockerState extends State<Locker> {
  String token;
  int lockerNumber;
  _LockerState(this.token,this.lockerNumber);
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
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
      body: LockerBody(token),
    );
  }
}



class LockerBody extends StatefulWidget {
  String token;
  LockerBody(this.token);
  _LockerBodyState createState() => _LockerBodyState(this.token);
}

class _LockerBodyState extends State<LockerBody> {
  var _requestController = new RequestController();
  var _lockerController = new LockerController();
  var _userController = new UserController();
  String token = '';
  _LockerBodyState(this.token);
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
  void dispose(){
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
}