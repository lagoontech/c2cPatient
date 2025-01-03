import 'package:cached_network_image/cached_network_image.dart';
import 'package:care2care/ReusableUtils_/AppColors.dart';
import 'package:care2care/ReusableUtils_/customLabel.dart';
import 'package:care2care/ReusableUtils_/sizes.dart';
import 'package:care2care/Screens_/HomeScreen/controller/home%20controller.dart';
import 'package:custom_rating_bar/custom_rating_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../Notification/controller.dart';
import '../../ReusableUtils_/appBar.dart';
import '../Profile/Controller/initila_profile_controller.dart';
import '../caretakerList/careTakerListView.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  ScrollController d = ScrollController();

  InitialProfileDetails controller = Get.put(InitialProfileDetails());
  HomeController homeController = Get.put(HomeController());
  NotificationController notifyController = Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<InitialProfileDetails>(builder: (v) {
      if (v.profileList == null) {
        return HomeSkeletonLoader();
      }
      String? name = controller.profileList!.data!.patientInfo!.firstName!;
      String? fullImg = ('${controller.profileList!.profilePath}' +
          ('${controller.profileList!.data!.profileImageUrl}'));
      return RefreshIndicator(
        onRefresh: () async {
          await homeController.fetchAllCaretakersApi();
          await notifyController.allNotifications();
        },
        child: Scaffold(
          appBar: HomeAppBar(
            username: name,
            subtitle: 'How is your Health?',
            avatarUrl: fullImg,
          ),
          body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/Splash.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.h),
              child: ListView(
                children: [
                  kHeight10,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            CustomLabel(
                              text: "Welcome to",
                              fontSize: 19.sp,
                              fontWeight: FontWeight.bold,
                            ),
                            CustomLabel(
                              text: " Care2Care",
                              fontSize: 19.sp,
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  kHeight15,
                  Container(
                    height: MediaQuery.of(context).size.height * 0.17,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        gradient: new LinearGradient(
                            colors: [
                              Color(0xff52AAFC),
                              Color(0xff41A2FD),
                            ],
                            stops: [
                              0.9,
                              1.6
                            ],
                            begin: FractionalOffset.topCenter,
                            end: FractionalOffset.bottomCenter,
                            tileMode: TileMode.repeated)),
                    child: Row(
                      children: [
                        Expanded(
                            flex: 5,
                            child: Padding(
                              padding: EdgeInsets.only(left: 12.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  kHeight15,
                                  Expanded(
                                    child: Text(
                                      "We provide high quality, individualized care for patients of all ages where you feel most comfortable – your home or community",
                                      style: TextStyle(color: Colors.white,fontSize: 13.sp),
                                    ),
                                  )
                                  /* kHeight25,
                                  Text(
                                    "Miss.Alexa Nova",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17.sp),
                                  ),
                                  kHeight10,
                                  Text(
                                    "Physiotherapist",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 17.sp),
                                  ),
                                  kHeight10,
                                  ClipRRect(
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaX: 3, sigmaY: 3),
                                      child: Container(
                                        padding: EdgeInsets.all(3.r),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.white.withOpacity(0.1),
                                              Colors.white.withOpacity(0.1),
                                            ],
                                            */
                                  /*begin: AlignmentDirectional.topStart,
                                            end: AlignmentDirectional.bottomEnd,*/ /*
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(2.r)),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              IconlyLight.calendar,
                                              color: Colors.white,
                                            ),
                                            SizedBox(
                                              width: 5.w,
                                            ),
                                            Text(
                                              "Aug 5  9:00AM",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  )*/
                                ],
                              ),
                            )),
                        Flexible(
                            flex: 5,
                            child: Padding(
                              padding: EdgeInsets.only(top: 18.h, left: 13.w),
                              child: Image.asset(
                                fit: BoxFit.cover,
                                "assets/images/female-nurse-hospital 1.png",
                              ),
                            )),
                      ],
                    ),
                  ),
                  kHeight20,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: CustomLabel(
                          text: "Top CareTakers",
                          fontSize: 19.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Get.to(() => CaretakerList());
                        },
                        child: CustomLabel(
                          text: "See all",
                          fontSize: 15.sp,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  kHeight10,
                  GetBuilder<HomeController>(builder: (v) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: v.topCaretakers.length > 4
                          ? 4
                          : v.topCaretakers.length,
                      itemBuilder: (BuildContext context, int index) {

                        var path = v.profilePath;
                        var imgUrl = v.topCaretakers[index].profileImageUrl;
                        var data = v.topCaretakers[index].caretakerInfo;
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 5.h),
                          child: CustomCareTakers(
                            name: '${data.firstName} ${data.lastName}',
                            age:data.age,
                            //initial: 2,
                            imageUrl: '${path}${imgUrl}',
                            amount:data. serviceCharge,
                            rating: v.topCaretakers[index].averageRating,
                          ),
                        );
                      },
                    );
                  }),
                  //kHeight10,
                  /*Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: CustomLabel(
                          text: "Upcomming Appointments",
                          fontSize: 19.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      CustomLabel(
                        text: "See all",
                        fontSize: 15.sp,
                        color: AppColors.primaryColor,
                      ),
                    ],
                  ),
                  kHeight10,
                  AppointmentsContainer(
                    appointmentDate: "Sun Aug 08",
                    appointmentTime: '10:00-11:00 AM',
                    doctorDesignation: "Ortho",
                    doctorName: "Sheeba",
                    imageUrl: 'assets/images/profile.jpg',
                  ),*/
                  kHeight30,
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}

