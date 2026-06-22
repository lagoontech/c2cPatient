import 'package:care2care/ReusableUtils_/appBar.dart';
import 'package:care2care/ReusableUtils_/image_background.dart';
import 'package:care2care/Screens_/patient_history/completed_appointment_details.dart';
import 'package:care2care/Utils/date_utils.dart';
import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart' hide DateUtils;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../ReusableUtils_/AppColors.dart';
import '../../ReusableUtils_/Custom_AppoinMents.dart';
import '../../ReusableUtils_/custom_textfield.dart';
import '../CareTakerInformation/CareTaker_information.dart';
import 'appointment_approved_details.dart';
import 'appointment_request_detiled.dart';
import 'controller/appointmentsStatus_Controller.dart';

class AppointmentView extends StatelessWidget {
  AppointmentView({super.key});

  final AppointmentStatusController controller =
      Get.put(AppointmentStatusController());
  final TextEditingController dateTEC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    dateTEC.text = controller.displayDate ?? '';
    return DefaultTabController(
      length: 3,
      child: CustomBackground(
        appBar: CustomAppBar(
          leading: SizedBox(),
          title: "Appointment",
          bottom: TabBar(
            onTap: (v) {
              controller.currentTab = v;
              if (controller.searchTEC.text.isNotEmpty ||
                  controller.selectedDate != null)
                controller.searchAppointments();
              else {
                controller.fetchAppointments();
              }
            },
            tabs: [
              Tab(text: "Requested"),
              Tab(text: "Approved"),
              Tab(text: "Processing"),
            ],
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 8.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 2.h),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      height: 56.h,
                      child: customTextField(
                        context,
                        onChanged: (v) {
                          controller.searchAppointments();
                        },
                        hint: "Appointments",
                        controller: controller.searchTEC,
                        borderColor: AppColors.primaryColor,
                        labelText: "",
                        prefix: Icon(Icons.search),
                        height: 56.h,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    flex: 2,
                    child: GetBuilder<AppointmentStatusController>(
                      builder: (vc) {
                        return SizedBox(
                          height: 56.h,
                          child: customTextField(
                            context,
                            readOnly: true,
                            onTap: () {
                              _selectDate(context);
                            },
                            hint: "Select a date",
                            controller: dateTEC,
                            borderColor: AppColors.primaryColor,
                            labelText: "",
                            prefix: Icon(Icons.calendar_month),
                            height: 56.h,
                            suffix: controller.selectedDate != null
                                ? GestureDetector(
                                    onTap: () {
                                      controller.selectedDate = null;
                                      controller.displayDate = null;
                                      dateTEC.clear();
                                      controller.update();
                                      controller.searchAppointments();
                                    },
                                    child: Icon(Icons.cancel_outlined),
                                  )
                                : SizedBox(width: 20.h, height: 20.h),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // Requested Tab
                  GetBuilder<AppointmentStatusController>(
                    builder: (controller) {
                      return RefreshIndicator(
                        onRefresh: () async {
                          await controller.refreshAppointments();
                        },
                        child: Column(
                          children: [
                            _buildInfoCard(
                              context,
                              text: "These appointments are pending caretaker confirmation. You'll be notified once a caretaker accepts or declines.",
                              icon: Icons.hourglass_empty_rounded,
                              iconColor: Colors.orange.shade700,
                              backgroundColor: Colors.orange.shade50,
                            ),
                            Expanded(
                              child: controller.isLoading
                                  ? Center(child: CircularProgressIndicator())
                                  : controller.RequestAppointment.isNotEmpty
                                      ? ListView.builder(
                                          padding: EdgeInsets.all(8.0),
                                          itemCount: controller
                                                      .searchedRequestAppointment.isEmpty &&
                                                  controller.searchTEC.text.isEmpty &&
                                                  controller.displayDate == null
                                              ? controller.RequestAppointment.length
                                              : controller
                                                  .searchedRequestAppointment.length,
                                          itemBuilder: (context, index) {
                                            final useSearched = controller
                                                    .searchedRequestAppointment
                                                    .isNotEmpty ||
                                                controller.searchTEC.text.isNotEmpty ||
                                                controller.displayDate != null;
                                            final requested = useSearched
                                                ? controller
                                                    .searchedRequestAppointment[index]
                                                : controller
                                                    .RequestAppointment[index];
                                            return Padding(
                                              padding:
                                                  EdgeInsets.symmetric(vertical: 3.h),
                                              child: InkWell(
                                                onTap: () {
                                                  Get.to(() => RequestDetailsScreen2(
                                                        careTakerId:
                                                            requested.caretakerId,
                                                        appointmentId: requested.id,
                                                        serviceCharge: requested
                                                            .caretaker
                                                            ?.caretakerInfo
                                                            ?.serviceCharge,
                                                        paymentStatus:
                                                            requested.paymentStatus,
                                                        imgUrl: (controller.appointmentStatus?.profilePath != null && requested.caretaker?.profileImageUrl != null)
                                                            ? '${controller.appointmentStatus!.profilePath}${requested.caretaker!.profileImageUrl}'
                                                            : '',
                                                        name: requested.caretaker?.caretakerInfo?.firstName ?? 'Unknown Caretaker',
                                                        dates: requested
                                                            .appointmentDates,
                                                        status:
                                                            requested.serviceStatus,
                                                        time:
                                                            "${requested.appointmentStartTime ?? 'N/A'} - ${requested.appointmentEndTime ?? 'N/A'}",
                                                      ));
                                                },
                                                child: AppointmentsContainer(
                                                  action: '',
                                                  appointmentDates:
                                                      requested.appointmentDates,
                                                  appointmentTime:
                                                      "${DateUtils().displayTime(requested.appointmentStartTime)} - ${DateUtils().displayTime(requested.appointmentEndTime)}",
                                                  doctorName: requested
                                                          .caretaker
                                                          ?.caretakerInfo
                                                          ?.firstName ??
                                                      "Unknown",
                                                  doctorDesignation: requested
                                                          .caretaker
                                                          ?.caretakerInfo
                                                          ?.location ??
                                                      "Neurologist",
                                                   imageUrl: (controller.appointmentStatus?.profilePath != null && requested.caretaker?.profileImageUrl != null)
                                                       ? '${controller.appointmentStatus!.profilePath}${requested.caretaker!.profileImageUrl}'
                                                       : '',
                                                ),
                                              ),
                                            );
                                          },
                                        )
                                      : SingleChildScrollView(
                                          physics: const AlwaysScrollableScrollPhysics(),
                                          child: SizedBox(
                                            height: 300.h,
                                            child: const Center(
                                              child: Text("No requests to show"),
                                            ),
                                          ),
                                        ),
                            ),
                          ],
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
                            _buildInfoCard(
                              context,
                              text: "These appointments have been accepted. Please proceed with payment or scheduling to activate the care service.",
                              icon: Icons.check_circle_outline_rounded,
                              iconColor: Colors.green.shade700,
                              backgroundColor: Colors.green.shade50,
                            ),
                            Expanded(
                              child: controller.isLoading
                                  ? Center(child: CircularProgressIndicator())
                                  : controller.ApprovedAppointment.isNotEmpty
                                      ? ListView.builder(
                                          padding: EdgeInsets.all(8.0),
                                          itemCount: controller
                                                      .searchedAppointments
                                                      .isEmpty &&
                                                  controller.searchTEC.text
                                                      .isEmpty &&
                                                  controller.displayDate ==
                                                      null
                                              ? controller
                                                  .ApprovedAppointment.length
                                              : controller
                                                  .searchedAppointments
                                                  .length,
                                          itemBuilder: (context, index) {
                                            final useSearched = controller
                                                    .searchedAppointments
                                                    .isNotEmpty ||
                                                controller.searchTEC.text.isNotEmpty ||
                                                controller.displayDate != null;
                                            final approved = useSearched
                                                ? controller.searchedAppointments[index]
                                                : controller.ApprovedAppointment[index];
                                            return Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 3.h),
                                              child: InkWell(
                                                onTap: () {
                                                  Get.to(
                                                    () => ApprovedDetailScreen(
                                                      fromTime: approved
                                                          .appointmentStartTime,
                                                      Totime: approved
                                                          .appointmentEndTime,
                                                      serviceCharge: approved
                                                          .caretaker
                                                          ?.caretakerInfo
                                                          ?.serviceCharge,
                                                      appointmentId:
                                                          approved.id,
                                                      careTakerId: approved
                                                          .caretakerId,
                                                      paymentStatus: approved
                                                          .paymentStatus,
                                                      imgUrl: (controller.appointmentStatus?.profilePath != null && approved.caretaker?.profileImageUrl != null)
                                                          ? '${controller.appointmentStatus!.profilePath}${approved.caretaker!.profileImageUrl}'
                                                          : '',
                                                      name: approved.caretaker?.caretakerInfo != null
                                                          ? '${approved.caretaker!.caretakerInfo!.firstName ?? ''} ${approved.caretaker!.caretakerInfo!.lastName ?? ''}'
                                                          : 'Unknown Caretaker',
                                                      dates: approved
                                                          .appointmentDates,
                                                      status: approved
                                                          .serviceStatus,
                                                      time: (approved.appointmentStartTime != null && approved.appointmentEndTime != null)
                                                          ? (() {
                                                              try {
                                                                return "From ${DateFormat('h:mm a').format(DateTime.parse('1970-01-01 ${approved.appointmentStartTime}'))} - To ${DateFormat('h:mm a').format(DateTime.parse('1970-01-01 ${approved.appointmentEndTime}'))}";
                                                              } catch (e) {
                                                                return "From ${approved.appointmentStartTime} - To ${approved.appointmentEndTime}";
                                                              }
                                                            })()
                                                          : "N/A",
                                                    ),
                                                  );
                                                },
                                                child: AppointmentsContainer(
                                                  statusColor: Colors.green,
                                                  appointmentDates: approved
                                                      .appointmentDates,
                                                  appointmentTime:
                                                      "${DateUtils().displayTime(approved.appointmentStartTime)} - ${DateUtils().displayTime(approved.appointmentEndTime)}",
                                                  doctorName: approved
                                                          .caretaker
                                                          ?.caretakerInfo
                                                          ?.firstName ??
                                                      "Unknown",
                                                  doctorDesignation: approved
                                                          .caretaker
                                                          ?.caretakerInfo
                                                          ?.location ??
                                                      "Neurologist",
                                                  imageUrl:
                                                      '${controller.appointmentStatus?.profilePath ?? ""}${approved.caretaker?.profileImageUrl ?? ""}',
                                                ),
                                              ),
                                            );
                                          },
                                        )
                                      : SingleChildScrollView(
                                          physics: const AlwaysScrollableScrollPhysics(),
                                          child: SizedBox(
                                            height: 300.h,
                                            child: const Center(
                                              child: Text("No requests to show"),
                                            ),
                                          ),
                                        ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  // Processing Tab
                  GetBuilder<AppointmentStatusController>(
                    builder: (controller) {
                      return RefreshIndicator(
                        onRefresh: () async {
                          await controller.refreshAppointments();
                        },
                        child: Column(
                          children: [
                            _buildInfoCard(
                              context,
                              text: "These sessions are currently active or ongoing. Select an appointment to view the caretaker's daily service report.",
                              icon: Icons.sync_rounded,
                              iconColor: AppColors.primaryColor,
                              backgroundColor: AppColors.primaryColor.withOpacity(0.08),
                            ),
                            Expanded(
                              child: controller.isLoading
                                  ? Center(child: CircularProgressIndicator())
                                  : controller.ProcessingAppointment.isNotEmpty
                                      ? ListView.builder(
                                          padding: EdgeInsets.all(8.0),
                                          itemCount: controller
                                                      .searchedProcessingAppointment.isEmpty &&
                                                  controller.searchTEC.text.isEmpty &&
                                                  controller.displayDate == null
                                              ? controller
                                                  .ProcessingAppointment.length
                                              : controller
                                                  .searchedProcessingAppointment
                                                  .length,
                                          itemBuilder: (context, index) {
                                            final useSearched = controller
                                                    .searchedProcessingAppointment
                                                    .isNotEmpty ||
                                                controller.searchTEC.text.isNotEmpty ||
                                                controller.displayDate != null;
                                            final cancelled = useSearched
                                                ? controller.searchedProcessingAppointment[index]
                                                : controller.ProcessingAppointment[index];
                                            var data = controller
                                                .appointmentStatus?.profilePath ?? '';

                                            return Padding(
                                              padding:
                                                  EdgeInsets.symmetric(vertical: 3.h),
                                              child: GestureDetector(
                                                onTap: () {
                                                  Get.to(() =>
                                                      CompletedAppointmentDetails(
                                                        caretakerId:
                                                            cancelled.caretakerId,
                                                        appointmentId: cancelled.id,
                                                        patientId:
                                                            cancelled.patientId,
                                                        appointmentDates: cancelled
                                                            .appointmentDates,
                                                      ));
                                                },
                                                child: AppointmentsContainer(
                                                  actionTap: () {
                                                    Get.to(() => CaretakerInformation(
                                                          careTakerId:
                                                              cancelled.caretakerId,
                                                          gender: cancelled.caretaker
                                                              ?.caretakerInfo?.sex ?? 'N/A',
                                                          charge: cancelled
                                                              .caretaker
                                                              ?.caretakerInfo
                                                              ?.serviceCharge ?? 'N/A',
                                                          doctorDesignation:
                                                              "Care Taker",
                                                          doctorState: cancelled
                                                              .caretaker
                                                              ?.caretakerInfo
                                                              ?.nationality ?? 'N/A',
                                                          totalPatient: cancelled
                                                              .caretaker
                                                              ?.caretakerInfo
                                                              ?.totalPatientsAttended ?? 'N/A',
                                                          experience: cancelled
                                                              .caretaker
                                                              ?.caretakerInfo
                                                              ?.yearOfExperiences ?? 'N/A',
                                                          doctorName: cancelled
                                                              .caretaker
                                                              ?.caretakerInfo
                                                              ?.firstName ?? 'N/A',
                                                          imageUrl:
                                                              '${data}${cancelled.caretaker?.profileImageUrl ?? ""}',
                                                          rating: "2",
                                                        ));
                                                  },
                                                  action: "Reschedule",
                                                  actionIcon:
                                                      EneftyIcons.refresh_outline,
                                                  appointmentDates:
                                                      cancelled.appointmentDates,
                                                  appointmentTime:
                                                      "${DateUtils().displayTime(cancelled.appointmentStartTime)} - ${DateUtils().displayTime(cancelled.appointmentEndTime)}",
                                                  doctorName: cancelled
                                                          .caretaker
                                                          ?.caretakerInfo
                                                          ?.firstName ??
                                                      "Unknown",
                                                  doctorDesignation: cancelled
                                                          .caretaker
                                                          ?.caretakerInfo
                                                          ?.location ??
                                                      "Neurologist",
                                                  imageUrl:
                                                      '${controller.appointmentStatus?.profilePath ?? ""}${cancelled.caretaker?.profileImageUrl ?? ""}',
                                                ),
                                              ),
                                            );
                                          },
                                        )
                                      : SingleChildScrollView(
                                          physics: const AlwaysScrollableScrollPhysics(),
                                          child: SizedBox(
                                            height: 300.h,
                                            child: Center(
                                              child: EmptyStateWidget(
                                                title: "No ongoing sessions",
                                                description: "Active and in-progress service appointments will appear here.",
                                                icon: Icons.hourglass_empty_rounded,
                                              ),
                                            ),
                                          ),
                                        ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required String text,
    required IconData icon,
    required Color iconColor,
    required Color backgroundColor,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: iconColor.withOpacity(0.15), width: 1),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: iconColor, size: 18.r),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 11.5.sp,
                  color: Colors.black87,
                  height: 1.4,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //
  Future<void> _selectDate(BuildContext context) async {
    var date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
                primary: Colors.purple,
                onPrimary: Colors.white,
                onSurface: Colors.black),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.purple,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      controller.selectedDate = date;
      controller.displayDate = DateUtils().dateOnlyFormat(date);
      dateTEC.text = controller.displayDate ?? '';
      controller.update();
      controller.searchAppointments();
    }
  }
}

class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;

  const EmptyStateWidget({
    Key? key,
    required this.title,
    required this.description,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(20.r),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 64.r,
                color: AppColors.primaryColor,
              ),
            ),
            SizedBox(height: 18.h),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.grey.shade600,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
