import 'package:care2care/ReusableUtils_/AppColors.dart';
import 'package:care2care/ReusableUtils_/appBar.dart';
import 'package:care2care/ReusableUtils_/image_background.dart';
import 'package:care2care/Screens_/patient_history/Controller/completed_appointment_details_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'Models/vitals_model.dart';

class VitalsView extends StatelessWidget {
  VitalsView({super.key});

  final CompletedAppointmentDetailsController vc = Get.find();

  @override
  Widget build(BuildContext context) {

    return Material(
      child: Stack(
        children: [
          CustomBackground(
            appBar: CustomAppBar(title: "Vitals History"),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: GetBuilder<CompletedAppointmentDetailsController>(
                builder: (vc) {
                  if (vc.vitals.isEmpty) {
                    return Center(
                      child: Text(
                        "No vitals recorded",
                        style: TextStyle(fontSize: 16.sp),
                      ),
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader("Vital Signs History"),
                      SizedBox(height: 8),

                      /// Card container like other sections
                      Card(
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.r),
                            child: DataTable(
                              columnSpacing: 24,
                              horizontalMargin: 8,
                              dataRowMinHeight: 40,
                              dataRowMaxHeight: 44,
                              headingRowHeight: 44,
                              dividerThickness: 0.6,
                              headingRowColor:
                              MaterialStateProperty.all(AppColors.primaryColor.withOpacity(.08)),
                              columns: [
                                DataColumn(
                                  label: Text(
                                    "Date",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Center(child: Text("BP")),
                                ),
                                DataColumn(
                                  label: Center(child: Text("Pulse")),
                                ),
                                DataColumn(
                                  label: Center(child: Text("Resp")),
                                ),
                                DataColumn(
                                  label: Center(child: Text("Temp")),
                                ),
                              ],
                              rows: [
                                ...vc.vitals.map((v) {
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(
                                        DateFormat("dd MMM yyyy").format(v.appointmentDate!),
                                      )),
                                      DataCell(Center(child: Text(v.vitalSigns?.bloodPressure ?? "-"))),
                                      DataCell(Center(child: Text(v.vitalSigns?.heartRate ?? "-"))),
                                      DataCell(Center(child: Text(v.vitalSigns?.respiratoryRate ?? "-"))),
                                      DataCell(Center(child: Text(v.vitalSigns?.temperature ?? "-"))),
                                    ],
                                  );
                                }).toList(),

                                /// Average row
                                vc.avg!=null?DataRow(
                                  color: MaterialStateProperty.all(
                                      Colors.green.withOpacity(0.08)),
                                  cells: [
                                    DataCell(
                                      Text(
                                        "Average",
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    DataCell(Center(child: Text(vc.avg["bp"]!))),
                                    DataCell(Center(child: Text(vc.avg["heart"]!))),
                                    DataCell(Center(child: Text(vc.avg["resp"]!))),
                                    DataCell(Center(child: Text(vc.avg["temp"]!))),
                                  ],
                                ):DataRow(cells: []),

                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  //


  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Container(
          height: 24.h,
          width: 4.w,
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          title,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}