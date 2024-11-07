import 'dart:convert';

import 'package:care2care/ReusableUtils_/AppColors.dart';
import 'package:care2care/ReusableUtils_/sizes.dart';
import 'package:care2care/Screens_/HomeView/home_view.dart';
import 'package:care2care/sharedPref/sharedPref.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart'; // Import GetX
import 'package:googleapis_auth/auth_io.dart';
import '../../ReusableUtils_/image_background.dart';
import '../../ReusableUtils_/loader.dart';
import '../Auth_screen/Sigin_screen/signIn_view.dart';
import 'package:http/http.dart' as http;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    tokenCheck();
  }

  tokenCheck() async {
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
