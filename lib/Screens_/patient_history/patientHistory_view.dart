import 'package:care2care/ReusableUtils_/AppColors.dart';
import 'package:care2care/ReusableUtils_/appBar.dart';
import 'package:care2care/ReusableUtils_/image_background.dart';
import 'package:care2care/Screens_/RatingScreen/rating_screen.dart';
import 'package:care2care/Screens_/patient_history/completed_appointment_details.dart';
import 'package:flutter/material.dart' hide DateUtils;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../ReusableUtils_/custom_textfield.dart';
import '../../Utils/date_utils.dart';
import '../Appoinment/controller/appointmentsStatus_Controller.dart';
import '../Appoinment/modal/AppointmentStatus_Modal.dart';

class PatientHistoryView extends StatefulWidget {
  PatientHistoryView({super.key});

  @override
  State<PatientHistoryView> createState() => _PatientHistoryViewState();
}

class _PatientHistoryViewState extends State<PatientHistoryView> {
  AppointmentStatusController controller =
      Get.put(AppointmentStatusController());
  final TextEditingController dateTEC = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (controller.displayDate != null) {
      dateTEC.text = controller.displayDate!;
    }
  }

  Future<void> _onRefresh() async {
    await controller.fetchAppointments();
  }

  bool isLoading = false;

  void showPatientDetailsDialog(
    BuildContext context,
    String name,
    String time,
    String imgUrl,
    String status,
    String? breakfast,
    String? patientBreakfasttime,
    String? patientBreakfasttimeDetails,
    String? patientLunchtime,
    String? patientLunchtimeDetails,
    String? patientSnackstime,
    String? patientSnackstimeDetails,
    String? patientDinnertime,
    String? patientDinnertimeDetails,
    String? patientMedications,
    String? patientMedicationsDetails,
    String? patientHydration,
    String? patientOralcare,
    String? patientBathing,
    String? patientDressing,
    String? patientToileting,
    String? patientWalkingtime,
    String? patientVitalsigns,
    String? patientBloodsugar,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text("Service History")),
          content: SingleChildScrollView(
            child: Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Patient Information
                    const SizedBox(height: 8),
                    Text(
                      "Caretaker: $name",
                      style: TextStyle(fontSize: 18.sp),
                    ),
                    Text("Time: $time"),
                    Text(
                        "Status: ${status[0].toUpperCase()}${status.substring(1)}"),
                    const SizedBox(height: 8),

                    // Service Given Title
                    Text(
                      "Service Given",
                      style: TextStyle(
                          fontSize: 15.sp, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),

                    // Breakfast Details
                    if (breakfast != null) Text("Breakfast: $breakfast"),
                    if (patientBreakfasttime != null)
                      Text("Breakfast Time: $patientBreakfasttime"),
                    if (patientBreakfasttimeDetails != null)
                      Text("Breakfast Details: $patientBreakfasttimeDetails"),

                    // Lunch Details
                    if (patientLunchtime != null)
                      Text("Lunch Time: $patientLunchtime"),
                    if (patientLunchtimeDetails != null)
                      Text("Lunch Details: $patientLunchtimeDetails"),

                    // Snack Details
                    if (patientSnackstime != null)
                      Text("Snacks Time: $patientSnackstime"),
                    if (patientSnackstimeDetails != null)
                      Text("Snacks Details: $patientSnackstimeDetails"),

                    // Dinner Details
                    if (patientDinnertime != null)
                      Text("Dinner Time: $patientDinnertime"),
                    if (patientDinnertimeDetails != null)
                      Text("Dinner Details: $patientDinnertimeDetails"),

                    // Medications Details
                    if (patientMedications != null)
                      Text("Medications: $patientMedications"),
                    if (patientMedicationsDetails != null)
                      Text("Medications Details: $patientMedicationsDetails"),

                    // Hydration & Care Details
                    if (patientHydration != null)
                      Text("Hydration: $patientHydration"),
                    if (patientOralcare != null)
                      Text("Oral Care: $patientOralcare"),
                    if (patientBathing != null)
                      Text("Bathing: $patientBathing"),
                    if (patientDressing != null)
                      Text("Dressing: $patientDressing"),
                    if (patientToileting != null)
                      Text("Toileting: $patientToileting"),

                    // Patient Activity and Vital Details
                    if (patientWalkingtime != null)
                      Text("Walking Time: $patientWalkingtime"),
                    if (patientVitalsigns != null)
                      Text("Vital Signs: $patientVitalsigns"),
                    if (patientBloodsugar != null)
                      Text("Blood Sugar: $patientBloodsugar"),
                  ],
                ),
                if (isLoading)
                  Center(
                    child: CircularProgressIndicator(),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomBackground(
      appBar: CustomAppBar(
        title: 'My History',
      ),
      child: Padding(
        padding: EdgeInsets.all(8.r),
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.h, vertical: 2.h),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: SizedBox(
                        height: 56.h,
                        child: customTextField(
                          context,
                          onChanged: (v) {
                            controller.searchAppointments(completedOnly: true);
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
                                        controller.searchAppointments(
                                            completedOnly: true);
                                      },
                                      child: Icon(Icons.cancel_outlined),
                                    )
                                  : SizedBox(width: 20.h, height: 20.h),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: GetBuilder<AppointmentStatusController>(builder: (v) {
                  if (controller.CompletedAppointment.isEmpty) {
                    return Center(
                      child: Text("No Data Available "),
                    );
                  }
                  return ListView.builder(
                      itemCount:
                          controller.searchedCompletedAppointment.isEmpty &&
                                  controller.searchTEC.text.isEmpty &&
                                  controller.displayDate == null
                              ? controller.CompletedAppointment.length
                              : controller.searchedCompletedAppointment.length,
                      itemBuilder: (context, index) {
                        StatusData completed;
                        if (controller
                            .searchedCompletedAppointment.isNotEmpty) {
                          completed =
                              controller.searchedCompletedAppointment[index];
                        } else {
                          completed = controller.CompletedAppointment[index];
                        }
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3.0),
                          child: Card(
                            color: Colors.white,
                            surfaceTintColor: Colors.white,
                            elevation: 2,
                            child: InkWell(
                              onTap: () async {
                                print(completed.appointmentId);
                                Get.to(() => CompletedAppointmentDetails(
                                      patientId: completed.patientId,
                                      appointmentId: completed.id,
                                      appointmentDates:
                                          completed.appointmentDates ??
                                              [DateTime.now()],
                                      caretakerId: completed.caretakerId,
                                    ));
                              },
                              child: Container(
                                padding: EdgeInsets.all(12.r),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 9.0),
                                      child: CircleAvatar(
                                        radius: 34.r,
                                        backgroundImage: (v.appointmentStatus
                                                        ?.profilePath !=
                                                    null &&
                                                completed.caretaker
                                                        ?.profileImageUrl !=
                                                    null)
                                            ? NetworkImage(
                                                '${v.appointmentStatus?.profilePath ?? ""}${completed.caretaker?.profileImageUrl ?? ""}')
                                            : null,
                                        child:
                                            (v.appointmentStatus?.profilePath ==
                                                        null ||
                                                    completed.caretaker
                                                            ?.profileImageUrl ==
                                                        null)
                                                ? Icon(Icons.person, size: 34.r)
                                                : null,
                                      ),
                                    ),
                                    SizedBox(width: 12.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 2.h),
                                            child: Row(
                                              children: [
                                                Text(
                                                  completed
                                                          .caretaker
                                                          ?.caretakerInfo
                                                          ?.firstName ??
                                                      'Caretaker',
                                                  style: TextStyle(
                                                      fontSize: 15.sp,
                                                      color: Colors.green[700],
                                                      fontWeight: FontWeight
                                                          .w600 // Color for the value
                                                      ),
                                                ),
                                                Expanded(
                                                  child: Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: Text(
                                                      '${completed.serviceStatus?.capitalizeFirst ?? ''}',
                                                      style: TextStyle(
                                                        fontSize: 14.sp,
                                                        color: Colors.green[
                                                            700], // Color for the value
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          // Appointment Date
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 4.h),
                                            child: Row(
                                              children: [
                                                if (completed
                                                            .appointmentDates !=
                                                        null &&
                                                    completed.appointmentDates!
                                                        .isNotEmpty) ...[
                                                  Text(
                                                    DateFormat('MMM dd').format(
                                                        completed
                                                            .appointmentDates![0]),
                                                    style: TextStyle(
                                                      fontSize: 12.sp,
                                                      color: Colors.grey
                                                          .shade500, // Color for the value
                                                    ),
                                                  ),
                                                  if (completed
                                                          .appointmentDates!
                                                          .length >
                                                      1)
                                                    Text(
                                                      " To " +
                                                          DateFormat('MMM dd')
                                                              .format(completed
                                                                  .appointmentDates!
                                                                  .last),
                                                      style: TextStyle(
                                                        fontSize: 12.sp,
                                                        color: Colors.grey
                                                            .shade500, // Color for the value
                                                      ),
                                                    ),
                                                ],
                                              ],
                                            ),
                                          ),
                                          // Appointment Time
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 2.h),
                                            child: Row(
                                              children: [
                                                Text(
                                                  (completed.appointmentStartTime !=
                                                              null &&
                                                          completed
                                                                  .appointmentEndTime !=
                                                              null)
                                                      ? '${DateUtils().displayTime(completed.appointmentStartTime!)} - ${DateUtils().displayTime(completed.appointmentEndTime!)}'
                                                      : '',
                                                  style: TextStyle(
                                                    fontSize: 12.sp,
                                                    color: Colors.grey
                                                        .shade500, // Color for the value
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // Appointment Status

                                          SizedBox(height: 4.h),

                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 1.h),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Align(
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      Get.to(() =>
                                                          CompletedAppointmentDetails(
                                                            patientId: completed
                                                                .patientId,
                                                            appointmentId:
                                                                completed.id,
                                                            appointmentDates:
                                                                completed
                                                                        .appointmentDates ??
                                                                    [
                                                                      DateTime
                                                                          .now()
                                                                    ],
                                                            caretakerId:
                                                                completed
                                                                    .caretakerId,
                                                          ));
                                                    },
                                                    child: Container(
                                                      width: 80.w,
                                                      height: 24.h,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.r),
                                                          color: AppColors
                                                              .secondaryColor,
                                                          boxShadow: [
                                                            BoxShadow(
                                                                offset: Offset(
                                                                    0, 2),
                                                                color: Colors
                                                                    .black12)
                                                          ]),
                                                      child: Center(
                                                          child: Text(
                                                        "View",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      )),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 12.w),
                                                Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      Get.to(() => RatingScreen(
                                                            careTakerId:
                                                                completed
                                                                    .caretakerId,
                                                            name: completed
                                                                    .caretaker
                                                                    ?.caretakerInfo
                                                                    ?.firstName ??
                                                                'Caretaker',
                                                            imageUrl: (v.appointmentStatus
                                                                            ?.profilePath !=
                                                                        null &&
                                                                    completed
                                                                            .caretaker
                                                                            ?.profileImageUrl !=
                                                                        null)
                                                                ? '${v.appointmentStatus?.profilePath ?? ""}${completed.caretaker?.profileImageUrl ?? ""}'
                                                                : '',
                                                            appointmentDates:
                                                                completed
                                                                        .appointmentDates ??
                                                                    [
                                                                      DateTime
                                                                          .now()
                                                                    ],
                                                            appointmentTime: (completed
                                                                            .appointmentStartTime !=
                                                                        null &&
                                                                    completed
                                                                            .appointmentEndTime !=
                                                                        null)
                                                                ? '${DateUtils().displayTime(completed.appointmentStartTime!)} - ${DateUtils().displayTime(completed.appointmentEndTime!)}'
                                                                : 'N/A',
                                                          ));
                                                    },
                                                    child: Container(
                                                      width: 80.w,
                                                      height: 24.h,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.r),
                                                          color: AppColors
                                                              .primaryColor,
                                                          boxShadow: [
                                                            BoxShadow(
                                                                offset: Offset(
                                                                    0, 2),
                                                                color: Colors
                                                                    .black12)
                                                          ]),
                                                      child: Center(
                                                          child: Text(
                                                        "Rate",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      )),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          // Video Call Statu
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      });
                }),
              ),
            ],
          ),
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
      controller.searchAppointments(completedOnly: true);
    }
  }
}
