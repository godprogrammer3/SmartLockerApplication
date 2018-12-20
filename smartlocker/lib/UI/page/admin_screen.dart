import 'package:flutter/material.dart';

class HomeAdmin extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeUserState();
  }
}

class _HomeUserState extends State<HomeAdmin> {
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
      drawer: SideMenuAdmin(),
      
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
