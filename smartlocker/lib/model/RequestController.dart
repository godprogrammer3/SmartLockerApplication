import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'dart:io';
class RequestController{
  final httpClient = new Client();
   Future<Map> filterRequest(String token,int lockerId) async {
    String url ='http://smart-locker-227608.appspot.com/v1.1/requests?state=wait&lockerId='+lockerId.toString();
    var response = await httpClient.get(url,  headers: {HttpHeaders.authorizationHeader: token},); 
    //print('Response status: ${response.statusCode}');
    var  result = new Map();
    if(response.statusCode==200){
      result = jsonDecode(response.body);
    }else if(response.statusCode==401){
      result['success']=false;
      result['error']=response.body;
    }else{
      result = jsonDecode(response.body);
    }
    return result; 
  }
  Future<Map> update(String token,int requestId,String state) async {
    String url ='http://smart-locker-227608.appspot.com/v1.1/requests/'+requestId.toString();
    Map data ={
      'state':state
    };
    var response = await httpClient.put(url,body:jsonEncode(data),headers: {"Content-Type": "application/json",HttpHeaders.authorizationHeader: token}); 
    print('Response status: ${response.statusCode}');
    var  result = new Map();
    if(response.statusCode==200){
      result = jsonDecode(response.body);
    }else if(response.statusCode==401){
      result['success']=false;
      result['error']=response.body;
    }else{
      result = jsonDecode(response.body);
    }
    return result; 
  }
  Future<Map> create(String token,int lockerNumber,int boxNumber,String reason) async {
    String url ='http://smart-locker-227608.appspot.com/v1.1/requests';
    Map data ={
      'lockerNum':lockerNumber,
      'boxNum':boxNumber,
      'reason':reason
    };
    var response = await httpClient.post(url,body:jsonEncode(data),headers: {"Content-Type": "application/json",HttpHeaders.authorizationHeader: token}); 
    print('Response status: ${response.statusCode}');
    var  result = new Map();
    if(response.statusCode==200){
      result = jsonDecode(response.body);
    }else if(response.statusCode==401){
      result['success']=false;
      result['error']=response.body;
    }else{
      result = jsonDecode(response.body);
    }
    return result; 
  }
}
