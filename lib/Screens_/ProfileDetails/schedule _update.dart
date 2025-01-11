import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:care2care/ReusableUtils_/customButton.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import '../../ReusableUtils_/AppColors.dart';
import '../../ReusableUtils_/appBar.dart';
import '../../ReusableUtils_/customChips.dart';
import '../../ReusableUtils_/customLabel.dart';
import '../../ReusableUtils_/custom_textfield.dart';
import '../../ReusableUtils_/customradio.dart';
import '../../ReusableUtils_/image_background.dart';
import '../../ReusableUtils_/sizes.dart';
import '../Profile/Controller/initila_profile_controller.dart';
import '../Profile/modal/initilaProfileDetailsModal.dart';
import '../Schedule/controller/schedule_controller.dart';

class ScheduleUpdate extends StatefulWidget {
  ScheduleUpdate({super.key});

  @override
  State<ScheduleUpdate> createState() => _ScheduleUpdateState();
}

class _ScheduleUpdateState extends State<ScheduleUpdate> {
  final ScheduleController sc = Get.put(ScheduleController());
  final InitialProfileDetails tc = Get.put(InitialProfileDetails());

  @override
  Widget build(BuildContext context) {
    return CustomBackground(
      appBar: CustomAppBar(title: "Update Schedules", actions: [
        GetBuilder<ScheduleController>(
            builder: (sc) {
              return Padding(
                padding: EdgeInsets.only(right: 18.r),
                child: sc.updating
                    ? Center(
                        child: SizedBox(
                          height: 20.h,
                          width: 23.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 1,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      )
                    : InkWell(
                        onTap: () {
                         sc.updateInformationAndScheduleApi();
                        },
                        child: Icon(
                          IconlyLight.tick_square,
                          color: AppColors.primaryColor,
                        ),
                      ),
              );
            }),
      ]),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.w),
        child: SingleChildScrollView(
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
                      closedBorder:
                          Border.all(width: 0.2, color: Colors.black)),
                  items: controller.DietItems,
                  initialItems: controller.DietItems.where((item) =>
                          controller.diet.any((dietItem) =>
                              dietItem.name == item.name)) // Match by ID
                      .toList(),
                  onListChanged: (List<Diet> value) {
                    if (!ListEquality().equals(controller.diet, value)) {
                      controller.diet = value;
                      controller.update();
                    }
                  },
                );
              }),
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
                      closedBorder:
                          Border.all(width: 0.2, color: Colors.black)),
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
                    labelText: 'Activity Type', controller: sc.activityCT);
              }),
              kHeight20,
              GetBuilder<ScheduleController>(builder: (v) {
                return customTextField(context,
                    labelText: ' Past Surgical History',
                    controller: sc.pastSurgicalCT);
              }),
              kHeight15,
              kHeight15,
              CustomLabel(
                text: "Food Timing",
                color: AppColors.primaryColor,
              ),
              kHeight15,
              CustomLabel(text: "Break Fast"),
              kHeight10,
              Row(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: GetBuilder<ScheduleController>(
                        init: sc,
                        builder: (v) {
                          String? selectedBreakfastTime =
                              v.patientSchedules?.patientBreakfasttime;
                          String? formattedSelectedBreakfastTime;
                          if (selectedBreakfastTime != null) {
                            final timeParts = selectedBreakfastTime.split('.');
                            final hour = int.parse(timeParts[0]);
                            final minute = timeParts[1];
                            formattedSelectedBreakfastTime =
                                (hour % 12).toString().padLeft(2, '0') +
                                    '.' +
                                    minute +
                                    (hour < 12 ? ' AM' : ' PM');
                          }

                          return Wrap(
                            spacing: 8.0,
                            children: v.breakFast.map((String time) {
                              bool isSelected =
                                  time == formattedSelectedBreakfastTime ||
                                      v.filters.contains(time);
                              return CustomChip(
                                label: time,
                                isSelected: isSelected,
                                onSelected: (bool selected) {
                                  if (selected) {
                                    v.filters.clear();
                                    v.patientSchedules?.patientBreakfasttime =
                                        null;
                                    v.filters.add(time);
                                    v.update();
                                  } else {
                                    v.filters.remove(time);
                                  }

                                  // Update the controller and UI
                                  v.update();

                                },
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              kHeight15,
              CustomLabel(text: "Lunch"),
              kHeight10,
              Row(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: GetBuilder<ScheduleController>(builder: (v) {
                        String? selectedBreakfastTime =
                            v.patientSchedules?.patientLunchtime;
                        String? formattedSelectedBreakfastTime;
                        if (selectedBreakfastTime != null) {
                          final timeParts = selectedBreakfastTime.split('.');
                          final hour = int.parse(timeParts[0]);
                          final minute = timeParts[1];
                          formattedSelectedBreakfastTime =
                              (hour % 12).toString().padLeft(2, '0') +
                                  '.' +
                                  minute +
                                  (hour < 12 ? ' AM' : ' PM');
                        }
                        return Wrap(
                          spacing: 8.0,
                          children: v.lunchList.map((String name) {
                            bool isSelected =
                                name == formattedSelectedBreakfastTime ||
                                    v.lunchFilters.contains(name);
                            return CustomChip(
                              label: name,
                              isSelected: isSelected,
                              onSelected: (bool selected) {
                                setState(() {
                                  if (selected) {
                                    v.lunchFilters.clear();
                                    v.patientSchedules!.patientLunchtime = null;
                                    v.lunchFilters.add(name);
                                  } else {
                                    v.lunchFilters.remove(name);
                                  }
                                });
                              },
                            );
                          }).toList(),
                        );
                      }),
                    ),
                  ),
                ],
              ),
              kHeight15,
              CustomLabel(text: "Snacks"),
              kHeight10,
              Row(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: GetBuilder<ScheduleController>(
                          builder: (v) {
                            String selectedSnackTime = v.patientSchedules
                                        ?.patientSnackstime?.isNotEmpty ==
                                    true
                                ? v.patientSchedules!.patientSnackstime!
                                : "06:00"; // Default to "06:00"

                            String formattedSelectedSnackTime =
                                "06:00"; // Default value in case of errors

                            // Safely split and format the time, ensuring it doesn't cause index errors
                            if (selectedSnackTime.contains(':')) {
                              final timeParts = selectedSnackTime.split(':');
                              if (timeParts.length == 2) {
                                final hour = int.tryParse(timeParts[0]) ?? 0;
                                final minute = timeParts[1];
                                formattedSelectedSnackTime =
                                    (hour % 12 == 0 ? 12 : hour % 12)
                                            .toString()
                                            .padLeft(2, '0') +
                                        '.' +
                                        minute +
                                        (hour < 12 ? ' AM' : ' PM');
                              }
                            }

                            return Wrap(
                              spacing: 8.0,
                              children: v.snackList.map((String name) {
                                // Ensure that the list is not empty or out of bounds
                                bool isSelected =
                                    name == formattedSelectedSnackTime ||
                                        v.snacks.contains(name);

                                return CustomChip(
                                  label: name,
                                  isSelected: isSelected,
                                  onSelected: (bool selected) {
                                    // Safely update snacks list
                                    if (selected) {
                                      v.snacks.clear();
                                      v.snacks.add(name);
                                      v.patientSchedules!.patientSnackstime =
                                          name; // Update snack time
                                      v.update(); // Rebuild GetX state
                                    } else {
                                      v.snacks.remove(name);
                                      v.patientSchedules!.patientSnackstime =
                                          null; // Clear snack time
                                      v.update();
                                    }
                                  },
                                );
                              }).toList(),
                            );
                          },
                        )),
                  ),
                ],
              ),
              kHeight15,
              CustomLabel(text: "Dinner"),
              kHeight10,
              Row(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: GetBuilder<ScheduleController>(builder: (v) {
                        String? selectedBreakfastTime =
                            v.patientSchedules?.patientDinnertime;
                        String? formattedSelectedBreakfastTime;
                        if (selectedBreakfastTime != null) {
                          final timeParts = selectedBreakfastTime.split('.');
                          final hour = int.parse(timeParts[0]);
                          final minute = timeParts[1];
                          formattedSelectedBreakfastTime =
                              (hour % 12).toString().padLeft(2, '0') +
                                  '.' +
                                  minute +
                                  (hour < 12 ? ' AM' : ' PM');
                        }
                        return Wrap(
                          spacing: 8.0,
                          children: sc.dinnerList.map((String name) {
                            bool isSelected =
                                name == formattedSelectedBreakfastTime ||
                                    v.dinner.contains(name);
                            return CustomChip(
                              label: name,
                              isSelected: isSelected,
                              onSelected: (bool selected) {
                                setState(() {
                                  if (selected) {
                                    v.dinner.clear();
                                    v.patientSchedules?.patientDinnertime =
                                        null;
                                    v.dinner.add(name);
                                  } else {
                                    sc.dinner.remove(name);
                                  }
                                });
                              },
                            );
                          }).toList(),
                        );
                      }),
                    ),
                  ),
                ],
              ),
              kHeight15,
              CustomLabel(text: "Hydration(Water)"),
              kHeight10,
              customTextField(context,
                  controller: sc.hydrationTEC, labelText: "Hydration"),
              kHeight15,
              CustomLabel(text: "Oral Care"),
              kHeight10,
              GetBuilder<ScheduleController>(builder: (v) {
                return Row(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Wrap(
                            children: [
                              CustomRadioButton(
                                selectedColor: AppColors.primaryColor,
                                unselectedColor: Colors.white,
                                value: 'Morning',
                                groupValue: sc.oralSelection,
                                label: 'Morning',
                                onChanged: (value) {
                                  sc.oralSelection = value!;
                                  sc.update();
                                },
                              ),
                              kWidth10,
                              CustomRadioButton(
                                selectedColor: AppColors.primaryColor,
                                unselectedColor: Colors.white,
                                value: 'Noon',
                                groupValue: sc.oralSelection,
                                label: 'Noon',
                                onChanged: (value) {
                                  sc.oralSelection = value!;
                                  sc.update();
                                },
                              ),
                              kWidth10,
                              CustomRadioButton(
                                selectedColor: AppColors.primaryColor,
                                unselectedColor: Colors.white,
                                value: 'Evening',
                                groupValue: sc.oralSelection,
                                label: 'Evening',
                                onChanged: (value) {
                                  sc.oralSelection = value!;
                                  sc.update();
                                },
                              ),
                            ],
                          )),
                    ),
                  ],
                );
              }),
              kHeight15,
              CustomLabel(text: "Bathing"),
              kHeight10,
              GetBuilder<ScheduleController>(builder: (v) {
                return Row(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Wrap(
                            children: [
                              CustomRadioButton(
                                selectedColor: AppColors.primaryColor,
                                unselectedColor: Colors.white,
                                value: 'Morning',
                                groupValue: sc.bathingSelection,
                                label: 'Morning',
                                onChanged: (value) {
                                  sc.bathingSelection = value!;
                                  sc.update();
                                },
                              ),
                              kWidth10,
                              CustomRadioButton(
                                selectedColor: AppColors.primaryColor,
                                unselectedColor: Colors.white,
                                value: 'Noon',
                                groupValue: sc.bathingSelection,
                                label: 'Noon',
                                onChanged: (value) {
                                  sc.bathingSelection = value!;
                                  sc.update();
                                },
                              ),
                              kWidth10,
                              CustomRadioButton(
                                selectedColor: AppColors.primaryColor,
                                unselectedColor: Colors.white,
                                value: 'Evening',
                                groupValue: sc.bathingSelection,
                                label: 'Evening',
                                onChanged: (value) {
                                  sc.bathingSelection = value!;
                                  sc.update();
                                },
                              ),
                            ],
                          )),
                    ),
                  ],
                );
              }),
              kHeight15,
              CustomLabel(text: "Medication"),
              kHeight10,
              GetBuilder<ScheduleController>(builder: (v) {
                return Row(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Wrap(
                            children: [
                              CustomRadioButton(
                                selectedColor: AppColors.primaryColor,
                                unselectedColor: Colors.white,
                                value: 'Morning',
                                groupValue: sc.medidation,
                                label: 'Morning',
                                onChanged: (value) {
                                  sc.medidation = value!;
                                  sc.selectedMedication = "Morning";
                                  sc.update();
                                },
                              ),
                              kWidth10,
                              CustomRadioButton(
                                selectedColor: AppColors.primaryColor,
                                unselectedColor: Colors.white,
                                value: 'Noon',
                                groupValue: sc.medidation,
                                label: 'Noon',
                                onChanged: (value) {
                                  sc.medidation = value!;
                                  sc.selectedMedication = "Noon";
                                  sc.update();
                                },
                              ),
                              kWidth10,
                              CustomRadioButton(
                                selectedColor: AppColors.primaryColor,
                                unselectedColor: Colors.white,
                                value: 'Evening',
                                groupValue: sc.medidation,
                                label: 'Evening',
                                onChanged: (value) {
                                  sc.medidation = value!;
                                  sc.selectedMedication = "Evening";
                                  sc.update();
                                },
                              ),
                            ],
                          )),
                    ),
                  ],
                );
              }),
              GetBuilder<ScheduleController>(
                  builder: (v){
                    return sc.selectedMedication!=null
                        ? Column(
                          children: [

                            kHeight15,

                            ListView.builder(
                            itemCount: sc.meditationDetails.firstWhere((element) => element.time == sc.selectedMedication!).medicationDetails!.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context,index){
                                                  return Padding(
                                                    padding: EdgeInsets.only(top: 16.h),
                                                    child: Row(
                                                      children: [

                                                        Expanded(
                                                          flex: 3,
                                                          child: customTextField(
                                                              context,
                                                              controller: sc.meditationDetails.firstWhere((element) => element.time == sc.selectedMedication!).medicationDetails![index],
                                                              hint: "Enter details",
                                                              labelText: "${sc.selectedMedication!} medication ${index+1}"
                                                          ),
                                                        ),

                                                        Expanded(
                                                          flex: 1,
                                                          child: IconButton(
                                                            onPressed: (){
                                                              sc.meditationDetails.firstWhere((element) => element.time == sc.selectedMedication!).medicationDetails!.removeAt(index);
                                                              sc.update();
                                                              },
                                                            icon: Icon(Icons.remove),
                                                        )),

                                                      ],
                                                    ),
                                                  );
                                                }),

                            kHeight15,

                            CustomButton(
                                onPressed: (){
                                  sc.meditationDetails.firstWhere((element) => element.time == sc.selectedMedication!).medicationDetails!.add(TextEditingController());
                                  sc.update();
                                },
                                text: "Add medication detail"
                            ),

                          ],
                        ) : SizedBox();
                  }
              ),
              kHeight15,
              CustomLabel(text: "Dressing"),
              kHeight10,
              GetBuilder<ScheduleController>(builder: (v) {
                return Row(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Wrap(
                            children: [
                              CustomRadioButton(
                                selectedColor: AppColors.primaryColor,
                                unselectedColor: Colors.white,
                                value: 'Option 1',
                                groupValue: sc.dressingSelection,
                                label: 'Morning',
                                onChanged: (value) {
                                  sc.dressingSelection = value!;
                                  sc.update();
                                },
                              ),
                              kWidth10,
                              CustomRadioButton(
                                selectedColor: AppColors.primaryColor,
                                unselectedColor: Colors.white,
                                value: 'Option 2',
                                groupValue: sc.dressingSelection,
                                label: 'Noon',
                                onChanged: (value) {
                                  sc.dressingSelection = value!;
                                  sc.update();
                                },
                              ),
                              kWidth10,
                              CustomRadioButton(
                                selectedColor: AppColors.primaryColor,
                                unselectedColor: Colors.white,
                                value: 'Option 3',
                                groupValue: sc.dressingSelection,
                                label: 'Evening',
                                onChanged: (value) {
                                  sc.dressingSelection = value!;
                                  sc.update();
                                },
                              ),
                            ],
                          )),
                    ),
                  ],
                );
              }),
              kHeight15,
              CustomLabel(text: "Toileting"),
              kHeight10,
              GetBuilder<ScheduleController>(builder: (v) {
                return TextField(
                  controller: v.toileting,
                  decoration: InputDecoration(
                    //filled: true,
                    focusColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.black, width: 0.3),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    border: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.black, width: 0.3),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.black, width: 0.3),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    hintStyle: const TextStyle(color: Colors.grey),
                  ),
                );
              }),
              kHeight15,
              CustomLabel(text: "Walking"),
              kHeight10,
              GetBuilder<ScheduleController>(builder: (v) {
                return Row(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Wrap(
                            children: [
                              CustomRadioButton(
                                selectedColor: AppColors.primaryColor,
                                unselectedColor: Colors.white,
                                value: 'Morning',
                                groupValue: sc.walkingTime,
                                label: 'Morning',
                                onChanged: (value) {
                                  sc.walkingTime = value!;
                                  sc.update();
                                },
                              ),
                              kWidth10,
                              CustomRadioButton(
                                selectedColor: AppColors.primaryColor,
                                unselectedColor: Colors.white,
                                value: 'Evening',
                                groupValue: sc.walkingTime,
                                label: 'Evening',
                                onChanged: (value) {
                                  sc.walkingTime = value!;
                                  sc.update();
                                },
                              ),
                            ],
                          )),
                    ),
                  ],
                );
              }),
              kHeight15,
              CustomLabel(text: "Baseline Vital Signs"),
              kHeight10,
              Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                          child: customTextField(context,
                              controller: sc.temp, labelText: "Temperature")),
                      kWidth10,
                      Expanded(
                          child: customTextField(context,
                              labelText: "Pulse", controller: sc.heartRate)),
                      kWidth10,
                      Expanded(
                          child: customTextField(context,
                              controller: sc.respiration,
                              labelText: "Respirations")),
                      kWidth10,
                      Expanded(
                          child: customTextField(context,
                              controller: sc.bp, labelText: "BP")),
                    ],
                  ),
                  SizedBox(height: 10),
                ],
              ),
              kHeight15,
              CustomLabel(text: "Blood Sugar"),
              kHeight10,
              GetBuilder<ScheduleController>(builder: (v) {
                return customTextField(context,
                    controller: sc.bloodSugarTEC, labelText: "Blood Sugar");
              }),
              kHeight10,

            ],
          ),
        ),
      ),
    );
  }
}
