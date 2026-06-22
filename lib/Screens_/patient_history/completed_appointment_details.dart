import 'package:care2care/Screens_/patient_history/vitals_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../ReusableUtils_/AppColors.dart';
import '../../ReusableUtils_/appBar.dart';
import '../../ReusableUtils_/image_background.dart';
import 'Controller/completed_appointment_details_controller.dart';

class CompletedAppointmentDetails extends StatelessWidget {
  CompletedAppointmentDetails(
      {super.key,
      this.appointmentDates,
      this.appointmentId,
      this.patientId,
      this.caretakerId});

  List<DateTime>? appointmentDates;
  int? appointmentId;
  int? patientId;
  int? caretakerId;

  CompletedAppointmentDetailsController sc =
      Get.put(CompletedAppointmentDetailsController());

  String _buildDateRange(List<DateTime> dates) {
    if (dates.isEmpty) return 'No dates available';
    if (dates.length == 1) {
      return DateFormat("MMM dd, yyyy").format(dates.first);
    } else {
      final sorted = List<DateTime>.from(dates)..sort();
      return "${DateFormat("MMM dd").format(sorted.first)} to ${DateFormat("MMM dd, yyyy").format(sorted.last)}";
    }
  }

  @override
  Widget build(BuildContext context) {
    final dates = appointmentDates ?? [];
    if (sc.patientSchedules == null) {
      sc.selectedDate = dates.isNotEmpty ? dates[0] : DateTime.now();
      sc.caretakerId = caretakerId;
      sc.loadGetHistory(patientId: patientId, appointmentId: appointmentId);
    }

    return Material(
      child: Stack(
        children: [
          CustomBackground(
            appBar: CustomAppBar(
              leading: IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.arrow_back_ios)),
              title: "Service Report",
              actions: const [],
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(12.w),
                child: GetBuilder<CompletedAppointmentDetailsController>(
                  builder: (v) {
                    return v.loadingServiceHistory
                        ? Center(
                            child: CircularProgressIndicator(
                                color: AppColors.primaryColor))
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Card(
                                elevation: 1,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.r)),
                                child: Padding(
                                  padding: EdgeInsets.all(12.w),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Appointment Dates",
                                              style: TextStyle(
                                                color: Colors.grey.shade600,
                                                fontSize: 11.sp,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              _buildDateRange(dates),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13.sp,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 8.w),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8.w, vertical: 2.h),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: AppColors.primaryColor
                                                  .withOpacity(0.3)),
                                          borderRadius:
                                              BorderRadius.circular(8.r),
                                        ),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<DateTime>(
                                            value: sc.selectedDate,
                                            icon: Icon(Icons.arrow_drop_down,
                                                color: AppColors.primaryColor,
                                                size: 20.r),
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12.sp,
                                              color: Colors.black,
                                            ),
                                            onChanged: (DateTime? newValue) {
                                              if (newValue != null) {
                                                sc.selectedDate = newValue;
                                                sc.loadGetHistory(
                                                    appointmentId:
                                                        appointmentId,
                                                    patientId: patientId);
                                              }
                                            },
                                            items: dates.map<
                                                    DropdownMenuItem<DateTime>>(
                                                (DateTime date) {
                                              return DropdownMenuItem<DateTime>(
                                                value: date,
                                                child: Text(DateFormat("MMM dd")
                                                    .format(date)),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              SizedBox(height: 12.h),

                              // Vital Signs Section
                              v.noDataYet
                                  ? SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.6,
                                      child: Center(
                                        child: Text(
                                          "Report yet to be updated",
                                          style: TextStyle(fontSize: 14.sp),
                                        ),
                                      ),
                                    )
                                  : Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            _buildSectionHeader(
                                                "Baseline Vital Signs"),
                                            GestureDetector(
                                              onTap: () {
                                                Get.to(() => VitalsView());
                                                sc.getVitals();
                                              },
                                              child: Text("View in detail",
                                                  style: TextStyle(
                                                    color:
                                                        AppColors.primaryColor,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 12.sp,
                                                  )),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 6.h),
                                        Card(
                                          elevation: 1,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12.r)),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 12.h,
                                                horizontal: 8.w),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                _buildVitalInfo(
                                                    Icons.thermostat,
                                                    "Temp",
                                                    "${sc.temp.text}°F",
                                                    Colors.orange),
                                                _buildVitalInfo(
                                                    Icons.favorite,
                                                    "Pulse",
                                                    "${sc.heartRate.text} bpm",
                                                    Colors.red),
                                                _buildVitalInfo(
                                                    Icons.air,
                                                    "Resp",
                                                    sc.respiration.text,
                                                    Colors.blue),
                                                _buildVitalInfo(
                                                    Icons.speed,
                                                    "BP",
                                                    sc.bp.text,
                                                    Colors.green),
                                              ],
                                            ),
                                          ),
                                        ),

                                        SizedBox(height: 12.h),

                                        // Blood Sugar Section
                                        _buildSectionHeader("Blood Sugar"),
                                        SizedBox(height: 6.h),
                                        Card(
                                          elevation: 1,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12.r)),
                                          child: Padding(
                                            padding: EdgeInsets.all(12.w),
                                            child: Row(
                                              children: [
                                                const Icon(Icons.bloodtype,
                                                    color: Colors.red),
                                                const SizedBox(width: 10),
                                                Text(
                                                  "${sc.bloodSugarTEC.text} mg/dL",
                                                  style: TextStyle(
                                                    fontSize: 13.sp,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                        SizedBox(height: 12.h),

                                        // Food and Nutrition Section
                                        _buildSectionHeader(
                                            "Food and Nutrition"),
                                        SizedBox(height: 6.h),
                                        Card(
                                          elevation: 1,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12.r)),
                                          child: Padding(
                                            padding: EdgeInsets.all(12.w),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                _buildMealRow(
                                                    "Breakfast",
                                                    sc.filters.isNotEmpty
                                                        ? sc.filters.first
                                                        : _formatTime(sc
                                                            .patientSchedules
                                                            ?.patientBreakfasttime),
                                                    sc.breakfastField.text),
                                                const Divider(),
                                                _buildMealRow(
                                                    "Lunch",
                                                    sc.lunchFilters.isNotEmpty
                                                        ? sc.lunchFilters.first
                                                        : _formatTime(sc
                                                            .patientSchedules
                                                            ?.patientLunchtime),
                                                    sc.lunchField.text),
                                                const Divider(),
                                                _buildMealRow(
                                                    "Snacks",
                                                    sc.snacks.isNotEmpty
                                                        ? sc.snacks.first
                                                        : _formatTime(sc
                                                            .patientSchedules
                                                            ?.patientSnackstime),
                                                    sc.snacksField.text),
                                                const Divider(),
                                                _buildMealRow(
                                                    "Dinner",
                                                    sc.dinner.isNotEmpty
                                                        ? sc.dinner.first
                                                        : _formatTime(sc
                                                            .patientSchedules
                                                            ?.patientDinnertime),
                                                    sc.dinnerField.text),
                                              ],
                                            ),
                                          ),
                                        ),

                                        SizedBox(height: 12.h),

                                        // Hydration Section
                                        _buildSectionHeader("Hydration"),
                                        SizedBox(height: 6.h),
                                        Card(
                                          elevation: 1,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12.r)),
                                          child: Padding(
                                            padding: EdgeInsets.all(12.w),
                                            child: Row(
                                              children: [
                                                const Icon(Icons.water_drop,
                                                    color: Colors.blue),
                                                const SizedBox(width: 10),
                                                Text(
                                                  sc.hydrationTEC.text,
                                                  style: TextStyle(
                                                    fontSize: 13.sp,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                        SizedBox(height: 12.h),

                                        // Daily Care Activities Section
                                        _buildSectionHeader(
                                            "Daily Care Activities"),
                                        SizedBox(height: 6.h),
                                        Card(
                                          elevation: 1,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12.r)),
                                          child: Padding(
                                            padding: EdgeInsets.all(12.w),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                _buildActivityRow(
                                                    "Oral Care",
                                                    sc.selectedOralCareTimings
                                                        .join(", ")),
                                                const Divider(),
                                                _buildActivityRow(
                                                    "Bathing",
                                                    sc.selectedBathingTimings
                                                        .join(", ")),
                                                const Divider(),
                                                _buildActivityRow(
                                                    "Dressing",
                                                    sc.selectedDressingTimings
                                                        .join(", ")),
                                                const Divider(),
                                                _buildActivityRow(
                                                    "Walking",
                                                    sc.selectedWalkingTimings
                                                        .join(", ")),
                                                const Divider(),
                                                _buildActivityRow("Toileting",
                                                    sc.toileting.text),
                                              ],
                                            ),
                                          ),
                                        ),

                                        SizedBox(height: 12.h),

                                        // Medication Section
                                        _buildSectionHeader("Medication"),
                                        SizedBox(height: 6.h),
                                        Card(
                                          elevation: 1,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12.r)),
                                          child: Padding(
                                            padding: EdgeInsets.all(12.w),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Time: ${sc.selectedMedication ?? "N/A"}",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13.sp,
                                                  ),
                                                ),
                                                SizedBox(height: 8.h),
                                                sc.selectedMedication != null
                                                    ? Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: sc
                                                            .meditationDetails
                                                            .firstWhere((element) =>
                                                                element.time ==
                                                                sc
                                                                    .selectedMedication!)
                                                            .medicationDetails!
                                                            .map(
                                                                (controller) =>
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          bottom:
                                                                              6.0),
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          const Icon(
                                                                              Icons.medication,
                                                                              color: AppColors.primaryColor,
                                                                              size: 15),
                                                                          const SizedBox(
                                                                              width: 8),
                                                                          Text(
                                                                            controller.text.isEmpty
                                                                                ? "Not specified"
                                                                                : controller.text,
                                                                            style:
                                                                                TextStyle(fontSize: 11.sp),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ))
                                                            .toList(),
                                                      )
                                                    : Text(
                                                        "No medication recorded",
                                                        style: TextStyle(
                                                          color: Colors
                                                              .grey.shade600,
                                                          fontSize: 11.sp,
                                                        ),
                                                      ),
                                              ],
                                            ),
                                          ),
                                        ),

                                        Card(
                                          elevation: 1,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12.r)),
                                          child: Padding(
                                            padding: EdgeInsets.all(12.w),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Time: ${"Noon" ?? "N/A"}",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13.sp,
                                                  ),
                                                ),
                                                SizedBox(height: 8.h),
                                                sc.selectedMedication != null
                                                    ? Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: sc
                                                            .meditationDetails
                                                            .firstWhere(
                                                                (element) =>
                                                                    element
                                                                        .time ==
                                                                    "Noon")
                                                            .medicationDetails!
                                                            .map(
                                                                (controller) =>
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          bottom:
                                                                              6.0),
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          const Icon(
                                                                              Icons.medication,
                                                                              color: AppColors.primaryColor,
                                                                              size: 15),
                                                                          const SizedBox(
                                                                              width: 8),
                                                                          Text(
                                                                            controller.text.isEmpty
                                                                                ? "Not specified"
                                                                                : controller.text,
                                                                            style:
                                                                                TextStyle(fontSize: 11.sp),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ))
                                                            .toList(),
                                                      )
                                                    : Text(
                                                        "No medication recorded",
                                                        style: TextStyle(
                                                          color: Colors
                                                              .grey.shade600,
                                                          fontSize: 11.sp,
                                                        ),
                                                      ),
                                              ],
                                            ),
                                          ),
                                        ),

                                        Card(
                                          elevation: 1,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12.r)),
                                          child: Padding(
                                            padding: EdgeInsets.all(12.w),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Time: ${"Evening" ?? "N/A"}",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13.sp,
                                                  ),
                                                ),
                                                SizedBox(height: 8.h),
                                                sc.selectedMedication != null
                                                    ? Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: sc
                                                            .meditationDetails
                                                            .firstWhere(
                                                                (element) =>
                                                                    element
                                                                        .time ==
                                                                    "Evening")
                                                            .medicationDetails!
                                                            .map(
                                                                (controller) =>
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          bottom:
                                                                              6.0),
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          const Icon(
                                                                              Icons.medication,
                                                                              color: AppColors.primaryColor,
                                                                              size: 15),
                                                                          const SizedBox(
                                                                              width: 8),
                                                                          Text(
                                                                            controller.text.isEmpty
                                                                                ? "Not specified"
                                                                                : controller.text,
                                                                            style:
                                                                                TextStyle(fontSize: 11.sp),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ))
                                                            .toList(),
                                                      )
                                                    : Text(
                                                        "No medication recorded",
                                                        style: TextStyle(
                                                          color: Colors
                                                              .grey.shade600,
                                                          fontSize: 11.sp,
                                                        ),
                                                      ),
                                              ],
                                            ),
                                          ),
                                        ),

                                        SizedBox(height: 24.h),
                                      ],
                                    ),
                            ],
                          );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Container(
          height: 18.h,
          width: 3.w,
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          title,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildVitalInfo(
      IconData icon, String label, String value, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20.r),
        SizedBox(height: 6.h),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 10.sp,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildMealRow(String mealType, String? time, String details) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                mealType,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13.sp,
                ),
              ),
              Text(
                time ?? "Not recorded",
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            details.isEmpty ? "No details recorded" : details,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 11.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityRow(String activity, String timing) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            activity,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13.sp,
            ),
          ),
          Text(
            timing.isEmpty ? "Not recorded" : timing,
            style: TextStyle(
              color: AppColors.primaryColor,
              fontWeight: FontWeight.w500,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }

  String? _formatTime(String? timeString) {
    if (timeString == null || timeString.isEmpty) return null;

    try {
      final timeParts = timeString.split(':');
      final hour = int.parse(timeParts[0]);
      final minute = timeParts[1];
      return (hour % 12 == 0 ? 12 : hour % 12).toString().padLeft(2, '0') +
          '.' +
          minute +
          (hour < 12 ? ' AM' : ' PM');
    } catch (e) {
      return timeString;
    }
  }
}
