import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../page/Page.dart';
import '../widget/Widget.dart';
import '../../model/Model.dart';

class HistoryList {
  String name;
  String day;
  String locker;
  String lockerBox;
  String time;
  String reason;

  HistoryList(
      this.name, this.day, this.locker, this.lockerBox, this.time, this.reason);
}

class History extends StatefulWidget {
  String token;
  History(this.token);
  @override
  State<StatefulWidget> createState() {
    return _HistoryState(token);
  }
}

class _HistoryState extends State<History> {
  String token;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  _HistoryState(this.token);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: HistoryBody(token),
    );
  }
}
//----------------------------------------------------------------------------------------

class HistoryBody extends StatefulWidget {
  String token;

  HistoryBody(this.token);

  @override
  HistoryBodyState createState() {
    return new HistoryBodyState(token);
  }
}

//----------------------------------------------------------------------------------------------
class HistoryBodyState extends State<HistoryBody> {
  String token;
  var _historyController = new HistoryController();

  List _itemFilter = ["วัน เวลา", "หมายเลขล็อกเกอร์", "หมายเลขตู้"];

  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _currentItem;

  HistoryBodyState(this.token);

  void backToAdminHome() {
    Navigator.of(context).pop();
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeAdmin(token),
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

    var listRequestHistory = _historyController.getAllRequestLocker(token);
    List<HistoryList> items = [];

    return Scaffold(
        body: ListView(
      children: <Widget>[
        Padding(
          child: Center(
              child: Text(
            "ประวัติการขอเปิดล็อกเกอร์",
            style: TextStyle(
                fontSize: 20,
                color: Colors.orange,
                fontWeight: FontWeight.bold),
          )),
          padding: EdgeInsets.only(top: 20),
        ),
        Container(
          color: Colors.grey[350],
          margin: EdgeInsets.fromLTRB(40, 20, 40, 0),
          height: 1,
        ),
        Padding(
          child: FutureBuilder(
            future: listRequestHistory,
            builder: (context, asyncSnapshot) {
              switch (asyncSnapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return new Text('loading...');
                default:
                  if (asyncSnapshot.hasError)
                    return new Text('Error: ${asyncSnapshot.error}');
                  else {
                    if (asyncSnapshot.data.toString() == '[]') {
                      return Text('No Data');
                    } else {
                      asyncSnapshot.data.forEach((element) {

                        var dateTime = DateTime.parse(element['createdAt']);
                        var day = dateTime.day.toString();
                        var month = dateTime.month.toString();
                        var year =dateTime.year;
                        year = year +  543;

                        var time = DateFormat.Hm().format(dateTime).toString();
                      
                        items.add(HistoryList(
                            element['requestUser']['username'].toString(),
                            day+'/'+month+'/'+year.toString(),
                            element['Box']['id'].toString(),
                            element['Box']['number'].toString(),
                            time+'น.',
                            element['reason'].toString()));
                      });
                      // แสดงผล ExpansionTile
                      return ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return ExpansionTile(
                            title: Container(
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        "ตู้ที่ " +
                                            items[index].locker +
                                            " ล็อกเกอร์ " +
                                            items[index].locker,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Opacity(
                                        opacity: 0.6,
                                        child: Text(
                                            "วัน " +
                                                items[index].day +
                                                " เวลา " +
                                                items[index].time,
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600)),
                                      ),
                                      Text(items[index].name),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            children: <Widget>[
                              Padding(
                                child: Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        "เหตุผลขอเปิดตู้ : ",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(items[index].reason)
                                    ],
                                  ),
                                ),
                                padding: EdgeInsets.fromLTRB(20, 5, 20, 10),
                              )
                            ],
                          );
                        },
                        itemCount: items.length,
                        shrinkWrap: true,
                      );
                    }
                  }
              }
            },
          ),
          padding: EdgeInsets.only(top: 20),
        ),
      ],
    ));
  }

  void changedDropDownItem(String selected) {
    setState(() {
      _currentItem = selected;
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
