import 'package:awesome_bottom_bar/tab_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

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
}
