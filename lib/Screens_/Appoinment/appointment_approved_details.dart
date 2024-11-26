import 'package:cached_network_image/cached_network_image.dart';
import 'package:care2care/ReusableUtils_/AppColors.dart';
import 'package:care2care/ReusableUtils_/appBar.dart';
import 'package:care2care/ReusableUtils_/customLabel.dart';
import 'package:care2care/ReusableUtils_/image_background.dart';
import 'package:care2care/ReusableUtils_/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

import '../../ReusableUtils_/customButton.dart';
import '../Paymentmethod/controller/paymentMethod_controller.dart';

class ApprovedDetailScreen extends StatefulWidget {
  final String? name;
  final String? date;
  final String? time;
  final String? status;
  final String? imgUrl;
  final String? notes;
  String? fromTime;
  String? Totime;
  String? serviceCharge;
  String? paymentStatus;
  int? careTakerId;
  int? appointmentId;
  int? total;

  ApprovedDetailScreen(
      {super.key,
        this.imgUrl,
        this.name,
        this.status,
        this.time,
        this.date,
        this.notes,
        this.fromTime,
        this.Totime,
        this.serviceCharge,
        this.paymentStatus,
        this.appointmentId,
        this.careTakerId,
        this.total});

  @override
  State<ApprovedDetailScreen> createState() => _ApprovedDetailScreenState();
}

class _ApprovedDetailScreenState extends State<ApprovedDetailScreen> {
  int totalAmount = 0;

  PayMethodController pm = Get.put(PayMethodController());

  @override
  void initState() {
    super.initState();
    calculateTotalAmount();
  }

