import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'dart:io';
class LockerController{
  final httpClient = new Client();
  Future<Map> getBoxState(String token,int lockerNumber,int boxNumber) async {
    String url ='http://smart-locker-227608.appspot.com/v1.1/lockers/${lockerNumber}/boxes/${boxNumber}';
    var response = await httpClient.get(url,  headers: {HttpHeaders.authorizationHeader: token},);
     //print('Response status: ${response.statusCode}');
     var  result = new Map();
    if(response.statusCode==200){
      result = jsonDecode(response.body);
      result['success'] = true;
    }else{
      result['success']=false;
      result['error']=response.body;
    }
    return result; 
  }
  Future<Map> update(String token,int lockerNumber,int boxNumber,String state) async {
    String url ='http://smart-locker-227608.appspot.com//v1.1/lockers/$lockerNumber/boxes/$boxNumber';
    Map data ={
      'state':state
    };
    var response = await httpClient.put(url,body:jsonEncode(data),headers: {"Content-Type": "application/json",HttpHeaders.authorizationHeader: token}); 
    //print('Response status: ${response.statusCode}');
    var  result = new Map();
    if(response.statusCode==200){
      result = jsonDecode(response.body);
      result['success'] = true;
    }else{
      result['success']=false;
      result['error']=response.body;
    }
    return result; 
  }
  Future<Map> getRecentRequest(String token,int lockerNumber,int boxNumber) async {
    String url ='http://smart-locker-227608.appspot.com/v1.1/lockers/$lockerNumber/boxes/$boxNumber/requests?order=id:DESC&limit=1';
    var response = await httpClient.get(url,  headers: {HttpHeaders.authorizationHeader: token},);
     //print('Response status: ${response.statusCode}');
    var tmpResult;
    var result = new Map();
    if(response.statusCode==200){
      //print(response.body);
      tmpResult = jsonDecode(response.body);
      result = tmpResult[0];
      result['success'] = true;
    }else{
      result['success']=false;
      result['error']=response.body;
    }
    return result; 
  }

}
