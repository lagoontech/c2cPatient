import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:care2care/ReusableUtils_/AppColors.dart';
import 'package:care2care/ReusableUtils_/appBar.dart';
import 'package:care2care/ReusableUtils_/customLabel.dart';
import 'package:care2care/ReusableUtils_/custom_textfield.dart';
import 'package:care2care/ReusableUtils_/image_background.dart';
import 'package:care2care/ReusableUtils_/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';
import '../../ReusableUtils_/customButton.dart';
import '../../ReusableUtils_/customChips.dart';
import '../../ReusableUtils_/customradio.dart';
import '../Profile/modal/initilaProfileDetailsModal.dart';
import 'controller/schedule_controller.dart';

class ScheduleView extends StatefulWidget {
  final List<Diet>? selectedDiet;
  final List<MedicalHistory>? selectedMedicalHistory;
  final String? activityType;
  final String? pastSurgicalHistor;

  ScheduleView(
      {super.key,
      this.activityType,
      this.pastSurgicalHistor,
      this.selectedDiet,
      this.selectedMedicalHistory});

  @override
  State<ScheduleView> createState() => _ScheduleViewState();
}

class _ScheduleViewState extends State<ScheduleView> {
  ScheduleController sc = Get.put(ScheduleController());

  @override
  void initState() {
    super.initState();
    sc.diet = widget.selectedDiet!;
    sc.setInitialMedication();
    // sc.fetchPrimaryInformationApi();
  }

