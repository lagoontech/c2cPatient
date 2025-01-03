import 'package:care2care/ReusableUtils_/AppColors.dart';
import 'package:care2care/ReusableUtils_/appBar.dart';
import 'package:care2care/ReusableUtils_/customButton.dart';
import 'package:care2care/ReusableUtils_/image_background.dart';
import 'package:care2care/Screens_/RatingScreen/rating_screen.dart';
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

  Future<void> _onRefresh() async {
    await controller.fetchAppointments();
  }

  bool isLoading = false;

  void showPatientDetailsDialog(
    BuildContext context,
    String name,
    String date,
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
                    Text("Date: $date"),
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
                padding: EdgeInsets.symmetric(
                    horizontal: 2.h,
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
                            controller.searchAppointments(completedOnly: true);
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
                                          controller.searchAppointments(completedOnly: true);
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
                child: GetBuilder<AppointmentStatusController>(builder: (v) {
                    if(controller.CompletedAppointment.isEmpty){
                      return Center(
                         child: Text("No Data Available "),
                      );
                    }
                  return ListView.builder(
                      itemCount: controller.searchedCompletedAppointment.isEmpty && controller.searchTEC.text.isEmpty && controller.displayDate==null
                          ? controller.CompletedAppointment.length
                          : controller.searchedCompletedAppointment.length,
                      itemBuilder: (context, index) {
                        StatusData completed;
                        if(controller.searchedCompletedAppointment.isNotEmpty){
                          completed = controller.searchedCompletedAppointment[index];
                        }else {
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
                                setState(() {
                                  isLoading = true;
                                });

                                try {
                                  await controller.loadGetHistory(
                                    appointmentId: completed.id,
                                    CaretakerId: completed.caretakerId,
                                  );
                                  if (controller.serviceHistory?.data != null) {
                                    final patientInfo = controller.serviceHistory!
                                        .data!.caretaker!.caretakerInfo;
                                    final detailsdata =
                                        controller.serviceHistory!.data;
                                    String? breakfast =
                                        detailsdata!.patientBreakfasttime;
                                    String? patientBreakfasttime =
                                        detailsdata.patientBreakfasttime;
                                    String? patientBreakfasttimeDetails =
                                        detailsdata.patientBreakfasttimeDetails;
                                    String? patientLunchtime =
                                        detailsdata.patientLunchtime;
                                    String? patientLunchtimeDetails =
                                        detailsdata.patientLunchtimeDetails;
                                    String? patientSnackstime =
                                        detailsdata.patientSnackstime;
                                    String? patientSnackstimeDetails =
                                        detailsdata.patientSnackstimeDetails;
                                    String? patientDinnertime =
                                        detailsdata.patientDinnertime;
                                    String? patientDinnertimeDetails =
                                        detailsdata.patientDinnertimeDetails;
                                    String? patientMedications =
                                        detailsdata.patientMedications;
                                    String? patientMedicationsDetails =
                                        detailsdata.patientMedicationsDetails;
                                    String? patientHydration =
                                        detailsdata.patientHydration;
                                    String? patientOralcare =
                                        detailsdata.patientOralcare;
                                    String? patientBathing =
                                        detailsdata.patientBathing;
                                    String? patientDressing =
                                        detailsdata.patientDressing;
                                    String? patientToileting =
                                        detailsdata.patientToileting;
                                    String? patientWalkingtime =
                                        detailsdata.patientWalkingtime;
                                    String? patientVitalsigns =
                                        detailsdata.patientVitalsigns;
                                    String? patientBloodsugar =
                                        detailsdata.patientBloodsugar;

                                    // Calling the dlialog function with all parameters
                                    showPatientDetailsDialog(
                                      context,
                                      patientInfo!.firstName!,
                                      DateFormat('dd MMM yyyy').format(controller
                                          .serviceHistory!
                                          .data!
                                          .appointment!
                                          .appointmentDate!),
                                      '${DateFormat('h:mm a').format(DateTime.parse('1970-01-01 ${completed.appointmentStartTime}'))} - ${DateFormat('h:mm a').format(DateTime.parse('1970-01-01 ${completed.appointmentEndTime!}'))}',
                                      '${controller.appointmentStatus!.profilePath}${completed.caretaker!.profileImageUrl}',
                                      completed.serviceStatus ?? '',
                                      breakfast,
                                      // Ensure this is provided
                                      patientBreakfasttime,
                                      patientBreakfasttimeDetails,
                                      patientLunchtime,
                                      patientLunchtimeDetails,
                                      patientSnackstime,
                                      patientSnackstimeDetails,
                                      patientDinnertime,
                                      patientDinnertimeDetails,
                                      patientMedications,
                                      patientMedicationsDetails,
                                      patientHydration,
                                      patientOralcare,
                                      patientBathing,
                                      patientDressing,
                                      patientToileting,
                                      patientWalkingtime,
                                      patientVitalsigns,
                                      patientBloodsugar,
                                    );
                                  }
                                } catch (e) {
                                  Get.snackbar(
                                      'Error', 'Failed to load patient history',
                                      snackPosition: SnackPosition.BOTTOM);
                                }
                                setState(() {
                                  isLoading = false;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.all(12.r),
                                decoration: BoxDecoration(
                                  //border: Border.all(color: Colors.red),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 9.0),
                                      child: CircleAvatar(
                                        radius: 34.r,
                                        backgroundImage: NetworkImage(
                                            '${v.appointmentStatus!.profilePath}${completed.caretaker!.profileImageUrl}'),
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
                                                  completed.caretaker!
                                                      .caretakerInfo!.firstName!,
                                                  style: TextStyle(
                                                    fontSize: 15.sp,
                                                    color: Colors.green[
                                                        700],
                                                    fontWeight: FontWeight.w600// Color for the value
                                                  ),
                                                ),

                                                Expanded(
                                                  child: Align(
                                                    alignment: Alignment.centerRight,
                                                    child: Text(
                                                      '${completed.serviceStatus.toString().capitalizeFirst}',
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

                                                Text(
                                                  DateFormat('dd-MM-yyyy').format(
                                                      DateTime.parse(completed
                                                          .appointmentDate
                                                          .toString())),
                                                  style: TextStyle(
                                                    fontSize: 12.sp,
                                                    color: Colors.grey.shade500, // Color for the value
                                                  ),
                                                ),
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
                                                  '${DateUtils().displayTime(completed.appointmentStartTime!)} - ${DateUtils().displayTime(completed.appointmentEndTime!)}',
                                                  style: TextStyle(
                                                    fontSize: 12.sp,
                                                    color: Colors.grey.shade500, // Color for the value
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
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [

                                                Align(
                                                  child: GestureDetector(
                                                    onTap: () async {
                                                      setState(() {
                                                        isLoading = true;
                                                      });

                                                      try {
                                                        await controller.loadGetHistory(
                                                          appointmentId: completed.id,
                                                          CaretakerId: completed.caretakerId,
                                                        );
                                                        if (controller.serviceHistory?.data != null) {
                                                          final patientInfo = controller.serviceHistory!
                                                              .data!.caretaker!.caretakerInfo;
                                                          final detailsdata =
                                                              controller.serviceHistory!.data;
                                                          String? breakfast =
                                                              detailsdata!.patientBreakfasttime;
                                                          String? patientBreakfasttime =
                                                              detailsdata.patientBreakfasttime;
                                                          String? patientBreakfasttimeDetails =
                                                              detailsdata.patientBreakfasttimeDetails;
                                                          String? patientLunchtime =
                                                              detailsdata.patientLunchtime;
                                                          String? patientLunchtimeDetails =
                                                              detailsdata.patientLunchtimeDetails;
                                                          String? patientSnackstime =
                                                              detailsdata.patientSnackstime;
                                                          String? patientSnackstimeDetails =
                                                              detailsdata.patientSnackstimeDetails;
                                                          String? patientDinnertime =
                                                              detailsdata.patientDinnertime;
                                                          String? patientDinnertimeDetails =
                                                              detailsdata.patientDinnertimeDetails;
                                                          String? patientMedications =
                                                              detailsdata.patientMedications;
                                                          String? patientMedicationsDetails =
                                                              detailsdata.patientMedicationsDetails;
                                                          String? patientHydration =
                                                              detailsdata.patientHydration;
                                                          String? patientOralcare =
                                                              detailsdata.patientOralcare;
                                                          String? patientBathing =
                                                              detailsdata.patientBathing;
                                                          String? patientDressing =
                                                              detailsdata.patientDressing;
                                                          String? patientToileting =
                                                              detailsdata.patientToileting;
                                                          String? patientWalkingtime =
                                                              detailsdata.patientWalkingtime;
                                                          String? patientVitalsigns =
                                                              detailsdata.patientVitalsigns;
                                                          String? patientBloodsugar =
                                                              detailsdata.patientBloodsugar;

                                                          // Calling the dlialog function with all parameters
                                                          showPatientDetailsDialog(
                                                            context,
                                                            patientInfo!.firstName!,
                                                            DateFormat('dd MMM yyyy').format(controller
                                                                .serviceHistory!
                                                                .data!
                                                                .appointment!
                                                                .appointmentDate!),
                                                            '${DateFormat('h:mm a').format(DateTime.parse('1970-01-01 ${completed.appointmentStartTime}'))} - ${DateFormat('h:mm a').format(DateTime.parse('1970-01-01 ${completed.appointmentEndTime!}'))}',
                                                            '${controller.appointmentStatus!.profilePath}${completed.caretaker!.profileImageUrl}',
                                                            completed.serviceStatus ?? '',
                                                            breakfast,
                                                            // Ensure this is provided
                                                            patientBreakfasttime,
                                                            patientBreakfasttimeDetails,
                                                            patientLunchtime,
                                                            patientLunchtimeDetails,
                                                            patientSnackstime,
                                                            patientSnackstimeDetails,
                                                            patientDinnertime,
                                                            patientDinnertimeDetails,
                                                            patientMedications,
                                                            patientMedicationsDetails,
                                                            patientHydration,
                                                            patientOralcare,
                                                            patientBathing,
                                                            patientDressing,
                                                            patientToileting,
                                                            patientWalkingtime,
                                                            patientVitalsigns,
                                                            patientBloodsugar,
                                                          );
                                                        }
                                                      } catch (e) {
                                                        Get.snackbar(
                                                            'Error', 'Failed to load patient history',
                                                            snackPosition: SnackPosition.BOTTOM);
                                                      }
                                                      setState(() {
                                                        isLoading = false;
                                                      });
                                                    },
                                                    child: Container(
                                                      width: 80.w,
                                                      height: 24.h,
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(8.r),
                                                          color: AppColors.secondaryColor,
                                                          boxShadow: [
                                                            BoxShadow(
                                                                offset: Offset(0,2),
                                                                color: Colors.black12
                                                            )
                                                          ]
                                                      ),
                                                      child: Center(
                                                          child: Text(
                                                            "View",
                                                            style: TextStyle(color: Colors.white),
                                                          )
                                                      ),
                                                    ),
                                                  ),
                                                ),

                                                SizedBox(width: 12.w),

                                                Align(
                                                  alignment: Alignment.centerRight,
                                                  child: GestureDetector(
                                                    onTap: (){
                                                      Get.to(()=> RatingScreen(
                                                        careTakerId: completed.caretakerId,
                                                        name: completed.caretaker!
                                                            .caretakerInfo!.firstName,
                                                        appointmentDate: DateFormat('dd-MM-yyyy').format(
                                                            DateTime.parse(completed
                                                                .appointmentDate
                                                                .toString())),
                                                        appointmentTime: '${completed.appointmentStartTime} - ${completed.appointmentEndTime}',
                                                      ));
                                                    },
                                                    child: Container(
                                                      width: 80.w,
                                                      height: 24.h,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(8.r),
                                                        color: AppColors.primaryColor,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            offset: Offset(0,2),
                                                            color: Colors.black12
                                                          )
                                                        ]
                                                      ),
                                                      child: Center(
                                                          child: Text(
                                                              "Rate",
                                                              style: TextStyle(color: Colors.white),
                                                          )
                                                      ),
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
      controller.searchAppointments(completedOnly: true);
    }

  }

}
