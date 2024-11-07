import 'package:care2care/ReusableUtils_/AppColors.dart';
import 'package:care2care/ReusableUtils_/appBar.dart';
import 'package:care2care/ReusableUtils_/customButton.dart';
import 'package:care2care/ReusableUtils_/customLabel.dart';
import 'package:care2care/ReusableUtils_/custom_textfield.dart';
import 'package:care2care/ReusableUtils_/sizes.dart';
import 'package:care2care/ReusableUtils_/toast2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../ReusableUtils_/image_background.dart';
import '../Appoinment/controller/appointmentsStatus_Controller.dart';

class CancelAppointment extends StatefulWidget {
  final String? name;
  final String? date;
  final String? time;
  final String? status;
  final String? imgUrl;
  final String? notes;
  String? serviceCharge;
  String? paymentStatus;
  int? careTakerId;
  int? appointmentId;

  CancelAppointment({
    super.key,
    this.imgUrl,
    this.name,
    this.status,
    this.time,
    this.date,
    this.notes,
    this.serviceCharge,
    this.paymentStatus,
    this.appointmentId,
    this.careTakerId,
  });

  @override
  State<CancelAppointment> createState() => _CancelAppointmentState();
}

class _CancelAppointmentState extends State<CancelAppointment> {
  final AppointmentStatusController controller =
      Get.put(AppointmentStatusController());

  @override
  Widget build(BuildContext context) {
    return CustomBackground(
      bottomNavBar: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: GetBuilder<AppointmentStatusController>(builder: (context) {
          return CustomButton(
            isLoading: controller.isLoading,
            onPressed: () {
              if (controller.cancelCT.text.isEmpty) {
                // Display an error if the reason is empty
                showCustomToast(
                    message: "Please Enter Valid Reason for Cancellation ",
                    gravity: ToastGravity.CENTER);
                return;
              }

              controller.isLoading = true;
              controller.update();

              controller
                  .cancelRequest(
                appId: widget.appointmentId,
                careTakerId: widget.careTakerId,
                serviceStatus: "cancelled",
                cancelReason: controller.cancelCT.text,
              )
                  .then((_) {
                controller.isLoading = false;
                controller.update();

                // Close the screens only after the request completes
                Get.back();
                Get.back();
              });
            },
            text: 'Cancel Request',
          );
        }),
      ),
      appBar: CustomAppBar(
        title: 'Cancel Appointment',
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(5.0),
              height: MediaQuery.sizeOf(context).height * 0.15,
              width: MediaQuery.sizeOf(context).width,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.red.withOpacity(0.2)),
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Patient's Circular Avatar
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(widget.imgUrl ?? ""),
                  ),
                  const SizedBox(width: 10),
                  // Patient Info
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.name ?? "N/A",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(Icons.calendar_today,
                              size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            "Date: ${widget.date ?? "N/A"}",
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(Icons.access_time, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            widget.time ?? "N/A",
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            kHeight20,
            CustomLabel(
              text: "Reason For Cancellation",
              fontSize: 15.sp,
              color: AppColors.primaryColor,
            ),
            kHeight15,
            customTextField(
              context,
              labelText: 'Enter Reason',
              maxLines: 4,
              controller: controller.cancelCT,
            ),
          ],
        ),
      ),
    );
  }
}
