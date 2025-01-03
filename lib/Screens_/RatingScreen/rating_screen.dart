import 'package:care2care/ReusableUtils_/AppColors.dart';
import 'package:care2care/ReusableUtils_/Custom_AppoinMents.dart';
import 'package:care2care/ReusableUtils_/customButton.dart';
import 'package:care2care/ReusableUtils_/custom_textfield.dart';
import 'package:care2care/ReusableUtils_/image_background.dart';
import 'package:care2care/Screens_/RatingScreen/Controller/rating_controller.dart';
import 'package:custom_rating_bar/custom_rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../ReusableUtils_/appBar.dart';

class RatingScreen extends StatelessWidget {

   RatingScreen({
     super.key,
     this.name,
     this.appointmentDate,
     this.appointmentTime,
     this.careTakerId
   });

   String ?name;
   String ?appointmentTime;
   String ?appointmentDate;
   int ?careTakerId;

   RatingController rc = Get.put(RatingController());

  @override
  Widget build(BuildContext context) {

    if(rc.careTakerId == null){
      rc.careTakerId = careTakerId;
    }

    return CustomBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: CustomAppBar(
          title: 'Rating and Review',
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
                
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w,vertical: 8.h),
                child: AppointmentsContainer(
                    imageUrl: "",
                    appointmentDate: appointmentDate!,
                    appointmentTime: appointmentTime!,
                    doctorName: name!,
                    doctorDesignation: ""
                ),
              ),
                
              SizedBox(height: 48.h,),
                
              Text(
                  "Your rating",
                  style: TextStyle(
                      fontSize: 24.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
              ),
                
              SizedBox(height: 24.h,),
                
              RatingBar(
                  alignment: Alignment.center,
                  filledIcon: Icons.star,
                  emptyIcon: Icons.star_border,
                  size: 48.sp,
                  onRatingChanged: (v){
                    rc.rating = v;
                    rc.update();
                  }
              ),
                
              SizedBox(height: 24.h,),
                
              Padding(
                padding: EdgeInsets.only(left: 14.w),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Add detailed review")
                ),
              ),
              
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w,vertical: 12.h),
                child: customTextField(
                    context,
                    hint: "Enter here...",
                    hintStyle: TextStyle(color: Colors.grey.shade400,fontSize: 13.sp),
                    controller: rc.ratingTEC,
                    labelText: "",
                    maxLines: 4,
                    borderColor: Colors.grey.shade400,
                    borderRadius: 12.r
                ),
              )
                
            ],
          ),
        ),
        bottomNavigationBar: Container(
          width: MediaQuery.of(context).size.width,
          height: 80.h,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                offset: Offset(0,-2),
                color: Colors.black12,
                blurRadius: 4
              )
            ]
          ),
          child: Row(
            children: [
      
              Expanded(
                child: CustomButton(
                  text: "Cancel",
                  onPressed: (){
                    Get.back();
                  },
                  textColor: Colors.black,
                  color: Colors.grey.shade300,
                ),
              ),
      
              GetBuilder<RatingController>(
                builder: (vc) {
                  return Expanded(
                    child: CustomButton(
                      text: "Submit",
                      isLoading: vc.ratingCaretaker,
                      onPressed: (){
                        rc.rateAndReview();
                      },
                    ),
                  );
                }
              )
      
            ],
          ),
        ),
      
      ),
    );
  }
}
