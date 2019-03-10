import 'package:flutter/material.dart';
import '../page/Page.dart';
import '../widget/Widget.dart';

class HistoryList {
  String name;
  String day;
  String locker;
  String lockerBox;
  String time;
  String description;

  HistoryList(this.locker, this.lockerBox, this.name, this.day, this.time,
      this.description);
}

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
        leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }),
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
    List<HistoryList> items = [
      HistoryList('0', '1', 'AAA', '1/2/1', '01.22',
          'หิวหิวหิวหิวหิวหิวหิวหิวหิวหิวหิวหิวหิวหิวหิวหิวหิวหิวหิวหิวหิวหิวหิวหิวหิวหิวหิวหิวหิวหิวหิวหิว'),
      HistoryList('0', '1', 'BBB', '1/2/1', '01.22', 'ข้าวมันไก่ทอด'),
      HistoryList('1', '2', 'CCC', '1/2/1', '01.22', 'มาม่า'),
      HistoryList('0', '2', 'DDD', '1/2/1', '01.22', 'ยำมาม่า'),
      HistoryList('4', '1', 'FFF', '1/2/1', '01.22', 'โอริโอ้ปั่น'),
      HistoryList('1', '1', 'EEE', '1/2/1', '01.22', 'ข้าวกระเพราไข่เจียว'),
    ];

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
          child: ListView.builder(
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
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Opacity(
                            opacity: 0.6,
                            child: Text(
                                "วัน " +
                                    items[index].day +
                                    " เวลา " +
                                    items[index].time,
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w600)),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "เหตุผลขอเปิดตู้ : ",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          Text(items[index].description)
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
          ),
          padding: EdgeInsets.only(top: 20),
        ),
      ],
    )

        // Center(
        //   child: Container(
        //     padding: EdgeInsets.fromLTRB(23.00, 24.00, 23.00, 24.00),
        //     child: Column(
        //       children: <Widget>[
        //         //--------------------------------
        //         //_backIcon,
        //         //--------------------------------
        //         Padding(
        //           child: Row(
        //             children: <Widget>[
        //               Text("เรียงตาม : "),
        //               DropdownButtonHideUnderline(
        //                 child: Container(
        //                   child: new DropdownButton(
        //                     isDense: true,
        //                     value: _currentItem,
        //                     items: _dropDownMenuItems,
        //                     onChanged: changedDropDownItem,
        //                   ),
        //                   padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
        //                   decoration: ShapeDecoration(
        //                     shape: RoundedRectangleBorder(
        //                       side: BorderSide(
        //                           width: 1.0, style: BorderStyle.solid),
        //                       borderRadius:
        //                           BorderRadius.all(Radius.circular(2.0)),
        //                     ),
        //                   ),
        //                 ),
        //               )
        //             ],
        //             mainAxisAlignment: MainAxisAlignment.center,
        //           ),
        //           padding: EdgeInsets.only(bottom: 15),
        //         ),
        //         //--------------------------------
        //         ListView.builder(
        //           itemBuilder: (BuildContext context, int index) {
        //             // if (index == items.length)
        //             //   return RaisedButton(
        //             //     child: Text('footer'),
        //             //     onPressed: () {},
        //             //   );
        //             return ExpansionTile(
        //               title: Text(items[index].name),
        //               children: <Widget>[
        //                 Text(items[index].age),
        //                 Text(items[index].gender)
        //               ],
        //             );
        //           },
        //           itemCount: items.length,
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        );
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
