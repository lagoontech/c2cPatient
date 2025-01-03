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
     // sc.fetchPrimaryInformationApi();
  }

  @override
  Widget build(BuildContext context) {
    return CustomBackground(
        appBar: CustomAppBar(title: "My Schedule", actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18.0),
            child: IconButton(
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
            ),
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
                        String? firstName =
                            n.profile!.data!.patientInfo!.firstName!;
                        String? lastname =
                            n.profile!.data!.patientInfo!.lastName!;

                        return Column(
                          //mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 5.h,
                            ),
                            Text(
                              '$firstName $lastname',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            kHeight10,
                            Text(
                              n.profile!.data!.patientInfo!.sex!,
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
                           /* String? formattedSelectedBreakfastTime;
                            if (selectedBreakfastTime != null) {
                              final timeParts =
                                  selectedBreakfastTime.split(':');
                              final hour = int.parse(timeParts[0]);
                              final minute = timeParts[1];
                              formattedSelectedBreakfastTime =
                                  (hour % 12).toString().padLeft(2, '0') +
                                      '.' +
                                      minute +
                                      (hour < 12 ? ' AM' : ' PM');
                            }*/

                            return Wrap(
                              spacing: 8.0,
                              children: v.breakFast.map((String time) {
                                bool isSelected =
                                    time == selectedBreakfastTime ||
                                        v.filters.contains(time);
                                return CustomChip(
                                  label: time,
                                  isSelected: isSelected,
                                  onSelected: (bool selected) {
                                    if (selected) {
                                      v.filters.clear();
                                      print("--->${v.filters.isEmpty}");
                                      v.patientSchedules?.patientBreakfasttime =
                                          null;
                                      v.filters.add(time);
                                      v.update();
                                    } else {
                                      v.filters.remove(time);
                                    }

                                    // Update the controller and UI
                                    v.update();

                                    print("updated time: $time");
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
                          String? selectedBreakfastTime = v.patientSchedules?.patientLunchtime;
                          String? formattedSelectedBreakfastTime;
                       /*   if (selectedBreakfastTime != null) {
                            final timeParts = selectedBreakfastTime.split(':');
                            final hour = int.parse(timeParts[0]);
                            final minute = timeParts[1];
                            formattedSelectedBreakfastTime =
                                (hour % 12).toString().padLeft(2, '0') +
                                    '.' +
                                    minute +
                                    (hour < 12 ? ' AM' : ' PM');
                          }*/
                          return Wrap(
                            spacing: 8.0,
                            children: v.lunchList.map((String name) {
                              bool isSelected = name == selectedBreakfastTime || v.lunchFilters.contains(name);
                              return CustomChip(
                                label: name,
                                isSelected: isSelected,
                                onSelected: (bool selected) {
                                  setState(() {
                                    if (selected) {
                                      v.lunchFilters.clear();
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
                            // Assign default snack time if empty or null, otherwise use existing snack time
                            String selectedSnackTime = v.patientSchedules!=null ? v.patientSchedules!.patientSnackstime!:"";/*?.isNotEmpty == true
                                ? v.patientSchedules!.patientSnackstime!
                                : "06:00"; // Default to "06:00"
*/
                            String formattedSelectedSnackTime = "06:00"; // Default value in case of errors

                            // Safely split and format the time, ensuring it doesn't cause index errors
                       /*     if (selectedSnackTime.contains(':')) {
                              final timeParts = selectedSnackTime.split(':');
                              if (timeParts.length == 2) {
                                final hour = int.tryParse(timeParts[0]) ?? 0;
                                final minute = timeParts[1];
                                formattedSelectedSnackTime =
                                    (hour % 12 == 0 ? 12 : hour % 12).toString().padLeft(2, '0') +
                                        '.' +
                                        minute +
                                        (hour < 12 ? ' AM' : ' PM');
                              }
                            }*/

                            return Wrap(
                              spacing: 8.0,
                              children: v.snackList.map((String name) {
                                // Ensure that the list is not empty or out of bounds
                                bool isSelected = name == selectedSnackTime || v.snacks.contains(name);

                                return CustomChip(
                                  label: name,
                                  isSelected: isSelected,
                                  onSelected: (bool selected) {
                                    // Safely update snacks list
                                    if (selected) {
                                      v.snacks.clear();
                                      v.snacks.add(name);
                                      v.patientSchedules!.patientSnackstime = name; // Update snack time
                                      v.update(); // Rebuild GetX state
                                    } else {
                                      v.snacks.remove(name);
                                      v.patientSchedules!.patientSnackstime = null; // Clear snack time
                                      v.update();
                                    }
                                  },
                                );
                              }).toList(),
                            );
                          },
                        )


                      ),
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
                         /* if (selectedBreakfastTime != null) {
                            final timeParts = selectedBreakfastTime.split(':');
                            final hour = int.parse(timeParts[0]);
                            final minute = timeParts[1];
                            formattedSelectedBreakfastTime =
                                (hour % 12).toString().padLeft(2, '0') +
                                    '.' +
                                    minute +
                                    (hour < 12 ? ' AM' : ' PM');
                          }*/
                          return Wrap(
                            spacing: 8.0,
                            children: sc.dinnerList.map((String name) {
                              bool isSelected =
                                  name == selectedBreakfastTime ||
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
                Row(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: GetBuilder<ScheduleController>(builder: (v) {
                         // String? hydrationLevel = v.patientSchedules!.patientHydration != null ?v.patientSchedules!.patientHydration:"500ML";
                          return Wrap(
                            spacing: 8.0,
                            children: sc.Hydration.map((String name) {
                              return CustomChip(
                                label: name,
                                isSelected: v.selectedHydration == name,
                                onSelected: (bool selected) {
                                  v.selectedHydration = name;
                                  v.update();
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
                                  value: 'Option 1',
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
                                  value: 'Option 2',
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
                                  value: 'Option 3',
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
                                  value: 'Option 1',
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
                                  value: 'Option 2',
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
                                  value: 'Option 3',
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
                CustomLabel(text: "Medidation"),
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
                                  groupValue: sc.medidation,
                                  label: 'Morning',
                                  onChanged: (value) {
                                    sc.medidation = value!;
                                    sc.update();
                                  },
                                ),
                                kWidth10,
                                CustomRadioButton(
                                  selectedColor: AppColors.primaryColor,
                                  unselectedColor: Colors.white,
                                  value: 'Option 2',
                                  groupValue: sc.medidation,
                                  label: 'Noon',
                                  onChanged: (value) {
                                    sc.medidation = value!;
                                    sc.update();
                                  },
                                ),
                                kWidth10,
                                CustomRadioButton(
                                  selectedColor: AppColors.primaryColor,
                                  unselectedColor: Colors.white,
                                  value: 'Option 3',
                                  groupValue: sc.medidation,
                                  label: 'Evening',
                                  onChanged: (value) {
                                    sc.medidation = value!;
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
                      ],
                    ),
                    SizedBox(height: 10),
                    // Optional: Add some spacing between the rows
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                            child: SizedBox(
                          width: 30,
                          child: GetBuilder<ScheduleController>(builder: (v) {
                            return customTextField(context,
                                controller: sc.bp, labelText: "Blood Pressure");
                          }),
                        )),
                        // Updated label for the 4th field
                      ],
                    ),
                  ],
                ),
                kHeight10,
              ],
            ),
          ),
        ));
  }
}
