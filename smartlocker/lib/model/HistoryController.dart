import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'dart:io';

class HistoryController{
  final httpClient = new Client();
  final String host = "http://139.59.242.154:8888";
  Future<List> getAllRequestLocker(String token) async {
    String url ='$host/v1.1/requests?order=createdAt:DESC&limit=10';
    var response = await httpClient.get(url,headers: {HttpHeaders.authorizationHeader: token}); 
    print('Response recent status history: ${response.statusCode}');
      List result;
    if(response.statusCode==200){
      List temp = jsonDecode(response.body);
      result = temp;
      
    }else{
      var detail = {'success':false,'error':response.body};
      result = [detail];
    }
    // print(result.toString());
    return result; 
  }

}
