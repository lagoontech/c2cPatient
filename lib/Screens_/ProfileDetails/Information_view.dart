import 'package:cached_network_image/cached_network_image.dart';
import 'package:care2care/ReusableUtils_/appBar.dart';
import 'package:care2care/ReusableUtils_/image_background.dart';
import 'package:care2care/ReusableUtils_/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../ReusableUtils_/AppColors.dart';
import '../../ReusableUtils_/custom_textfield.dart';
import '../Profile/Controller/initila_profile_controller.dart';

class AccountInformation extends StatelessWidget {
  AccountInformation({super.key});

  final InitialProfileDetails getX = Get.put(InitialProfileDetails());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<InitialProfileDetails>(builder: (v) {
      var data = getX.profileList!.data!.patientInfo;
      return CustomBackground(
        appBar: CustomAppBar(
          title: 'Profile Information',
          actions: [
            InkWell(
              onTap: (){
                Get.back();
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text(
                  "Done",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: GetBuilder<InitialProfileDetails>(builder: (v) {
                        String imageURL = '${v.profileList!.profilePath}${v.profileList!.data!.profileImageUrl}';
                        return CircleAvatar(
                            radius: 20,
                            child: CachedNetworkImage(imageUrl: imageURL));
                      }),
                    ),
                    kWidth10,
                    GetBuilder<InitialProfileDetails>(builder: (v) {
                      String fullName =
                          '${v.profileList!.data!.patientInfo!.firstName!} ${v.profileList!.data!.patientInfo!.lastName!}';
                      return Container(
                        height: MediaQuery.of(context).size.height * 0.10,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              fullName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Remove Photo",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    kWidth10,
                    Padding(
                      padding: EdgeInsets.only(top: 20.h),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Change Photo',
                          style: TextStyle(
                            color: Colors.blue, // Adjust color if needed
                            fontSize: 14.sp, // Adjust font size if needed
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                kHeight20,
                customTextField(
                  context,
                  controller: TextEditingController(
                      text:
                          '${v.profileList!.data!.patientInfo!.firstName!} ${v.profileList!.data!.patientInfo!.lastName!}'),
                  labelText: "Full Name",
                ),
                kHeight15,
                Row(
                  children: [
                    Expanded(
                        flex: 5,
                        child: customTextField(context,
                            controller: TextEditingController(
                                text:
                                    '${v.profileList!.data!.patientInfo!.sex}'),
                            labelText: "Sex")),
                    kWidth20,
                    Flexible(
                      flex: 5,
                      child: customTextField(context,
                          controller: TextEditingController(text: '${data!.age}'),
                          labelText: "Age"),
                    ),
                  ],
                ),
                kHeight15,
                customTextField(
                  context,
                  controller: TextEditingController(text: '${data.dob}'),
                  labelText: "Date of Birth",
                ),
                kHeight15,
                customTextField(
                  context,
                  controller: TextEditingController(text: '${"dat"}'),
                  labelText: "Medical License",
                ),
                kHeight15,
                Row(
                  children: [
                    Expanded(
                        flex: 5,
                        child: customTextField(context,
                            controller: TextEditingController(text: '${data.location}'),

                            labelText: "Location")),
                    kWidth15,
                    Flexible(
                        child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: 40,
                        width: 40,
                        color: AppColors.primaryColor,
                        child: const Icon(
                          Icons.add_location_alt,
                          color: Colors.white,
                        ),
                      ),
                    )),
                  ],
                ),
                kHeight15,
                customTextField(
                  context,
                  controller: TextEditingController(text: '${data.nationality}'),
                  labelText: "Nationality",
                ),
                kHeight15,
                customTextField(
                  context,
                  controller: TextEditingController(text: '${data.address}'),
                  maxLines: 3,
                  labelText: "Address",
                ),
                kHeight15,
          /*      DottedBorder(
                  color: AppColors.primaryColor,
                  strokeWidth: 1,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.10,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            Get.to(() => DocumentUploadNew());
                          },
                          icon: Icon(EneftyIcons.attach_circle_outline),
                        ),
                        Text(
                          "Add Attachment",
                          style: TextStyle(color: AppColors.primaryColor),
                        ),
                      ],
                    ),
                  ),
                ),*/
                kHeight15,
              ],
            ),
          ),
        ),
      );
    });
  }
}

class ProfileInformationLoader extends StatelessWidget {
  const ProfileInformationLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[100] ?? Colors.grey,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: [
          Container(
            height: 80.0,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          SizedBox(height: 10.0),
          ...List.generate(7, (index) => _buildShimmerItem()),
        ],
      ),
    );
  }

  Widget _buildShimmerItem() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.0),
      height: 40.0,
      width: double.infinity,
      color: Colors.white,
    );
  }
}
