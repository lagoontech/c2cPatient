import 'package:care2care/ReusableUtils_/AppColors.dart';
import 'package:care2care/ReusableUtils_/customButton.dart';
import 'package:care2care/ReusableUtils_/image_background.dart';
import 'package:care2care/ReusableUtils_/sizes.dart';
import 'package:care2care/Screens_/location/search_location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../Profile/Controller/initila_profile_controller.dart';

class AllowLocation extends StatelessWidget {
  AllowLocation({super.key});

  InitialProfileDetails ip = Get.find<InitialProfileDetails>();

  @override
  Widget build(BuildContext context) {
    return CustomBackground(
        child: Column(
      children: [
        kHeight90,
        kHeight90,
        Container(
          height: MediaQuery.of(context).size.height * 0.15,
          decoration: BoxDecoration(
              color: AppColors.secondaryColor.withOpacity(0.09),
              shape: BoxShape.circle),
          child: Center(
            child: Icon(
              size: 40.sp,
              Icons.location_on_rounded,
              color: AppColors.secondaryColor,
            ),
          ),
        ),
        kHeight20,
        Text(
          "What is Your Location?",
          style: TextStyle(
              fontSize: 20.sp,
              color: Colors.black,
              fontWeight: FontWeight.w600),
        ),
        kHeight20,
        Text(
          'We need to know your location in order to',
          style: TextStyle(
              color: Colors.black,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500),
        ),
        Text(
          'suggest nearby services.',
          style: TextStyle(
              color: Colors.black,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500),
        ),
        kHeight70,
        kHeight40,
        GetBuilder<InitialProfileDetails>(builder: (v) {
          return CustomButton(
              text: "Allow Location Access",
              onPressed: () async {
                await v.allowLocationAccess();
                await Get.to(() => SearchLocation());
              });
        })
      ],
    ));
  }
}
