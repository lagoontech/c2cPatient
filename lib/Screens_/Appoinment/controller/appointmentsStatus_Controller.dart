import 'dart:convert';

import 'package:care2care/ReusableUtils_/toast2.dart';
import 'package:care2care/Utils/date_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../constants/api_urls.dart';
import '../../../modals/servicehistory_modal.dart';
import '../../../sharedPref/sharedPref.dart';
import '../modal/AppointmentStatus_Modal.dart';

class AppointmentStatusController extends GetxController {
  bool isLoading = false;
  AppointmentStatus? appointmentStatus;
  List<StatusData> statusData = [];

  List<StatusData> RequestAppointment = [];
  List<StatusData> searchedRequestAppointment = [];
  List<StatusData> ApprovedAppointment = [];
  List<StatusData> searchedAppointments = [];
  List<StatusData> CompletedAppointment = [];
  List<StatusData> searchedCompletedAppointment = [];
  List<StatusData> CancelledAppointment = [];
  List<StatusData> ProcessingAppointment = [];
  List<StatusData> searchedProcessingAppointment = [];
  TextEditingController cancelCT = TextEditingController();

  DateTime ?selectedDate;

  int currentTab = 1;
  TextEditingController searchTEC = TextEditingController();
  String ?displayDate;

  Future<void> refreshAppointments() async {
    await fetchAppointments();
    update();
  }

  // Function to fetch and categorize appointments
  Future<void> fetchAppointments() async {
    isLoading = true;
    update();
    try {
      String? token = await SharedPref().getToken();
      var response =
          await http.get(Uri.parse(ApiUrls().appointmentHistory), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        appointmentStatus = AppointmentStatus.fromJson(jsonData);
        statusData = appointmentStatus?.data ?? [];

        RequestAppointment.clear();
        ApprovedAppointment.clear();
        CompletedAppointment.clear();
        ProcessingAppointment.clear();

        // Categorize appointments based on service_status
        for (var appointment in statusData) {
          switch (appointment.serviceStatus) {
            case 'requested':
              RequestAppointment.add(appointment);
              break;
            case 'approved':
              ApprovedAppointment.add(appointment);
              break;
            case 'completed':
              CompletedAppointment.add(appointment);
              break;
            case 'processing':
              ProcessingAppointment.add(appointment);
              break;
          }
          update();
        }
        update();
      } else {
        debugPrint(
            "Failed to fetch appointments, Status Code: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error: $e");
    }
    isLoading = false;
    update();
  }

  Future<void> cancelRequest(
      {int? appId,
      int? careTakerId,
      String? serviceStatus,
      String? cancelReason}) async {
    try {
      String? token = await SharedPref().getToken();

      final response = await http.post(
        Uri.parse(ApiUrls().cancelRequest),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'appointment_id': appId.toString(),
          'caretaker_id': careTakerId.toString(),
          'service_status': serviceStatus,
          'cancel_reason': cancelReason,
        }),
      );

      if (response.statusCode == 200) {
        print('Request cancelled successfully: ${response.body}');
        showCustomToast(
            message: "Cancel Request Successful", gravity: ToastGravity.TOP);
      } else {
        print(
            'Failed to cancel request: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  //
  loadRejectList() async {
    try {
      String? token = await SharedPref().getToken();
      var req = await http.get(
        Uri.parse(ApiUrls().loadCancelRequest),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (req.statusCode == 200) {
        appointmentStatus = appointmentStatusFromJson(req.body);
        CancelledAppointment = appointmentStatus!.data ?? [];
      } else {
        debugPrint("Not load cancel req");
      }
    } catch (e) {
      print(e);
    }
  }
  ServiceHistory? serviceHistory;

  //
  loadGetHistory({int? appointmentId, int? CaretakerId}) async {
    try {
      String? token = await SharedPref().getToken();
      final uri = Uri.parse(ApiUrls().ServiceHistory).replace(queryParameters: {
        "appointment_id": appointmentId?.toString(),
        "caretaker_id": CaretakerId?.toString(),
      });

      var res = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        serviceHistory = ServiceHistory.fromJson(data);
      } else {
        print('Failed to load history: ${res.statusCode}');
      }
    } catch (e) {
      print('Error loading history: $e');
    }
  }

  //
  searchAppointments({bool completedOnly = false}){

    if(completedOnly){
      searchedCompletedAppointment = CompletedAppointment.where((app)
      {
        var hasAppointment = false;
        if(displayDate==null)
          hasAppointment = app.caretaker!.caretakerInfo!.firstName!.toLowerCase().contains(
              searchTEC.text.toLowerCase());
        else if(displayDate!=null && searchTEC.text.isNotEmpty) {
          hasAppointment = app.caretaker!.caretakerInfo!.firstName!.toLowerCase().contains(
              searchTEC.text.toLowerCase()) && displayDate == DateUtils().dateOnlyFormat(app.appointmentDate!);
        }else if(displayDate!=null){
          hasAppointment = displayDate == DateUtils().dateOnlyFormat(app.appointmentDate!);
        }
        return hasAppointment;
      }
      ).toList();
      update();
      return;
    }

    if(currentTab == 0){
      searchedRequestAppointment = RequestAppointment.where((app)
      {
        var hasAppointment = false;
        if(displayDate==null)
          hasAppointment = app.caretaker!.caretakerInfo!.firstName!.toLowerCase().contains(
              searchTEC.text.toLowerCase());
        else if(displayDate!=null && searchTEC.text.isNotEmpty) {
          hasAppointment = app.caretaker!.caretakerInfo!.firstName!.toLowerCase().contains(
              searchTEC.text.toLowerCase()) && displayDate == DateUtils().dateOnlyFormat(app.appointmentDate!);
        }else if(displayDate!=null){
          hasAppointment = displayDate == DateUtils().dateOnlyFormat(app.appointmentDate!);
        }
        return hasAppointment;
      }
      ).toList();
    }
    if(currentTab == 1){
      searchedAppointments = ApprovedAppointment.where((app) {
        var hasAppointment = false;
        if(displayDate==null)
        hasAppointment = app.caretaker!.caretakerInfo!.firstName!.toLowerCase().contains(
            searchTEC.text.toLowerCase());
        else if(displayDate!=null && searchTEC.text.isNotEmpty) {
          hasAppointment = app.caretaker!.caretakerInfo!.firstName!.toLowerCase().contains(
              searchTEC.text.toLowerCase()) && displayDate == DateUtils().dateOnlyFormat(app.appointmentDate!);
        }else if(displayDate!=null){
          hasAppointment = displayDate == DateUtils().dateOnlyFormat(app.appointmentDate!);
        }
        return hasAppointment;
      }
      ).toList();
    }
    if(currentTab == 2){
      searchedProcessingAppointment = ProcessingAppointment.where((app)
      {
        var hasAppointment = false;
        if(displayDate==null)
          hasAppointment = app.caretaker!.caretakerInfo!.firstName!.toLowerCase().contains(
              searchTEC.text.toLowerCase());
        else if(displayDate!=null && searchTEC.text.isNotEmpty) {
          hasAppointment = app.caretaker!.caretakerInfo!.firstName!.toLowerCase().contains(
              searchTEC.text.toLowerCase()) && displayDate == DateUtils().dateOnlyFormat(app.appointmentDate!);
        }else if(displayDate!=null){
          hasAppointment = displayDate == DateUtils().dateOnlyFormat(app.appointmentDate!);
        }
        return hasAppointment;
      }).toList();
    }
    update();
  }

  //
  @override
  void onInit() {
    loadRejectList();
    fetchAppointments();
    super.onInit();
  }
}
