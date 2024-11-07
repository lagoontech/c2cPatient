import 'package:care2care/Screens_/HomeView/home_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iconly/iconly.dart';
import 'package:lottie/lottie.dart';
import 'package:care2care/ReusableUtils_/AppColors.dart';
import 'package:care2care/ReusableUtils_/appBar.dart';

class PaymentSuccessful extends StatelessWidget {
  String? careTakerName;
  String? bookingDate;
  String? bookingFromTime;
  String? bookingToTime;
  String? payId;
  String? amount;

  PaymentSuccessful(
      {Key? key,
      this.bookingDate,
      this.bookingFromTime,
      this.bookingToTime,
      this.payId,
      this.amount,
      this.careTakerName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Payment Successful',
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/Splash.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.33,
                  width: MediaQuery.of(context).size.width,
                  child: Lottie.asset(
                      repeat: false,
                      'assets/lottie/Animation - 1724308788670.json'),
                ),
                SizedBox(height: 10.h),
                Text("You have successfully booked appointment with"),
                SizedBox(height: 5.h),
                Text(
                  careTakerName!,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryColor,
                  ),
                ),
                SizedBox(height: 10.h),
                Container(
                  height: MediaQuery.of(context).size.height * 0.20,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          customWidget(
                              icon: IconlyBold.user_2, text: careTakerName),
                          SizedBox(width: 10.w),
                          customWidget(
                              icon: IconlyBold.calendar, text: bookingDate),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          customWidget(
                              icon: Icons.access_time_filled,
                              text: "${bookingFromTime} - ${bookingToTime}"),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.monetization_on,
                                color: AppColors.primaryColor, size: 20.sp),
                            Text("Paid Amount : \$${amount}"),
                          ],
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Center(
                        child: Text("Payment Id : ${payId}"),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 20.h,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      Get.offAll(() => HomeView());
                    },
                    child: Container(
                      padding: EdgeInsets.all(3.r),
                      width: MediaQuery.of(context).size.width * 0.35,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(5.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            IconlyBold.home,
                            color: Colors.white,
                          ),
                          SizedBox(width: 10.w),
                          Text(
                            "Go to Home",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  /*    GestureDetector(
                    onTap: () {
                      */ /*Get.to(
                        () => const ReceiptView(),
                      );*/ /*
                    },
                    child: Text(
                      "View Receipt",
                      style: TextStyle(color: AppColors.primaryColor),
                    ),
                  ),*/
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget customWidget({String? text, IconData? icon}) {
    return Row(
      children: [
        Icon(
          icon,
          size: 22.sp,
          color: AppColors.primaryColor,
        ),
        SizedBox(width: 10.w),
        Text(
          text ?? ' ',
          style: TextStyle(fontSize: 14.sp),
        ),
      ],
    );
  }
}
