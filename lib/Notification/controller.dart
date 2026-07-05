import 'dart:developer';

import 'package:care2care/Notification/modal/notification_modal.dart';
import 'package:care2care/Notification/notification_routes.dart';
import 'package:care2care/ReusableUtils_/toast2.dart';
import 'package:care2care/Screens_/Appoinment/controller/appointmentsStatus_Controller.dart';
import 'package:care2care/Screens_/HomeView/Controller/bottomNav_controller.dart';
import 'package:care2care/Screens_/HomeView/home_view.dart';
import 'package:care2care/constants/api_urls.dart';
import 'package:care2care/sharedPref/sharedPref.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class NotificationController extends GetxController {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  var unreadCount = 0;

  /// Survives controller re-registration; used for cold-start notification taps.
  static Map<String, dynamic>? _launchPayload;

  /// Holds tap payload until [HomeView] is mounted (cold start / splash).
  Map<String, dynamic>? _pendingNotificationData;

  @override
  void onInit() {
    super.onInit();
    initFirebaseMessaging();
    initLocalNotifications();
    setupInteractedMessage();
    allNotifications();
  }

  /// Call from [HomeView] once the shell (bottom nav) is ready.
  void markAppReady() {
    _pendingNotificationData ??= _launchPayload;
    _launchPayload = null;
    _flushPendingNavigation();
  }

  void clearPendingNavigation() {
    _pendingNotificationData = null;
    _launchPayload = null;
  }

  void _flushPendingNavigation() {
    final pending = _pendingNotificationData ?? _launchPayload;
    _pendingNotificationData = null;
    _launchPayload = null;
    if (pending == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _applyNavigation(pending);
    });
  }

  /// Single entry point for all notification taps (FCM + local).
  void handleNotificationOpen(Map<String, dynamic> data) {
    if (kDebugMode) {
      debugPrint(
        'handleNotificationOpen → data: $data, canNavigateNow: ${_canNavigateNow()}',
      );
    }
    if (_canNavigateNow()) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _applyNavigation(data);
      });
    } else {
      final copy = Map<String, dynamic>.from(data);
      _pendingNotificationData = copy;
      _launchPayload = copy;
    }
  }

  bool _canNavigateNow() => Get.isRegistered<BottomNavController>();

  Map<String, dynamic> _routingDataFrom(RemoteMessage message) {
    final data = Map<String, dynamic>.from(message.data);
    final notification = message.notification;
    if (notification?.title != null) {
      data['_title'] = notification!.title!;
    }
    if (notification?.body != null) {
      data['_body'] = notification!.body!;
    }
    return data;
  }

  bool _isAppointmentApproved(Map<String, dynamic> data) {
    final type = (data['type'] ??
            data['notification_type'] ??
            data['event'] ??
            '')
        .toString()
        .toLowerCase();
    if (type == 'appointment_approved' ||
        type == 'approved_appointment' ||
        type == 'appointments_approved') {
      return true;
    }
    if (type.contains('approved')) {
      return true;
    }

    final title =
        (data['_title'] ?? data['title'] ?? '').toString().toLowerCase();
    final body =
        (data['_body'] ?? data['body'] ?? '').toString().toLowerCase();
    final text = '$title $body';
    return text.contains('approved') ||
        text.contains('accept') ||
        text.contains('appointment request approved');
  }

  bool _isPaymentProcessingUpdate(Map<String, dynamic> data) {
    final type = (data['type'] ??
            data['notification_type'] ??
            data['event'] ??
            '')
        .toString()
        .toLowerCase();
    if (type.contains('payment') || type.contains('paid')) {
      return true;
    }
    if (type == 'appointment_paid' ||
        type == 'payment_received' ||
        type == 'appointment_processing') {
      return true;
    }

    final title =
        (data['_title'] ?? data['title'] ?? '').toString().toLowerCase();
    final body =
        (data['_body'] ?? data['body'] ?? '').toString().toLowerCase();
    final text = '$title $body';

    final mentionsPayment =
        text.contains('paid') || text.contains('payment received');
    final mentionsAppointment =
        text.contains('appointment') || text.contains('processing');
    return mentionsPayment && mentionsAppointment;
  }

  bool isApprovedAppointmentText(String? title, String? body) {
    return _isAppointmentApproved({
      if (title != null) '_title': title,
      if (body != null) '_body': body,
    });
  }

  void openAppointmentFromNotificationText(String? title, String? body) {
    final isProcessing = _isPaymentProcessingUpdate({
      if (title != null) '_title': title,
      if (body != null) '_body': body,
    });
    handleNotificationOpen({
      'screen': isProcessing
          ? NotificationRoutes.appointmentsProcessing
          : NotificationRoutes.appointmentsApproved,
      if (title != null) '_title': title,
      if (body != null) '_body': body,
    });
    if (!Get.isRegistered<BottomNavController>()) {
      Get.offAll(() => HomeView());
    }
  }

  String? _resolveScreen(Map<String, dynamic> data) {
    if (_isPaymentProcessingUpdate(data)) {
      return NotificationRoutes.appointmentsProcessing;
    }
    if (_isAppointmentApproved(data)) {
      return NotificationRoutes.appointmentsApproved;
    }

    final screen = data['screen']?.toString();
    if (screen == NotificationRoutes.appointmentsProcessing ||
        screen == 'appointment_processing' ||
        screen == 'processing_appointments') {
      return NotificationRoutes.appointmentsProcessing;
    }
    if (screen == NotificationRoutes.appointmentsApproved ||
        screen == 'approved_appointments' ||
        screen == 'appointment_approved') {
      return NotificationRoutes.appointmentsApproved;
    }
    if (screen != null && screen.isNotEmpty) return screen;
    return null;
  }

  void _applyNavigation(Map<String, dynamic> data) {
    final screen = _resolveScreen(data);
    if (kDebugMode) {
      debugPrint('Notification navigation → screen: $screen, data: $data');
    }
    if (screen == null) return;

    switch (screen) {
      case NotificationRoutes.appointmentsApproved:
        _navigateToAppointmentsTab(
            NotificationRoutes.approvedSubTabIndex);
        break;
      case NotificationRoutes.appointmentsProcessing:
        _navigateToAppointmentsTab(
            NotificationRoutes.processingSubTabIndex);
        break;
      case NotificationRoutes.notificationList:
        Get.toNamed('/notification');
        break;
      default:
        if (kDebugMode) {
          debugPrint('Unhandled notification screen: $screen');
        }
    }
  }

  void _navigateToAppointmentsTab(int subTabIndex) {
    if (Get.isRegistered<BottomNavController>()) {
      final nav = Get.find<BottomNavController>();
      nav.currentIndex = NotificationRoutes.appointmentsTabIndex;
      nav.update();
    }
    final appt = Get.isRegistered<AppointmentStatusController>()
        ? Get.find<AppointmentStatusController>()
        : Get.put(AppointmentStatusController());
    appt.currentTab = subTabIndex;
    appt.fetchAppointments();
    appt.update();
  }

  void _refreshAppointmentsIfPossible() {
    try {
      if (Get.isRegistered<AppointmentStatusController>()) {
        Get.find<AppointmentStatusController>().fetchAppointments();
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Foreground appointment refresh error: $e');
      }
    }
  }

  void initFirebaseMessaging() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print(
          'Received a message in the foreground: ${message.notification?.body}');

      _refreshAppointmentsIfPossible();

      if (message.notification != null) {
        showLocalNotification(
          message.notification?.title,
          message.notification?.body,
          _routingDataFrom(message),
        );
        unreadCount++;
      }
      await allNotifications();
    });
  }

  void setupInteractedMessage() async {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print(
          'Notification opened from background: ${message.notification?.body}');
      handleNotificationOpen(_routingDataFrom(message));
    });

    final RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      if (kDebugMode) {
        debugPrint(
          'getInitialMessage → data: ${initialMessage.data}, '
          'title: ${initialMessage.notification?.title}, '
          'body: ${initialMessage.notification?.body}',
        );
      }
      handleNotificationOpen(_routingDataFrom(initialMessage));
    }
  }

  void initLocalNotifications() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse response) async {
      final payload = response.payload;
      print('Payload on notification click: $payload');
      if (payload != null) {
        handleNotificationOpen({'screen': payload});
      }
    });
  }

  void showLocalNotification(
      String? title, String? body, Map<String, dynamic> data) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'channel_id',
      'Care2Care',
      channelDescription: 'Appointment and account notifications',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
      playSound: true,
    );

    const DarwinNotificationDetails initializationSettingsIOS =
        DarwinNotificationDetails();

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: initializationSettingsIOS,
    );

    try {
      await flutterLocalNotificationsPlugin.show(
        0,
        title ?? 'Default Title',
        body ?? 'Default Body',
        platformChannelSpecifics,
        payload: _resolveScreen({
          ...data,
          if (title != null) '_title': title,
          if (body != null) '_body': body,
        }),
      );
    } catch (e, stack) {
      if (kDebugMode) {
        debugPrint('Local notification error: $e\n$stack');
      }
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
    var res = await http.get(
      Uri.parse(ApiUrls().allNotifications),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (res.statusCode == 200) {
      log(res.body);
      receiveNotification = receiveNotificationFromJson(res.body);
      listNotification = receiveNotification!.notifications ?? [];
      unreadCount = receiveNotification!.unreadCount ?? 0;
      update();
      print("Fetch Successfully ");
      update();
    } else {
      debugPrint("message fetch not successfully ");
    }
    loadNotification = false;
    update();
  }

  bool viewedNotification = false;

  notificationsUnread() async {
    if (listNotification.isEmpty) {
      return;
    }
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
        listNotification
            .removeWhere((notification) => notification.id == notificationId);
        update();
        showCustomToast(message: "Notification deleted successfully");
      } else {
        debugPrint("Failed to delete notification: ${res.body}");
        showCustomToast(message: "Failed to delete notification");
      }
    } catch (e) {
      debugPrint("Exception while deleting notification: $e");
      showCustomToast(
          message: "An error occurred while deleting the notification");
    }
  }
}
