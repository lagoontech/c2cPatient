import 'package:awesome_bottom_bar/tab_item.dart';
import 'package:care2care/constants/api_urls.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:http/http.dart' as http;
import '../../../sharedPref/sharedPref.dart';
import '../../Appoinment/appoinment_view.dart';
import '../../Chat_/ChatListScreen/chat_list_screen.dart';
import '../../HomeScreen/home-screen.dart';
import '../../ProfileDetails/Profile_view.dart';
import '../../caretakerList/careTakerListView.dart';

class BottomNavController extends GetxController {
  int currentIndex = 0;
  final List<Widget> screens = [
    HomePage(),
    CaretakerList(),
    AppointmentView(),
    // ChatListScreen(),
    ProfileDetails(),
  ];
  List<TabItem> items = [
    TabItem(
      icon: IconlyBold.home,
    ),
    TabItem(
      icon: IconlyBold.user_2,
    ),
    TabItem(
      icon: IconlyBold.calendar,
    ),
    /* TabItem(
      icon: Icons.chat_rounded,
    ),*/
    TabItem(
      icon: IconlyBold.profile,
    ),
  ];

  //
  Future<void> updateFCMTokenOnServer(String newToken) async {
    /* try {*/
    String? patientId = await SharedPref().getId();

    if (patientId != null) {
      var response = await http.post(
        Uri.parse(ApiUrls().UpdateFcmToken),
        body: {
          'caretaker_id': patientId,
          'fcm_token': newToken,
        },
        /*  headers: {
            "Content-Type": "application/json",
          },*/
      );

      if (response.statusCode == 200) {
        print("FCM Token updated successfully.");
      } else {
        print("Failed to update FCM Token: ${response.body}");
      }
    } else {
      print("Patient ID is not available.");
    }
    /*   } catch (e) {
      print("Error updating FCM Token on server: $e");
    }*/
  }

  @override
  void onInit() {
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      updateFCMTokenOnServer(newToken);
    });
    super.onInit();

  }
}
