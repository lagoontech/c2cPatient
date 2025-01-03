import 'dart:convert';


import 'package:care2care/ReusableUtils_/toast2.dart';
import 'package:care2care/Screens_/Document_Upload/controller/document_upload_controller.dart';
import 'package:care2care/constants/api_urls.dart';
import 'package:care2care/sharedPref/sharedPref.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../modals/Profile_modal.dart';
import '../../PrimaryInformation/primaryInformation_view.dart';


class InitialProfileDetails extends GetxController {
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController sexCT = TextEditingController(text: "Male");
  TextEditingController emailCT = TextEditingController();
  TextEditingController ageCT = TextEditingController();
  TextEditingController dobCT = TextEditingController();
  TextEditingController heightCT = TextEditingController();
  TextEditingController weightCT = TextEditingController();
  TextEditingController locationCT = TextEditingController();
  TextEditingController nationalityCT = TextEditingController();
  TextEditingController addressCT = TextEditingController();
  TextEditingController diagnosisCT = TextEditingController();
  TextEditingController primary_care_giver_nameCT = TextEditingController();
  TextEditingController specialist_nameCT = TextEditingController();
  TextEditingController bmiCT = TextEditingController();
  TextEditingController primaryContactNameCT = TextEditingController();
  TextEditingController primaryContactNumberCT = TextEditingController();
  TextEditingController secondaryNameCT = TextEditingController();
  TextEditingController secondaryNumberCT = TextEditingController();
  TextEditingController specialListNumberCT = TextEditingController();
  TextEditingController moreInfoCT = TextEditingController();

  //TextEditingController fullNameCt = TextEditingController();
  PatientInfo? initialUserDetails;
  ProfileList ?profileList;
  Data?dataList;


  DateTime? dob;
  bool isUserFound = false;
  bool hasFetchedUserDetails = false;
  bool isLoading = false;
  bool isFetchingLocation = false;


  // Common variables
  String? token;
  int? patientID;

  @override
  void onInit() {
    super.onInit();
    fetchCommonDetails();
    heightCT.addListener(calculateBMI);
    weightCT.addListener(calculateBMI);
    fetchInitialUserDetails();
  }

  // Method to fetch token and patientID once and store them
  Future<void> fetchCommonDetails() async {
    token = await SharedPref().getToken();
    String? patientIDStr = await SharedPref().getId();
    if (patientIDStr != null) {
      patientID = int.parse(patientIDStr);
    }
  }

  Future<void> selectDob(BuildContext context) async {
    DateTime? pickDob = await showDatePicker(
        context: context,
        initialDate: dob ?? DateTime.now(),
        firstDate: DateTime(1000),
        lastDate: DateTime(2101));
    if (pickDob != null && pickDob != dob) {
      dob = pickDob;
      dobCT.text = DateFormat('yyyy-MM-dd').format(dob!);
      int age = calculateAge(dob!);
      ageCT.text = age.toString();
      update();
    }
  }

  // calculate age when select the dob

