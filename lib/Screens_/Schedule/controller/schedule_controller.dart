import 'dart:convert';
import 'dart:io';
import 'package:care2care/Screens_/Schedule/modal/medication_model.dart';
import 'package:care2care/constants/api_urls.dart';
import 'package:care2care/modals/Profile_modal.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import '../../../ReusableUtils_/toast2.dart';
import '../../../sharedPref/sharedPref.dart';
import '../../HomeView/home_view.dart';
import '../../Profile/modal/initilaProfileDetailsModal.dart' hide PatientInfo;

class ScheduleController extends GetxController {

  final List<String> filters = [];
  final List<String> lunchFilters = [];
  final List<String> snacks = [];
  final List<String> dinner = [];
  List<String> meditations = [];
  List<MedicationModel> meditationDetails = [];
  String ?selectedMedication;
  final List<String> hydration = [];
  final List<String> blood = [];

  var DietItems = [
    Diet(name: 'Regular Diet', id: 1),
    Diet(name: 'Clear Liquid Diet', id: 2),
    Diet(name: 'Full Liquid Diet', id: 3),
    Diet(name: 'Cardiac Diet (2 g sodium, low cholesterol, low-fat)', id: 4),
    Diet(
        name: 'Cardiac/Diabetic (2 g or 3 g sodium, low-cholesterol, low-fat)',
        id: 5),
    Diet(name: 'Renal Diet', id: 6),
    Diet(name: 'Non Regular Diet', id: 7),
  ];

  var medicalHistory = [
    MedicalHistory(name: 'Anemia', id: 1),
    MedicalHistory(name: 'Arthritis', id: 2),
    MedicalHistory(name: 'Asthma', id: 3),
    MedicalHistory(name: 'Bad teeth', id: 4),
    MedicalHistory(name: 'Bleeding problem', id: 5),
    MedicalHistory(name: 'Blood clots', id: 6),
    MedicalHistory(name: 'Cancer', id: 7),
    MedicalHistory(name: 'COPD', id: 8),
    MedicalHistory(name: 'Depression', id: 9),
    MedicalHistory(name: 'Diabetes', id: 10),
    MedicalHistory(name: 'Drug or alcohol problem', id: 11),
    MedicalHistory(name: 'GERD/acid reflux', id: 12),
    MedicalHistory(name: 'Glaucoma', id: 13),
    MedicalHistory(name: 'Gout', id: 14),
    MedicalHistory(name: 'Hearing problem', id: 15),
    MedicalHistory(name: 'Heart attack', id: 16),
    MedicalHistory(name: 'Heart disease', id: 17),
    MedicalHistory(name: 'Hepatitis', id: 18),
    MedicalHistory(name: 'High blood pressure', id: 19),
    MedicalHistory(name: 'HIV/AIDS', id: 20),
    MedicalHistory(name: 'Kidney/bladder infections', id: 21),
    MedicalHistory(name: 'Kidney stones', id: 22),
    MedicalHistory(name: 'Liver problem', id: 23),
    MedicalHistory(name: 'Lupus', id: 24),
    MedicalHistory(name: 'MRSA', id: 25),
    MedicalHistory(name: 'Osteoporosis', id: 26),
    MedicalHistory(name: 'Prostate problem', id: 27),
    MedicalHistory(name: 'Psoriasis', id: 28),
    MedicalHistory(name: 'Psychiatric problem', id: 29),
    MedicalHistory(name: 'Rheumatoid arthritis', id: 30),
    MedicalHistory(name: 'Scoliosis', id: 31),
    MedicalHistory(name: 'Seizures', id: 32),
    MedicalHistory(name: 'Stroke', id: 33),
    MedicalHistory(name: 'Thyroid problem', id: 34),
    MedicalHistory(name: 'Tuberculosis', id: 35),
    MedicalHistory(name: 'Ulcerative colitis/Crohn\'s', id: 36),
    MedicalHistory(name: 'Ulcers', id: 37),
    MedicalHistory(name: 'Other', id: 38),
  ];

