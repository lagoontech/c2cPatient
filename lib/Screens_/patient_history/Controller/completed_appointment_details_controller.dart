import 'dart:convert';
import 'dart:developer';
import 'package:care2care/Screens_/patient_history/Models/vitals_model.dart';
import 'package:care2care/constants/api_urls.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../../sharedPref/sharedPref.dart';
import '../../../modals/Profile_modal.dart';
import '../../Schedule/modal/medication_model.dart';

class CompletedAppointmentDetailsController extends GetxController {
  bool loadingServiceHistory = false;

  PatientSchedules? patientSchedules;
  DateTime? selectedDate;
  ProfileList? profile;

  var selectedPatient = '';
  var selectedHydration = '';
  var selectOral = '';
  var selectBath = '';
  var selectDressing = '';
  var selectMedication = '';

  TimeOfDay? breakfastTime;
  TimeOfDay? lunchTime;
  TimeOfDay? snacksTime;
  TimeOfDay? dinnerTime;

  TextEditingController breakfastField = TextEditingController();
  TextEditingController lunchField = TextEditingController();
  TextEditingController snacksField = TextEditingController();
  TextEditingController dinnerField = TextEditingController();

  final List<String> patients = ['Yes', 'No'];
  final List<String> oralList = ['Yes', 'No'];
  final List<String> Bathing = ['Yes', 'No'];
  final List<String> Medication = ['Yes', 'No'];
  final List<String> dressingList = ['Yes', 'No'];
  final List<String> hydration = ['500ML', '1L', '2L', '3L', '4L'];

  TextEditingController toiletingCT = TextEditingController();
  TextEditingController TempCT = TextEditingController();
  TextEditingController PulseCT = TextEditingController();
  TextEditingController Respirations = TextEditingController();
  TextEditingController BloodSugar = TextEditingController();
  TextEditingController medicationCT = TextEditingController();
  TextEditingController BloodPressure = TextEditingController();

  final List<String> filters = [];
  final List<String> lunchFilters = [];
  final List<String> snacks = [];
  final List<String> dinner = [];
  List<String> meditations = [];
  List<MedicationModel> meditationDetails = [];
  String? selectedMedication;
  final List<String> blood = [];

  String breakFastDetail = "";
  String lunchDetail = "";
  String snacksDetail = "";
  String dinnerDetail = "";

  final List<String> breakFast = [
    '06:00 AM',
    '06:30 AM',
    '07:00 AM',
    '07:30 AM',
    '08:00 AM',
  ];
  final List<String> lunchList = [
    '12:00 PM',
    '12:30 PM',
    '01:00 PM',
  ];
  final List<String> dinnerList = [
    '08:00 PM',
    '08:30 PM',
    '09:00 PM',
  ];
  final List<String> snackList = [
    '10:00 AM',
    '04:30 PM',
    '05:00 PM',
    '05:30 PM',
  ];

  final List<String> Hydration = [
    '500ML',
    '1L',
    '2L',
    '3L',
    '4L',
    '5L',
    '6L',
    '7L',
    '8L',
    '9L'
  ];
  var selectedOption = '';
  var oralSelection = '';
  var ostomySelection = '';
  var bathingSelection = '';
  var dressingSelection = '';
  var walkingTime = '';
  var medidation = '';
  List<dynamic> selectedOralCareTimings = [];
  List<dynamic> selectedBathingTimings = [];
  List<dynamic> selectedDressingTimings = [];
  List<dynamic> selectedWalkingTimings = [];
  TextEditingController medicalHistoryCT = TextEditingController();
  TextEditingController toileting = TextEditingController();
  TextEditingController bp = TextEditingController();
  TextEditingController bloodSugarTEC = TextEditingController();
  TextEditingController heartRate = TextEditingController();
  TextEditingController hydrationTEC = TextEditingController();
  TextEditingController respiration = TextEditingController();
  TextEditingController temp = TextEditingController();
  TextEditingController activityCT = TextEditingController();
  TextEditingController pastSurgicalCT = TextEditingController();

