class ApiUrls {
  static String baseUrl = 'https://care2carevital.us';

  String loginorRegister = '$baseUrl/api/patients/login-or-register';

  String checkOtp = '$baseUrl/api/patients/verify-otp';

  String patientInfoAdd = '$baseUrl/api/patients/patient-info/add';

  String patientInfoFetch = '$baseUrl/api/patients/patient/view';

  String patientInfoUpdate = '$baseUrl/api/patients/patient-info/edit';

  String addPatientSchedule = '$baseUrl/api/patients/patient-schedules/add';

  String editPatientScheduleAndUpdate = '$baseUrl/api/patients/patient-schedules/edit';

  //document and image upload

  String uploadImage = '$baseUrl/api/patients/patient/profile-img-upload';

  String deleteImage = '$baseUrl/api/patients/patient/delete-profile-img';

  String DocUpload = '$baseUrl/api/patients/patient/documents-upload';

  String deleteDocument = '$baseUrl/api/patients/patient/document-delete';

  //topCareTakers

  String viewAllCareTakers = '$baseUrl/api/patients/patient/view-caretakers';

  String topCaretakers = '$baseUrl/api/patients/patient/view-top-caretakers';

  //book Appointment

  String appointment = '$baseUrl/api/patients/patient/schedule-appointment';

  String appointmentHistory = '$baseUrl/api/patients/patient/appointment-requests';

  String UpdateFcmToken = '$baseUrl/api/patients/update-token';

  String paymentApi = '$baseUrl/api/patients/patient/payment';

  String paymentGateWay = '$baseUrl/api/patients/patient/payment';

  String confirmPayment = '$baseUrl/api/patients/patient/payment/confirm';

  String cancelRequest = '$baseUrl/api/patients/patient/cancel-appointment';

  String loadCancelRequest =  '$baseUrl/api/patients/patient/cancelled-appointments';

  String allNotifications = '$baseUrl/api/patients/patient/notifications';

  String markAllUnread =  '$baseUrl/api/patients/patient/notifications/mark-all-as-read';

  String deleteNotification = '$baseUrl/api/patients/patient/delete-notification';

  String ServiceHistory = '$baseUrl/api/patients/patient/get-service-history';

  String addReview = '$baseUrl/api/patients/patient/reviews/add';

}