  @override
  Widget build(BuildContext context) {
    return CustomBackground(
        appBar: CustomAppBar(title: "My Schedule", actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18.0),
            child: GetBuilder<ScheduleController>(builder: (vc) {
              return sc.inserting
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
                  : IconButton(
                      onPressed: () {
                        if (sc.patientSchedules == null) {
                          print("calling Function Insert");
                          sc.InsertPrimaryInformationAndScheduleApi();
                        } else {
                          print("calling Function update");
                          sc.updateInformationAndScheduleApi();
                        }

                        //  Get.to(()=>HomeView());
                      },
                      icon: Icon(
                        IconlyLight.tick_square,
                      ),
                      color: AppColors.primaryColor,
                    );
            }),
          ),
        ]),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.w),
            child: Column(
              children: [
                Container(
                  height: 60.h,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 8.r),
                        child: Stack(
                          children: [
                            GetBuilder<ScheduleController>(builder: (v) {
                              String fullImageUrl =
                                  (v.profile?.profilePath ?? '') +
                                      (v.profile?.data?.profileImageUrl ?? '');
                              String fallbackImage =
                                  v.profile?.data?.patientInfo?.sex == 'male'
                                      ? 'assets/icons/profle_men.jpg'
                                      : 'assets/icons/profle_women.jpg';

                              return ClipRRect(
                                borderRadius: BorderRadius.circular(30.r),
                                child: Container(
                                  height: 53.h,
                                  width: 60.w,
                                  child: CachedNetworkImage(
                                    imageUrl: fullImageUrl.isNotEmpty
                                        ? fullImageUrl
                                        : fallbackImage,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Image.asset(
                                        'assets/icons/profle_men.jpg'),
                                    errorWidget: (context, url, error) =>
                                        Image.asset(fallbackImage),
                                  ),
                                ),
                              );
                            }),
                            GetBuilder<ScheduleController>(builder: (v) {
                              return Positioned(
                                bottom: 0,
                                right: 0,
                                child: CircleAvatar(
                                  radius: 9.r,
                                  backgroundColor: Colors.grey.shade300,
                                  child: IconButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: () {
                                      showModalBottomSheet(
                                        context: context,
                                        builder: (context) {
                                          return Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.20,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            color: Colors.white,
                                            child: Column(
                                              //crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                TextButton(
                                                    onPressed: () {
                                                      v.pickImage(
                                                          ImageSource.camera,
                                                          context);
                                                    },
                                                    style: ButtonStyle(
                                                        overlayColor:
                                                            MaterialStatePropertyAll(
                                                                Colors
                                                                    .transparent)),
                                                    child:
                                                        AutoSizeText('Camera')),
                                                TextButton(
                                                    onPressed: () {
                                                      v.pickImage(
                                                          ImageSource.gallery,
                                                          context);
                                                    },
                                                    style: ButtonStyle(
                                                        overlayColor:
                                                            MaterialStatePropertyAll(
                                                                Colors
                                                                    .transparent)),
                                                    child: AutoSizeText(
                                                        'Gallery')),
                                                TextButton(
                                                    onPressed: () {
                                                      v.selectImage == null;
                                                      debugPrint(
                                                          "remove the ${v.selectImage}");
                                                    },
                                                    child: AutoSizeText(
                                                        'Remove Photo')),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    icon: Icon(
                                      Icons.edit,
                                      size: 10.sp,
                                    ),
                                    color: Colors.black,
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                      kWidth20,
                      GetBuilder<ScheduleController>(builder: (n) {
                        String firstName =
                            n.profile?.data?.patientInfo?.firstName ?? '';
                        String lastname =
                            n.profile?.data?.patientInfo?.lastName ?? '';

                        return Column(
                          //mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 5.h,
                            ),
                            Text(
                              '$firstName $lastname'.trim(),
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            kHeight10,
                            Text(
                              n.profile?.data?.patientInfo?.sex ?? '',
                              style: TextStyle(color: Colors.black),
                            )
                          ],
                        );
                      })
                    ],
                  ),
                ),
                kHeight15,
                CustomLabel(
                  text: "Food Timing",
                  color: AppColors.primaryColor,
                ),

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
                          time: v.filters.isNotEmpty
                              ? v.formatTime(v.filters.first)
                              : v.formatTime(v.patientSchedules?.patientBreakfasttime ?? "--"),
                          onTap: () async {
                            final result = await showTimePickerDialog(context);
                            if (result != null && result.toString().isNotEmpty) {
                              if (v.patientSchedules != null) {
                                v.patientSchedules!.patientBreakfasttime = result;
                              }
                              v.filters.clear();
                              v.filters.add(result);
                              v.update();
                            }
                          },
                        ),

                        MealTimeCard(
                          title: "Lunch",
                          icon: "🍛",
                          time: v.lunchFilters.isNotEmpty
                              ? v.formatTime(v.lunchFilters.first)
                              : v.formatTime(v.patientSchedules?.patientLunchtime ?? "--"),
                          onTap: () async {
                            final result = await showTimePickerDialog(context);
                            if (result != null && result.toString().isNotEmpty) {
                              if (v.patientSchedules != null) {
                                v.patientSchedules!.patientLunchtime = result;
                              }
                              v.lunchFilters.clear();
                              v.lunchFilters.add(result);
                              v.update();
                            }
                          },
                        ),

                        MealTimeCard(
                          title: "Snacks",
                          icon: "☕",
                          time: v.snacks.isNotEmpty
                              ? v.formatTime(v.snacks.first)
                              : v.formatTime(v.patientSchedules?.patientSnackstime ?? "--"),
                          onTap: () async {
                            final result = await showTimePickerDialog(context);
                            if (result != null && result.toString().isNotEmpty) {
                              if (v.patientSchedules != null) {
                                v.patientSchedules!.patientSnackstime = result;
                              }
                              v.snacks.clear();
                              v.snacks.add(result);
                              v.update();
                            }
                          },
                        ),

                        MealTimeCard(
                          title: "Dinner",
                          icon: "🌙",
                          time: v.dinner.isNotEmpty
                              ? v.formatTime(v.dinner.first)
                              : v.formatTime(v.patientSchedules?.patientDinnertime ?? "--"),
                          onTap: () async {
                            final result = await showTimePickerDialog(context);
                            if (result != null && result.toString().isNotEmpty) {
                              if (v.patientSchedules != null) {
                                v.patientSchedules!.patientDinnertime = result;
                              }
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
                              CustomChip(
                                label: "Morning",
                                isSelected: sc.selectedOralCareTimings.contains("Morning"),
                                onSelected: (bool selected) {
                                  print(selected);
                                  if (selected) {
                                    sc.selectedOralCareTimings.add("Morning");
                                  } else{
                                    sc.selectedOralCareTimings.remove("Morning");
                                  }
                                  v.update();
                                },
                              ),
                              kWidth10,
                              CustomChip(
                                label: "Noon",
                                isSelected: sc.selectedOralCareTimings.contains("Noon"),
                                onSelected: (bool selected) {
                                  if (selected) {
                                    sc.selectedOralCareTimings.add("Noon");
                                  }else{
                                    sc.selectedOralCareTimings.remove("Noon");
                                  }
                                  v.update();
                                },
                              ),

                              kWidth10,
                              CustomChip(
                                label: "Evening",
                                isSelected: sc.selectedOralCareTimings.contains("Evening"),
                                onSelected: (bool selected) {
                                  if (selected) {
                                    sc.selectedOralCareTimings.add("Evening");
                                  }else{
                                    sc.selectedOralCareTimings.remove("Evening");
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
                                  isSelected: sc.selectedBathingTimings.contains("Morning"),
                                  onSelected: (bool selected) {
                                    print(selected);
                                    if (selected) {
                                      sc.selectedBathingTimings.add("Morning");
                                    } else{
                                      sc.selectedBathingTimings.remove("Morning");
                                    }
                                    v.update();
                                  },
                                ),
                                kWidth10,
                                CustomChip(
                                  label: "Noon",
                                  isSelected: sc.selectedBathingTimings.contains("Noon"),
                                  onSelected: (bool selected) {
                                    if (selected) {
                                      sc.selectedBathingTimings.add("Noon");
                                    }else{
                                      sc.selectedBathingTimings.remove("Noon");
                                    }
                                    v.update();
                                  },
                                ),

                                kWidth10,
                                CustomChip(
                                  label: "Evening",
                                  isSelected: sc.selectedBathingTimings.contains("Evening"),
                                  onSelected: (bool selected) {
                                    if (selected) {
                                      sc.selectedBathingTimings.add("Evening");
                                    }else{
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
                GetBuilder<ScheduleController>(builder: (v) {
                  return sc.selectedMedication != null
                      ? Column(
                          children: [
                            kHeight15,
                            ListView.builder(
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
                                          child: customTextField(context,
                                              controller: sc.meditationDetails
                                                  .firstWhere((element) =>
                                                      element.time ==
                                                      sc.selectedMedication!)
                                                  .medicationDetails![index],
                                              hint: "Enter details",
                                              labelText:
                                                  "${sc.selectedMedication!} medication ${index + 1}"),
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
                                }),
                            kHeight15,
                            CustomButton(
                                onPressed: () {
                                  print(sc.selectedMedication);
                                  sc.meditationDetails
                                      .firstWhere((element) =>
                                          element.time ==
                                          sc.selectedMedication!)
                                      .medicationDetails!
                                      .add(TextEditingController());
                                  sc.update();
                                },
                                text: "Add medication detail"),
                          ],
                        )
                      : SizedBox();
                }),
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
                                  isSelected: sc.selectedDressingTimings.contains("Morning"),
                                  onSelected: (bool selected) {
                                    print(selected);
                                    if (selected) {
                                      sc.selectedDressingTimings.add("Morning");
                                    } else{
                                      sc.selectedDressingTimings.remove("Morning");
                                    }
                                    v.update();
                                  },
                                ),
                                kWidth10,
                                CustomChip(
                                  label: "Noon",
                                  isSelected: sc.selectedDressingTimings.contains("Noon"),
                                  onSelected: (bool selected) {
                                    print(selected);
                                    if (selected) {
                                      sc.selectedDressingTimings.add("Noon");
                                    } else{
                                      sc.selectedDressingTimings.remove("Noon");
                                    }
                                    v.update();
                                  },
                                ),
                                kWidth10,
                                CustomChip(
                                  label: "Evening",
                                  isSelected: sc.selectedDressingTimings.contains("Evening"),
                                  onSelected: (bool selected) {
                                    print(selected);
                                    if (selected) {
                                      sc.selectedDressingTimings.add("Evening");
                                    } else{
                                      sc.selectedDressingTimings.remove("Evening");
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
                                  isSelected: sc.selectedWalkingTimings.contains("Morning"),
                                  onSelected: (bool selected) {
                                    if (selected) {
                                      sc.selectedWalkingTimings.add("Morning");
                                    } else{
                                      sc.selectedWalkingTimings.remove("Morning");
                                    }
                                    v.update();
                                  },
                                ),
                                kWidth10,
                                CustomChip(
                                  label: "Evening",
                                  isSelected: sc.selectedWalkingTimings.contains("Evening"),
                                  onSelected: (bool selected) {
                                    if (selected) {
                                      sc.selectedWalkingTimings.add("Evening");
                                    } else{
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
                CustomLabel(text: "Vital Signs"),
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
                    kHeight15,
                    CustomLabel(text: "Blood Sugar"),
                    kHeight10,
                    GetBuilder<ScheduleController>(builder: (v) {
                      return customTextField(context,
                          controller: sc.bloodSugarTEC,
                          labelText: "Blood Sugar");
                    }),
                  ],
                ),
                kHeight10,
              ],
            ),
          ),
        ));
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


