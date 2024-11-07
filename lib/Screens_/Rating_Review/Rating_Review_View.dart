import 'package:care2care/ReusableUtils_/appBar.dart';
import 'package:care2care/ReusableUtils_/customButton.dart';
import 'package:care2care/ReusableUtils_/customLabel.dart';
import 'package:care2care/ReusableUtils_/image_background.dart';
import 'package:custom_rating_bar/custom_rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iconly/iconly.dart';

import '../../ReusableUtils_/AppColors.dart';
import '../../ReusableUtils_/Custom_AppoinMents.dart';
import '../../ReusableUtils_/sizes.dart';
import '../Paymentmethod/Payment_method.dart';

class RatingReviewView extends StatelessWidget {
  const RatingReviewView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomBackground(
        bottomNavBar: Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height * 0.11,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {},
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.05,
                  width: MediaQuery.of(context).size.width * 0.34,
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20.r)),
                  child: Center(
                    child: Text("Cancel"),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Get.to(() => PaymentMethod());
                },
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.05,
                  width: MediaQuery.of(context).size.width * 0.34,
                  decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(20.r)),
                  child: Center(
                    child: Text(
                      "Submit",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        appBar: CustomAppBar(
          title: "Rating & Review",
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: SingleChildScrollView(
            child: Column(
              children: [
                kHeight10,
                const AppointmentsContainer(
                    action: "Completed",
                    actionColor: AppColors.secondaryColor,
                    statusColor: AppColors.secondaryColor,
                    appointmentDate: "21/08/2024",
                    appointmentTime: "01:15 PM",
                    doctorName: "Habbeeban ",
                    doctorDesignation: "Neurologiest",
                    imageUrl: 'assets/images/Rectangle 4486.png'),
                kHeight30,
                Container(
                  height: MediaQuery.of(context).size.height * 0.10,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Your Overall rating',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20.sp),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RatingBar(
                            filledIcon: Icons.star,
                            emptyIcon: Icons.star_border,
                            onRatingChanged: (value) => debugPrint('$value'),
                            initialRating: 3,
                            maxRating: 5,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                kHeight10,
                CustomLabel(
                  text: "Add Detailed Review",
                  fontWeight: FontWeight.bold,
                ),
                kHeight10,
                TextField(
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: "Search here...",
                    //filled: true,
                    focusColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.black, width: 0.3),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    border: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.black, width: 0.3),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.black, width: 0.3),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    hintStyle: const TextStyle(color: Colors.grey),
                  ),
                ),
                kHeight10,
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(5.r)),
                    padding: EdgeInsets.all(2.r),
                    width: 120.w,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          IconlyLight.camera,
                          color: AppColors.primaryColor,
                        ),
                        Text("Add Photo")
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
