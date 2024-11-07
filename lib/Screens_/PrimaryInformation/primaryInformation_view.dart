import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:care2care/ReusableUtils_/AppColors.dart';
import 'package:care2care/ReusableUtils_/appBar.dart';
import 'package:care2care/ReusableUtils_/custom_textfield.dart';
import 'package:care2care/ReusableUtils_/image_background.dart';
import 'package:care2care/ReusableUtils_/sizes.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../ReusableUtils_/customLabel.dart';
import '../Profile/modal/initilaProfileDetailsModal.dart';
import '../Schedule/Schedule_view.dart';
import '../Schedule/controller/schedule_controller.dart';

class PrimaryInformationView extends StatelessWidget {
  PrimaryInformationView({super.key});

  final ScheduleController controller = Get.put(ScheduleController());

  @override
  Widget build(BuildContext context) {
    return CustomBackground(
      appBar: CustomAppBar(
        title: "Primary Information",
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.w),
        child: Column(
          children: [
            CustomLabel(
              text: "Select Your Diet Plan",
            ),
            SizedBox(
              height: 10.h,
            ),
            GetBuilder<ScheduleController>(builder: (controller) {
              return CustomDropdown.multiSelect(
                closedHeaderPadding: EdgeInsets.all(
                    MediaQuery.of(context).size.width * 0.06 * 0.5),
                decoration: CustomDropdownDecoration(
                    closedBorder: Border.all(width: 0.2, color: Colors.black)),
                items: controller.DietItems,
                initialItems: controller.DietItems.where((item) =>
                        controller.diet.any((dietItem) =>
                            dietItem.name == item.name)) // Match by ID
                    .toList(),
                onListChanged: (List<Diet> value) {
                  if (!ListEquality().equals(controller.diet, value)) {
                    controller.diet = value;
                    print(controller.diet);
                    controller.update();
                  }
                },
              );
            }),
            /*  SizedBox(
              height: 10.h,
            ),*/
            /*GetBuilder<ScheduleController>(builder: (controller) {
              debugPrint("fromApi--->${controller.diet}");
              return MultiDropdown(
                onSelectionChange: (List<int> selectedDiets) {
                  controller.CT.selectedItems
                      .map((e) => DropdownItem(label: e.label, value: e.value));
                  controller.update();

                  Map<String, dynamic> mapData = Map.fromEntries(
                      controller.diet.map((e) => MapEntry(e.name, e.id)));
                  print("from map-->${mapData}");
                },
                fieldDecoration: FieldDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
                items: controller.items
                    .map((e) => DropdownItem(label: e.name, value: e.id))
                    .toList(),
                enabled: true,
                searchEnabled: false,
                chipDecoration: const ChipDecoration(
                  backgroundColor: Color(0xffF5F5F5),
                  wrap: false,
                  runSpacing: 5,
                  spacing: 10,
                ),
              );
            }),*/
            kHeight15,
            CustomLabel(
              text: "Past medical History",
            ),
            SizedBox(
              height: 10.h,
            ),
            GetBuilder<ScheduleController>(builder: (controller) {
              return CustomDropdown.multiSelect(
                closedHeaderPadding: EdgeInsets.all(
                    MediaQuery.of(context).size.width * 0.06 * 0.5),
                decoration: CustomDropdownDecoration(
                    closedBorder: Border.all(width: 0.2, color: Colors.black)),
                items: controller.medicalHistory,
                initialItems: controller.medicalHistory
                    .where((item) => controller.medicalHistoryList.any(
                        (dietItem) =>
                            dietItem.name == item.name)) // Match by ID
                    .toList(),
                onListChanged: (List<MedicalHistory> value) {
                  controller.medicalHistoryList = value;

                  controller.update();
                },
              );
            }),
            kHeight20,
            GetBuilder<ScheduleController>(builder: (v) {
              return customTextField(context,
                  labelText: 'Activity Type',
                  controller: controller.activityCT);
            }),
            kHeight20,
            GetBuilder<ScheduleController>(builder: (v) {
              return customTextField(context,
                  labelText: ' Past Surgical History',
                  controller: controller.pastSurgicalCT);
            }),
            kHeight15,
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 60.h, right: 30.w),
        child: GetBuilder<ScheduleController>(builder: (controller) {
          return FloatingActionButton(
            shape: const CircleBorder(),
            onPressed: () async {
                Get.to(() => ScheduleView(
                      selectedDiet: controller.diet,
                      selectedMedicalHistory: controller.medicalHistoryList,
                      activityType: controller.activityCT.text,
                      pastSurgicalHistor: controller.pastSurgicalCT.text,
                    ));

            },
            backgroundColor: AppColors.primaryColor,
            child: Icon(
              Icons.arrow_forward_ios_sharp,
              color: Colors.white,
            ),
          );
        }),
      ),
    );
  }
}
