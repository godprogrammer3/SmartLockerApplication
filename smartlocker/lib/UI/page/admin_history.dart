import 'package:flutter/material.dart';
import '../page/Page.dart';
import '../widget/Widget.dart';

class History extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HistoryState();
  }
}

class _HistoryState extends State<History> {
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
      body: HistoryBody(),
    );
  }
}
//----------------------------------------------------------------------------------------

class HistoryBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          children: <Widget>[
            IconButton(
              alignment: Alignment.topLeft,
              icon: Icon(Icons.arrow_back),
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeAdmin(),
                  )
                );
              },
            ),
            Container(),
          ],
        ),
      ),
    );
  }
}
