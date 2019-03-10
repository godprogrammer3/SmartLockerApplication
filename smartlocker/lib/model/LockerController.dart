import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'dart:io';
class LockerController{
  final httpClient = new Client();
  Future<Map> fillterLocker(String token,int lockerId) async {
    String url ='http://smart-locker-227608.appspot.com/v1.1/lockers?id='+lockerId.toString();
    var response = await httpClient.get(url,  headers: {HttpHeaders.authorizationHeader: token},);
     //print('Response status: ${response.statusCode}');
     var  result = new Map();
    if(response.statusCode==200){
      result = jsonDecode(response.body);
    }else if(response.statusCode==401){
      result['success']=false;
      result['error']=response.body;
    }
    return result; 
  }
  Future<Map> update(String token,int lockerId,String state) async {
    String url ='http://smart-locker-227608.appspot.com/v1.1/lockers/'+lockerId.toString();
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
  
}
