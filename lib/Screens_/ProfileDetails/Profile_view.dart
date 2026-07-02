import 'package:cached_network_image/cached_network_image.dart';
import 'package:care2care/Notification/controller.dart';
import 'package:care2care/ReusableUtils_/AppColors.dart';
import 'package:care2care/ReusableUtils_/appBar.dart';
import 'package:care2care/ReusableUtils_/customLabel.dart';
import 'package:care2care/ReusableUtils_/image_background.dart';
import 'package:care2care/ReusableUtils_/sizes.dart';
import 'package:care2care/Screens_/ProfileDetails/schedule%20_update.dart';
import 'package:care2care/sharedPref/sharedPref.dart';
import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:shimmer/shimmer.dart';
import '../Document_Upload/document_uploadView.dart';
import '../Notifications/Notification_view.dart';
import '../Profile/Controller/initila_profile_controller.dart';
import '../cancel-request/cancel_list.dart';
import '../patient_history/patientHistory_view.dart';
import 'Information_view.dart';

class ProfileDetails extends StatelessWidget {
  ProfileDetails({super.key});

  final NotificationController controller = Get.put(NotificationController());
  final InitialProfileDetails profileController =
      Get.put(InitialProfileDetails());

  @override
  Widget build(BuildContext context) {
    if (profileController.profileList?.data?.patientInfo == null) {
      profileController.fetchInitialUserDetails(forceRefresh: true);
    }
    return GetBuilder<InitialProfileDetails>(builder: (v) {
      return CustomBackground(
        appBar: CustomAppBar(
          leading: SizedBox(),
          title: "Profile Details",
          actions: [
            GetBuilder<NotificationController>(builder: (v) {
              return Badge(
                offset: Offset(-5, 3),
                label: Text(v.unreadCount.toString()),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    Get.to(() => NotificationView());
                  },
                  icon: const Icon(IconlyLight.notification),
                ),
              );
            }),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w),
          child: SingleChildScrollView(
            child: Column(
              children: [
                kHeight10,
                Container(
                  height: 72.h,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.grey,
                          // Optional placeholder color
                          child: ClipOval(
                            child: (v.profileList?.profilePath != null &&
                                    v.profileList?.data?.profileImageUrl != null)
                                ? CachedNetworkImage(
                                    imageUrl: '${v.profileList?.profilePath}${v.profileList?.data?.profileImageUrl}',
                                    fit: BoxFit.cover,
                                    // Ensure the image covers the CircleAvatar
                                    width: 36,
                                    // Set width and height to ensure the image fits properly
                                    height: 36,
                                    placeholder: (context, url) =>
                                        const CircularProgressIndicator(strokeWidth: 2),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error, size: 18), // Error icon
                                  )
                                : const Icon(Icons.person, size: 20),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.08,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(height: 2),
                                v.profileList?.data?.patientInfo != null ? Text(
                                  '${v.profileList?.data?.patientInfo?.firstName ?? ''} ${v.profileList?.data?.patientInfo?.lastName ?? ''}'.trim(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ) : const SizedBox(),
                                const SizedBox(height: 2),
                                v.profileList?.data?.patientInfo != null ? Text(
                                  '${v.profileList?.data?.patientInfo?.email ?? ''}',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.black54,
                                  ),
                                ) : const SizedBox(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                CustomLabel(text: "General", fontSize: 15.sp),
                SizedBox(height: 6.h),
                ProfileDetailsCustom(
                  icons: IconlyBold.profile,
                  iconColor: const Color(0xff246AFD),
                  heading: "Profile",
                  message: "Change your account information ",
                  callback: () {
                    Get.to(() => AccountInformation());
                  },
                ),
                const Divider(),
                SizedBox(height: 6.h),
                ProfileDetailsCustom(
                  icons: EneftyIcons.wallet_remove_bold,
                  iconColor: Colors.green,
                  heading: "My Schedules",
                  message: "Update medical information",
                  callback: () {
                    Get.to(() => ScheduleUpdate());
                  },
                ),
                const Divider(),
                SizedBox(height: 6.h),
                ProfileDetailsCustom(
                  icons: EneftyIcons.wallet_remove_bold,
                  iconColor: Colors.green,
                  heading: "My History",
                  message: "To view your previous appointment history ",
                  callback: () {
                    Get.to(() => PatientHistoryView());
                  },
                ),
                const Divider(),
                SizedBox(height: 6.h),
                ProfileDetailsCustom(
                  icons: EneftyIcons.wallet_remove_bold,
                  iconColor: Colors.green,
                  heading: "Cancelled Appointments",
                  message: "To view your cancelled appointments history ",
                  callback: () {
                    Get.to(() => CancelList());
                  },
                ),
                const Divider(),
                ProfileDetailsCustom(
                  callback: () {
                    Get.to(() => DocumentUploadView());
                  },
                  icons: EneftyIcons.buildings_bold,
                  iconColor: Colors.amberAccent,
                  heading: "Medical Records",
                  message: "History about the your medical records",
                ),
                const Divider(),
                SizedBox(height: 6.h),
                ProfileDetailsCustom(
                  icons: EneftyIcons.logout_bold,
                  iconColor: const Color(0xff002574),
                  heading: "Logout",
                  message: "Tap to logout",
                  callback: () async {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Are You Sure?'),
                          content: const Text('Do you want to logout?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the dialog
                              },
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () async {
                                await SharedPref().logout();
                                Navigator.of(context).pop(); // Close the dialog
                              },
                              child: const Text('Logout'),
                            ),
                          ],
                        );
                      },
                    );

                  },
                ),
                const Divider(),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class ProfileDetailsCustom extends StatelessWidget {
  final String? heading;
  final String? message;
  final IconData? icons;
  final Color? circleColor;
  final Color? iconColor;
  VoidCallback? callback;
  double? radiusSize;

  ProfileDetailsCustom({
    super.key,
    this.heading,
    this.message,
    this.icons,
    this.callback,
    this.circleColor,
    this.iconColor,
    this.radiusSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: CircleAvatar(
              backgroundColor: Colors.grey.withOpacity(0.1),
              radius: radiusSize ?? 16.r,
              child: Icon(
                icons,
                color: iconColor,
                size: 18.sp,
              ),
            ),
          ),
          kWidth10,
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.05,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 2),
                  Text(
                    heading ?? "Alis Dia",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    message ?? "sujnc901@gmail.com",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            onPressed: callback,
            icon: Icon(
              Icons.arrow_forward_ios_sharp,
              color: Colors.black,
              size: 16.sp,
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileDetailsSkeleton extends StatelessWidget {
  const ProfileDetailsSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: [
          Container(
            height: 80.0, // Adjust this value as needed
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white, // The shimmer effect will cover this
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          SizedBox(height: 10.0),
          ...List.generate(5, (index) => _buildShimmerItem()),
        ],
      ),
    );
  }

  Widget _buildShimmerItem() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.0),
      height: 40.0,
      width: double.infinity,
      color: Colors.white, // The shimmer effect will cover this
    );
  }
}
