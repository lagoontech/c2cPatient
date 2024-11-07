import 'package:care2care/ReusableUtils_/appBar.dart';
import 'package:care2care/ReusableUtils_/image_background.dart';
import 'package:care2care/ReusableUtils_/sizes.dart';
import 'package:care2care/Screens_/Profile/Controller/initila_profile_controller.dart';
import 'package:care2care/Screens_/location/controller/location_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../Profile/profile_view.dart';

class SearchLocation extends StatelessWidget {
  SearchLocation({super.key});

  LocationController lc = Get.put(LocationController());
  InitialProfileDetails initialProfileDetails =
  Get.put(InitialProfileDetails());

  @override
  Widget build(BuildContext context) {
    return CustomBackground(
        appBar: CustomAppBar(
          title: "Enter Your Location",
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0.r),
          child: Column(
            children: [
              GetBuilder<LocationController>(builder: (v) {
                return Container(
                  height: 40.h,
                  child: TextField(
                    onChanged: (z) {
                      v.update();
                    },
                    controller: v.locationCT,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      prefixIcon: Container(
                        padding: EdgeInsets.symmetric(vertical: 10.r),
                        child: Image(
                          image: const AssetImage(
                            'assets/icons/search.png',
                          ),
                          height: 20.h,
                          width: 20.w,
                        ),
                      ),
                      suffixIcon: v.locationCT.text.isNotEmpty
                          ? Icon(
                              Icons.clear,
                              color: Colors.red,
                            )
                          : SizedBox(),
                      // / contentPadding: EdgeInsets.symmetric(horizontal: 8.w),
                      filled: true,
                      fillColor: Colors.white,
                      focusColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.black, width: 0.5),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      border: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.black, width: 0.5),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.black, width: 0.5),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      hintText: 'Search Your Location',
                      hintStyle: const TextStyle(color: Colors.grey),
                    ),
                  ),
                );
              }),
              kHeight10,
              Container(
                height: 40.h,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/icons/send-2.png",
                      height: MediaQuery.of(context).size.height * 0.04,
                    ),
                    kWidth10,
                    GestureDetector(
                      onTap: ()async{
                       await initialProfileDetails.fetchInitialUserDetails();
                       await  Get.to(()=> ProfileView());
                      },
                      child: Text(
                        "Use My Current Location",
                        style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16.sp),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
