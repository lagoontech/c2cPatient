import 'dart:async';
import 'dart:convert';

import 'package:care2care/Screens_/caretakerList/Models/caretakers_list_model.dart';
import 'package:care2care/constants/api_urls.dart';
import 'package:care2care/sharedPref/sharedPref.dart';
import 'package:flutter/cupertino.dart';
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
  bool isLoadingTopCareTakers  = false;
  TextEditingController searchTEC = TextEditingController();

  double rating = 0.0;
  RangeValues priceRange = RangeValues(0.0,1000);
  String profilePath = "";
  Timer ?searchTimer;
  int page = 1;
  String ?gender = "";
  RefreshController refreshController = RefreshController();

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

  //
  debounceSearch(){

    if(searchTimer!=null && searchTimer!.isActive){
      searchTimer!.cancel();
    }
    searchTimer = Timer(Duration(milliseconds: 750),(){
      getCareTakers();
    });
  }

  //
  getCareTakers({bool loading = false}) async{

    if(loading){
      page++;
    }
    else {
      isLoadingCareTakersList = true;
      page = 1;
      update();
    }
    try{
      String? token = await SharedPref().getToken();
      var result = await http.get(
        Uri.parse(
            ApiUrls().viewAllCareTakers
                +"?name=${searchTEC.text}&gender=$gender&rating=${int.parse(rating.toStringAsFixed(0))}"
                "&min_price=${priceRange.start}&max_price=${priceRange.end}&page=$page"
        ),
        headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },);
      if(result.statusCode == 200){
        if(!loading)
        careTakers = caretakersListModel(result.body).data.data;
        else {
          careTakers.addAll(caretakersListModel(result.body).data.data);
        }
        print("caretakers-->${careTakers.length}");
      }
    }catch(e){
      print(e);
    }
    if(!loading){
      refreshController.refreshCompleted();
    }else{
      refreshController.loadComplete();
    }
    isLoadingCareTakersList = false;
    update();

  }
  
  //
  fetchTopCaretakers() async{

    isLoadingTopCareTakers = true;
    update();
    try{
      String? token = await SharedPref().getToken();
      var result = await http.get(Uri.parse(ApiUrls().topCaretakers),headers: {
        "authorization": "Bearer $token",
        "Content-Type": "application/json"
      });
      if(result.statusCode == 200){
        topCaretakers = welcomeFromJson(result.body).data;
        profilePath = welcomeFromJson(result.body).profilePath;
        print('topCaretakers-->${topCaretakers.length}');
      }
    }catch(e){
      print(e);
    }
    isLoadingTopCareTakers = false;
    update();

  }

  //
  @override
  void onInit() {
    super.onInit();
    fetchAllCaretakersApi();
    fetchTopCaretakers();
    getCareTakers();
    // TODO: implement onInit
  }
}
