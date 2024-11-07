import 'package:care2care/ReusableUtils_/AppColors.dart';
import 'package:care2care/ReusableUtils_/appBar.dart';
import 'package:care2care/ReusableUtils_/custom_textfield.dart';
import 'package:care2care/ReusableUtils_/image_background.dart';
import 'package:care2care/ReusableUtils_/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

import 'Controller/initila_profile_controller.dart';

class ProfileView extends StatelessWidget {
  ProfileView({super.key});

  final InitialProfileDetails CT = Get.find<InitialProfileDetails>();

  @override
  Widget build(BuildContext context) {
    return CustomBackground(
        appBar: CustomAppBar(title: "Profile", actions: [
          GetBuilder<InitialProfileDetails>(
              init: InitialProfileDetails(),
              builder: (v) {
                return Padding(
                  padding: EdgeInsets.only(right: 18.r),
                  child: v.isLoading
                      ? Center(
                          child: SizedBox(
                            height: 20.h,
                            width: 23.w,
                            child: CircularProgressIndicator(
                              strokeWidth: 1,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        )
                      : InkWell(
                          onTap: () {
                            if (v.profileList == null) {
                              debugPrint("Calling addInitialProfileDetails()");
                              v.addInitialProfileDetails();
                            } else {
                              debugPrint("Calling updateInitialProfileDetails()");
                              v.updateInitialProfileDetails();
                            }
                          },
                          child: Icon(
                            IconlyLight.tick_square,
                            color: AppColors.primaryColor,
                          ),
                        ),
                );
              }),
        ]),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.r),
          child: SingleChildScrollView(
            child: GetBuilder(
                init: InitialProfileDetails(),
                builder: (v) {
                  return Column(
                    children: [
                      SizedBox(height: 5.h),
                      customTextField(
                        context,
                        controller: CT.firstName,
                        labelText: "First Name",
                      ),
                      SizedBox(height: 15.h),
                      customTextField(
                        context,
                        controller: CT.lastName,
                        labelText: "Last Name",
                      ),
                      SizedBox(height: 15.h),
                      customTextField(
                        context,
                        labelText: "Date of Birth",
                        readOnly: true,
                        controller: CT.dobCT,
                        suffix: IconButton(
                            onPressed: () {
                              CT.selectDob(context);
                            },
                            icon: Icon(
                              Icons.calendar_month_outlined,
                              color: AppColors.primaryColor,
                            )),
                      ),
                      kHeight20,
                      Row(
                        children: [
                          Flexible(
                            flex: 5,
                            child: customTextField(context,
                                readOnly: true,
                                labelText: "Age",
                                controller: CT.ageCT),
                          ),
                          kWidth20,
                          Expanded(
                              flex: 5,
                              child: customTextField(context,
                                  labelText: "Sex", controller: CT.sexCT)),
                        ],
                      ),
                      SizedBox(height: 15.h),
                      customTextField(
                        context,
                        controller: CT.emailCT,
                        labelText: "E-mail",
                      ),
                      kHeight20,
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: customTextField(
                              context,
                              labelText: "Height (CM)",
                              controller: CT.heightCT,
                            ),
                          ),
                          kWidth15,
                          Expanded(
                            flex: 3,
                            child: customTextField(
                              context,
                              labelText: "Weight (KG)",
                              controller: CT.weightCT,
                            ),
                          ),
                          kWidth15,
                          Expanded(
                            flex: 3,
                            child: customTextField(
                              context,
                              labelText: "BMI",
                              controller: CT.bmiCT,
                              readOnly: true,
                            ),
                          ),
                        ],
                      ),
                      kHeight20,
                      Row(
                        children: [
                          Expanded(
                              flex: 5,
                              child: customTextField(context,
                                  controller: CT.locationCT,
                                  labelText: "Location")),
                          kWidth15,
                          GetBuilder<InitialProfileDetails>(builder: (v) {
                            return Flexible(
                              child: Stack(
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      await v.getCurrentLocation();
                                    },
                                    child: Container(
                                      height: 40,
                                      width: 40,
                                      color: AppColors.primaryColor,
                                      child: v.isFetchingLocation
                                          ? Center(
                                              child: SizedBox(
                                                height: 20.h,
                                                width: 23.w,
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 0.7,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            )
                                          : const Icon(
                                              Icons.add_location_alt,
                                              color: Colors.white,
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                      kHeight20,
                      customTextField(context,
                          labelText: "Nationality",
                          controller: CT.nationalityCT),
                      kHeight20,
                      customTextField(context,
                          maxLines: 3,
                          labelText: "Address",
                          controller: CT.addressCT),
                      kHeight20,
                      customTextField(
                        context,
                        controller: CT.diagnosisCT,
                        labelText: "Diagnosis",
                      ),
                      kHeight20,
                      customTextField(context,
                          labelText: "Primary Care Provider Name",
                          controller: CT.primary_care_giver_nameCT),
                      kHeight20,
                      customTextField(context,
                          labelText: "Primary Contact Name",
                          controller: CT.primaryContactNameCT),
                      kHeight20,
                      customTextField(context,
                          labelText: "Secondary Contact Name",
                          controller: CT.secondaryNameCT),
                      kHeight20,
                      Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child: customTextField(context,
                                textInputType: TextInputType.phone,
                                labelText: "Primary Contact Number",
                                controller: CT.primaryContactNumberCT),
                          ),
                          kWidth15,
                          Flexible(
                            flex: 5,
                            child: customTextField(context,
                                textInputType: TextInputType.phone,
                                labelText: "Secondary Contact Number",
                                controller: CT.secondaryNumberCT),
                          )
                        ],
                      ),
                      kHeight20,
                      customTextField(context,
                          labelText: "Specialist (DR) Name",
                          controller: CT.specialist_nameCT),
                      kHeight20,
                      customTextField(
                        context,
                        controller: CT.specialListNumberCT,
                        textInputType: TextInputType.phone,
                        labelText: "Specialist (DR) Phone Number",
                      ),
                      kHeight20,
                      customTextField(
                        context,
                        maxLines: 3,
                        controller: CT.moreInfoCT,
                        labelText: "More Info",
                      ),
                      kHeight20,
                    ],
                  );
                }),
          ),
        ));
  }
}

/*

if (!v.hasFetchedUserDetails) {
bool userFound = await v.fetchInitialUserDetails();
if (userFound) {
v.updateInitialProfileDetails();
showCustomToast(
message: 'User details successfully updated!',
);
} else {
v.addInitialProfileDetails();
showCustomToast(
message: 'User details successfully added!',
);
}
} else {
if (v.isUserFound) {
v.updateInitialProfileDetails();
showCustomToast(
message: 'User details successfully updated!',
);
} else {
v.addInitialProfileDetails();
showCustomToast(
message: 'User details successfully added!',
);
}
}
*/
