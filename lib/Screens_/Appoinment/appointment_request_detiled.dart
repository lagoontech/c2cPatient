import 'package:care2care/ReusableUtils_/image_background.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../ReusableUtils_/appBar.dart';
import '../../ReusableUtils_/customButton.dart';
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
                        name: widget.name,time: widget.time,
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
