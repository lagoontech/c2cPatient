import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../ReusableUtils_/image_background.dart';
import 'Controller/bottomNav_controller.dart';
import 'bottomNav.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final BottomNavController bn = Get.put(BottomNavController());
  DateTime? _lastBackPressTime;

  Future<bool> _onWillPop() async {
    final now = DateTime.now();
    if (bn.currentIndex == 0) {
      if (_lastBackPressTime == null || now.difference(_lastBackPressTime!) > Duration(seconds: 2)) {
        _lastBackPressTime = now;
        CustomToast.show(context, 'Press back again to exit');
        return Future.value(false);
      } else {
        return Future.value(true);
      }
    } else {
      bn.currentIndex = 0;
      bn.update(); // Ensure this updates the UI correctly
      return Future.value(false);
    }

  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: GetBuilder<BottomNavController>(
        builder: (vv) {
          return CustomBackground(
            bottomNavBar: BottomNavBar(),
            child: bn.screens[bn.currentIndex],
          );
        },
      ),
    );
  }
}

class CustomToast {
  static void show(BuildContext context, String message) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.black,
        duration: Duration(seconds: 2),
      ),
    );
  }
}
