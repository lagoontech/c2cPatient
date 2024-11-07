import 'package:flutter/cupertino.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import '../../Profile/Controller/initila_profile_controller.dart';

class LocationController extends GetxController {
  TextEditingController locationCT = TextEditingController();



  @override
  void onInit() {
    super.onInit();
    InitialProfileDetails().fetchInitialUserDetails();
    locationCT.addListener(() {
      update();
    });
  }

  @override
  void onClose() {
    locationCT.dispose();
    super.onClose();
  }

}
