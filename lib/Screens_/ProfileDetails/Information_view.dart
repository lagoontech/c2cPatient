import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:care2care/ReusableUtils_/appBar.dart';
import 'package:care2care/ReusableUtils_/image_background.dart';
import 'package:care2care/ReusableUtils_/sizes.dart';
import 'package:care2care/Screens_/Schedule/controller/schedule_controller.dart';
import 'package:care2care/Utils/date_utils.dart';
import 'package:flutter/material.dart' hide DateUtils;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shimmer/shimmer.dart';
import '../../ReusableUtils_/AppColors.dart';
import '../../ReusableUtils_/custom_textfield.dart';
import '../Profile/Controller/initila_profile_controller.dart';
import 'Controller/edit_profile_controller.dart';

class AccountInformation extends StatelessWidget {
  AccountInformation({super.key});

  final InitialProfileDetails getX = Get.put(InitialProfileDetails());
  final ScheduleController sc = Get.put(ScheduleController());
  EditProfileController ec = Get.put(EditProfileController());

  @override
  Widget build(BuildContext context) {

    return GetBuilder<EditProfileController>(builder: (v) {

      var data ;
      if(!ec.loadingProfile && ec.profileList!=null){
        data = ec.profileList!.data!.patientInfo;
      }

      return !v.loadingProfile?CustomBackground(
        appBar: CustomAppBar(
          title: 'Profile Information',
          actions: [
            InkWell(
              onTap: () {
                      ec.updateInitialProfileDetails();
                    },
              child: Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: Text(
                  "Done",
                  style: TextStyle(
                    color: Colors.blue,
                  ),
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
                        String imageURL =
                            '${ec.profileList!.profilePath}${ec.profileList!.data!.profileImageUrl}';
                        return CircleAvatar(
                            radius: 20,
                            child: CachedNetworkImage(imageUrl: imageURL));
                      }),
                    ),
                    kWidth10,
                    GetBuilder<InitialProfileDetails>(builder: (v) {
                      String fullName =
                          '${ec.profileList!.data!.patientInfo!.firstName!} ${ec.profileList!.data!.patientInfo!.lastName!}';
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
                            GetBuilder<ScheduleController>(builder: (v) {
                              return InkWell(
                                onTap: () {
                                  v.deleteProfileImage();
                                },
                                child: Text(
                                  "Remove Photo",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      );
                    }),
                    kWidth10,
                    GetBuilder<ScheduleController>(builder: (v) {
                      return Padding(
                        padding: EdgeInsets.only(top: 20.h),
                        child: Align(
                          alignment: Alignment.center,
                          child: TextButton(
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.20,
                                    width: MediaQuery.of(context).size.width,
                                    color: Colors.white,
                                    child: Column(
                                      //crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        TextButton(
                                            onPressed: () {
                                              v.pickImage(
                                                  ImageSource.camera, context);
                                            },
                                            style: ButtonStyle(
                                                overlayColor:
                                                    MaterialStatePropertyAll(
                                                        Colors.transparent)),
                                            child: AutoSizeText('Camera')),
                                        TextButton(
                                            onPressed: () {
                                              v.pickImage(
                                                  ImageSource.gallery, context);
                                            },
                                            style: ButtonStyle(
                                                overlayColor:
                                                    MaterialStatePropertyAll(
                                                        Colors.transparent)),
                                            child: AutoSizeText('Gallery')),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            child: Text(
                              'Change Photo',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
                kHeight20,
                Row(
                  children: [
                    Expanded(
                      child: customTextField(
                        context,
                        controller: ec.firstName,
                        labelText: "First Name *",
                      ),
                    ),
                    kWidth20,
                    Expanded(child: customTextField(
                      context,
                      controller: ec.lastName,
                      labelText: "Last Name *",
                    ))
                  ],
                ),
                kHeight15,
                Row(
                  children: [
                    Expanded(
                        flex: 5,
                        child: customTextField(context,
                            controller: ec.sexCT,
                            labelText: "Sex *")),
                    kWidth20,
                    Flexible(
                      flex: 5,
                      child: customTextField(context,
                          controller: ec.ageCT,
                          labelText: "Age"),
                    ),
                  ],
                ),
                kHeight15,
                customTextField(
                  context,
                  controller: ec.emailCT,
                  labelText: "Email *",
                ),
                kHeight15,
                customTextField(
                  context,
                  controller: ec.dobCT,
                  readOnly: true,
                  onTap: (){
                    selectDob(context);
                  },
                  labelText: "Date of Birth *",
                ),
                kHeight15,
                Row(
                  children: [
                    Expanded(
                        flex: 5,
                        child: customTextField(context,
                            controller: ec.heightCT,
                            onChanged: (v){
                          ec.calculateBMI();
                            },
                            labelText: "Height")),
                    kWidth20,
                    Flexible(
                      flex: 5,
                      child: customTextField(context,
                          controller: ec.weightCT,
                          onChanged: (v){
                        ec.calculateBMI();
                          },
                          labelText: "Weight"),
                    ),
                    kWidth20,
                    Flexible(
                      flex: 5,
                      child: customTextField(context,
                          controller: ec.bmiCT,
                          labelText: "BMI"),
                    ),
                  ],
                ),
                kHeight15,
                Row(
                  children: [
                    Expanded(
                        flex: 5,
                        child: customTextField(context,
                            controller: ec.locationCT,
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
                  controller: ec.nationalityCT,
                  labelText: "Nationality",
                ),
                kHeight15,
                customTextField(
                  context,
                  controller: ec.addressCT,
                  maxLines: 3,
                  labelText: "Address",
                ),
                kHeight20,
                customTextField(
                  context,
                  controller: ec.diagnosisCT,
                  labelText: "Diagnosis",
                ),
                kHeight20,
                customTextField(context,
                    labelText: "Primary Care Provider Name",
                    controller: ec.primary_care_giver_nameCT),
                kHeight20,
                customTextField(context,
                    labelText: "Primary Contact Name *",
                    controller: ec.primaryContactNameCT),
                kHeight20,
                customTextField(context,
                    labelText: "Secondary Contact Name",
                    controller: ec.secondaryNameCT),
                kHeight20,
                Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: customTextField(context,
                          textInputType: TextInputType.phone,
                          labelText: "Primary Contact Number *",
                          controller: ec.primaryContactNumberCT),
                    ),
                    kWidth15,
                    Flexible(
                      flex: 5,
                      child: customTextField(context,
                          textInputType: TextInputType.phone,
                          labelText: "Secondary Contact Number",
                          controller: ec.secondaryNumberCT),
                    )
                  ],
                ),
                kHeight20,
                customTextField(context,
                    labelText: "Specialist (DR) Name",
                    controller: ec.specialist_nameCT),
                kHeight20,
                customTextField(
                  context,
                  controller: ec.specialListNumberCT,
                  textInputType: TextInputType.phone,
                  labelText: "Specialist (DR) Phone Number",
                ),
                kHeight20,
                customTextField(
                  context,
                  maxLines: 3,
                  controller: ec.moreInfoCT,
                  labelText: "More Info",
                ),  kHeight20,  kHeight20,
              ],
            ),
          ),
        ),
      ) : Scaffold(
        body: Center(
          child: Container(
              color: Colors.white,
              width: 32.w,
              height: 32.w,
              child: CircularProgressIndicator(
              strokeWidth: 2,
              )
          ),
        ),
      );
    });
  }

  //
  Future<void> selectDob(BuildContext context) async {

    DateTime? pickDob = await showDatePicker(
        context: context,
        initialDate: ec.dob ?? DateTime.now(),
        firstDate: DateTime(1000),
        lastDate: DateTime(2101));
    if (pickDob != null) {
      print(pickDob);
      ec.dob = pickDob;
      ec.dobCT.text = DateUtils().dateOnlyFormat(pickDob);
      int age = calculateAge(pickDob);
      ec.ageCT.text = age.toString();
      ec.update();
    }

  }

    //
    int calculateAge(DateTime birthDate) {
      DateTime today = DateTime.now();
      int age = today.year - birthDate.year;
      if (today.month < birthDate.month ||
          (today.month == birthDate.month && today.day < birthDate.day)) {
        age--;
      }
      return age;
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
