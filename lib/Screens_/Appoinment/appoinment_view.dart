import 'package:care2care/ReusableUtils_/appBar.dart';
import 'package:care2care/ReusableUtils_/image_background.dart';
import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../ReusableUtils_/Custom_AppoinMents.dart';
import '../CareTakerInformation/CareTaker_information.dart';
import 'appointment_approved_details.dart';
import 'appointment_request_detiled.dart';
import 'controller/appointmentsStatus_Controller.dart';

class AppointmentView extends StatelessWidget {
  AppointmentView({super.key});

  final AppointmentStatusController controller =
      Get.put(AppointmentStatusController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: CustomBackground(
        appBar: CustomAppBar(
          leading: SizedBox(),
          title: "Appointment",
          bottom: const TabBar(
            tabs: [
              Tab(text: "Requested"),
              Tab(text: "Approved"),
              Tab(text: "Processing"),
            ],
          ),
        ),
        child: TabBarView(
          children: [
            GetBuilder<AppointmentStatusController>(
              builder: (controller) {
                return RefreshIndicator(
                  onRefresh: () async {
                    await controller.refreshAppointments();
                  },
                  child: controller.isLoading
                      ? Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          padding: EdgeInsets.all(8.0),
                          itemCount: controller.RequestAppointment.length,
                          itemBuilder: (context, index) {
                            final requested =
                                controller.RequestAppointment[index];
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 3.h),
                              child: InkWell(
                                onTap: () {
                                  Get.to(() => RequestDetailsScreen2(
                                        careTakerId: requested.caretakerId,
                                        appointmentId: requested.id,
                                        serviceCharge: requested.caretaker!.caretakerInfo!.serviceCharge,
                                        paymentStatus: requested.paymentStatus,
                                        imgUrl: '${controller.appointmentStatus!.profilePath}${requested.caretaker?.profileImageUrl}',
                                        name: requested.caretaker!.caretakerInfo!.firstName,
                                        date: DateFormat('dd/MM/yyyy').format(requested.appointmentDate!),
                                        status: requested.serviceStatus,
                                        time: "${requested.appointmentStartTime} - ${requested.appointmentEndTime}",
                                      ));
                                },
                                child: AppointmentsContainer(
                                  action: '',
                                  appointmentDate: DateFormat('dd/MM/yyyy')
                                      .format(requested.appointmentDate!),
                                  appointmentTime:
                                      "${requested.appointmentStartTime} - ${requested.appointmentEndTime}",
                                  doctorName: requested.caretaker?.caretakerInfo
                                          ?.firstName ??
                                      "Unknown",
                                  doctorDesignation: requested
                                          .caretaker?.caretakerInfo?.location ??
                                      "Neurologist",
                                  imageUrl:
                                      '${controller.appointmentStatus!.profilePath}${requested.caretaker?.profileImageUrl}',
                                ),
                              ),
                            );
                          },
                        ),
                );
              },
            ),
            // Approved Tab
            GetBuilder<AppointmentStatusController>(
              builder: (controller) {
                return RefreshIndicator(
                    onRefresh: () async {
                      await controller.refreshAppointments();
                    },
                    child: Column(
                      children: [
                        SizedBox(height: 5.h),
                        /* Padding(
                          padding: const EdgeInsets.all(5),
                          child: CustomEasyDateTimeLine(

                          ),
                        ),*/

                        SizedBox(height: 10.h), // Spacing belo
                        Expanded(
                          child: controller.isLoading
                              ? Center(child: CircularProgressIndicator())
                              : ListView.builder(
                                  padding: EdgeInsets.all(8.0),
                                  itemCount:
                                      controller.ApprovedAppointment.length,
                                  itemBuilder: (context, index) {
                                    final approved =
                                        controller.ApprovedAppointment[index];
                                    return Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 3.h),
                                      child: InkWell(
                                        onTap: () {
                                          Get.to(
                                            () => ApprovedDetailScreen(
                                              fromTime:
                                                  approved.appointmentStartTime,
                                              Totime:
                                                  approved.appointmentEndTime,
                                              serviceCharge: approved.caretaker!
                                                  .caretakerInfo!.serviceCharge,
                                              appointmentId: approved.id,
                                              careTakerId: approved.caretakerId,
                                              paymentStatus:
                                                  approved.paymentStatus,
                                              imgUrl:
                                                  '${controller.appointmentStatus!.profilePath}${approved.caretaker?.profileImageUrl}',
                                              name: '${approved.caretaker!.caretakerInfo!.firstName} ${approved.caretaker!.caretakerInfo!.lastName}',
                                              date: DateFormat('dd/MM/yyyy')
                                                  .format(approved
                                                      .appointmentDate!),
                                              status: approved.serviceStatus,
                                              time:
                                                  "From ${DateFormat('h:mm a').format(DateTime.parse('1970-01-01 ${approved.appointmentStartTime}'))} - To ${DateFormat('h:mm a').format(DateTime.parse('1970-01-01 ${approved.appointmentEndTime}'))}",
                                            ),
                                          );
                                        },
                                        child: AppointmentsContainer(
                                          statusColor: Colors.green,
                                          appointmentDate:
                                              DateFormat('dd/MM/yyyy').format(
                                                  approved.appointmentDate!),
                                          appointmentTime:
                                              "${approved.appointmentStartTime} - ${approved.appointmentEndTime}",
                                          doctorName: approved.caretaker
                                                  ?.caretakerInfo?.firstName ??
                                              "Unknown",
                                          doctorDesignation: approved.caretaker
                                                  ?.caretakerInfo?.location ??
                                              "Neurologist",
                                          imageUrl:
                                              '${controller.appointmentStatus!.profilePath}${approved.caretaker?.profileImageUrl}',
                                        ),
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ],
                    ));
              },
            ),
            // Requested Tab

            // Completed Tab
            /*GetBuilder<AppointmentStatusController>(
              builder: (controller) {
                return RefreshIndicator(
                  onRefresh: () async {
                    await controller.refreshAppointments();
                  },
                  child: controller.isLoading
                      ? Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          padding: EdgeInsets.all(8.0),
                          itemCount: controller.CompletedAppointment.length,
                          itemBuilder: (context, index) {
                            final completed =
                                controller.CompletedAppointment[index];
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 3.h),
                              child: AppointmentsContainer(
                                action: "Reschedule",
                                actionIcon: EneftyIcons.refresh_outline,
                                appointmentDate: DateFormat('dd/MM/yyyy')
                                    .format(completed.appointmentDate!),
                                appointmentTime:
                                    "${completed.appointmentStartTime} - ${completed.appointmentEndTime}",
                                doctorName: completed
                                        .caretaker?.caretakerInfo?.firstName ??
                                    "Unknown",
                                doctorDesignation: completed
                                        .caretaker?.caretakerInfo?.location ??
                                    "Neurologist",
                                imageUrl:
                                    '${controller.appointmentStatus!.profilePath}${completed.caretaker?.profileImageUrl}',
                              ),
                            );
                          },
                        ),
                );
              },
            ),*/
            // Cancelled Tab
            GetBuilder<AppointmentStatusController>(
              builder: (controller) {
                return RefreshIndicator(
                  onRefresh: () async {
                    await controller.refreshAppointments();
                  },
                  child: controller.isLoading
                      ? Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          padding: EdgeInsets.all(8.0),
                          itemCount: controller.ProcessingAppointment.length,
                          itemBuilder: (context, index) {
                            final cancelled =
                                controller.ProcessingAppointment[index];
                            var data =
                                controller.appointmentStatus!.profilePath;

                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 3.h),
                              child: AppointmentsContainer(
                                actionTap: () {
                                  Get.to(() => CaretakerInformation(
                                        careTakerId: cancelled.caretakerId,
                                        gender: cancelled
                                            .caretaker!.caretakerInfo!.sex,
                                        charge: cancelled.caretaker!
                                            .caretakerInfo!.serviceCharge,
                                        doctorDesignation: "Care Taker",
                                        doctorState: cancelled.caretaker!
                                            .caretakerInfo!.nationality,
                                        totalPatient: cancelled
                                            .caretaker!
                                            .caretakerInfo!
                                            .totalPatientsAttended,
                                        experience: cancelled.caretaker!
                                            .caretakerInfo!.yearOfExperiences,
                                        doctorName: cancelled.caretaker!
                                            .caretakerInfo!.firstName,
                                        imageUrl:
                                            '${data}${cancelled.caretaker!.profileImageUrl}',
                                        rating: "2",
                                      ));
                                },
                                action: "Reschedule",
                                actionIcon: EneftyIcons.refresh_outline,
                                appointmentDate: DateFormat('dd/MM/yyyy')
                                    .format(cancelled.appointmentDate!),
                                appointmentTime:
                                    "${cancelled.appointmentStartTime} - ${cancelled.appointmentEndTime}",
                                doctorName: cancelled
                                        .caretaker?.caretakerInfo?.firstName ??
                                    "Unknown",
                                doctorDesignation: cancelled
                                        .caretaker?.caretakerInfo?.location ??
                                    "Neurologist",
                                imageUrl:
                                    '${controller.appointmentStatus!.profilePath}${cancelled.caretaker?.profileImageUrl}',
                              ),
                            );
                          },
                        ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