// Custom Stateless Widget
class CustomCareTakers extends StatelessWidget {
  final String? name;
  final int? age;
  final String? imageUrl;
  final double initial;
  String? amount;
  final VoidCallback? onPressed;
  String ?rating;

  // Constructor with named parameters
  CustomCareTakers({
    this.name,
    this.imageUrl,
    this.age,
    this.amount,
    this.initial = 3.0,
    this.onPressed,
    this.rating
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.12,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: Colors.grey,
          width: 0.2,
        ),
      ),
      padding: EdgeInsets.all(6.r),
      child: Row(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: 68.w,

            //color: AppColors.secondaryColor,
            child: ClipOval(
              child: CachedNetworkImage(fit: BoxFit.cover, imageUrl: imageUrl!),
            ),
          ),
          kWidth10,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    name ?? '',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Text(
                "Age : ${age ?? ''}Yrs",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12.sp,
                ),
              ),
              Text(
                "Service Charge : \$${amount ?? ''}/Hr",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12.sp,
                ),
              ),
              SizedBox(height: 4.h),
              rating!=null
                  ? RatingBar.readOnly(
                filledIcon: Icons.star,
                emptyIcon: Icons.star_border,
                isHalfAllowed: true,
                halfFilledIcon: Icons.star_half,
                initialRating: double.parse(rating!),
                size: 16.sp,
              ):SizedBox()
              /*  RatingBar(
                size: 23.sp,
                filledIcon: Icons.star,
                emptyIcon: Icons.star_border,
                onRatingChanged: (value) => debugPrint('$value'),
                initialRating: initial,
                maxRating: 5,
              ),*/
            ],
          ),
        ],
      ),
    );
  }
}

class HomeSkeletonLoader extends StatelessWidget {
  const HomeSkeletonLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        // Add AppBar Skeleton Loader
        HomeAppBarSkeletonLoader(),
        const SizedBox(height: 10),
        _skeletonRow(),
        const SizedBox(height: 15),
        _skeletonContainer(),
        const SizedBox(height: 10),
        _skeletonRow(),
        const SizedBox(height: 10),
        _skeletonCareTaker(),
        const SizedBox(height: 10),
        _skeletonCareTaker(),
        const SizedBox(height: 10),
        _skeletonCareTaker(),
        const SizedBox(height: 10),
        _skeletonRow(),
        const SizedBox(height: 10),
        _skeletonAppointment(),
        const SizedBox(height: 30),
      ],
    );
  }

  // Existing methods for skeleton rows and containers
  Widget _skeletonRow() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[100] ?? Colors.grey,
      highlightColor: Colors.grey[100]!,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 100,
            height: 20,
            color: Colors.white,
          ),
          Container(
            width: 60,
            height: 20,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _skeletonContainer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[100] ?? Colors.grey,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _skeletonCareTaker() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[100] ?? Colors.grey,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _skeletonAppointment() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[100] ?? Colors.grey,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
      ),
    );
  }
}

class HomeAppBarSkeletonLoader extends StatelessWidget
    implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(100.0), // Match the height of your app bar
      child: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 8.0),
          child: CircleAvatar(
            radius: 20.0,
            backgroundColor:
                Colors.grey[100], // Use a light color for the skeleton
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _skeletonText(120, 20), // For username
            SizedBox(height: 4.0),
            _skeletonText(80, 14), // For subtitle
          ],
        ),
        actions: [
          _skeletonIconButton(),
          _skeletonIconButton(),
          SizedBox(width: 16.0), // Add some space at the end
        ],
      ),
    );
  }

  // A helper method to create skeleton text
  Widget _skeletonText(double width, double height) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[100] ?? Colors.grey,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        color: Colors.white,
      ),
    );
  }

  // A helper method to create a skeleton icon button
  Widget _skeletonIconButton() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[100] ?? Colors.grey,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: 30, // Adjust width as needed for the icon
        height: 30, // Adjust height as needed for the icon
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(100); // Match your app bar height
}
