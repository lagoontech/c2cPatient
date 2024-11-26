import 'package:care2care/ReusableUtils_/appBar.dart';
import 'package:care2care/ReusableUtils_/image_background.dart';
import 'package:care2care/ReusableUtils_/sizes.dart';
import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

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
              onPressed: () {},
              icon: const Icon(
                IconlyLight.filter,
                color: AppColors.primaryColor,
              ),
            ),
          ),
        ],
      ),
      child: RefreshIndicator(
        onRefresh: () async {
          await ct.fetchAllCaretakersApi();
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.h),
                child: GetBuilder<HomeController>(
                  builder: (controller) {
                    // Check if caretakers list is loaded and available
                    if (controller.isLoadingCareTakersList) {
                      return Center(
                          child:
                              CircularProgressIndicator()); // Loading indicator
                    }
                    if (controller.careTakerInfo.isEmpty) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.7,
                        // Ensures a large enough area for pull-to-refresh
                        child: Center(child: Text("No Care Takers Available")),
                      );
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemCount: controller.careTakerInfo.length,
                      itemBuilder: (context, index) {
                        var caretaker = controller.careTakerInfo[index];
                        var path = controller.viewAllCareTakers!.profilePath;
                        var imgUrl = controller
                            .viewAllCareTakers!.data![index].profileImageUrl;

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
                                totalPatient:
                                    caretaker.totalPatientsAttended.toString(),
                                experience:
                                    caretaker.yearOfExperiences.toString(),
                                rating: caretaker.yearOfExperiences.toString(),
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
    String? imageUrl}) {
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
                  icon: IconlyBold.star, name: '${rating}+ratings\n Reviews'),
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