  void calculateTotalAmount() {
    // Ensure fromTime and toTime are not null
    if (widget.fromTime != null && widget.Totime != null) {
      // Parse the time strings into DateTime objects
      DateTime fromDateTime = DateTime.parse("2024-10-30 ${widget.fromTime}");
      DateTime toDateTime = DateTime.parse("2024-10-30 ${widget.Totime}");

      // Calculate the total hours worked
      Duration duration = toDateTime.difference(fromDateTime);
      int totalHoursWorked = duration.inHours;

      // Parse the service charge to an integer
      int? serviceCharge = int.tryParse(widget.serviceCharge ?? '');

      // Calculate the total charge only if serviceCharge is valid
      if (serviceCharge != null) {
        totalAmount = totalHoursWorked * serviceCharge;
      } else {
        totalAmount = 0; // Handle parsing error
      }
    } else {
      totalAmount = 0; // Default to 0 if times are null
    }

    // Trigger UI update
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return CustomBackground(
      bottomNavBar: GetBuilder<PayMethodController>(builder: (v) {
        return Padding(
          padding: EdgeInsets.only(bottom: 10.h),
          child: CustomButton(
            isLoading: v.paymentLoading,
            text: 'Pay Now',
            onPressed: () {
              // Show confirmation dialog
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text("Confirm Payment"),
                  content: Text(
                      "Do you want to proceed with the payment of \$${totalAmount}?"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pop(); // Close the dialog without any action
                      },
                      child: Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () async {
                        Navigator.of(context).pop(); // Close the dialog
                        // Set loading state to true
                        v.paymentLoading = true;
                        v.update();

                        // Initialize payment
                        await v.paymentSheetInitialization(
                          context,
                          totalAmount.toString(),
                          "USD",
                          appointmentId: widget.appointmentId,
                          caretakerId: widget.careTakerId,
                          careTakerName: widget.name,
                          bookingDate: widget.date,
                          bookingFromTime: widget.fromTime,
                          bookingToTime: widget.Totime,
                        );

                        // Set loading state to false after initialization
                        v.paymentLoading = false;
                        v.update();
                      },
                      child: Text("Confirm"),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      }),
      appBar: CustomAppBar(
        appbarBackgroundColor: AppColors.primaryColor,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: "Appoint Req",
      ),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              height: MediaQuery.sizeOf(context).height * 0.25,
              decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30.r),
                      bottomRight: Radius.circular(30.r))),
              child: Column(
                children: [
                  kHeight15,
                  CachedNetworkImage(
                    imageUrl: widget.imgUrl!,
                    height: 100.h,
                    width: 100.h,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Center(
                      child: SizedBox(
                        height: 20.h,
                        width: 20.h,
                        child: CircularProgressIndicator(strokeWidth: 2.0),
                      ),
                    ),
                    errorWidget: (context, url, error) => Icon(
                      Icons.error,
                      size: 30.sp,
                      color: Colors.red,
                    ),
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  kHeight10,
                  Text(
                    widget.name ?? "No Name",
                    style:
                    TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          // Adding more slivers if needed
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  kHeight10,
                  CustomLabel(
                    text: 'Requested Date',
                    fontWeight: FontWeight.bold,
                    fontSize: 17.sp,
                  ),
                  kHeight5,
                  Text(
                    '${widget.date ?? DateTime.now()}',
                    style: TextStyle(
                        fontSize: 16.sp, fontWeight: FontWeight.normal),
                  ),

                  // Divider with height 5
                  Divider(
                    height: 12, // Adjusted height
                    thickness: 1.5,
                    color: Colors.grey.shade300,
                  ),

                  CustomLabel(
                    text: 'Appointment Time',
                    fontWeight: FontWeight.bold,
                    fontSize: 17.sp,
                  ),
                  kHeight5,
                  Text(
                    widget.time!,
                    style: TextStyle(
                        fontSize: 16.sp, fontWeight: FontWeight.normal),
                  ),

                  // Divider with height 5
                  Divider(
                    height: 12, // Adjusted height
                    thickness: 1.5,
                    color: Colors.grey.shade300,
                  ),

                  CustomLabel(
                    text: 'Service Charge',
                    fontWeight: FontWeight.bold,
                    fontSize: 17.sp,
                  ),
                  kHeight5,
                  Text(
                    '\$ ${widget.serviceCharge} /Hr',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                    ),
                  ),

                  // Divider with height 5
                  Divider(
                    height: 12, // Adjusted height
                    thickness: 1.5,
                    color: Colors.grey.shade300,
                  ),

                  CustomLabel(
                    text: 'Total Charge',
                    fontWeight: FontWeight.bold,
                    fontSize: 17.sp,
                  ),
                  kHeight5,
                  Text(
                    '\$ ${totalAmount}',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                    ),
                  ),

                  // Divider with height 5
                  Divider(
                    height: 12, // Adjusted height
                    thickness: 1.5,
                    color: Colors.grey.shade300,
                  ),

                  CustomLabel(
                    text: 'Appointment Status',
                    fontWeight: FontWeight.bold,
                    fontSize: 17.sp,
                  ),
                  kHeight5,
                  Text(
                    '${widget.status![0].toUpperCase()}${widget.status!.substring(1).toLowerCase()}',
                    style: TextStyle(
                      color: widget.status == 'approved'
                          ? AppColors.primaryColor
                          : Colors.red,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.normal,
                    ),
                  ),

                  // Divider with height 5
                  Divider(
                    height: 12, // Adjusted height
                    thickness: 1.5,
                    color: Colors.grey.shade300,
                  ),

                  CustomLabel(
                    text: 'Payment Status',
                    fontWeight: FontWeight.bold,
                    fontSize: 17.sp,
                  ),
                  kHeight5,
                  Text(
                    '${widget.paymentStatus![0].toUpperCase()}${widget.paymentStatus!.substring(1).toLowerCase()}',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: widget.paymentStatus == 'pending'
                          ? AppColors.secondaryColor
                          : Colors.red,
                      fontWeight: FontWeight.normal,
                    ),
                  ),

                  // Divider with height 5
                  Divider(
                    height: 12, // Adjusted height
                    thickness: 1.5,
                    color: Colors.grey.shade300,
                  ),

                  CustomLabel(
                    text: 'Notes',
                    fontWeight: FontWeight.bold,
                    fontSize: 17.sp,
                  ),
                  kHeight5,
                  Text(
                    '${widget.notes ?? 'No Notes Available'}',
                    maxLines: 3,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.black,
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
