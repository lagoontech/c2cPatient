import 'package:care2care/ReusableUtils_/appBar.dart';
import 'package:care2care/ReusableUtils_/customButton.dart';
import 'package:care2care/ReusableUtils_/custom_textfield.dart';
import 'package:care2care/ReusableUtils_/image_background.dart';
import 'package:care2care/ReusableUtils_/sizes.dart';
import 'package:custom_rating_bar/custom_rating_bar.dart';
import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../ReusableUtils_/AppColors.dart';
import '../CareTakerInformation/CareTaker_information.dart';
import '../HomeScreen/controller/home controller.dart';

class CaretakerList extends StatelessWidget {
  CaretakerList({super.key});

  HomeController ct = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return CustomBackground(
      appBar: CustomAppBar(
        leading: SizedBox(),
        title: "Care Taker list",
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10.w),
            child: IconButton(
              onPressed: () {
                showFilterSheet(context);
              },
              icon: const Icon(
                IconlyLight.filter,
                color: AppColors.primaryColor,
              ),
            ),
          ),
        ],
      ),
      child: SmartRefresher(
        onRefresh: () async {
          await ct.getCareTakers();
        },
        onLoading: (){
          ct.getCareTakers(loading: true);
        },
        enablePullUp: true,
        controller: ct.refreshController,
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            children: [

              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 10.h,
                    vertical: 12.h),
                child: customTextField(
                    context,
                    onChanged: (v){
                      ct.debounceSearch();
                    },
                    hint: "Search caretakers",
                    controller: ct.searchTEC,
                    borderColor: AppColors.primaryColor,
                    labelText: "",
                    prefix: Icon(Icons.search),
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.h),
                child: GetBuilder<HomeController>(
                  builder: (controller) {
                    if (controller.isLoadingCareTakersList) {
                      return Center(
                          child:
                              CircularProgressIndicator()); // Loading indicator
                    }
                    if (controller.careTakers.isEmpty) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: Center(child: Text("No Care Takers Available")),
                      );
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: controller.careTakers.length,
                      itemBuilder: (context, index) {
                        var caretaker = controller.careTakers[index].caretakerInfo;
                        var path = controller.profilePath;
                        var imgUrl = controller
                            .careTakers[index].profileImageUrl;

                        return GestureDetector(
                          onTap: () {
                            Get.to(
                              () => CaretakerInformation(
                                charge: caretaker.serviceCharge,
                                careTakerId: caretaker.caretakerId,
                                doctorName: caretaker.firstName,
                                doctorDesignation: 'Care Taker',
                                doctorState: caretaker.nationality,
                                gender: caretaker.sex,
                                about: caretaker.about,
                                totalPatient:
                                    caretaker.totalPatientsAttended.toString(),
                                experience:
                                    caretaker.yearOfExperiences.toString(),
                                rating: controller.careTakers[index].averageRating,
                                imageUrl: '${path}${imgUrl}',
                              ),
                              transition: Transition.fade,
                              duration: const Duration(milliseconds: 300),
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 3.h),
                            child: carTakerList(
                              context,
                              ct,
                              charge:caretaker.serviceCharge ,
                              gender: caretaker.sex,
                              doctorDesignation: 'Care Taker',
                              doctorName: caretaker.firstName,
                              imageUrl: '${path}${imgUrl}',
                              doctorState: caretaker.nationality,
                              totalPatient:
                                  caretaker.totalPatientsAttended.toString(),
                              experience:
                                  caretaker.yearOfExperiences.toString(),
                              rating: caretaker.yearOfExperiences.toString(),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              kHeight15,
            ],
          ),
        ),
      ),
    );
  }

  //
  Widget filterLabel(String label){

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 9.w,vertical: 12.h),
      child: Text(
          label,
          style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15.sp,
          )),
    );

  }

  //
  showFilterSheet(BuildContext context) async{

    await showModalBottomSheet(
        context: context,
        builder: (context){
          return GetBuilder<HomeController>(
            builder: (vc) {
              return Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.5,
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: SingleChildScrollView(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    filterLabel("Rating"),

                    Center(
                      child: RatingBar(
                          alignment: Alignment.center,
                          filledIcon: Icons.star,
                          emptyIcon: Icons.star_border,
                          onRatingChanged: (v){
                            ct.rating = v;
                            ct.update();
                          }
                      ),
                    ),

                    filterLabel("Price"),

                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: SliderTheme(
                        data: SliderThemeData(
                            showValueIndicator: ShowValueIndicator.always,
                        ),
                        child: RangeSlider(
                          values: ct.priceRange,
                          min: 0,
                          max: 1000,
                          labels: RangeLabels('${ct.priceRange.start.round()}', '${ct.priceRange.end.round()}'),
                          inactiveColor: Colors.grey,
                          activeColor: Colors.black,
                          onChanged: (RangeValues values) {
                            ct.priceRange = values;
                            ct.update();
                          },
                        ),
                      )
                    ),

                    SizedBox(height: 12.h,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Male Option
                      GestureDetector(
                        onTap: (){
                          ct.gender = "male";
                          ct.update();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                          decoration: BoxDecoration(
                            color: ct.gender == "male" ? Colors.blue : Colors.grey[300],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "Male",
                            style: TextStyle(
                              color: ct.gender == "male" ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Female Option
                      GestureDetector(
                        onTap: (){
                          ct.gender = "female";
                          ct.update();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                          decoration: BoxDecoration(
                            color: ct.gender == "female" ? Colors.pink : Colors.grey[300],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "Female",
                            style: TextStyle(
                              color: ct.gender == "female" ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                    SizedBox(height: 24.h,),

                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            width: 80.w,
                            text: "Apply",
                            onPressed: (){
                              ct.getCareTakers();
                            },
                          ),
                        ),
                        CustomButton(
                          width: 80.w,
                          text: "Clear",
                          color: Colors.red,
                          onPressed: (){
                            ct.gender = "";
                            ct.priceRange = const RangeValues(0, 1000);
                            ct.rating = 0.0;
                            ct.update();
                          },
                        ),
                      ],
                    )

                  ],
                ),),
              );
            }
          );
        });
  }

}

