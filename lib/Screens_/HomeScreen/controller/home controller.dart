import 'dart:convert';

import 'package:care2care/constants/api_urls.dart';
import 'package:care2care/sharedPref/sharedPref.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:http/http.dart' as http;
import '../../../modals/Profile_modal.dart' hide CaretakerInfo;
import '../modal/allCaretakers_modal.dart';

class HomeController extends GetxController {
  ViewAllCareTakers? viewAllCareTakers;
  List<CaretakerInfo> careTakerInfo = [];
  bool isLoadingCareTakersList = false;

  fetchAllCaretakersApi() async {
    isLoadingCareTakersList = false;
    update();
    try {
    String? token = await SharedPref().getToken();
    var request = await http.get(
      Uri.parse(ApiUrls().viewAllCareTakers),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (request.statusCode == 200) {
      var res = jsonDecode(request.body);
      viewAllCareTakers = ViewAllCareTakers.fromJson(res);
      if (viewAllCareTakers != null && viewAllCareTakers!.data != null) {
        careTakerInfo =
            viewAllCareTakers!.data!.map((e) => e.caretakerInfo!).toList();
      }
    }
    } catch (e) {
      print('fetchAllCaretakersApi$e');
    }
    isLoadingCareTakersList = false;
    update();
  }

  @override
  void onInit() {
    fetchAllCaretakersApi();
    // TODO: implement onInit
    super.onInit();
  }
}
