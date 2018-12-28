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

class RequestController{
  final httpClient = new Client();
  Future<Map> userSent(String user_name,String locker_number,String box_number,String reason,int status) async {
    String url ='https://webserv.kmitl.ac.th/godprogrammer/request.php';
    Map data = {
      'user_name': user_name,
      'locker_number' : locker_number,
      'box_number':box_number,
      'reason':reason,
      'status':status,
    };
    var response = await httpClient.post(url, body: jsonEncode(data));
    print('Response status: ${response.statusCode}');
    Map result = jsonDecode(response.body);
    return result; 
  }
  Future<Map> userGet(String requestId,int status) async {
    String url ='https://webserv.kmitl.ac.th/godprogrammer/request.php';
    Map data = {
      'request_id':requestId,
      'status':status,
    };
    var response = await httpClient.post(url, body: jsonEncode(data));
    print('Response status: ${response.statusCode}');
    Map result = jsonDecode(response.body);
    return result; 
  }
  Future<Map> adminGet() async {
    String url ='https://webserv.kmitl.ac.th/godprogrammer/box.php';
    Map data = {
      'query':'getBoxState',
    };
    var response = await httpClient.post(url, body: jsonEncode(data));
    print('Response status: ${response.statusCode}');
    Map result = jsonDecode(response.body);
    return result;
  }
  Future<Map> adminSent(String requestId,int status) async {
    print(requestId);
    String url ='https://webserv.kmitl.ac.th/godprogrammer/box.php';
    Map data = {
      'query':'updateBoxState',
      'request_id':requestId,
      'status':status,
    };
    var response = await httpClient.post(url, body: jsonEncode(data));
    if(status == 2)
      status = 1;
    else if(status == 0)
      status = -1;
    print('Response status: ${response.statusCode}');
    Map result = jsonDecode(response.body);
    url = 'https://webserv.kmitl.ac.th/godprogrammer/request.php';
    data ={
      'request_id':requestId,
      'status':status,
    };
    await httpClient.post(url, body: jsonEncode(data));
    print(result);
    return result;
  }
}
