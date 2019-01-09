import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
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
    int status2;
    if(status == 5)
    {
      status = 0;
      status2 = 5;
    }else if(status == 2){
      status2 = 1;
    }else if(status == 0){
      status2 = -1;
    }
    String url ='https://webserv.kmitl.ac.th/godprogrammer/box.php';
    Map data = {
      'query':'updateBoxState',
      'request_id':requestId,
      'status':status,
    };
    var response = await httpClient.post(url, body: jsonEncode(data));
    
    
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
