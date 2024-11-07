import 'package:care2care/ReusableUtils_/image_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';

import '../../ReusableUtils_/appBar.dart';
import '../../ReusableUtils_/customButton.dart';
import '../Cancel_Appointment/cancel_appointment.dart';
import '../Paymentmethod/controller/paymentMethod_controller.dart';
import '../SuccessfulPament/paymet_successfulView.dart';

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

  ApprovedDetailScreen({
    Key? key,
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
  }) : super(key: key);

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
      appBar: CustomAppBar(
        title: "Appointment Request Details",
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 50,
              child: ClipOval(
                child: Image.network(
                  widget.imgUrl ?? '',
                  width: 95,
                  height: 95,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 10),
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(text: widget.name ?? ''),
                ],
              ),
            ),
            SizedBox(height: 10),
            RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 16, color: Colors.black),
                children: [
                  TextSpan(text: "Date: "),
                  TextSpan(
                      text: widget.date ?? '',
                      style: TextStyle(color: Colors.blue, fontSize: 14.sp)),
                ],
              ),
            ),
            SizedBox(height: 5),
            RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 16, color: Colors.black),
                children: [
                  TextSpan(text: "Appointment Time: "),
                  TextSpan(
                      text: widget.time ?? '',
                      style: TextStyle(color: Colors.blue, fontSize: 14.sp)),
                ],
              ),
            ),
            SizedBox(height: 10),
            RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 16, color: Colors.black),
                children: [
                  TextSpan(text: "Appointment Status: "),
                  TextSpan(
                      text: widget.status ?? '',
                      style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
            SizedBox(height: 10),
            RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 16, color: Colors.black),
                children: [
                  TextSpan(text: "Payment Status: "),
                  TextSpan(
                      text: widget.paymentStatus ?? '',
                      style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
            SizedBox(height: 10),
            RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 16, color: Colors.black),
                children: [
                  TextSpan(text: "Service Charge: "),
                  TextSpan(
                      text: "\$${widget.serviceCharge}/Hr",
                      style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
            SizedBox(height: 10),
            RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 16, color: Colors.black),
                children: [
                  TextSpan(text: "Total Charge: "),
                  TextSpan(
                      text: "\$${totalAmount}",
                      style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
            SizedBox(height: 10),
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(text: "Notes:"),
                ],
              ),
            ),
            SizedBox(height: 5),
            RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 16, color: Colors.black),
                children: [
                  TextSpan(text: widget.notes ?? 'No notes available'),
// Show dynamic notes or default message
                ],
              ),
            ),
            SizedBox(height: 5),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
// Evenly space buttons
                children: [
                  Expanded(
                    child: CustomButton(
                      text: 'Cancel Request',
                      onPressed: () {
                        Get.to(() => CancelAppointment(
                              name: widget.name,
                              time: widget.time,
                              date: widget.date,
                              imgUrl: widget.imgUrl,
                              appointmentId: widget.appointmentId,
                              careTakerId: widget.careTakerId,
                            ));
                      },
                    ),
                  ),
                  SizedBox(width: 10), // Add space between buttons
                  Expanded(
                    child: GetBuilder<PayMethodController>(builder: (v) {
                      return CustomButton(
                        isLoading: v.paymentLoading,
                        text: 'Pay Now',
                        onPressed: () {
                          // Show confirmation dialog
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: Text("Confirm Payment"),
                              content: Text("Do you want to proceed with the payment of \$$totalAmount?"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(); // Close the dialog without any action
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
                      );
                    }),

                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
