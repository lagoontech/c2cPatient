import 'dart:convert';
import 'package:care2care/ReusableUtils_/AppColors.dart';
import 'package:care2care/ReusableUtils_/toast2.dart';
import 'package:care2care/constants/api_urls.dart';
import 'package:care2care/sharedPref/sharedPref.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../../HomeScreen/modal/allCaretakers_modal.dart';

class CareTakerController extends GetxController {
  ViewAllCareTakers? viewAllCareTakers;
  List<CaretakerInfo> careTakerInfo = [];
  DateTime? appointmentDate;
  bool isAppointmentLoading = false;
  List<CaretakerInfo> requestedAppointments = [];
  List<CaretakerInfo> approvedAppointments = [];
  List<CaretakerInfo> completedAppointments = [];
  List<CaretakerInfo> cancelledAppointments = [];
  List<DateTime>? disabledDates = [];

  bookAppointmentApi({int? careTakerId}) async {
    isAppointmentLoading = true;
    update();
    //  await Future.delayed(Duration(seconds: 4));
    try {
      String formattedAppointmentDate =
          DateFormat('yyyy-MM-dd').format(appointmentDate ?? DateTime.now());
      String formattedStartTime = DateFormat('HH:mm:ss').format(fromTime!);
      String formattedEndTime = DateFormat('HH:mm:ss').format(toTime!);
      Map<String, dynamic> payload = {
        "caretaker_id": careTakerId,
        "appointment_date": formattedAppointmentDate,
        "appointment_start_time": formattedStartTime,
        "appointment_end_time": formattedEndTime
      };
      String? token = await SharedPref().getToken();
      var request = await http.post(Uri.parse(ApiUrls().appointment),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(payload));
      if (request.statusCode == 200) {
        showCustomToast(
            message: 'Your Appointment Submitted Successfully',
            gravity: ToastGravity.CENTER);
        debugPrint("Appointment Completed");
      } else {
        final responseData = jsonDecode(request.body);
        String errorMessage = responseData['error'] ??
            responseData['message'] ??
            'Something went wrong';

        showCustomToast(
            message: errorMessage,
            gravity: ToastGravity.TOP); // Show the specific error message
        debugPrint("Appointment not Completed");
      }
    } catch (e) {
      print(e);
    }
    isAppointmentLoading = false;
    update();
  }

  DateTime? fromTime = DateTime.now().copyWith(hour: 9, minute: 0);
  DateTime? toTime = DateTime.now().copyWith(hour: 18, minute: 0);

  Future<void> pickFromTime(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      fromTime = DateTime.now()
          .copyWith(hour: pickedTime.hour, minute: pickedTime.minute);
      update();
    }
  }

  Future<void> pickToTime(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      DateTime selectedToTime = DateTime.now()
          .copyWith(hour: pickedTime.hour, minute: pickedTime.minute);
      if (fromTime != null && selectedToTime.isBefore(fromTime!)) {
        Get.snackbar("Invalid Time", "End time must be after start time.",
            snackStyle: SnackStyle.FLOATING,
            backgroundColor: AppColors.primaryColor.withOpacity(0.3));
      } else {
        toTime = selectedToTime;
        update();
      }
    }
  }

  // Method to get disabled dates up to today
  List<DateTime>? getDisabledDates() {
    DateTime today = DateTime.now();

    DateTime startDate = DateTime(today.year, 1, 1);
    while (startDate.isBefore(today)) {
      disabledDates!.add(startDate);
      startDate = startDate.add(Duration(days: 1));
    }

    return disabledDates;
  }
}
