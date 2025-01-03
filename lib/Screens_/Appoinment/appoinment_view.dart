import 'package:care2care/ReusableUtils_/appBar.dart';
import 'package:care2care/ReusableUtils_/image_background.dart';
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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: CustomBackground(
        appBar: CustomAppBar(
          leading: SizedBox(),
          title: "Appointment",
          bottom: TabBar(
            onTap: (v){
              controller.currentTab = v;
              controller.searchAppointments();
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
              padding: EdgeInsets.symmetric(
                  horizontal: 10.h,
                  vertical: 2.h),
              child: Row(
                children: [

                  Expanded(
                    flex: 3,
                    child: SizedBox(
                      height: kToolbarHeight * 0.9,
                      child: customTextField(
                        context,
                        onChanged: (v){
                          controller.searchAppointments();
                        },
                        hint: "Search appointments",
                        controller: controller.searchTEC,
                        borderColor: AppColors.primaryColor,
                        labelText: "",
                        prefix: Icon(Icons.search),
                      ),
                    ),
                  ),

                  SizedBox(width: 12.w),

                  Expanded(
                    flex: 2,
                    child: GestureDetector(
                      onTap: (){
                        _selectDate(context);
                      },
                      child: Container(
                        height: kToolbarHeight * 0.9,
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.primaryColor),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            Icon(Icons.calendar_month),

                            SizedBox(width: 4.w),

                            GetBuilder<AppointmentStatusController>(
                              builder: (vc) {
                                return controller.selectedDate!=null
                                    ? Text(controller.displayDate.toString(),style: TextStyle(
                                  fontSize: 12.sp
                                ),)
                                    : Center(child: Text("Select a date",style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "verdana_regular"
                                ),));

                              }
                            ),

                            SizedBox(width: 2.w),

                            GetBuilder<AppointmentStatusController>(
                              builder: (vc) {
                                return controller.selectedDate!=null
                                    ? GestureDetector(
                                    onTap: (){
                                      controller.selectedDate = null;
                                      controller.displayDate = null;
                                      controller.update();
                                      controller.searchAppointments();
                                    },
                                    child: Icon(Icons.cancel_outlined)
                                )
                                    : SizedBox();
                              }
                            )

                          ],
                        ),
                      ),
                    ),
                  )

                ],
              ),
            ),

            Expanded(
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
                                itemCount: controller.searchedAppointments.isEmpty && controller.searchTEC.text.isEmpty && controller.displayDate==null
                                    ? controller.RequestAppointment.length
                                    : controller.searchedRequestAppointment.length,
                                itemBuilder: (context, index) {
                                  var requested ;

                                  if(controller.searchedRequestAppointment.isNotEmpty){
                                    requested = controller.searchedRequestAppointment[index];
                                  }
                                  else {
                                    requested =
                                    controller
                                        .RequestAppointment[index];
                                  }
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
                                            "${DateUtils().displayTime(requested.appointmentStartTime)} - ${DateUtils().displayTime(requested.appointmentEndTime)}",
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
                              SizedBox(height: 10.h), // Spacing belo
                              Expanded(
                                child: controller.isLoading
                                    ? Center(child: CircularProgressIndicator())
                                    : ListView.builder(
                                        padding: EdgeInsets.all(8.0),
                                        itemCount: controller.searchedAppointments.isEmpty && controller.searchTEC.text.isEmpty && controller.displayDate==null
                                            ? controller.ApprovedAppointment.length
                                            : controller.searchedAppointments.length,
                                        itemBuilder: (context, index) {
                                          var approved;
                                          if(controller.searchedAppointments.isNotEmpty){
                                            approved = controller.searchedAppointments[index];
                                          }
                                          else {
                                            approved =
                                            controller
                                                .ApprovedAppointment[index];
                                          }
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
                                                "${DateUtils().displayTime(approved.appointmentStartTime)} - ${DateUtils().displayTime(approved.appointmentEndTime)}",
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
                                itemCount: controller.searchedAppointments.isEmpty && controller.searchTEC.text.isEmpty && controller.displayDate==null
                                    ? controller.ProcessingAppointment.length
                                    : controller.searchedProcessingAppointment.length,
                                itemBuilder: (context, index) {
                                  var cancelled;
                                  if(controller.searchedProcessingAppointment.isNotEmpty){
                                    cancelled = controller.searchedProcessingAppointment[index];
                                  }else
                                    cancelled = controller.ProcessingAppointment[index];
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
                                      "${DateUtils().displayTime(cancelled.appointmentStartTime)} - ${DateUtils().displayTime(cancelled.appointmentEndTime)}",
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
              onSurface: Colors.black
            ),
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

    if(date!=null){
      controller.selectedDate = date;
      controller.displayDate = DateUtils().dateOnlyFormat(date);
      controller.update();
      controller.searchAppointments();
    }

  }



}
