import 'package:flutter/material.dart';
import '../../model/Model.dart';
import '../widget/Widget.dart';
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
          onPressed: () => _scaffoldKey.currentState.openDrawer(),
        ),
        backgroundColor: Colors.deepOrange,
      ),
      drawer: SideMenuAdmin(),
      body: HomeAdminBody(),
    ),
  );
    
    
  }

}


class SideMenuAdmin extends StatelessWidget {
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
                        'นายแอดมิน',
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
              // go to history page
            },
            leading: Icon(
              Icons.history,
              size: 40.0,
            ),
            title: Text(
              "ประวัติการขอเปิดตู้",
              style: TextStyle(fontSize: 18.0, fontFamily: 'Kanit'),
            ),
          ),
          ListTile(
            onTap: () {
              //Logout naja
            },
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

class HomeAdminBody extends StatefulWidget{
  _HomeAdminBodyState createState()=> _HomeAdminBodyState();
}

class _HomeAdminBodyState extends State<HomeAdminBody>{
  var _requestController = new RequestController();
  final lockerStatus = List<int>.generate(9, (i)=>0);
  List<Color> lockerColor = List.generate(9, (i){return Colors.green;});
  List<String> requestId = List.generate(9,(i)=>'');
  bool firstUpdate = false;
  @override
  void initState(){
    const millis = const Duration(milliseconds: 500);
    timerController = new Timer.periodic(millis,(Timer t)=>updateState(t)); 
  }
  updateState(Timer t) async {
    Map result = await _requestController.adminGet() as Map;
    for(int i=0;i<9;i++)
    {
      lockerStatus[i]=int.parse(result[i.toString()]['status']);
      requestId[i]=result[i.toString()]['request_id'];
      setState(() {
        if(lockerStatus[i] == 0){
          lockerColor[i] = Colors.green;
        }else if(lockerStatus[i] == 1){
          lockerColor[i] = Colors.yellow;
        }else{
          lockerColor[i] = Colors.red;
        }
            });
    }
    if(firstUpdate == false){
     firstUpdate = true;
    }
  }
  void onChanged(index) async {
    if(firstUpdate == true)
    {
      if(lockerStatus[index]==1)
      {
        Map result = await _requestController.userGet(requestId[index], 0) as Map;
        showAdminConfirm(context, 0.toString() , index.toString() , result['user_name'], result['time'], result['reason'],requestId[index]);
      }
    }
  } 
  @override
  Widget build(BuildContext context){
    return Container(
      margin: EdgeInsets.only(top: 80.0),
      child: GridView.count(
        crossAxisCount: 3,
        children: List.generate(9, (index){
          return GestureDetector(
            onTap: (){
              setState((){
                onChanged(index);
              });
            },
            child: Column(
              children: <Widget>[
                Icon(
                  Icons.branding_watermark,
                  size: 90.0,
                  color: lockerColor[index],
                ),
                Text(
                  index.toString(),
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
              ],
            )
          );
        }),
      ),
    );
          
  }
}