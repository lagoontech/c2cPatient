import 'dart:convert';
import 'package:care2care/Screens_/HomeView/home_view.dart';
import 'package:care2care/Screens_/PrimaryInformation/primaryInformation_view.dart';
import 'package:care2care/constants/api_urls.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../ReusableUtils_/toast2.dart';
import '../../../sharedPref/sharedPref.dart';
import '../../Profile/Controller/initila_profile_controller.dart';
import '../../Profile/profile_view.dart';

class OtpController extends GetxController {
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
      await initialProfileDetails.fetchInitialUserDetails();
      final profileList = initialProfileDetails.profileList;
      final data = profileList?.data;
      final patientInfo = data?.patientInfo;
      final patientSchedules = data?.patientSchedules;

      if (profileList != null && data != null && patientInfo != null && patientSchedules != null) {
        onUserDetailsCompleted();
        Get.offAll(() => HomeView());
      } else if (profileList != null && data != null && patientInfo == null) {
        Get.offAll(() => ProfileView());
      } else if (profileList != null && data != null && patientSchedules == null) {
        Get.offAll(() => PrimaryInformationView());
      } else {
        showCustomToast(
            message: "Unable to load your profile. Please complete setup.");
        Get.offAll(() => ProfileView());
      }
    } else {
      var responseBody = jsonDecode(result.body);
      String errorMessage = responseBody['message'];
      debugPrint("Error: $errorMessage");
      showCustomToast(message: errorMessage);
    }
    isLoading = false;
    update();
  }

  void onUserDetailsCompleted() {
    SharedPref().setRegisterComplete(true);
  }
}
