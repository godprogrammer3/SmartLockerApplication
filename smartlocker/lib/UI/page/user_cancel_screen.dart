import 'package:flutter/material.dart';
import '../widget/Widget.dart';
import 'dart:async';
class UserCancel extends StatefulWidget{
  UserCancel({this.token,this.requestId});
  String token;
  int requestId;
  @override
  State<StatefulWidget> createState() {
    return UserCancelState(token: token , requestId: requestId);
  }
}
class UserCancelState extends State<UserCancel>{
  UserCancelState({this.token ,this.requestId});
  String token;
  int requestId;
  int count = 0;
  //final Stream newsStream = new Stream.periodic(Duration(seconds: 2);

  update(){
    count++;
  }
  @override
  void initState(){
    super.initState();
    /*
    newsStream.listen(update());
    newsStream.map((e) {
    count = e;
    print(count);
    return 'stuff $e';
  }).take(5).forEach((e) {
    print(e);
  });
  */
  }
  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
    return WillPopScope(
      onWillPop: (){

      },
      child: Scaffold(
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
      body: UserCancelBody(),
    )
    );
  }

}

class UserCancelBody extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Cancel screen')
          ],
        )
      ],
    );
  }

}