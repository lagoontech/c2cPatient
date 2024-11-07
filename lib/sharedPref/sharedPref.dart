import 'package:care2care/Screens_/Auth_screen/Sigin_screen/signIn_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  saveToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    debugPrint('Token saved: $token');
  }

  Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    debugPrint('Token retrieved: $token');
    return token;
  }
  saveFCMToken(String fcmToken) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('fcm_token', fcmToken);
    debugPrint('FCM Token saved: $fcmToken');
  }

  Future<String?> getFCMToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? fcmToken = prefs.getString('fcm_token');
    debugPrint('FCM Token retrieved: $fcmToken');
    return fcmToken;
  }

  saveId(String ID) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('id', ID);

  }

  Future<String?> getId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('id');
    return token;
  }
  savePaymentId(String payId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('payId', payId);

  }

  Future<String?> getPaymentId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('payId');
    return token;
  }

  Future<void> setRegisterComplete(bool isComplete) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setBool('isDetailsComplete', isComplete);
  }

  Future<bool> getRegisterComplete() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getBool('isDetailsComplete') ?? false;
  }

  Future<void> logout() async {
    // Clear shared preferences
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.remove('token');
    await pref.remove('isDetailsComplete');
    await pref.remove('fcm_token');
    Get.deleteAll();
    Get.offAll(MobileEmail());
  }
}
