import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:care2care/Screens_/caretakerList/Models/caretakers_list_model.dart';
import 'package:care2care/constants/api_urls.dart';
import 'package:care2care/sharedPref/sharedPref.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../modals/Profile_modal.dart' hide CaretakerInfo;
import '../modal/allCaretakers_modal.dart';
import '../modal/top_care_takers_model.dart';

class HomeController extends GetxController {
  ViewAllCareTakers? viewAllCareTakers;
  List<CaretakerInfo> careTakerInfo = [];
  List<CaretakerData> topCaretakers = [];
  List<CaretakersListData> careTakers = [];
  bool isLoadingCareTakersList = false;
  bool isLoadingTopCareTakers = false;
  TextEditingController searchTEC = TextEditingController();

  double rating = 0.0;
  double maxPrice = 1000.0;
  RangeValues priceRange = const RangeValues(0.0, 1000.0);
  String profilePath = "";
  Timer? searchTimer;
  int page = 1;
  String? gender = "";
  RefreshController refreshController = RefreshController();

  //
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
          print(careTakerInfo[0].address);
        }
      }
    } catch (e,s) {
      print('fetchAllCaretakersApi$s');
    }
    isLoadingCareTakersList = false;
    update();

  }

  //
  debounceSearch() {
    if (searchTimer != null && searchTimer!.isActive) {
      searchTimer!.cancel();
    }
    searchTimer = Timer(Duration(milliseconds: 750), () {
      getCareTakers();
    });
  }

  //
  getCareTakers({bool loading = false}) async {
    if (loading) {
      page++;
    } else {
      isLoadingCareTakersList = true;
      page = 1;
      update();
    }
    try {
      String? token = await SharedPref().getToken();
      var result = await http.get(
        Uri.parse(ApiUrls().viewAllCareTakers +
            "?name=${searchTEC.text}&gender=$gender&rating=${int.parse(rating.toStringAsFixed(0))}"
                "&min_price=${priceRange.start}&max_price=${priceRange.end}&page=$page"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (result.statusCode == 200) {
        log(result.body);
        final model = caretakersListModel(result.body);
        profilePath = model.profilePath;
        if (!loading) {
          careTakers = model.data.data;
        } else {
          careTakers.addAll(model.data.data);
        }

        // Calculate max price from the list
        double highest = 0.0;
        for (var item in careTakers) {
          final val = double.tryParse(item.caretakerInfo.serviceCharge) ?? 0.0;
          if (val > highest) {
            highest = val;
          }
        }
        if (highest <= 0.0) {
          highest = 1000.0; // Fallback if list is empty or charges are 0
        }
        if (priceRange.start > highest) {
          priceRange = RangeValues(0.0, highest);
        } else if (priceRange.end > highest || priceRange.end == maxPrice) {
          priceRange = RangeValues(priceRange.start, highest);
        }
        maxPrice = highest;

        print("caretakers-->${careTakers.length}");
      }
    } catch (e, s) {
      print(e);
      print(s);
    }
    if (!loading) {
      refreshController.refreshCompleted();
    } else {
      refreshController.loadComplete();
    }
    isLoadingCareTakersList = false;
    update();
  }

  //
  fetchTopCaretakers() async {
    isLoadingTopCareTakers = true;
    update();
    print("fetching top caretakers");
    try {
      String? token = await SharedPref().getToken();
      var result = await http.get(Uri.parse(ApiUrls().topCaretakers), headers: {
        "authorization": "Bearer $token",
        "Content-Type": "application/json"
      });
      if (result.statusCode == 200) {
        topCaretakers = welcomeFromJson(result.body).data;
        profilePath = welcomeFromJson(result.body).profilePath;
        print('topCaretakers-->${topCaretakers.length}');
      }
    } catch (e, s) {
      print(s);
    }
    isLoadingTopCareTakers = false;
    update();
  }

  //
  @override
  void onInit() {
    super.onInit();
    //fetchAllCaretakersApi();
    fetchTopCaretakers();
    getCareTakers();
  }
}
