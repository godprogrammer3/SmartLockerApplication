import 'package:flutter/material.dart';
import '../widget/Widget.dart';
import '../page/Page.dart';

class HomeUser extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeUserState();
  }
}

class _HomeUserState extends State<HomeUser> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

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
      body: HomeUserBody(),
    );
  }
}

class SideMenuUser extends StatelessWidget {
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
            onTap: () {}, //get back to login screen
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

class HomeUserBody extends StatelessWidget {

  var _inputLockerController = new TextEditingController();
  var _inputSlotController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
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
              child: TextField(
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                    hintText: 'กรอกหมายเลขตู้',
                    hintStyle: TextStyle(fontFamily: 'Kanit')),
                keyboardType: TextInputType.numberWithOptions(signed: false),
                controller: _inputLockerController,
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
              child: TextField(
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                    hintText: 'กรอกหมายเลขช่อง',
                    hintStyle: TextStyle(fontFamily: 'Kanit')),
                keyboardType: TextInputType.numberWithOptions(signed: false),
                controller: _inputSlotController,
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
                showUserReasonForm(context, _inputLockerController.text, _inputSlotController.text);
              },
            ),
          ],
        ),
      ],
    );
  }  
}