  bool isLoading = false;
  int? caretakerId;
  bool noDataYet = false;

  int? appointmentId;
  int? patientId;

  //
  loadGetHistory({int? appointmentId, int? patientId}) async {
    this.appointmentId = appointmentId;
    this.patientId = patientId;
    loadingServiceHistory = true;
    update();
    print(appointmentId);
    print(selectedDate.toString());
    try {
      String? token = await SharedPref().getToken();
      final uri = Uri.parse(ApiUrls().ServiceHistory).replace(queryParameters: {
        "appointment_id": appointmentId?.toString(),
        "patient_id": patientId?.toString(),
        "caretaker_id": caretakerId.toString(),
        "appointment_date": selectedDate.toString()
      });

      var res = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        log(data.toString());
        profile = ProfileList.fromJson(data, isReport: true);
        final schedules = profile?.data?.patientSchedules;
        print(schedules?.toJson());
        if (schedules != null) {
          patientSchedules = schedules;
          pastSurgicalCT.text = schedules.patientPastsurgicalhistory ?? "";
          breakfastField.text = schedules.patientBreakfast ?? "";
          lunchField.text = schedules.patientLunch ?? "";
          snacksField.text = schedules.patientSnack ?? "";
          dinnerField.text = schedules.patientDinner ?? "";
          lunchDetail = schedules.patientLunch ?? "";
          snacksDetail = schedules.patientSnack ?? "";
          dinnerDetail = schedules.patientDinner ?? "";
          breakFastDetail = schedules.patientBreakfast ?? "";
          print(breakFastDetail);
          activityCT.text = schedules.patientActivitytype ?? "";
          toileting.text = schedules.patientToileting ?? "";
          temp.text = schedules.patientVitalsigns?.temperature ?? "";
          bp.text = schedules.patientVitalsigns?.bloodPressure ?? "";
          final walkingTimeVal = schedules.patientWalkingtime;
          selectedWalkingTimings =
              walkingTimeVal != null ? jsonDecode(walkingTimeVal) : [];
          print(selectedWalkingTimings);
          heartRate.text =
              schedules.patientVitalsigns?.heartRate?.toString() ?? "";
          respiration.text = schedules.patientVitalsigns?.respiratoryRate ?? "";

          ///
          final breakfastTime = schedules.patientBreakfasttime;
          if (breakfastTime != null && breakfastTime.isNotEmpty) {
            filters.clear();
            filters.add(breakfastTime);
            update();
          }

          print(schedules.patientMedications);
          final medications = schedules.patientMedications;
          if (medications != null && medications.isNotEmpty) {
            medidation = "Morning";
            meditationDetails = [
              MedicationModel(time: "Morning", medicationDetails: []),
              MedicationModel(time: "Noon", medicationDetails: []),
              MedicationModel(time: "Evening", medicationDetails: []),
            ];
            var medicationValues = jsonDecode(medications);
            medicationValues.keys.forEach((time) {
              List<dynamic>? details = medicationValues[time];
              if (details != null) {
                if (time == "Morning") {
                  details.forEach((element) {
                    meditationDetails[0]
                        .medicationDetails!
                        .add(TextEditingController(text: element.toString()));
                  });
                }
                if (time == "Noon") {
                  details.forEach((element) {
                    meditationDetails[1]
                        .medicationDetails!
                        .add(TextEditingController(text: element.toString()));
                  });
                }
                if (time == "Evening") {
                  details.forEach((element) {
                    meditationDetails[2]
                        .medicationDetails!
                        .add(TextEditingController(text: element.toString()));
                  });
                }
              }
            });
            selectedMedication = medidation;
            debugPrint(medidation);
            update();
          }
          final oralCare = schedules.patientOralcare;
          if (oralCare != null && oralCare.isNotEmpty) {
            selectedOralCareTimings = jsonDecode(oralCare);
            debugPrint(medidation);
            update();
          }
          final bathing = schedules.patientBathing;
          if (bathing != null && bathing.isNotEmpty) {
            selectedBathingTimings = jsonDecode(bathing);
            debugPrint(medidation);
            update();
          }
          final dressing = schedules.patientDressing;
          if (dressing != null && dressing.isNotEmpty) {
            selectedDressingTimings = jsonDecode(dressing);
            debugPrint(medidation);
            update();
          }

          final lunchFiltersVal = schedules.patientLunchtime;
          if (lunchFiltersVal != null && lunchFiltersVal.isNotEmpty) {
            lunchFilters.clear();
            lunchFilters.add(lunchFiltersVal);
            update();
          }
          final hydrationVal = schedules.patientHydration;
          if (hydrationVal != null && hydrationVal.isNotEmpty) {
            hydrationTEC.text = hydrationVal;
            update();
          }

          final snacksVal = schedules.patientSnackstime;
          if (snacksVal != null && snacksVal.isNotEmpty) {
            snacks.clear();
            snacks.add(snacksVal);
            update();
          }

          final dinnerVal = schedules.patientDinnertime;
          if (dinnerVal != null && dinnerVal.isNotEmpty) {
            dinner.clear();
            dinner.add(dinnerVal);
            update();
          }
          final bloodSugarVal = schedules.patientBloodsugar;
          if (bloodSugarVal != null && bloodSugarVal.isNotEmpty) {
            bloodSugarTEC.text = bloodSugarVal;
            update();
          }
          noDataYet = false;
          update();
        } else {
          debugPrint("No patient schedules found.");
        }
      } else {
        print('Failed to load history: ${res.statusCode}');
        noDataYet = true;
      }
    } catch (e, s) {
      print('Failed to load history: $s');
    }
    loadingServiceHistory = false;
    update();
  }

  List<VitalsByDay> vitals = [];
  bool loadingVitals = false;

  var avg;

  //
  getVitals() async {
    loadingVitals = true;
    update();
    try {
      String? token = await SharedPref().getToken();
      print(token);
      final uri = Uri.parse(ApiUrls().getVitalsForAppointment)
          .replace(queryParameters: {
        "appointment_id": appointmentId?.toString(),
        "caretaker_id": caretakerId.toString(),
        "patient_id": patientId?.toString(),
      });
      var res = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (res.statusCode == 200) {
        vitals = vitalsModelFromJson(res.body).data?.vitalsByDay ?? [];
        avg = calculateAverage(vitals);
      }
    } catch (e, s) {
      print("Error in getting vitals: $s");
    }
    loadingVitals = false;
    update();
  }

  //
  Map<String, String> calculateAverage(List<VitalsByDay> vitals) {
    double bp = 0;
    double heart = 0;
    double resp = 0;
    double temp = 0;

    int count = vitals.length;

    for (var v in vitals) {
      heart += double.tryParse(v.vitalSigns?.heartRate ?? "0") ?? 0;
      resp += double.tryParse(v.vitalSigns?.respiratoryRate ?? "0") ?? 0;
      temp += double.tryParse(v.vitalSigns?.temperature ?? "0") ?? 0;
    }

    return {
      "bp": averageBloodPressure(
          vitals.map((e) => e.vitalSigns!.bloodPressure!).toList()),
      "heart": (heart / count).toStringAsFixed(0),
      "resp": (resp / count).toStringAsFixed(0),
      "temp": (temp / count).toStringAsFixed(1),
    };
  }

  //
  String averageBloodPressure(List<String> readings) {
    if (readings.isEmpty) return "--/--";

    int systolicSum = 0;
    int diastolicSum = 0;
    int count = 0;

    for (final reading in readings) {
      final parts = reading.split('/');

      if (parts.length != 2) continue;

      final systolic = int.tryParse(parts[0].trim());
      final diastolic = int.tryParse(parts[1].trim());

      if (systolic == null || diastolic == null) continue;

      systolicSum += systolic;
      diastolicSum += diastolic;
      count++;
    }

    if (count == 0) return "--/--";

    final avgSystolic = (systolicSum / count).round();
    final avgDiastolic = (diastolicSum / count).round();

    return "$avgSystolic/$avgDiastolic";
  }
}
