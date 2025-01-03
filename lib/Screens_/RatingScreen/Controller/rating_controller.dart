import 'dart:convert';
import 'package:care2care/constants/api_urls.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../ReusableUtils_/toast2.dart';
import '../../../sharedPref/sharedPref.dart';

class RatingController extends GetxController{

  double rating = 0.0;
  TextEditingController ratingTEC = TextEditingController();
  bool ratingCaretaker = false;
  int ?careTakerId;

  //
  rateAndReview() async{

    ratingCaretaker = true;
    update();
    try{
      String? token = await SharedPref().getToken();
      var result = await http.post(
          Uri.parse(ApiUrls().addReview),
          body: jsonEncode({
            "caretaker_id": careTakerId,
            "rating": int.parse(rating.toStringAsFixed(0)),
            "review_msg": ratingTEC.text
          }),
        headers: {
            "authorization": "Bearer $token",
            "Content-Type": "application/json"
        }
      );
      if(result.statusCode == 200){
        showCustomToast(
            message: jsonDecode(result.body)["message"], gravity: ToastGravity.CENTER);
        Get.back();
      } else if(result.statusCode == 400){
        showCustomToast(
            message: jsonDecode(result.body)["message"], gravity: ToastGravity.CENTER);
      }
    }catch (e){
      print(e);
    }
    ratingCaretaker = false;
    update();

  }


}