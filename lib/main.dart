import 'package:care2care/Screens_/SplashScreen/splash_screen.dart';
import 'package:care2care/test/payment%20screen.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '.env.dart';
import 'Notification/controller.dart';
import 'Screens_/Notifications/Notification_view.dart';
import 'Screens_/Profile/Controller/initila_profile_controller.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
   Stripe.publishableKey = "pk_test_51O0Fr3SINY9SXzkchfDIq1iKssrpWyKJHEaOd2dVya0NOxYDtLT2pbX6dkBMvbsS5QvMmwuovC2brM3bkLAgvDkQ00tGDrRjSi";
  await Stripe.instance.applySettings();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Get.put(NotificationController());
  Get.lazyPut<InitialProfileDetails>(() => InitialProfileDetails());
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
    return ScreenUtilInit(builder: (context, w) {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        defaultTransition: Transition.native,
        getPages: [
          GetPage(name: '/notification', page: () => NotificationView()),
        ],
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xff15ADD2),
          ),
          fontFamily: GoogleFonts.kumbhSans().fontFamily,
          applyElevationOverlayColor: false,
          useMaterial3: true,
          textTheme: TextTheme(
            bodyMedium: TextStyle(color: Color(0xff222222)),
          ),
        ),
        navigatorObservers: [
          FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
        ],
        home:  SplashScreen(),
      );
    });
  }
}
