import 'package:cached_network_image/cached_network_image.dart';
import 'package:care2care/ReusableUtils_/AppColors.dart';
import 'package:care2care/ReusableUtils_/image_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../ReusableUtils_/appBar.dart';
import '../../ReusableUtils_/customButton.dart';
import '../../ReusableUtils_/customLabel.dart';
import '../../ReusableUtils_/sizes.dart';
import '../Cancel_Appointment/cancel_appointment.dart';
import 'controller/appointmentsStatus_Controller.dart';

class RequestDetailsScreen extends StatefulWidget {
  final String? name;
  final String? date;
  final String? time;
  final String? status;
  final String? imgUrl;
  String? ServiceCharge;
  String? paymentStatus;
  int? careTakerId;
  int? AppointmentId;

  RequestDetailsScreen(
      {Key? key,
      this.imgUrl,
      this.name,
      this.status,
      this.time,
      this.ServiceCharge,
      this.date,
      this.paymentStatus,
      this.careTakerId,
      this.AppointmentId})
      : super(key: key);

  @override
  State<RequestDetailsScreen> createState() => _RequestDetailsScreenState();
}

class _RequestDetailsScreenState extends State<RequestDetailsScreen> {
  AppointmentStatusController controller =
      Get.put(AppointmentStatusController());

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
                    color: Colors.black),
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
                      style: TextStyle(color: Colors.blue)),
                  // Change color if needed
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
                      style: TextStyle(color: Colors.blue)),
                  // Change color if needed
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
                  // Status color
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
                  // Status color
                ],
              ),
            ),
            SizedBox(height: 10),
            RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 16, color: Colors.black),
                children: [
                  TextSpan(text: "Service Charges: "),
                  TextSpan(
                      text: widget.ServiceCharge ?? '',
                      style: TextStyle(color: Colors.red)),
                  // Status color
                ],
              ),
            ),
            SizedBox(height: 10),
            RichText(
              text: TextSpan(
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
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
                  TextSpan(text: " appointment.notes"),
                  // This should be dynamic if needed
                ],
              ),
            ),
            SizedBox(height: 20),
            GetBuilder<AppointmentStatusController>(builder: (v) {
              return CustomButton(
                text: 'Cancel request',
                onPressed: () {
                  Get.to(() => CancelAppointment(
                        appointmentId: widget.AppointmentId,
                        careTakerId: widget.careTakerId,
                        serviceCharge: widget.ServiceCharge,
                        status: widget.status,
                        imgUrl: widget.imgUrl,
                        date: widget.date,
                        name: widget.name,
                        time: widget.time,
                        paymentStatus: widget.paymentStatus,
                        /*         notes: widget.notes,*/
                      ));
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}

class RequestDetailsScreen2 extends StatefulWidget {
  final String? name;
  final String? date;
  final String? time;
  final String? status;
  final String? imgUrl;
  String? serviceCharge;
  String? paymentStatus;
  int? careTakerId;
  int? appointmentId;

  RequestDetailsScreen2(
      {Key? key,
      this.imgUrl,
      this.name,
      this.status,
      this.time,
      this.serviceCharge,
      this.date,
      this.paymentStatus,
      this.careTakerId,
      this.appointmentId})
      : super(key: key);

  @override
  State<RequestDetailsScreen2> createState() => _RequestDetailsScreen2State();
}

class _RequestDetailsScreen2State extends State<RequestDetailsScreen2> {
  AppointmentStatusController controller =
      Get.put(AppointmentStatusController());

  @override
  Widget build(BuildContext context) {
    return CustomBackground(
      bottomNavBar:      GetBuilder<AppointmentStatusController>(builder: (v) {
        return Padding(
          padding:  EdgeInsets.only(bottom: 12.r),
          child: CustomButton(
            text: 'Cancel Request',
            onPressed: () {
              Get.to(() => CancelAppointment(
                appointmentId: widget.appointmentId,
                careTakerId: widget.careTakerId,
                serviceCharge: widget.serviceCharge,
                status: widget.status,
                imgUrl: widget.imgUrl,
                date: widget.date,
                name: widget.name,
                time: widget.time,
                paymentStatus: widget.paymentStatus,
              ));
            },
          ),
        );
      }),
      appBar: CustomAppBar(
        appbarBackgroundColor: AppColors.primaryColor,
        title: "Appointment Request Details",
      ),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              height: MediaQuery.sizeOf(context).height * 0.25,
              decoration: BoxDecoration(
                  color: AppColors.primaryColor, // Primary color or change as per design
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30))),
              child: Column(
                children: [
                  kHeight15,
                  CachedNetworkImage(
                    imageUrl: widget.imgUrl ?? '',
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) => Icon(
                      Icons.error,
                      size: 30,
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
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  kHeight10,
                  CustomLabel(
                    text: 'Requested Date',
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                  kHeight5,
                  Text(
                    '${widget.date ?? DateTime.now()}',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                  ),
                  Divider(
                      height: 12, thickness: 1.5, color: Colors.grey.shade300),
                  CustomLabel(
                    text: 'Appointment Time',
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                  kHeight5,
                  Text(
                    widget.time ?? "Not Available",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                  ),
                  Divider(
                      height: 12, thickness: 1.5, color: Colors.grey.shade300),
                  CustomLabel(
                    text: 'Service Charge ',
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                  kHeight5,
                  Text(
                    " \$${widget.serviceCharge ?? "Not Available"}",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                  ),
                  Divider(
                      height: 12, thickness: 1.5, color: Colors.grey.shade300),
                  CustomLabel(
                    text: 'Appointment Status',
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                  kHeight5,
                  Text(
                    '${widget.status ?? "Unknown"}',
                    style: TextStyle(
                      color: widget.status == 'approved'
                          ? Colors.green
                          : Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  Divider(
                      height: 12, thickness: 1.5, color: Colors.grey.shade300),
                  CustomLabel(
                    text: 'Payment Status',
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                  kHeight5,
                  Text(
                    '${widget.paymentStatus ?? "Pending"}',
                    style: TextStyle(
                      fontSize: 16,
                      color: widget.paymentStatus == 'pending'
                          ? Colors.orange
                          : Colors.green,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  Divider(
                      height: 12, thickness: 1.5, color: Colors.grey.shade300),
                  CustomLabel(
                    text: 'Notes',
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                  kHeight5,
                  Text(
                    'No additional notes available',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  kHeight20,

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