Widget carTakerList(BuildContext context, HomeController controller,
    {String? name,
    String? doctorName,
    String? doctorDesignation,
    String? doctorState,
    String? gender, // Add gender parameter to the widget
    String? totalPatient,
    String? experience,
    String? rating,
      String?charge,
    String? reviews,
    String? imageUrl,
    String? about
    }) {
  // Define the icon and color based on the gender
  IconData genderIcon =
      (gender?.toLowerCase() == 'male') ? Icons.male : Icons.female;

  Color genderColor =
      (gender?.toLowerCase() == 'male') ? Colors.blue : Colors.pink;

  return Container(
    padding: EdgeInsets.all(10.r),
    height: MediaQuery.of(context).size.height * 0.25,
    width: MediaQuery.of(context).size.width,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12.r),
      border: Border.all(
        color: AppColors.primaryColor,
      ),
    ),
    child: Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.10,
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
              CircleAvatar(
                radius: 28.r,
                backgroundImage: NetworkImage(imageUrl!),
              ),
              SizedBox(width: 10.w),
              Expanded(
                flex: 8,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          doctorName ?? '',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(width: 5.w),
                        Image.asset(
                          "assets/images/verified_tick.png",
                          fit: BoxFit.cover,
                          height: 17.h,
                        ),
                      ],
                    ),
                    Text(
                      doctorDesignation ?? '',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      doctorState ?? '',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10.w),
              Align(
                alignment: Alignment.topCenter,
                child: Icon(genderIcon,
                    color: genderColor), // Show the gender icon
              ),
            ],
          ),
        ),

        const Divider(),

        Container(
          height: MediaQuery.of(context).size.height * 0.10,
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Circleso(context,
                  icon: IconlyBold.user_2, name: '${totalPatient}+ Patients'),
              Circleso(context,
                  icon: IconlyBold.work, name: '${experience}+ years '),
              Circleso(context, icon: EneftyIcons.dollar_circle_outline, name: "\$${charge}/Hr"),
              Circleso(context,
                  icon: IconlyBold.star, name: rating!=null? '${double.parse(rating).toStringAsFixed(1)}':'No ratings'),
            ],
          ),
        )

      ],
    ),
  );
}

Widget Circleso(BuildContext context, {IconData? icon, String? name}) {
  return Column(
    children: [
      CircleAvatar(
        radius: 24.r,
        backgroundColor: AppColors.primaryColor,
        child: Icon(
          icon,
          color: Colors.white,
        ),
      ),
      SizedBox(height: 6.h),
      Expanded(
        child: Text(
          name ?? '',
          style: TextStyle(
            color: Colors.black,
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      )
    ],
  );
}
