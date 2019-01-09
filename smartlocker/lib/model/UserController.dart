import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
class UserController {
  final httpClient = new Client();
  Future<Map> login(String user_name,String user_password) async {
    String url ='https://webserv.kmitl.ac.th/godprogrammer/user/login.php';
    Map data = {
      'user_name': user_name,
      'user_password' : user_password,
    };
    var response = await httpClient.post(url, body: jsonEncode(data));
    print('Response status: ${response.statusCode}');
    Map result =  jsonDecode(response.body);
    return result; 
  }
}
