import 'package:care2care/ReusableUtils_/AppColors.dart';
import 'package:care2care/ReusableUtils_/sizes.dart';
import 'package:care2care/Screens_/HomeView/home_view.dart';
import 'package:care2care/sharedPref/sharedPref.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart'; // Import GetX
import '../../ReusableUtils_/image_background.dart';
import '../../ReusableUtils_/loader.dart';
import '../Auth_screen/Sigin_screen/signIn_view.dart';
import '../PrimaryInformation/primaryInformation_view.dart';
import '../Profile/Controller/initila_profile_controller.dart';
import '../Profile/profile_view.dart';

class SplashScreen extends StatefulWidget {
   SplashScreen({super.key,this.fromSchedule = false});

  bool ?fromSchedule;

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {

  //
  @override
  void initState() {
    super.initState();
    tokenCheck();
  }

  //
  tokenCheck() async {
    if(widget.fromSchedule!){
      await Future.delayed(Duration(milliseconds: 1500));
      Get.offAll(() => HomeView());
      return;
    }
    widget.fromSchedule = false;
    InitialProfileDetails initialProfileDetails =
    Get.put(InitialProfileDetails());
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
      return;
    } else if (profileList != null && data != null && patientInfo == null) {
      print("Navigating to ProfileView");
      Get.offAll(() => ProfileView());
      return;
    } else if (profileList != null && data != null && patientSchedules == null) {
      Get.offAll(() => PrimaryInformationView());
      return;
    }

    if (profileList != null && data != null && patientInfo != null) {
      onUserDetailsCompleted();
    }
    bool isDetailsComplete = await SharedPref().getRegisterComplete();
    Future.delayed(const Duration(seconds: 1), () {
      if (isDetailsComplete) {
        Get.off(() => HomeView());
      } else {
        Get.off(() => MobileEmail());
      }
    }).then((_){
      requestNotificationPermissions();
    });
  }

  //
  void onUserDetailsCompleted() {
    SharedPref().setRegisterComplete(true);
  }

  Future<void> requestNotificationPermissions() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission for notifications');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted notification permissions');
    }
  }

  @override
  Widget build(BuildContext context) {

    if(widget.fromSchedule!=null && widget.fromSchedule!){
      tokenCheck();
    }

    return CustomBackground(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: SvgPicture.asset(
              'assets/images/svg/logo.svg',
            ),
          ),
          kHeight10,
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 50.h),
              child: CustomCircularLoader(
                height: 50.h,
                width: 50.w,
                color: AppColors.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
