import 'package:cached_network_image/cached_network_image.dart';
import 'package:care2care/Notification/controller.dart';
import 'package:care2care/ReusableUtils_/AppColors.dart';
import 'package:care2care/ReusableUtils_/appBar.dart';
import 'package:care2care/ReusableUtils_/customLabel.dart';
import 'package:care2care/ReusableUtils_/image_background.dart';
import 'package:care2care/ReusableUtils_/sizes.dart';
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

  @override
  Widget build(BuildContext context) {
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
                  height: 80.h,
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
                          radius: 20,
                          backgroundColor: Colors.grey,
                          // Optional placeholder color
                          child: ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: '${v.profileList!.profilePath}${v.profileList!.data!.profileImageUrl}',
                              fit: BoxFit.cover,
                              // Ensure the image covers the CircleAvatar
                              width: 40,
                              // Set width and height to ensure the image fits properly
                              height: 40,
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error), // Error icon
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.10,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height: 5),
                                Text(
                                  '${v.profileList!.data!.patientInfo!.firstName!} ${v.profileList!.data!.patientInfo!.lastName}',
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
                                  '${v.profileList!.data!.patientInfo!.email}',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      /*  Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          onPressed: () {
                            // Handle edit action
                          },
                          icon: Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 20.sp,
                          ),
                        ),
                      ),*/
                    ],
                  ),
                ),
                kHeight30,
                CustomLabel(text: "General"),
                kHeight10,
                ProfileDetailsCustom(
                  icons: IconlyBold.profile,
                  iconColor: Color(0xff246AFD),
                  heading: "Profile",
                  message: "change Your Account Information ",
                  callback: () {
                    Get.to(() => AccountInformation());
                  },
                ),
                /*    Divider(),
                kHeight10,
                ProfileDetailsCustom(
                  icons: EneftyIcons.wallet_remove_bold,
                  iconColor: Colors.green,
                  heading: "My Schedules",
                  message: "Add your Insurance Details",
                  callback: () {
                    Get.to(() => ScheduleUpdate());
                  },
                ),*/
                Divider(),
                kHeight10,
                ProfileDetailsCustom(
                  icons: EneftyIcons.wallet_remove_bold,
                  iconColor: Colors.green,
                  heading: "My History",
                  message: "To View Your Previous Appointment History ",
                  callback: () {
                    Get.to(() => PatientHistoryView());
                  },
                ),
                Divider(),
                kHeight10,
                ProfileDetailsCustom(
                  icons: EneftyIcons.wallet_remove_bold,
                  iconColor: Colors.green,
                  heading: "Cancelled Appointments",
                  message: "To View Your Cancelled Appointments History ",
                  callback: () {
                    Get.to(() => CancelList());
                  },
                ),
                Divider(),
                ProfileDetailsCustom(
                  callback: () {
                    Get.to(() => DocumentUploadView());
                  },
                  icons: EneftyIcons.buildings_bold,
                  iconColor: Colors.amberAccent,
                  heading: "Medical Records",
                  message: "History about the your medical records",
                ),
                /*   Divider(),
                kHeight10,
                ProfileDetailsCustom(
                  icons: IconlyBold.location,
                  iconColor: Color(0xff076F88),
                  heading: "My Address",
                  message: "Add Your Address",
                ),*/
                Divider(),
                kHeight10,
                ProfileDetailsCustom(
                  icons: EneftyIcons.logout_bold,
                  iconColor: Color(0xff002574),
                  heading: "Logout",
                  message: "want to logout",
                  callback: () async {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Are You Sure?'),
                          content: Text('Do you want to logout?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the dialog
                              },
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () async {
                                await SharedPref().logout();
                                Navigator.of(context).pop(); // Close the dialog
                              },
                              child: Text('Logout'),
                            ),
                          ],
                        );
                      },
                    );

                  },
                ),
                Divider(),
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
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: CircleAvatar(
              backgroundColor: Colors.grey.withOpacity(0.1),
              radius: radiusSize ?? 20,
              child: Icon(
                icons,
                color: iconColor,
              ),
            ),
          ),
          kWidth10,
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.06,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 5),
                  Text(
                    heading ?? "Alis Dia",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    message ?? "sujnc901@gmail.com",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.sp,
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
              size: 20.sp,
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
