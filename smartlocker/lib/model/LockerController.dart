import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'dart:io';
class LockerController{
  final httpClient = new Client();
  final String host = "http://139.59.242.154:8888";
  Future<Map> getBoxState(String token,int lockerNumber,int boxNumber) async {
    String url ='$host/v1.1/lockers/${lockerNumber}/boxes/${boxNumber}';
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
    String url ='$host/v1.1/lockers/$lockerNumber/boxes/$boxNumber';
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
    String url ='$host/v1.1/lockers/$lockerNumber/boxes/$boxNumber/requests?order=id:DESC&limit=1';
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
  Future<Map> countLocker(String token) async {
    String url ='$host/v1.1/lockers/count?';
    var response = await httpClient.get(url,  headers: {HttpHeaders.authorizationHeader: token},);
     print('Response status of countLocker: ${response.statusCode}');
    var tmpResult;
    var result = new Map();
    if(response.statusCode==200){
      //print(response.body);
      result = jsonDecode(response.body);
      result['success'] = true;
    }else{
      result['success']=false;
      result['error']=response.body;
    }
    return result; 
  }
   Future<Map> countBox(String token,int lockerNumber) async {
    String url ='$host/v1.1/lockers/${lockerNumber}/boxes/count?';
    var response = await httpClient.get(url,  headers: {HttpHeaders.authorizationHeader: token},);
     print('Response status of countBox: ${response.statusCode}');
    var result = new Map();
    if(response.statusCode==200){
      result = jsonDecode(response.body);
      result['success'] = true;
    }else{
      result['success']=false;
      result['error']=response.body;
    }
    return result; 
  }
  Future<Map> countOpenboxs(String token,int lockerNumber) async {
    String url ='$host/v1.1/lockers/${lockerNumber}/boxes?state=open';
    var response = await httpClient.get(url,  headers: {HttpHeaders.authorizationHeader: token},);
     print('Response status of countOpenBoxs: ${response.statusCode}');
    var result = new Map();
    if(response.statusCode==200){
      result['count'] = jsonDecode(response.body).length;
      result['success'] = true;
    }else{
      result['success']=false;
      result['error']=response.body;
    }
    return result; 
  }
  Future<Map> countLockerRequest(String token,int lockerNumber) async {
    String urlTotalBox ='$host/v1.1/lockers/${lockerNumber}/boxes/count?';
    var responseTotalBox = await httpClient.get(urlTotalBox,  headers: {HttpHeaders.authorizationHeader: token},);
    int totalBox =jsonDecode(responseTotalBox.body)['count'];
    int totalRequest = 0;
    Map result = new Map();
    bool haveProblem = false;
    for( int i = 1 ; i <= totalBox ; i++ ){
      List<dynamic> temp = await getBoxsWithQuery(token, lockerNumber, i, "state=wait") as List<dynamic>;
      if( temp[0]['success'] == true){
        totalRequest+=temp[1].length;
      }else{
        result['success'] = false;
        haveProblem = true;
        result['error'] = temp[1]['error'];
        break;
      }
    }
    if(!haveProblem){
      result['count'] = totalRequest;
    }
    return result;
   
  }
  Future<List> getBoxsWithQuery(String token,int lockerNumber,int boxNumber,String query) async {
    String maxIdUrl = '$host/v1.1/lockers/${lockerNumber}/boxes/${boxNumber}/requests?limit=1&order=id:DESC';
    var maxIdResponse = await httpClient.get(maxIdUrl,  headers: {HttpHeaders.authorizationHeader: token},);
    int maxId = jsonDecode(maxIdResponse.body)[0]['id'];
    String url ='$host/v1.1/lockers/${lockerNumber}/boxes/${boxNumber}/requests?'+query+'&limit='+maxId.toString();
    var response = await httpClient.get(url,  headers: {HttpHeaders.authorizationHeader: token},);
     print('Response status of getBoxsWithQuery: ${response.statusCode}');
    List result = new List();
    if(response.statusCode==200){ 
      result.add({'success':true});
      result.add(jsonDecode(response.body));
    }else{
      result.add({'success':false});
      result.add({'error':jsonDecode(response.body)['error']});
    }
    return result;
  }
Future<List> getAllBoxState(String token,int lockerNumber) async {
    String url ='$host/v1.1/lockers/${lockerNumber}/boxes?';
    var response = await httpClient.get(url,  headers: {HttpHeaders.authorizationHeader: token},);
     print('Response status of getAllBoxState: ${response.statusCode}');
    List result = new List();
    if(response.statusCode==200){ 
      result.add({'success':true});
      result.add(jsonDecode(response.body));
    }else{ 
      result.add({'success':false});
      if(response.body == "Unauthorized")
        result.add({'error':"Unauthorized"});
      else
        result.add({'error':jsonDecode(response.body)['error']}); 
     
    }
    return result;
  }
  
}
