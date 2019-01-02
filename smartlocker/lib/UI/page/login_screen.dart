import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'Page.dart';
import '../../model/Model.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var _userController = new UserController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  final logo = Container(
    child: Text(
      'SmartLocker',
      style: TextStyle(
          fontSize: 40, color: Colors.orange, fontWeight: FontWeight.bold),
    ),
    margin: const EdgeInsets.only(top: 105),
  );

  void login() async {
    Map result = await _userController.login(
        usernameController.text, passwordController.text) as Map;
    if (_formKey.currentState.validate()) {
      if (result['success'] == true) {
        print('Login success');
        print(result['role']);
        if (result['role'] == '0') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomeUser(),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomeAdmin(),
            ),
          );
        }
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: new Text("รหัสผ่านไม่ถูกต้อง"),
              content:
                  new Text("ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง โปรดลองอีกครั้ง"),
              actions: <Widget>[
                new FlatButton(
                  child: new Text("Close"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
        print('Login failed');
        usernameController.text = '';
        passwordController.text = '';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget username =
        new UsernameTextField(usernameController: usernameController);
    Widget password =
        new PasswordTextField(passwordController: passwordController);
    Widget signInButton = new SignInButton(
      login: login,
    );

    return Scaffold(
      backgroundColor: Colors.orange[100],
      body: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 64),
          child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                logo,
                username,
                password,
                signInButton,
                RaisedButton(
                  child: Text('ไปหน้าผู้ใช้'),
                  onPressed: (() {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeUser(),
                      ),
                    );
                  }),
                ),
                RaisedButton(
                  child: Text('ไปหน้าแอดมิน'),
                  onPressed: (() {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeAdmin(),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SignInButton extends StatelessWidget {
  Function login;
  SignInButton({Key key, this.login}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RaisedButton(
        child: Text(
          "เข้าสู่ระบบ",
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        color: Colors.orange,
        onPressed: login,
      ),
      margin: EdgeInsets.only(top: 52),
    );
  }
}

class PasswordTextField extends StatelessWidget {
  const PasswordTextField({
    Key key,
    @required this.passwordController,
  }) : super(key: key);

  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Text(
            "รหัสผ่าน",
            style: TextStyle(fontSize: 14, color: Colors.orange),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: TextFormField(
              controller: passwordController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white70,
                contentPadding: EdgeInsets.fromLTRB(10.0, 8.0, 10.0, 8.0),
                border: OutlineInputBorder(
                    borderSide:
                        BorderSide(width: 1.0, color: Color(0xFFFFDFDFDF))),
              ),
              validator: validatePassword,
              obscureText: true,
            ),
          )
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
      margin: EdgeInsets.only(top: 7.54),
      width: 296.23,
    );
  }
}

class UsernameTextField extends StatelessWidget {
  const UsernameTextField({
    Key key,
    @required this.usernameController,
  }) : super(key: key);

  final TextEditingController usernameController;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Text(
            "ชื่อผู้ใช้งาน",
            style: TextStyle(fontSize: 14, color: Colors.orange),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: TextFormField(
              controller: usernameController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white70,
                contentPadding: EdgeInsets.fromLTRB(10.0, 8.0, 10.0, 8.0),
                border: OutlineInputBorder(
                    borderSide:
                        BorderSide(width: 1.0, color: Color(0xFFFFDFDFDF))),
              ),
              validator: validateUsername,
            ),
          )
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
      margin: EdgeInsets.only(top: 77),
      width: 296.23,
    );
  }
}

String validatePassword(String value) {
  Pattern pattern = r'^([a-zA-Z0-9]+)$';
  RegExp regex = new RegExp(pattern);
  if (value.isEmpty)
    return 'กรุณากรอกรหัสผ่าน';
  else if (!regex.hasMatch(value))
    return 'เป็น a-z A-Z หรือ 0-9 เท่านั้น';
  else
    return null;
}

String validateUsername(String value) {
  Pattern pattern = r'^([a-zA-Z0-9]+)$';
  RegExp regex = new RegExp(pattern);
  if (value.isEmpty)
    return 'กรุณากรอกชื่อผู้ใช้';
  else if (!regex.hasMatch(value))
    return 'เป็น a-z A-Z หรือ 0-9 เท่านั้น';
  else
    return null;
}