  int calculateAge(DateTime birthDate) {
    DateTime today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  //calculate BMI calculate

  void calculateBMI() {
    double height = double.tryParse(heightCT.text) ?? 0;
    double weight = double.tryParse(weightCT.text) ?? 0;

    if (height > 0) {
      double bmi = weight / ((height / 100) * (height / 100));
      bmiCT.text = bmi.toStringAsFixed(2);
    } else {
      bmiCT.text = "";
    }

    update();
  }

  //add Profile Details

  addInitialProfileDetails() async {
    isLoading = true;
    update();

    try {
      if (token == null || patientID == null) {
        await fetchCommonDetails();
      }
      Map<String, dynamic> params = {
        "patient_id": patientID,
        "first_name": firstName.text,
        "last_name": lastName.text,
        "sex": sexCT.text.toLowerCase(),
        "age": ageCT.text,
        "dob": dobCT.text,
        "email":emailCT.text,
        "bmi": bmiCT.text,
        "height": heightCT.text,
        "weight": weightCT.text,
        'location': locationCT.text,
        'nationality': nationalityCT.text,
        "address": addressCT.text,
        'diagnosis': diagnosisCT.text,
        "primary_care_giver_name": primary_care_giver_nameCT.text,
        "primary_contact_name": primaryContactNameCT.text,
        "primary_contact_number": primaryContactNumberCT.text,
        "secondary_contact_name": secondaryNameCT.text,
        "secondary_contact_number": secondaryNumberCT.text,
        "specialist_name": specialist_nameCT.text,
        "specialist_contact_number": secondaryNumberCT.text,
        "moreinfo": moreInfoCT.text
      };

      var res = await http.post(
        Uri.parse(ApiUrls().patientInfoAdd),
        body: jsonEncode(params),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );
      if (res.statusCode == 200) {
        //await ScheduleController().fetchPrimaryInformationApi();
        Get.to(() => PrimaryInformationView());
        print("Profile details added successfully");
      } else if(res.statusCode == 422){
        var response = jsonDecode(res.body) as Map<String,dynamic>;
        response.keys.forEach((element) {
          var errorMsg = response[element][0];
          showCustomToast(message: errorMsg);
        });
      } else {
        var errorMsg = jsonDecode(res.body)['message'] ?? 'Error occurred';
        showCustomToast(message: errorMsg);
        debugPrint('not successfully update');
      }
    } catch (w) {
      print(w);
    }
    isLoading = false;
    update();
  }

  //update Profile Details if user already found in db

  updateInitialProfileDetails() async {
    isLoading = true;
    update();
   try {
      if (token == null || patientID == null) {
        await fetchCommonDetails();
      }
      DateTime parsed = DateTime.parse(dobCT.text);
      Map<String, dynamic> params = {
        "patient_id": patientID,
        "first_name": firstName.text,
        "last_name": lastName.text,
        "sex": sexCT.text,
        "age": ageCT.text,
        "email":emailCT.text,
        "dob": DateFormat('yyyy-MM-dd').format(parsed),
        "bmi": bmiCT.text,
        "height": heightCT.text,
        "weight": weightCT.text,
        'location': locationCT.text,
        'nationality': nationalityCT.text,
        "address": addressCT.text,
        'diagnosis': diagnosisCT.text,
        "primary_care_giver_name": primary_care_giver_nameCT.text,
        "primary_contact_name": primaryContactNameCT.text,
        "primary_contact_number": primaryContactNumberCT.text,
        "secondary_contact_name": secondaryNameCT.text,
        "secondary_contact_number": secondaryNumberCT.text,
        "specialist_name": specialist_nameCT.text,
        "specialist_contact_number": secondaryNumberCT.text,
        "moreinfo": moreInfoCT.text
      };

      print('params$params');
      var res = await http.put(
        Uri.parse(ApiUrls().patientInfoUpdate),
        body: jsonEncode(params),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );
      if (res.statusCode == 200) {
        update();
        Get.to(() => PrimaryInformationView());
        // await ScheduleController().fetchPrimaryInformationApi();
        debugPrint('successfully update');
      } else {
        var errorMsg = jsonDecode(res.body)['message'] ?? 'Error occurred';
        showCustomToast(message: errorMsg);
        debugPrint('not successfully update');
      }
    } catch (w) {
      print(w);
    }
    isLoading = false;
    update();
  }



  bool isProfileLoad = false;
  Future<bool> fetchInitialUserDetails() async {

    if (hasFetchedUserDetails) {
      return isUserFound;
    }
    if (token == null || patientID == null) {
      await fetchCommonDetails();
    }
    isProfileLoad = true;
    update();

 //   try {
      var res = await http.get(
        Uri.parse(ApiUrls().patientInfoFetch),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (res.statusCode == 200) {
        var decodeBody = jsonDecode(res.body);
        profileList = ProfileList.fromJson(decodeBody);
        initialUserDetails = profileList!.data!.patientInfo;
        update();
        if (initialUserDetails != null) {
          // Populate the text controllers with user details
          firstName.text = initialUserDetails?.firstName ?? '';
          lastName.text = initialUserDetails?.lastName ?? '';
          emailCT.text = initialUserDetails?.email ?? '';
          sexCT.text = initialUserDetails?.sex ?? '';
          dobCT.text = initialUserDetails?.dob?.toIso8601String() ?? '';
          ageCT.text = initialUserDetails?.age.toString() ?? '';
          heightCT.text = initialUserDetails?.height.toString() ?? '';
          weightCT.text = initialUserDetails?.weight.toString() ?? '';
          locationCT.text = initialUserDetails?.location ?? '';
          nationalityCT.text = initialUserDetails?.nationality ?? '';
          addressCT.text = initialUserDetails?.address ?? '';
          diagnosisCT.text = initialUserDetails?.diagnosis ?? '';
          primary_care_giver_nameCT.text =
              initialUserDetails?.primaryCareGiverName ?? '';
          specialist_nameCT.text = initialUserDetails?.specialistName ?? '';
          bmiCT.text = initialUserDetails?.bmi.toString() ?? '';
          primaryContactNameCT.text =
              initialUserDetails?.primaryContactName ?? '';
          primaryContactNumberCT.text =
              initialUserDetails?.primaryContactNumber ?? '';
          secondaryNameCT.text = initialUserDetails?.secondaryContactName ?? '';
          secondaryNumberCT.text =
              initialUserDetails?.secondaryContactNumber ?? '';
          specialListNumberCT.text =
              initialUserDetails?.specialistContactNumber ?? '';
          moreInfoCT.text = initialUserDetails?.moreinfo ?? '';
          update();
          return true;
        }
        update();
      } else {
        print("Error: ${res.statusCode} - ${res.body}");
      }
    /*} catch (e) {
      print("Exception occurred: $e");
    }*/
    isProfileLoad = false;
    update();
    return false;
  }
  bool isUpdated = false;


  void addListeners() {
    firstName.addListener(() => trackChanges());
    lastName.addListener(() => trackChanges());
    sexCT.addListener(() => trackChanges());
    emailCT.addListener(() => trackChanges());
    ageCT.addListener(() => trackChanges());
    dobCT.addListener(() => trackChanges());
    heightCT.addListener(() => trackChanges());
    weightCT.addListener(() => trackChanges());
    locationCT.addListener(() => trackChanges());
    nationalityCT.addListener(() => trackChanges());
    addressCT.addListener(() => trackChanges());
    diagnosisCT.addListener(() => trackChanges());
    primary_care_giver_nameCT.addListener(() => trackChanges());
    primaryContactNameCT.addListener(() => trackChanges());
    primaryContactNumberCT.addListener(() => trackChanges());
    secondaryNameCT.addListener(() => trackChanges());
    secondaryNumberCT.addListener(() => trackChanges());
    specialist_nameCT.addListener(() => trackChanges());
    moreInfoCT.addListener(() => trackChanges());
  }

  void trackChanges() {
    // Compare the current values with initial values
    if (firstName.text != initialUserDetails?.firstName ||
        lastName.text != initialUserDetails?.lastName ||
        sexCT.text != initialUserDetails?.sex ||
        emailCT.text != initialUserDetails?.email ||
        ageCT.text != initialUserDetails?.age.toString() ||
        dobCT.text != initialUserDetails?.dob?.toIso8601String() ||
        heightCT.text != initialUserDetails?.height.toString() ||
        weightCT.text != initialUserDetails?.weight.toString() ||
        locationCT.text != initialUserDetails?.location ||
        nationalityCT.text != initialUserDetails?.nationality ||
        addressCT.text != initialUserDetails?.address ||
        diagnosisCT.text != initialUserDetails?.diagnosis ||
        primary_care_giver_nameCT.text != initialUserDetails?.primaryCareGiverName ||
        primaryContactNameCT.text != initialUserDetails?.primaryContactName ||
        primaryContactNumberCT.text != initialUserDetails?.primaryContactNumber ||
        secondaryNameCT.text != initialUserDetails?.secondaryContactName ||
        secondaryNumberCT.text != initialUserDetails?.secondaryContactNumber ||
        specialist_nameCT.text != initialUserDetails?.specialistName ||
        moreInfoCT.text != initialUserDetails?.moreinfo) {
      isUpdated = true;
    } else {
      isUpdated = false;
    }
    update();
  }



  //getCurrentLocation and show the location name

  Future<void> getCurrentLocation() async {
    isFetchingLocation = true;
    update();
    try {
      bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
      if (!isLocationEnabled) {
        showCustomToast(message: "Please Enable location");
        isFetchingLocation = false;
        update();
        return;
      }
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          showCustomToast(message: 'Location permission denied.');
          isFetchingLocation = false;
          update();
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        showCustomToast(message: "Location permissions are permanently denied");
        isFetchingLocation = false;
        update();
      }
      Position position = await Geolocator.getCurrentPosition();

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      Placemark place = placemarks[0];
      String address =
          "${place.locality}, ${place.postalCode}, ${place.country}";
      locationCT.text = address;
      update();
      showCustomToast(message: 'Location updated successfully!');
    } catch (e) {
      print(e);
    }
    isFetchingLocation = false;
    update();
  }

  allowLocationAccess() async {
    var permissionStatus = await Permission.location.status;

    if (permissionStatus.isDenied || permissionStatus.isRestricted) {
      await Permission.location.request();
    }
    if (permissionStatus.isGranted) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
    } else if (permissionStatus.isPermanentlyDenied) {
      openAppSettings();
    }
  }

}
