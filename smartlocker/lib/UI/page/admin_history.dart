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
      appBar:  AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.pop(context);
            }
        ),
      ),
      body: HistoryBody(),
    );
  }
}
//----------------------------------------------------------------------------------------

class HistoryBody extends StatefulWidget {
  @override
  HistoryBodyState createState() {
    return new HistoryBodyState();
  }
}

//----------------------------------------------------------------------------------------------
class HistoryBodyState extends State<HistoryBody> {
  List _itemFilter = ["วัน เวลา", "หมายเลขล็อกเกอร์", "หมายเลขตู้"];

  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _currentItem;

  void backToAdminHome() {
    Navigator.of(context).pop();
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeAdmin("token"),
        ));
  }

  @override
  void initState() {
    _dropDownMenuItems = getDropDownMenuItems();
    _currentItem = _dropDownMenuItems[0].value;
    super.initState();
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String listHistory in _itemFilter) {
      items.add(new DropdownMenuItem(
          value: listHistory, child: new Text(listHistory)));
    }
    return items;
  }

//----------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final _backIcon = new BackIcon(backToAdminHome: backToAdminHome);

    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.fromLTRB(23.00, 24.00, 37.09, 24.00),
          child: ListView(
            children: <Widget>[
              //--------------------------------
              //_backIcon,
              //--------------------------------
              Row(
                children: <Widget>[
                  Text("เรียงตาม : "),
                  DropdownButtonHideUnderline(
                    child: Container(
                      child: new DropdownButton(
                        isDense: true,
                        value: _currentItem,
                        items: _dropDownMenuItems,
                        onChanged: changedDropDownItem,
                      ),
                      padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side:
                              BorderSide(width: 1.0, style: BorderStyle.solid),
                          borderRadius: BorderRadius.all(Radius.circular(2.0)),
                        ),
                      ),
                    ),
                  )
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
              //--------------------------------
            ],
          ),
        ),
      ),
    );
  }

  void changedDropDownItem(String selectedCity) {
    setState(() {
      _currentItem = selectedCity;
    });
  }
}

class BackIcon extends StatelessWidget {
  Function backToAdminHome;
  BackIcon({Key key, this.backToAdminHome})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return IconButton(
      alignment: Alignment.topLeft,
      icon: Icon(
        Icons.arrow_back,
        size: 20,
      ),
      onPressed: backToAdminHome,
    );
  }
}
