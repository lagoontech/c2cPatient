import 'dart:convert';
import 'package:care2care/Screens_/HomeView/home_view.dart';
import 'package:care2care/Screens_/PrimaryInformation/primaryInformation_view.dart';
import 'package:care2care/constants/api_urls.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../ReusableUtils_/toast2.dart';
import '../../../sharedPref/sharedPref.dart';
import '../../Profile/Controller/initila_profile_controller.dart';
import '../../Profile/profile_view.dart';

class OtpController extends GetxController {
  // Initialize InitialProfileDetails controller
  InitialProfileDetails initialProfileDetails =
      Get.put(InitialProfileDetails());

  TextEditingController otpTEC = TextEditingController();
  bool isUserFound = false;
  bool isLoading = false;

  checkOtp({
    BuildContext? context,
    String? phoneNumber,
  }) async {
    if (otpTEC.text.length != 4) {
      showCustomToast(message: "OTP must be  4 digits");
      return;
    }
    isLoading = true;
    update();
    /*try {*/
    var result = await http.post(Uri.parse(ApiUrls().checkOtp),
        body: {
          "mobilenum": phoneNumber,
          "otp": otpTEC.text});
    if (result.statusCode == 200) {
      var response = jsonDecode(result.body);
      debugPrint(response.toString());
      var token = response['token'];
      var savedToken = await SharedPref().saveToken(token);
      await initialProfileDetails.fetchCommonDetails();
      debugPrint("userToken${savedToken}");
      bool locationIsEnabled = await Geolocator.isLocationServiceEnabled();
      await initialProfileDetails.fetchInitialUserDetails();
      final profileList = initialProfileDetails.profileList;
      final data = profileList?.data;
      final patientInfo = data?.patientInfo;
      final patientSchedules = data?.patientSchedules;

      if (profileList != null && data != null && patientInfo != null && patientSchedules != null) {
        print("Navigating to HomeView");
        print("Profile List: $profileList");
        print("Patient Info: $patientInfo");

        Get.offAll(() => HomeView());
      } else if (profileList != null && data != null && patientInfo == null) {
        print("Navigating to ProfileView");
        Get.offAll(() => ProfileView());
      } else if (profileList != null && data != null && patientSchedules == null) {
        Get.offAll(() => PrimaryInformationView());
      }

      if (profileList != null && data != null && patientInfo != null) {
        onUserDetailsCompleted();
      }
    /*  if (locationIsEnabled) {
        await initialProfileDetails.fetchInitialUserDetails();
        Get.to(() => ProfileView());
      } else {
        Get.to(() => AllowLocation());
      }*/
    } else {
      var responseBody = jsonDecode(result.body);
      String errorMessage = responseBody['message'];
      debugPrint("Error: $errorMessage");
      showCustomToast(message: errorMessage);
    }
    /* } catch (e) {
      debugPrint(e.toString());
    }*/
    isLoading = false;
    update();
  }
  void onUserDetailsCompleted() {
    SharedPref().setRegisterComplete(true);
  }
}
