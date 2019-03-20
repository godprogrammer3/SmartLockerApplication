import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'dart:io';
class HistoryController{
  final httpClient = new Client();

  Future<List> getAllRequestLocker(String token) async {
    String url ='http://smart-locker-227608.appspot.com/v1.1/requests?order=createdAt:DESC&limit=10';
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
