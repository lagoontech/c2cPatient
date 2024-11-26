/*

import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationController extends GetxController {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // String? fcmToken;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void onInit() {
    super.onInit();
    initFirebaseMessaging();
    initLocalNotifications();
  }

  // Initialize Firebase Messaging
  void initFirebaseMessaging() async {
    */
/*fcmToken = await messaging.getToken();
    print('FCM Token: $fcmToken');*/ /*

    //var  fcmTokens = await SharedPref().getFCMToken();
   // print("after close $fcmTokens");
    // Handle foreground messages

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received a message in the foreground: ${message.notification?.body}');

      // Show local notification
      if (message.notification != null) {
        showLocalNotification(
          message.notification?.title,
          message.notification?.body,
        );
      }
    });

    // Handle when the app is opened via the notification (from background or terminated state)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Message opened from background: ${message.notification?.body}');
    });
  }

  // Initialize Local Notifications Plugin
  void initLocalNotifications() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Show a local notification
  void showLocalNotification(String? title, String? body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'channel_id', // Channel ID from manifest
      'channel_name', // Channel name
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      title ?? 'Default Title', // Notification Title
      body ?? 'Default Body', // Notification Body
      platformChannelSpecifics, // Notification Details
    );
  }
}
*/

import 'package:care2care/Notification/modal/notification_modal.dart';
import 'package:care2care/ReusableUtils_/toast2.dart';
import 'package:care2care/constants/api_urls.dart';
import 'package:care2care/sharedPref/sharedPref.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class NotificationController extends GetxController {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  var unreadCount = 0;
  FlutterTts tts = FlutterTts();

  @override
  void onInit() {
    super.onInit();
    initFirebaseMessaging();
    initLocalNotifications();
    setupInteractedMessage();
    //initTextToSpeech();
    allNotifications();
  }

  // Initialize Firebase Messaging
  void initFirebaseMessaging() async {
    // Request notification permissions
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('Received a message in the foreground: ${message.notification?.body}');

      // Show local notification with sound
      if (message.notification != null) {
        showLocalNotification(message.notification?.title,
            message.notification?.body, message.data);

/*        readNotificationWithTTS(
            message.notification!.title!, message.notification!.body!);*/

        unreadCount++;
      }
      await allNotifications();
    });
  }

  //initialize text to speech

 /* void initTextToSpeech() {
    tts.setLanguage('en-US');
    tts.setSpeechRate(0.5);

  }

  void readNotificationWithTTS(String title, String body) async {
    await tts.speak('${title}${body}');
  }*/

  // Handle messages when the app is in the background or terminated
  void setupInteractedMessage() async {
    // When the app is in the background and opened by tapping the notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Notification opened from background: ${message.notification?.body}');
      // Handle notification navigation or actions here
      _navigateToScreen(message.data);
    });

    // When the app is terminated and opened by tapping the notification
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      print(
          'Notification opened from terminated state: ${initialMessage.notification?.body}');
      // Handle notification navigation or actions here
      _navigateToScreen(initialMessage.data);
    }
  }

  // Initialize Local Notifications Plugin
  void initLocalNotifications() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS initialization settings
    const DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    final InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid,iOS: initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse response) async {
      String? payload = response.payload;
      print('Payload on notification click: $payload'); // Add this line
      if (payload != null) {
        _navigateToScreen({"screen": payload});
      }
    });
  }

  // Show a local notification with sound
  void showLocalNotification(
      String? title, String? body, Map<String, dynamic> data) async {
    print('Data payload in showLocalNotification: $data');
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'channel_id', // Channel ID from manifest
      'channel_name', // Channel name
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
      playSound: true,
      //sound: RawResourceAndroidNotificationSound('notification_sound'), // Custom sound
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
        0, // Notification ID
        title ?? 'Default Title', // Notification Title
        body ?? 'Default Body', // Notification Body
        platformChannelSpecifics,
        payload: data['screen'] // Notification Details
        );
  }

  // Navigate to a specific screen based on notification data
  void _navigateToScreen(Map<String, dynamic> data) {
    String? screen = data['screen'];
    print('Screen to navigate: $screen'); // Add this line
    if (screen == 'notification_screen') {
      Get.toNamed('/notification');
    } else {
      print("---->error");
    }
  }

  bool loadNotification = false;
  ReceiveNotification? receiveNotification;
  List<AllNotification> listNotification = [];
  String? Count;





  allNotifications() async {
    loadNotification = true;
    update();
    String? token = await SharedPref().getToken();
    // try {
    var res = await http.get(
      Uri.parse(ApiUrls().allNotifications),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (res.statusCode == 200) {
      receiveNotification = receiveNotificationFromJson(res.body);
      listNotification = receiveNotification!.notifications ?? [];
      // Access and print notification IDs (if needed)


      unreadCount = receiveNotification!.unreadCount ?? 0;
      update();
      print("------All notifications${Count}");
      print("Fetch Successfully ");
      update();
    } else {
      debugPrint("message fetch not successfully ");
    }
    /* } catch (d) {
      debugPrint(d.toString());
    }*/
    loadNotification = false;
    update();
  }

  bool viewedNotification = false;

  notificationsUnread() async {
    viewedNotification = true;
    update();
    String? token = await SharedPref().getToken();
    var request = await http.post(
      Uri.parse(ApiUrls().markAllUnread),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (request.statusCode == 200) {
      unreadCount = 0;
      update();
      showCustomToast(message: "successfully read");
    } else {
      showCustomToast(message: "successfully not read");
    }
    viewedNotification = false;
    update();
  }



  Future<void> deleteNotification(String notificationId) async {
    String? token = await SharedPref().getToken();
    try {
      var res = await http.delete(
        Uri.parse("${ApiUrls().deleteNotification}/$notificationId"),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (res.statusCode == 200) {
        // Remove the notification from the list locally
        listNotification.removeWhere((notification) => notification.id == notificationId);
        update();
        showCustomToast(message: "Notification deleted successfully");
      } else {
        debugPrint("Failed to delete notification: ${res.body}");
        showCustomToast(message: "Failed to delete notification");
      }
    } catch (e) {
      debugPrint("Exception while deleting notification: $e");
      showCustomToast(message: "An error occurred while deleting the notification");
    }
  }

}
