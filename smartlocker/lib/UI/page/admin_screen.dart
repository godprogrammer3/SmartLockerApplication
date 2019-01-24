import 'package:flutter/material.dart';
import '../../model/Model.dart';
import '../widget/Widget.dart';
import '../page/Page.dart';
import 'dart:async';

Timer timerController;

class HomeAdmin extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeAdminState();
  }
}

class _HomeAdminState extends State<HomeAdmin> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

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
        drawer: SideMenuAdmin(),
        body: HomeAdminBody(),
      ),
    );
  }
}
class HomeAdminBody extends StatefulWidget {
  _HomeAdminBodyState createState() => _HomeAdminBodyState();
}

class _HomeAdminBodyState extends State<HomeAdminBody> {
  var _requestController = new RequestController();
  var _lockerController = new LockerController();
  var _userController = new UserController();
  String token = '';
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
      if(userLoginResult['success']==true){
        //print(userLoginResult['user']);
        token = userLoginResult['token'];
        //print(token);
      }else{
        //print(userLoginResult['error']);
      }
    }
    for(int i=1 ; i<=9 ; i++){
      Map requestFilterResult = await _requestController.filterRequest(token,i) as Map;
      //print(requestFilterResult['data']);
      if(requestFilterResult['success']==true)
      {
        if(requestFilterResult['data'].toString()=='[]'){
          Map lockerFilterResult = await _lockerController.fillterLocker(token,i) as Map;
         
          if(lockerFilterResult['data'][0]['state']=='close'){
            setState(() {
               lockerColor[i-1] = Colors.green;     
               lockerStatus[i-1] = 0;    
                    });
          }else{
             setState(() {
               lockerColor[i-1] = Colors.red;
               lockerStatus[i-1] = 1;            
                    });
          }
        }else{
           setState(() {
               lockerColor[i-1] = Colors.yellow;    
               lockerStatus[i-1] = 2;        
                    });
        }
      }
      else{
        print(requestFilterResult['error']);
      }
    }
    if (firstUpdate == false) {
      firstUpdate = true;
    }
  }

  void onChanged(index) async {
    if (firstUpdate == true) {
      if (lockerStatus[index] == 2) {
        Map requestFilterResult = await _requestController.filterRequest(token,index+1) as Map;
        //print(lockerFilterResult['data'][0]['requestUserId']);
        Map userFilterResult = await _userController.filterUser(token,  requestFilterResult['data'][0]['requestUserId']) as Map;
        //print(userFilterResult['data']['username']); 
        //print( userFilterResult['error']);
        
        showAdminConfirm(
            context,
            token,
            userFilterResult['data']['username'],
            requestFilterResult['data'][0]['createdAt'],
            requestFilterResult['data'][0]['reason'],
            requestFilterResult['data'][0]['id'],
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
