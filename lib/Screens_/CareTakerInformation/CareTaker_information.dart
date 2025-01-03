import 'package:care2care/ReusableUtils_/AppColors.dart';
import 'package:care2care/ReusableUtils_/appBar.dart';
import 'package:care2care/ReusableUtils_/customButton.dart';
import 'package:care2care/ReusableUtils_/customLabel.dart';
import 'package:care2care/ReusableUtils_/image_background.dart';
import 'package:care2care/ReusableUtils_/sizes.dart';
import 'package:care2care/Screens_/CareTakerInformation/Controller/careTaker_controller.dart';
import 'package:care2care/Screens_/HomeScreen/controller/home%20controller.dart';
import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';
import '../../ReusableUtils_/Sliding_date.dart';
import '../../ReusableUtils_/customChips.dart';
import '../../ReusableUtils_/toast2.dart';
import '../caretakerList/careTakerListView.dart';

class CaretakerInformation extends StatefulWidget {
  String? doctorName;
  String? doctorDesignation;
  String? doctorState;
  String? gender;
  String? totalPatient;
  String? experience;
  String? rating;
  String? imageUrl;
  String? charge;
  String? about;

  int? careTakerId;

  CaretakerInformation({
    super.key,
    this.doctorName,
    this.doctorDesignation,
    this.doctorState,
    this.gender,
    this.totalPatient,
    this.experience,
    this.rating,
    this.imageUrl,
    this.careTakerId,
    this.charge,
    this.about
  });

  @override
  State<CaretakerInformation> createState() => _CaretakerInformationState();
}

class _CaretakerInformationState extends State<CaretakerInformation> {
  final List<String> morning = [];
  final List<String> noon = [];
  final List<String> evening = [];

  final List<String> zone = [
    '06.00 AM',
    '06.30 AM',
    '07.00 AM',
    '07.30 AM',
    '08.00 AM',
  ];

  HomeController ct = Get.put(HomeController());
  CareTakerController controller = Get.put(CareTakerController());

  @override
  Widget build(BuildContext context) {
    return CustomBackground(
      appBar: CustomAppBar(
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.share,
                  color: AppColors.primaryColor,
                )),
          ),
        ],
        title: "CareTaker Information",
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: SingleChildScrollView(
          child: GetBuilder<HomeController>(builder: (v) {
            var path = v.profilePath;
            //var imgUrl = v.viewAllCareTakers!.data![index].profileImageUrl;
            return Column(
              children: [
                carTakerList(context, ct,
                    doctorDesignation: 'Care taker',
                    doctorName: widget.doctorName,
                    imageUrl: widget.imageUrl,
                    gender: widget.gender,
                    rating: widget.rating,
                    totalPatient: widget.totalPatient,
                    experience: widget.experience,
                    charge: widget.charge,
                    doctorState: widget.doctorState),
                kHeight10,
                Row(
                  children: [
                    switchContainer(context,
                        circleColor: AppColors.primaryColor,
                        icon: IconlyBold.heart,
                        name: "Add to Favorites"),
                    kWidth10,
                    switchContainer(context,
                        icon: IconlyBold.message,
                        circleColor: Colors.white,
                        name: "Contact Care Taker",
                        containerColor: AppColors.primaryColor),
                  ],
                ),
                kHeight10,
                CustomLabel(
                  text: "About",
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
                kHeight10,
                ReadMoreText(
                  widget.about ?? "",
                  trimMode: TrimMode.Line,
                  trimLines: 2,
                  colorClickableText: Colors.pink,
                  trimCollapsedText: 'Show more',
                  trimExpandedText: 'Show less',
                  moreStyle:
                      TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                kHeight10,
                Divider(),
                CustomLabel(
                  text: "Working Hours",
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
                SizedBox(
                  height: 5.h,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Monday - Saturday"),
                    Text("9.00AM - 9.00PM"),
                  ],
                ),
                kHeight10,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Schedule",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(IconlyLight.calendar)),
                  ],
                ),
                GetBuilder<CareTakerController>(builder: (v) {
                  return CustomEasyDateTimeLine(
                    disabledDates: v.getDisabledDates(),
                    selectedDate: v.appointmentDate,
                    onDateChange: (date) {
                      v.appointmentDate = date;
                      print("selected Date: $date");
                      v.update();
                    },
                  );
                }),
                kHeight10,
                Container(
                  height: MediaQuery.of(context).size.height * 0.17,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10.r),
                    border:
                        Border.all(color: AppColors.primaryColor, width: 0.5),
                  ),
                  padding: EdgeInsets.all(10.w),
                  child: GetBuilder<CareTakerController>(builder: (v) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            v.pickFromTime(context);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 10.h, horizontal: 15.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${controller.fromTime != null ? DateFormat.jm().format(controller.fromTime!) : "09:00 AM"}', // Format to Indian Time
                                  style: TextStyle(fontSize: 16.sp),
                                ),
                                Icon(EneftyIcons.calendar_3_outline,
                                    color: AppColors.primaryColor),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        GestureDetector(
                          onTap: () {
                            v.pickToTime(context);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 10.h, horizontal: 15.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${controller.toTime != null ? DateFormat.jm().format(controller.toTime!) : "06:00 PM"}', // Format to Indian Time
                                  style: TextStyle(fontSize: 16.sp),
                                ),
                                Icon(EneftyIcons.calendar_3_outline,
                                    color: AppColors.primaryColor),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
                kHeight10,
                CustomLabel(
                  text: "If you have any instruction kindly add here",
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
                kHeight10,
                TextField(
                  maxLines: 4,
                  decoration: InputDecoration(
                    //filled: true,
                    focusColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.black, width: 0.3),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    border: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.black, width: 0.3),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.black, width: 0.3),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    hintStyle: const TextStyle(color: Colors.grey),
                  ),
                ),
                kHeight30,
              ],
            );
          }),
        ),
      ),
      bottomNavBar: Container(
        height: MediaQuery.of(context).size.height * 0.09,
        color: Colors.white,
        child: Center(
          child: GetBuilder<CareTakerController>(builder: (v) {
            return CustomButton(
              text: 'Book Appointment',
              isLoading: v.isAppointmentLoading,
              onPressed: () async {
                if (!v.isAppointmentLoading) {
                  v.isAppointmentLoading = true;
                  v.update();

                  await v.bookAppointmentApi(careTakerId: widget.careTakerId);
                  Get.back();
                  v.isAppointmentLoading = false;
                  v.update();

                }
              },
            );
          }),
        ),
      ),
    );
  }
}

Widget switchContainer(BuildContext context,
    {IconData? icon,
    String? name,
    Color? containerColor,
    Color? circleColor,
    Color? iconColor}) {
  return Expanded(
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w),
      height: 30.h,
      width: MediaQuery.of(context).size.width * 0.38,
      decoration: BoxDecoration(
        border: Border.all(width: 0.2),
        color: containerColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 15.r,
            backgroundColor: circleColor,
            child: Icon(
              size: 17.sp,
              icon,
              color: iconColor,
            ),
          ),
          SizedBox(width: 5.w),
          Text(
            name ?? '',
            style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600),
          )
        ],
      ),
    ),
  );
}
