import 'dart:convert';
import 'package:care2care/Utils/date_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../ReusableUtils_/toast2.dart';
import '../../../constants/api_urls.dart';
import '../../../modals/Profile_modal.dart';
import '../../../sharedPref/sharedPref.dart';

class EditProfileController extends GetxController{

  TextEditingController firstName  = TextEditingController();
  TextEditingController lastName   = TextEditingController();
  TextEditingController sexCT      = TextEditingController();
  TextEditingController emailCT    = TextEditingController();
  TextEditingController ageCT      = TextEditingController();
  TextEditingController dobCT      = TextEditingController();
  TextEditingController heightCT   = TextEditingController();
  TextEditingController weightCT   = TextEditingController();
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

  PatientInfo? initialUserDetails;
  ProfileList ?profileList;
  Data? dataList;


  DateTime? dob;
  bool isUserFound = false;
  bool hasFetchedUserDetails = false;
  bool isLoading = false;
  bool isFetchingLocation = false;

  String? token;
  int? patientID;

  bool loadingProfile = true;

  //
  Future<void> fetchCommonDetails() async {
    token = await SharedPref().getToken();
    String? patientIDStr = await SharedPref().getId();
    if (patientIDStr != null) {
      patientID = int.parse(patientIDStr);
    }
  }

  //
  Future<bool> fetchInitialUserDetails() async {

    if (hasFetchedUserDetails) {
      return isUserFound;
    }
    if (token == null || patientID == null) {
      await fetchCommonDetails();
    }
    loadingProfile = true;
    update();

    try {
    var res = await http.get(
      Uri.parse(ApiUrls().patientInfoFetch),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (res.statusCode == 200) {
      var decodeBody     = jsonDecode(res.body);
      profileList        = ProfileList.fromJson(decodeBody);
      initialUserDetails = profileList!.data!.patientInfo;
      update();
      if (initialUserDetails != null) {
        // Populate the text controllers with user details
        firstName.text = initialUserDetails?.firstName ?? '';
        lastName.text = initialUserDetails?.lastName ?? '';
        emailCT.text = initialUserDetails?.email ?? '';
        sexCT.text = initialUserDetails?.sex ?? '';
        dobCT.text = DateUtils().dateOnlyFormat(initialUserDetails!.dob!)?? '';
        dob = initialUserDetails!.dob;
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
        loadingProfile = false;
        update();
        return true;
      }
      update();
    } else {
      print("Error: ${res.statusCode} - ${res.body}");
    }
    } catch (e) {
      print("Exception occurred: $e");
    }
    loadingProfile = false;
    update();
    print("loading profile-->$loadingProfile");
    return false;
  }

  //
  updateInitialProfileDetails() async {
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
        "sex": sexCT.text,
        "age": ageCT.text,
        "email":emailCT.text,
        "dob": DateUtils().parsableDate(dob!),
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
        Get.back();
        showCustomToast(message: "Updated successfully");
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

  //
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

  @override
  void onInit() {
    super.onInit();
    fetchInitialUserDetails();
  }

}