  //ScheduleModal? scheduleModal;
  ProfileList? profile;
  final List<String> breakFast = [
    '06.00 AM',
    '06.30 AM',
    '07.00 AM',
    '07.30 AM',
    '08.00 AM',
  ];
  final List<String> lunchList = [
    '12:00 PM',
    '12.30 PM',
    '01.00 PM',
  ];
  final List<String> dinnerList = [
    '08:00 PM',
    '08.30 PM',
    '09.00 PM',
  ];
  final List<String> snackList = [
    '10:00 AM',
    '04.30 PM',
    '05.00 PM',
    '05.30 PM',
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
  var selectedHydration = "";
  var selectedOption = '';
  var oralSelection = '';
  var ostomySelection = '';
  var bathingSelection = '';
  var dressingSelection = '';
  var walkingTime = '';
  var medidation = '';
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

//var item = [DropdownItem(label: "sujin", value: 3)];
  List<Diet> diet = [];
  List<MedicalHistory> medicalHistoryList = [];
  PatientSchedules? patientSchedules;

  // Common variables
  String? token;
  int? patientID;

  bool updating = false;
  bool inserting = false;

  Future<void> fetchCommonDetails() async {
    token = await SharedPref().getToken();
    String? patientIDStr = await SharedPref().getId();
    if (patientIDStr != null) {
      patientID = int.parse(patientIDStr);
    }
  }

  // Helper function to format time
  String formatTime(String time) {
    final parts = time.split(' ');
    if (parts.length != 2)
      return time;
    final timeParts = parts[0].split('.');

    int hours = int.parse(timeParts[0]);
    final minutes = '00';

    if (parts[1] == 'PM' && hours < 12) {
      hours += 12;
    } else if (parts[1] == 'AM' && hours == 12) {
      hours = 0;
    }

    return '${hours.toString().padLeft(2, '0')}:${minutes}';
  }

  InsertPrimaryInformationAndScheduleApi() async {
    inserting = true;
    update();
    try {
      String? patientIDStr = await SharedPref().getId();
      Map<String, dynamic> params = {
        'patient_id': int.parse(patientIDStr!),
        "patient_dietplan": diet.map((e) => e.name).toList(),
        "patient_activitytype": activityCT.text,
        "patient_pastmedicalhistory": medicalHistoryList.map((e) => e.name).toList(),
        "patient_pastsurgicalhistory": pastSurgicalCT.text,
        "patient_breakfasttime": filters.isNotEmpty ? filters.first : null, // Access as string
        "patient_lunchtime": lunchFilters.isNotEmpty ? lunchFilters.first : null, // Access as string
        "patient_dinnertime": dinner.isNotEmpty ? dinner.first : null, // Access as string
        "patient_snackstime": snacks.isNotEmpty ? snacks.first : null, // Access as string
        "patient_medications": {
          "Morning": meditationDetails.firstWhere((element) => element.time=="Morning").medicationDetails!.map((e) => e.text).toList(),
          "Noon": meditationDetails.firstWhere((element) => element.time=="Noon").medicationDetails!.map((e) => e.text).toList(),
          "Evening": meditationDetails.firstWhere((element) => element.time=="Evening").medicationDetails!.map((e) => e.text).toList()
        },
        "patient_hydration": hydrationTEC.text,
        "patient_oralcare": oralSelection,
        "patient_bathing": bathingSelection,
        "patient_dressing": dressingSelection,
        "patient_toileting": toileting.text,
        "patient_walkingtime": walkingTime, // This remains unchanged
        "patient_vitalsigns": {
          "blood_pressure": bp.text,
          "heart_rate": heartRate.text,
          "respiratory_rate": respiration.text,
          "temperature": temp.text,
          "weight": '90',
        },
        "patient_bloodsugar": bloodSugarTEC.text,
        // Populate as needed
      };
      var res = await http.post(
        Uri.parse(ApiUrls().addPatientSchedule),
        body: jsonEncode(params),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (res.statusCode == 200) {
        onUserDetailsCompleted();
        Get.offAll(() => HomeView());
        print(res.body);
        debugPrint("succssfully");
      } else {
        debugPrint("not Succeesfully");
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    inserting = false;
    update();

  }

  updateInformationAndScheduleApi() async {
    updating = true;
    update();
    try {
      String? patientIDStr = await SharedPref().getId();
      Map<String, dynamic> params = {
        'patient_id': int.parse(patientIDStr!),
        "patient_dietplan": diet.map((e) => e.name).toList(),
        "patient_activitytype": activityCT.text,
        "patient_pastmedicalhistory": medicalHistoryList.map((e) => e.name).toList(),
        "patient_pastsurgicalhistory": pastSurgicalCT.text,
        "patient_breakfasttime": filters.isNotEmpty ? filters.first : null, // Access as string
        "patient_lunchtime": lunchFilters.isNotEmpty ? lunchFilters.first : null, // Access as string
        "patient_dinnertime": dinner.isNotEmpty ? dinner.first : null, // Access as string
        "patient_snackstime": snacks.isNotEmpty ? snacks.first : null, // Access as string
        "patient_medications": {
          "Morning": meditationDetails.firstWhere((element) => element.time=="Morning").medicationDetails!.map((e) => e.text).toList(),
          "Noon": meditationDetails.firstWhere((element) => element.time=="Noon").medicationDetails!.map((e) => e.text).toList(),
          "Evening": meditationDetails.firstWhere((element) => element.time=="Evening").medicationDetails!.map((e) => e.text).toList()
        },
        "patient_hydration": hydrationTEC.text,
        "patient_oralcare": oralSelection,
        "patient_bathing": bathingSelection,
        "patient_dressing": dressingSelection,
        "patient_toileting": toileting.text,
        "patient_walkingtime": walkingTime, // This remains unchanged
        "patient_vitalsigns": {
          "blood_pressure": bp.text,
          "heart_rate": heartRate.text,
          "respiratory_rate": respiration.text,
          "temperature": temp.text,
          "weight": '90',
        },
        "patient_bloodsugar": bloodSugarTEC.text,
        // Populate as needed
      };

      var res = await http.put(
        Uri.parse(ApiUrls().editPatientScheduleAndUpdate),
        body: jsonEncode(params),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (res.statusCode == 200) {
        onUserDetailsCompleted();
        Get.back();
        showCustomToast(message: "Updated successfully");
        debugPrint("succssfully");
      } else {
        debugPrint("not Succeesfully");
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    updating = false;
    update();
  }


  //
  setInitialMedication(){

    medidation = "Morning";
    selectedMedication = "Morning";
    meditationDetails = [
      MedicationModel(time: "Morning",medicationDetails: []),
      MedicationModel(time: "Noon",medicationDetails: []),
      MedicationModel(time: "Evening",medicationDetails: []),
    ];
  }

  Future<void> fetchPrimaryInformationApi() async {
    /*  try {*/
    String? token = await SharedPref().getToken();
    String? patientIDStr = await SharedPref().getId();

    var response = await http.get(
      Uri.parse(ApiUrls().patientInfoFetch),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      profile = ProfileList.fromJson(jsonResponse);
      update();
      if (profile!.data != null && profile!.data!.patientSchedules != null) {
        patientSchedules = profile!.data!.patientSchedules!;
        pastSurgicalCT.text =
            patientSchedules!.patientPastsurgicalhistory!.toString();
        activityCT.text = patientSchedules!.patientActivitytype!;
        toileting.text = patientSchedules!.patientToileting!;
        temp.text = 120.toString();
        bp.text = patientSchedules!.patientVitalsigns!.bloodPressure!;
        walkingTime = patientSchedules!.patientWalkingtime!;
        heartRate.text =
            patientSchedules!.patientVitalsigns!.heartRate.toString();
        respiration.text =
            patientSchedules!.patientVitalsigns!.respiratoryRate!;

        //DietPlan

        diet = patientSchedules!.patientDietplan!.map((e) {
          return Diet(name: e, id: e.length);
        }).toList();

        //MedicalHistory
        medicalHistoryList =
            patientSchedules!.patientPastmedicalhistory!.map((e) {
          return MedicalHistory(name: e, id: e.length);
        }).toList();

        ///
        if (patientSchedules!.patientBreakfasttime != null &&
            patientSchedules!.patientBreakfasttime!.isNotEmpty) {
          filters.clear();
          filters.add(patientSchedules!.patientBreakfasttime!);
          update();
        }

        if (patientSchedules!.patientMedications != null &&
            patientSchedules!.patientMedications!.isNotEmpty) {
          medidation = "Morning";
          meditationDetails = [
            MedicationModel(time: "Morning",medicationDetails: []),
            MedicationModel(time: "Noon",medicationDetails: []),
            MedicationModel(time: "Evening",medicationDetails: []),
          ];
          var medicationValues = jsonDecode(patientSchedules!.patientMedications!);
          medicationValues.keys.forEach((time) {
            List<dynamic> ?details = medicationValues[time];
            if(time == "Morning"){
              details!.forEach((element) {
                meditationDetails[0].medicationDetails!.add(TextEditingController(text:element.toString()));
              });
            }
            if(time == "Noon"){
              details!.forEach((element) {
                meditationDetails[1].medicationDetails!.add(TextEditingController(text:element.toString()));
              });
            }
            if(time == "Evening"){
              details!.forEach((element) {
                meditationDetails[2].medicationDetails!.add(TextEditingController(text:element.toString()));
              });
            }
          });
          selectedMedication = medidation;
          debugPrint(medidation);
          update();
        }
        if (patientSchedules!.patientOralcare != null &&
            patientSchedules!.patientOralcare!.isNotEmpty) {
          oralSelection = patientSchedules!.patientOralcare!;
          debugPrint(medidation);
          update();
        }
        if (patientSchedules!.patientBathing != null &&
            patientSchedules!.patientBathing!.isNotEmpty) {
          bathingSelection = patientSchedules!.patientBathing!;
          debugPrint(medidation);
          update();
        }
        if (patientSchedules!.patientDressing != null &&
            patientSchedules!.patientDressing!.isNotEmpty) {
          dressingSelection = patientSchedules!.patientDressing!;
          debugPrint(medidation);
          update();
        }

        if (patientSchedules!.patientLunchtime != null &&
            patientSchedules!.patientLunchtime!.isNotEmpty) {
          lunchFilters.clear();
          lunchFilters.add(patientSchedules!.patientLunchtime!);
          update();
        }
        if (patientSchedules!.patientHydration != null &&
            patientSchedules!.patientHydration!.isNotEmpty) {
          hydrationTEC.text = patientSchedules!.patientHydration!;
          update();
        }

        if (patientSchedules!.patientSnackstime != null &&
            patientSchedules!.patientSnackstime!.isNotEmpty) {
          snacks.clear();
          snacks.add(patientSchedules!.patientSnackstime!);
          update();
        }

        if (patientSchedules!.patientDinnertime != null &&
            patientSchedules!.patientDinnertime!.isNotEmpty) {
          dinner.clear();
          dinner.add(patientSchedules!.patientDinnertime!);
          update();
        }
        if (patientSchedules!.patientBloodsugar != null &&
            patientSchedules!.patientBloodsugar!.isNotEmpty) {
          bloodSugarTEC.text = patientSchedules!.patientBloodsugar!;
          update();
        }
        update();
        debugPrint(
            "Fetched patient schedules: ${profile!.data!.patientSchedules?.toJson()}");
      } else {
        debugPrint("No patient schedules found.");
      }
    } else {
      debugPrint("Status code: ${response.statusCode}");
    }
    /*} catch (e) {
      debugPrint("Error: $e");
    }*/
  }

  //imageUploadProcess

  File? selectImage;
  ImagePicker imagePicker = ImagePicker();
  bool uploadLoading = false;

  pickImage(ImageSource imageSource, BuildContext context) async {
    XFile? image = await imagePicker.pickImage(source: imageSource);
    if (image != null) {
      selectImage = File(image.path);
      update();
      debugPrint("Image selected: ${selectImage?.path}");
      await profileImageUpload();
      update();
    }
    Navigator.pop(context);
  }

  profileImageUpload() async {
    if (selectImage == null) {
      debugPrint("No image selected for upload");
      return;
    }
    uploadLoading = true;
    update();
    try {
      String? patientId = await SharedPref().getId();
      String? token = await SharedPref().getToken();
      String fileName = path.basename(selectImage!.path);
      debugPrint("File Name: $fileName");
      var req =
          await http.MultipartRequest('POST', Uri.parse(ApiUrls().uploadImage));
      debugPrint(req.fields.toString());
      req.files.add(await http.MultipartFile.fromPath(
          'profile_image_url', selectImage!.path,
          filename: fileName));
      req.fields['id'] = patientId!;
      req.headers['Content-Type'] = 'multipart/form-data';
      if (token != null) {
        req.headers['Authorization'] = 'Bearer $token';
      }
      var response = await req.send();
      update();
      if (response.statusCode == 200) {
        final responseData = await response.stream.toBytes();
        final responseString = String.fromCharCodes(responseData);
        final Map<String, dynamic> jsonResponse = jsonDecode(responseString);
        String newImageUrl = jsonResponse['image'];
        profile!.data!.profileImageUrl = newImageUrl;
        print("newImageUrl$newImageUrl");
        print("uploadResponse$jsonResponse");
        update();
      } else {}
    } catch (e) {
      debugPrint(e.toString());
    }
    uploadLoading = false;
    update();
  }

  deleteProfileImage() async {
    try {
      String? token = await SharedPref().getToken();
      var res = await http.post(
        Uri.parse(ApiUrls().deleteImage),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );
      if(res.statusCode ==200 ){
        selectImage = null;
        profile!.data!.profileImageUrl = 'default-profile-img-female.png';
        update();
        showCustomToast(message: 'Successfully Removed');
      }else{
        showCustomToast(message: 'Not Successfully Removed');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }


  @override
  void onInit() {
    fetchPrimaryInformationApi();
    fetchCommonDetails();
    super.onInit();
  }

  void onUserDetailsCompleted() {
    SharedPref().setRegisterComplete(true);
  }
}
