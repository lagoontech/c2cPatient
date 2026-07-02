/// FCM `data` payload keys the backend should send alongside the notification.
///
/// Example push data:
/// ```json
/// {
///   "screen": "appointments_approved",
///   "appointment_id": "123"
/// }
/// ```
class NotificationRoutes {
  NotificationRoutes._();

  static const appointmentsApproved = 'appointments_approved';
  static const appointmentsProcessing = 'appointments_processing';
  static const notificationList = 'notification_screen';

  /// Bottom nav index for [AppointmentView].
  static const appointmentsTabIndex = 2;

  /// Inner tab indices inside [AppointmentView].
  static const requestedSubTabIndex = 0;
  static const approvedSubTabIndex = 1;
  static const processingSubTabIndex = 2;
}
