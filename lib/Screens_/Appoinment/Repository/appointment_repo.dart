import 'dart:convert';
import 'package:care2care/Screens_/Appoinment/modal/appointment_details_model.dart';
import 'package:care2care/constants/api_urls.dart';
import 'package:care2care/sharedPref/sharedPref.dart';
import 'package:http/http.dart' as http;

class AppointmentRepo {


  Future<dynamic> getAppointmentDetails(int id) async{

    var token = await SharedPref().getToken();
    try{
      var result = await http.get(Uri.parse(ApiUrls().appointmentDetails+"$id"),headers: {
        "authorization": "Bearer $token"
      });
      if(result.statusCode == 200){
        var decoded = AppointmentDetails.fromJson(jsonDecode(result.body));
        print(decoded);
        return decoded;
      }
    }catch(e){

    }
    return null;
  }

}