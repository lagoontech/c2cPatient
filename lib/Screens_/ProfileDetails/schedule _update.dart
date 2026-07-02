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
                      MediaQuery
                          .of(context)
                          .size
                          .width * 0.06 * 0.5),
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
                      MediaQuery
                          .of(context)
                          .size
                          .width * 0.06 * 0.5),
                  decoration: CustomDropdownDecoration(
                      closedBorder:
                      Border.all(width: 0.2, color: Colors.black)),
                  items: controller.medicalHistory,
                  initialItems: controller.medicalHistory
                      .where((item) =>
                      controller.medicalHistoryList.any(
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
                    isDense: false,
                    borderColor: Colors.black,
                    borderWidth: 0.2,
                    borderRadius: 12.r,
                    labelText: 'Activity Type',
                    controller: sc.activityCT);
              }),
              kHeight20,
              GetBuilder<ScheduleController>(builder: (v) {
                return customTextField(context,
                    isDense: false,
                    labelText: ' Past Surgical History',
                    borderRadius: 12.r,
                    borderColor: Colors.black,
                    borderWidth: 0.2,
                    controller: sc.pastSurgicalCT);
              }),
              kHeight15,
              kHeight15,
              CustomLabel(
                text: "Food Timing",
              ),
              kHeight15,

              GetBuilder<ScheduleController>(
                builder: (v) {
                  return !v.loadingInfo?GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 1.7,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [

                      MealTimeCard(
                        title: "Breakfast",
                        icon: "🌅",
                        time: v.formatTime(v.patientSchedules?.patientBreakfasttime ?? "--"),
                        onTap: () async {
                          final result = await showTimePickerDialog(context);
                          if (result != null && result.toString().isNotEmpty) {
                            v.patientSchedules?.patientBreakfasttime = result;
                            v.filters.clear();
                            v.filters.add(result);
                            v.update();
                          }
                        },
                      ),

                      MealTimeCard(
                        title: "Lunch",
                        icon: "🍛",
                        time: v.formatTime(v.patientSchedules?.patientLunchtime ?? "--"),
                        onTap: () async {
                          final result = await showTimePickerDialog(context);
                          if (result != null && result.toString().isNotEmpty) {
                            v.patientSchedules?.patientLunchtime = result;
                            v.lunchFilters.clear();
                            v.lunchFilters.add(result);
                            v.update();
                          }
                        },
                      ),

                      MealTimeCard(
                        title: "Snacks",
                        icon: "☕",
                        time: v.formatTime(v.patientSchedules?.patientSnackstime ?? "--"),
                        onTap: () async {
                          final result = await showTimePickerDialog(context);
                          if (result != null && result.toString().isNotEmpty) {
                            v.patientSchedules?.patientSnackstime = result;
                            v.snacks.clear();
                            v.snacks.add(result);
                            v.update();
                          }
                        },
                      ),

                      MealTimeCard(
                        title: "Dinner",
                        icon: "🌙",
                        time: v.formatTime(v.patientSchedules?.patientDinnertime ?? "--"),
                        onTap: () async {
                          final result = await showTimePickerDialog(context);
                          if (result != null && result.toString().isNotEmpty) {
                            v.patientSchedules?.patientDinnertime = result;
                            v.dinner.clear();
                            v.dinner.add(result);
                            v.update();
                          }
                        },
                      ),
                    ],
                  ) : SizedBox();
                },
              ),
              kHeight15,
              CustomLabel(text: "Hydration(Water)"),
              kHeight10,
              customTextField(context,
                  borderRadius: 12.r,
                  borderColor: Colors.black,
                  borderWidth: 0.2,
                  isDense: false,
                  controller: sc.hydrationTEC,
                  labelText: "Hydration"),
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
                              CustomChip(
                                label: "Morning",
                                isSelected: sc.selectedOralCareTimings.contains(
                                    "Morning"),
                                onSelected: (bool selected) {
                                  print(selected);
                                  if (selected) {
                                    sc.selectedOralCareTimings.add("Morning");
                                  } else {
                                    sc.selectedOralCareTimings.remove(
                                        "Morning");
                                  }
                                  v.update();
                                },
                              ),
                              kWidth10,
                              CustomChip(
                                label: "Noon",
                                isSelected: sc.selectedOralCareTimings.contains(
                                    "Noon"),
                                onSelected: (bool selected) {
                                  if (selected) {
                                    sc.selectedOralCareTimings.add("Noon");
                                  } else {
                                    sc.selectedOralCareTimings.remove("Noon");
                                  }
                                  v.update();
                                },
                              ),

                              kWidth10,
                              CustomChip(
                                label: "Evening",
                                isSelected: sc.selectedOralCareTimings.contains(
                                    "Evening"),
                                onSelected: (bool selected) {
                                  if (selected) {
                                    sc.selectedOralCareTimings.add("Evening");
                                  } else {
                                    sc.selectedOralCareTimings.remove(
                                        "Evening");
                                  }
                                  v.update();
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
                              CustomChip(
                                label: "Morning",
                                isSelected: sc.selectedBathingTimings.contains(
                                    "Morning"),
                                onSelected: (bool selected) {
                                  print(selected);
                                  if (selected) {
                                    sc.selectedBathingTimings.add("Morning");
                                  } else {
                                    sc.selectedBathingTimings.remove("Morning");
                                  }
                                  v.update();
                                },
                              ),
                              kWidth10,
                              CustomChip(
                                label: "Noon",
                                isSelected: sc.selectedBathingTimings.contains(
                                    "Noon"),
                                onSelected: (bool selected) {
                                  if (selected) {
                                    sc.selectedBathingTimings.add("Noon");
                                  } else {
                                    sc.selectedBathingTimings.remove("Noon");
                                  }
                                  v.update();
                                },
                              ),

                              kWidth10,
                              CustomChip(
                                label: "Evening",
                                isSelected: sc.selectedBathingTimings.contains(
                                    "Evening"),
                                onSelected: (bool selected) {
                                  if (selected) {
                                    sc.selectedBathingTimings.add("Evening");
                                  } else {
                                    sc.selectedBathingTimings.remove("Evening");
                                  }
                                  v.update();
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
                  builder: (v) {
                    return sc.selectedMedication != null
                        ? Column(
                      children: [

                        kHeight15,

                        sc.meditationDetails.isNotEmpty ? ListView.builder(
                            itemCount: sc.meditationDetails
                                .firstWhere((element) =>
                            element.time == sc.selectedMedication!)
                                .medicationDetails!
                                .length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.only(top: 16.h),
                                child: Row(
                                  children: [

                                    Expanded(
                                      flex: 3,
                                      child: customTextField(
                                          context,
                                          borderRadius: 12.r,
                                          borderColor: Colors.black,
                                          borderWidth: 0.2,
                                          isDense: false,
                                          controller: sc.meditationDetails
                                              .firstWhere((element) =>
                                          element.time ==
                                              sc.selectedMedication!)
                                              .medicationDetails![index],
                                          hint: "Enter details",
                                          labelText: "${sc
                                              .selectedMedication!} medication ${index +
                                              1}"
                                      ),
                                    ),

                                    Expanded(
                                        flex: 1,
                                        child: IconButton(
                                          onPressed: () {
                                            sc.meditationDetails
                                                .firstWhere((element) =>
                                            element.time ==
                                                sc.selectedMedication!)
                                                .medicationDetails!
                                                .removeAt(index);
                                            sc.update();
                                          },
                                          icon: Icon(Icons.remove),
                                        )),

                                  ],
                                ),
                              );
                            }) : SizedBox(),

                        kHeight15,

                        CustomButton(
                            onPressed: () {
                              print(sc.selectedMedication);
                              sc.meditationDetails
                                  .firstWhere((element) =>
                              element.time == sc.selectedMedication!)
                                  .medicationDetails!
                                  .add(TextEditingController());
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
                              CustomChip(
                                label: "Morning",
                                isSelected: sc.selectedDressingTimings.contains(
                                    "Morning"),
                                onSelected: (bool selected) {
                                  print(selected);
                                  if (selected) {
                                    sc.selectedDressingTimings.add("Morning");
                                  } else {
                                    sc.selectedDressingTimings.remove(
                                        "Morning");
                                  }
                                  v.update();
                                },
                              ),
                              kWidth10,
                              CustomChip(
                                label: "Noon",
                                isSelected: sc.selectedDressingTimings.contains(
                                    "Noon"),
                                onSelected: (bool selected) {
                                  print(selected);
                                  if (selected) {
                                    sc.selectedDressingTimings.add("Noon");
                                  } else {
                                    sc.selectedDressingTimings.remove("Noon");
                                  }
                                  v.update();
                                },
                              ),
                              kWidth10,
                              CustomChip(
                                label: "Evening",
                                isSelected: sc.selectedDressingTimings.contains(
                                    "Evening"),
                                onSelected: (bool selected) {
                                  print(selected);
                                  if (selected) {
                                    sc.selectedDressingTimings.add("Evening");
                                  } else {
                                    sc.selectedDressingTimings.remove(
                                        "Evening");
                                  }
                                  v.update();
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
                              CustomChip(
                                label: "Morning",
                                isSelected: sc.selectedWalkingTimings.contains(
                                    "Morning"),
                                onSelected: (bool selected) {
                                  if (selected) {
                                    sc.selectedWalkingTimings.add("Morning");
                                  } else {
                                    sc.selectedWalkingTimings.remove("Morning");
                                  }
                                  v.update();
                                },
                              ),
                              kWidth10,
                              CustomChip(
                                label: "Evening",
                                isSelected: sc.selectedWalkingTimings.contains(
                                    "Evening"),
                                onSelected: (bool selected) {
                                  if (selected) {
                                    sc.selectedWalkingTimings.add("Evening");
                                  } else {
                                    sc.selectedWalkingTimings.remove("Evening");
                                  }
                                  v.update();
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
                              borderRadius: 12.r,
                              borderColor: Colors.black,
                              borderWidth: 0.2,
                              isDense: false,
                              controller: sc.temp,
                              labelText: "Temperature")),
                      kWidth10,
                      Expanded(
                          child: customTextField(context,
                              borderRadius: 12.r,
                              borderColor: Colors.black,
                              borderWidth: 0.2,
                              isDense: false,
                              labelText: "Pulse",
                              controller: sc.heartRate)),
                      kWidth10,
                      Expanded(
                          child: customTextField(context,
                              controller: sc.respiration,
                              borderRadius: 12.r,
                              borderColor: Colors.black,
                              borderWidth: 0.2,
                              isDense: false,
                              labelText: "Respirations")),
                      kWidth10,
                      Expanded(
                          child: customTextField(context,
                              borderRadius: 12.r,
                              borderColor: Colors.black,
                              borderWidth: 0.2,
                              isDense: false,
                              controller: sc.bp,
                              labelText: "BP")),
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
                    borderRadius: 12.r,
                    borderColor: Colors.black,
                    borderWidth: 0.2,
                    isDense: false,
                    controller: sc.bloodSugarTEC,
                    labelText: "Blood Sugar");
              }),
              kHeight10,
              kHeight10,
              kHeight10,

            ],
          ),
        ),
      ),
    );
  }

  //
  Future<dynamic> showTimePickerDialog(BuildContext context) async {

    var result =  await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if(result!=null && result is TimeOfDay){
      //with am pm
      return "${result.hourOfPeriod.toString().padLeft(2, '0')}.${result.minute.toString().padLeft(2, '0')} ${result.period == DayPeriod.am ? 'AM' : 'PM'}";
    }
    return "";
  }

}

class MealTimeCard extends StatelessWidget {
  final String title;
  final String icon;
  final String? time;
  final VoidCallback onTap;

  const MealTimeCard({
    super.key,
    required this.title,
    required this.icon,
    required this.time,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(6.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14.w),
          color: AppColors.primaryColor.withOpacity(0.08),
          border: Border.all(
            color: AppColors.primaryColor.withOpacity(0.2),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(icon, style: TextStyle(fontSize: 18.sp)),
            SizedBox(height: 6.h),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13.sp
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              time ?? "Select Time",
              style: TextStyle(
                color: time == null
                    ? Colors.grey
                    : AppColors.primaryColor,
                fontWeight: FontWeight.w500,
                fontSize: 13.sp
              ),
            ),
          ],
        ),
      ),
    );
  }
}
