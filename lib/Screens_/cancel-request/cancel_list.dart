import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../ReusableUtils_/appBar.dart';
import '../../ReusableUtils_/image_background.dart';
import '../Appoinment/controller/appointmentsStatus_Controller.dart';

class CancelList extends StatelessWidget {
  CancelList({super.key});

  final AppointmentStatusController controller =
      Get.put(AppointmentStatusController());

  Future<void> _onRefresh() async {
    await controller.loadRejectList();
  }

  @override
  Widget build(BuildContext context) {
    return CustomBackground(
      appBar: CustomAppBar(
        title: 'Cancelled List',
      ),
      child: RefreshIndicator(
        onRefresh: _onRefresh,
        child: GetBuilder<AppointmentStatusController>(
          builder: (v) {
            if (v.CancelledAppointment.isEmpty) {
              return ListView(
                physics: AlwaysScrollableScrollPhysics(),
                children: [
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.4,
                      ),
                      child: Text(
                        "No cancelled appointments.",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              );
            }

            // Otherwise, display the list of cancelled appointments
            return ListView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * 0.01,
                horizontal: MediaQuery.of(context).size.width * 0.02,
              ),
              itemCount: v.CancelledAppointment.length,
              itemBuilder: (context, index) {
                var data = v.CancelledAppointment[index];
                return Container(
                  height: MediaQuery.sizeOf(context).height * 0.15,
                  width: MediaQuery.sizeOf(context).width,
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image Section
                      ClipOval(
                        child: Image.network(
                          "${v.appointmentStatus!.profilePath}${data.caretaker!.profileImageUrl}",
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.person,
                                size: 50, color: Colors.grey);
                          },
                        ),
                      ),
                      SizedBox(width: 10),
                      // Info Section
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data.caretaker!.caretakerInfo!.firstName ?? 'N/A',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                                "Age: ${data.caretaker!.caretakerInfo!.age ?? 'N/A'}"),
                            Text("Date: ${data.appointmentDate ?? 'N/A'}"),
                            Text(
                                "Time: ${data.appointmentStartTime ?? 'N/A'} - ${data.appointmentEndTime ?? 'N/A'}"),
                            Text(
                              "Status: ${data.serviceStatus ?? 'Cancelled'}",
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
