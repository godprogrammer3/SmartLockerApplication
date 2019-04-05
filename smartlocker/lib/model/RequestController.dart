import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'dart:io';
class RequestController{
  final httpClient = new Client();
  final String host = "http://139.59.242.154:8888";
  Future<Map> filterRequest(String token,int lockerId) async {
    String url ='$host/v1.1/requests?state=wait&lockerId='+lockerId.toString();
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
  Future<Map> filterRequestQuery(String token,String query) async {
    String url ='$host/v1.1/requests?'+query;
    var response = await httpClient.get(url,  headers: {HttpHeaders.authorizationHeader: token},); 
    //print('Response status: ${response.statusCode}');
    var  result = new Map();
    if(response.statusCode==200){
      result = jsonDecode(response.body);
      result['success'] = true;
    }else if(response.statusCode==401){
      result['success']=false;
      result['error']=response.body;
    }else{
      result = jsonDecode(response.body);
    }
    return result; 
  }
  Future<Map> update(String token,int requestId,String state) async {
    String url ='$host/v1.1/requests/'+requestId.toString();
    Map data ={
      'state':state
    };
    var response = await httpClient.put(url,body:jsonEncode(data),headers: {"Content-Type": "application/json",HttpHeaders.authorizationHeader: token}); 
    print('Response status: ${response.statusCode}');
    var  result = new Map();
    if(response.statusCode==200){
      result = jsonDecode(response.body);
      result['success'] = true;
    }else{
      result['success'] = false;
      result['error'] = response.body;
    }
    return result; 
  }
  Future<Map> create(String token,int lockerNumber,int boxNumber,String reason) async {
    String url ='$host/v1.1/requests';
    Map data ={
      'lockerNumber':lockerNumber,
      'boxNumber':boxNumber,
      'reason':reason
    };
    var response = await httpClient.post(url,body:jsonEncode(data),headers: {"Content-Type": "application/json",HttpHeaders.authorizationHeader: token}); 
    print('Response status: ${response.statusCode}');
    var  result = new Map();
    if(response.statusCode==201){
      result = jsonDecode(response.body);
      result['success'] = true;
    }else{
      result['success']=false;
      result['error']=response.body;
    }
    return result; 
  }
}
