import 'package:cached_network_image/cached_network_image.dart';
import 'package:care2care/ReusableUtils_/appBar.dart';
import 'package:care2care/ReusableUtils_/customButton.dart';
import 'package:care2care/ReusableUtils_/custom_textfield.dart';
import 'package:care2care/ReusableUtils_/image_background.dart';
import 'package:care2care/ReusableUtils_/sizes.dart';
import 'package:custom_rating_bar/custom_rating_bar.dart';
import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../ReusableUtils_/AppColors.dart';
import '../../Utils/screen_utils.dart';
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
        onLoading: () {
          ct.getCareTakers(loading: true);
        },
        enablePullUp: true,
        controller: ct.refreshController,
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 12.h),
                child: SizedBox(
                  height: kToolbarHeight,
                  child: customTextField(
                    context,
                    onChanged: (v) {
                      ct.debounceSearch();
                    },
                    hint: "Search caretakers",
                    hintStyle: TextStyle(fontSize: 14.sp),
                    controller: ct.searchTEC,
                    borderColor: AppColors.primaryColor,
                    labelText: "",
                    prefix: Icon(Icons.search),
                  ),
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
                        var data = controller.careTakers[index];
                        var caretaker =
                            controller.careTakers[index].caretakerInfo;
                        var path = controller.profilePath;
                        var imgUrl =
                            controller.careTakers[index].profileImageUrl;
                        return GestureDetector(
                          onTap: () {
                            Get.to(
                              () => CaretakerInformation(
                                charge: caretaker.serviceCharge,
                                careTakerId: caretaker.caretakerId,
                                doctorName: caretaker.firstName,
                                doctorDesignation: 'Care Taker',
                                doctorState: caretaker.address,
                                gender: caretaker.sex,
                                about: caretaker.about ?? data.about ?? '',
                                totalPatient:
                                    caretaker.totalPatientsAttended.toString(),
                                experience:
                                    caretaker.yearOfExperiences.toString(),
                                rating:
                                    controller.careTakers[index].averageRating,
                                imageUrl: '${path}${imgUrl}',
                                phoneNumber: caretaker.primaryContactNumber.isNotEmpty
                                    ? caretaker.primaryContactNumber
                                    : data.mobilenum,
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
                              charge: caretaker.serviceCharge,
                              gender: caretaker.sex,
                              doctorDesignation: 'Care Taker',
                              doctorName: caretaker.firstName,
                              imageUrl: '${path}${imgUrl}',
                              doctorState: caretaker.address,
                              totalPatient:
                                  caretaker.totalPatientsAttended.toString(),
                              experience:
                                  caretaker.yearOfExperiences.toString(),
                              rating: data.averageRating,
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
  Widget filterLabel(String label) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 12.h),
      child: Text(label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15.sp,
          )),
    );
  }

  //
  showFilterSheet(BuildContext context) async {
    await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        builder: (context) {
          return GetBuilder<HomeController>(builder: (vc) {
            return Padding(
              padding: EdgeInsets.only(
                top: 8.h,
                left: 20.w,
                right: 20.w,
                bottom: MediaQuery.of(context).padding.bottom + 16.h,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 40.w,
                      height: 4.h,
                      margin: EdgeInsets.only(bottom: 12.h),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Filter Caretakers",
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.close, size: 20.r, color: Colors.grey.shade600),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  const Divider(height: 20, thickness: 0.8),
                  
                  // Rating Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Minimum Rating",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        ct.rating > 0 ? "${ct.rating.toStringAsFixed(1)} Stars & up" : "Any Rating",
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Center(
                    child: RatingBar(
                        alignment: Alignment.center,
                        filledIcon: Icons.star,
                        emptyIcon: Icons.star_border,
                        filledColor: Colors.amber,
                        emptyColor: Colors.grey.shade300,
                        initialRating: ct.rating,
                        size: 36.sp,
                        onRatingChanged: (v) {
                          ct.rating = v;
                          ct.update();
                        }),
                  ),
                  SizedBox(height: 20.h),

                  // Price Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Price Range",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        "\$${ct.priceRange.start.round()} - \$${ct.priceRange.end.round()}/Hr",
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  SliderTheme(
                    data: SliderThemeData(
                      showValueIndicator: ShowValueIndicator.always,
                      activeTrackColor: AppColors.primaryColor,
                      inactiveTrackColor: AppColors.primaryColor.withOpacity(0.15),
                      thumbColor: AppColors.primaryColor,
                      valueIndicatorColor: AppColors.primaryColor,
                      valueIndicatorTextStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      overlayColor: AppColors.primaryColor.withOpacity(0.12),
                    ),
                    child: RangeSlider(
                      values: ct.priceRange,
                      min: 0,
                      max: ct.maxPrice,
                      labels: RangeLabels(
                          '${ct.priceRange.start.round()}',
                          '${ct.priceRange.end.round()}'),
                      onChanged: (RangeValues values) {
                        ct.priceRange = values;
                        ct.update();
                      },
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // Gender Section
                  Text(
                    "Gender",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Male Option
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            ct.gender = "male";
                            ct.update();
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: EdgeInsets.symmetric(vertical: 10.h),
                            decoration: BoxDecoration(
                              color: ct.gender == "male"
                                  ? AppColors.primaryColor.withOpacity(0.1)
                                  : Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: ct.gender == "male"
                                    ? AppColors.primaryColor
                                    : Colors.grey.shade300,
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.male_rounded,
                                  color: ct.gender == "male"
                                      ? AppColors.primaryColor
                                      : Colors.grey.shade600,
                                  size: 20.r,
                                ),
                                SizedBox(width: 6.w),
                                Text(
                                  "Male",
                                  style: TextStyle(
                                    color: ct.gender == "male"
                                        ? AppColors.primaryColor
                                        : Colors.grey.shade700,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      // Female Option
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            ct.gender = "female";
                            ct.update();
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: EdgeInsets.symmetric(vertical: 10.h),
                            decoration: BoxDecoration(
                              color: ct.gender == "female"
                                  ? AppColors.primaryColor.withOpacity(0.1)
                                  : Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: ct.gender == "female"
                                    ? AppColors.primaryColor
                                    : Colors.grey.shade300,
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.female_rounded,
                                  color: ct.gender == "female"
                                      ? AppColors.primaryColor
                                      : Colors.grey.shade600,
                                  size: 20.r,
                                ),
                                SizedBox(width: 6.w),
                                Text(
                                  "Female",
                                  style: TextStyle(
                                    color: ct.gender == "female"
                                        ? AppColors.primaryColor
                                        : Colors.grey.shade700,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 32.h),

                  // Actions
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            ct.gender = "";
                            ct.priceRange = RangeValues(0.0, ct.maxPrice);
                            ct.rating = 0.0;
                            ct.update();
                          },
                          child: Container(
                            height: 44.h,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(22.r),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Center(
                              child: Text(
                                "Clear All",
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            ct.getCareTakers();
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 44.h,
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(22.r),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primaryColor.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                "Apply Filters",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          });
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
    String? charge,
    String? reviews,
    String? imageUrl,
    String? about}) {
  // Define the icon and color based on the gender
  IconData genderIcon =
      (gender?.toLowerCase() == 'male') ? Icons.male : Icons.female;

  Color genderColor =
      (gender?.toLowerCase() == 'male') ? Colors.blue : Colors.pink;

  return Container(
    padding: EdgeInsets.all(8.r),
    height: isiPadLayout(context)
        ? MediaQuery.of(context).size.height * 0.25
        : MediaQuery.of(context).size.height * 0.21,
    width: MediaQuery.of(context).size.width,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12.r),
      border: Border.all(
        color: AppColors.primaryColor,
      ),
    ),
    child: Column(
      children: [
        Expanded(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.08,
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22.r,
                  backgroundColor: Colors.grey[200],
                  child: ClipOval(
                    child: (imageUrl != null &&
                            imageUrl.isNotEmpty &&
                            !imageUrl.endsWith('/'))
                        ? CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: imageUrl,
                            placeholder: (context, url) => const Center(
                              child: SizedBox(
                                width: 14,
                                height: 14,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              ),
                            ),
                            errorWidget: (context, url, error) => const Icon(
                              Icons.person,
                              size: 22,
                              color: Colors.grey,
                            ),
                          )
                        : const Icon(
                            Icons.person,
                            size: 22,
                            color: Colors.grey,
                          ),
                  ),
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
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(width: 5.w),
                          Image.asset(
                            "assets/images/verified_tick.png",
                            fit: BoxFit.cover,
                            height: 14.h,
                          ),
                        ],
                      ),
                      Text(
                        doctorDesignation ?? '',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        doctorState ?? '',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12.sp,
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
        ),
        const Divider(height: 12, thickness: 0.5),
        SizedBox(height: 8.h),
        Expanded(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.08,
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                Expanded(
                  child: Circleso(context,
                      icon: IconlyBold.user_2,
                      name: _formatPatients(totalPatient)),
                ),
                Expanded(
                  child: Circleso(context,
                      icon: IconlyBold.work,
                      name: _formatExperience(experience)),
                ),
                Expanded(
                  child: Circleso(context,
                      icon: EneftyIcons.dollar_circle_outline,
                      name: "\$${charge}/Hr"),
                ),
                Expanded(
                  child: Circleso(context,
                      icon: IconlyBold.star, name: _formatRating(rating)),
                ),
              ],
            ),
          ),
        )
      ],
    ),
  );
}

String _formatPatients(String? totalPatient) {
  if (totalPatient == null || totalPatient.trim().isEmpty) {
    return 'No patients yet';
  }
  return '$totalPatient+ Patients';
}

String _formatExperience(String? experience) {
  if (experience == null || experience.trim().isEmpty) {
    return 'No experience';
  }
  return '$experience+ years';
}

String _formatRating(String? rating) {
  if (rating == null || rating.trim().isEmpty) {
    return 'No ratings';
  }
  final parsed = double.tryParse(rating);
  return parsed != null ? '${parsed.round()}' : 'No ratings';
}

Widget Circleso(BuildContext context, {IconData? icon, String? name}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      CircleAvatar(
        radius: 20.r,
        backgroundColor: AppColors.primaryColor,
        child: Icon(
          icon,
          color: Colors.white,
          size: 18.sp,
        ),
      ),
      SizedBox(height: 4.h),
      Expanded(
        child: Text(
          name ?? '',
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.black,
            fontSize: 11.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      )
    ],
  );
}
