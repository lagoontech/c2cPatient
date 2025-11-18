import 'dart:convert';

import 'package:care2care/ReusableUtils_/toast2.dart';

class ResponseUtils{


  showErrorToast(dynamic body,{int statusCode = 0}){

    var decoded = jsonDecode(body);
    if(statusCode == 422){
      if(decoded is Map){
        var message = decoded[decoded.keys.first];
        if(message is List){
          showCustomToast(message: message[0]);
        }else if(message is String){
          showCustomToast(message: message);
        }

      }
    }

  }

}