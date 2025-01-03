// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));

String welcomeToJson(Welcome data) => json.encode(data.toJson());

class Welcome {
  bool success;
  int status;
  String type;
  List<CaretakerData> data;
  String profilePath;

  Welcome({
    required this.success,
    required this.status,
    required this.type,
    required this.data,
    required this.profilePath,
  });

  factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
    success: json["success"],
    status: json["status"],
    type: json["type"],
    data: List<CaretakerData>.from(json["data"].map((x) => CaretakerData.fromJson(x))),
    profilePath: json["profile_path"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "status": status,
    "type": type,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "profile_path": profilePath,
  };
}

class CaretakerData {
  int id;
  String mobilenum;
  String fcmToken;
  String otp;
  int otpverified;
  String profileImageUrl;
  DateTime createdAt;
  DateTime updatedAt;
  String? averageRating;
  CaretakerInfo2 caretakerInfo;
  List<CaretakerDocument> caretakerDocuments;
  List<PatientAppointment> patientAppointments;
  List<PatientReview> patientReviews;

  CaretakerData({
    required this.id,
    required this.mobilenum,
    required this.fcmToken,
    required this.otp,
    required this.otpverified,
    required this.profileImageUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.averageRating,
    required this.caretakerInfo,
    required this.caretakerDocuments,
    required this.patientAppointments,
    required this.patientReviews,
  });

  factory CaretakerData.fromJson(Map<String, dynamic> json) => CaretakerData(
    id: json["id"],
    mobilenum: json["mobilenum"],
    fcmToken: json["fcm_token"],
    otp: json["otp"],
    otpverified: json["otpverified"],
    profileImageUrl: json["profile_image_url"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    averageRating: json["average_rating"],
    caretakerInfo: CaretakerInfo2.fromJson(json["caretaker_info"]),
    caretakerDocuments: List<CaretakerDocument>.from(json["caretaker_documents"].map((x) => CaretakerDocument.fromJson(x))),
    patientAppointments: List<PatientAppointment>.from(json["patient_appointments"].map((x) => PatientAppointment.fromJson(x))),
    patientReviews: List<PatientReview>.from(json["patient_reviews"].map((x) => PatientReview.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "mobilenum": mobilenum,
    "fcm_token": fcmToken,
    "otp": otp,
    "otpverified": otpverified,
    "profile_image_url": profileImageUrl,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "average_rating": averageRating,
    "caretaker_info": caretakerInfo.toJson(),
    "caretaker_documents": List<dynamic>.from(caretakerDocuments.map((x) => x.toJson())),
    "patient_appointments": List<dynamic>.from(patientAppointments.map((x) => x.toJson())),
    "patient_reviews": List<dynamic>.from(patientReviews.map((x) => x.toJson())),
  };
}

class CaretakerDocument {
  int id;
  int caretakerId;
  String documentName;
  String fileName;
  String filePath;
  DateTime createdAt;
  DateTime updatedAt;

  CaretakerDocument({
    required this.id,
    required this.caretakerId,
    required this.documentName,
    required this.fileName,
    required this.filePath,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CaretakerDocument.fromJson(Map<String, dynamic> json) => CaretakerDocument(
    id: json["id"],
    caretakerId: json["caretaker_id"],
    documentName: json["document_name"],
    fileName: json["file_name"],
    filePath: json["file_path"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "caretaker_id": caretakerId,
    "document_name": documentName,
    "file_name": fileName,
    "file_path": filePath,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}

class CaretakerInfo2 {
  int id;
  int caretakerId;
  String firstName;
  String lastName;
  String email;
  String sex;
  int age;
  DateTime dob;
  String medicalLicense;
  String location;
  String nationality;
  String address;
  String yearOfExperiences;
  String primaryContactNumber;
  String secondaryContactNumber;
  String serviceCharge;
  String totalPatientsAttended;
  DateTime createdAt;
  DateTime updatedAt;

  CaretakerInfo2({
    required this.id,
    required this.caretakerId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.sex,
    required this.age,
    required this.dob,
    required this.medicalLicense,
    required this.location,
    required this.nationality,
    required this.address,
    required this.yearOfExperiences,
    required this.primaryContactNumber,
    required this.secondaryContactNumber,
    required this.serviceCharge,
    required this.totalPatientsAttended,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CaretakerInfo2.fromJson(Map<String, dynamic> json) => CaretakerInfo2(
    id: json["id"],
    caretakerId: json["caretaker_id"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    email: json["email"],
    sex: json["sex"],
    age: json["age"],
    dob: DateTime.parse(json["dob"]),
    medicalLicense: json["medical_license"],
    location: json["location"],
    nationality: json["nationality"],
    address: json["address"],
    yearOfExperiences: json["year_of_experiences"],
    primaryContactNumber: json["primary_contact_number"],
    secondaryContactNumber: json["secondary_contact_number"],
    serviceCharge: json["service_charge"],
    totalPatientsAttended: json["total_patients_attended"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "caretaker_id": caretakerId,
    "first_name": firstName,
    "last_name": lastName,
    "email": email,
    "sex": sex,
    "age": age,
    "dob": "${dob.year.toString().padLeft(4, '0')}-${dob.month.toString().padLeft(2, '0')}-${dob.day.toString().padLeft(2, '0')}",
    "medical_license": medicalLicense,
    "location": location,
    "nationality": nationality,
    "address": address,
    "year_of_experiences": yearOfExperiences,
    "primary_contact_number": primaryContactNumber,
    "secondary_contact_number": secondaryContactNumber,
    "service_charge": serviceCharge,
    "total_patients_attended": totalPatientsAttended,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}

class PatientAppointment {
  int id;
  int patientId;
  int caretakerId;
  DateTime appointmentDate;
  String appointmentStartTime;
  String appointmentEndTime;
  ServiceStatus serviceStatus;
  PaymentStatus paymentStatus;
  DateTime createdAt;
  DateTime updatedAt;

  PatientAppointment({
    required this.id,
    required this.patientId,
    required this.caretakerId,
    required this.appointmentDate,
    required this.appointmentStartTime,
    required this.appointmentEndTime,
    required this.serviceStatus,
    required this.paymentStatus,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PatientAppointment.fromJson(Map<String, dynamic> json) => PatientAppointment(
    id: json["id"],
    patientId: json["patient_id"],
    caretakerId: json["caretaker_id"],
    appointmentDate: DateTime.parse(json["appointment_date"]),
    appointmentStartTime: json["appointment_start_time"],
    appointmentEndTime: json["appointment_end_time"],
    serviceStatus: serviceStatusValues.map[json["service_status"]]!,
    paymentStatus: paymentStatusValues.map[json["payment_status"]]!,
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "patient_id": patientId,
    "caretaker_id": caretakerId,
    "appointment_date": "${appointmentDate.year.toString().padLeft(4, '0')}-${appointmentDate.month.toString().padLeft(2, '0')}-${appointmentDate.day.toString().padLeft(2, '0')}",
    "appointment_start_time": appointmentStartTime,
    "appointment_end_time": appointmentEndTime,
    "service_status": serviceStatusValues.reverse[serviceStatus],
    "payment_status": paymentStatusValues.reverse[paymentStatus],
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}

enum PaymentStatus {
  PENDING,
  SUCCEEDED
}

final paymentStatusValues = EnumValues({
  "pending": PaymentStatus.PENDING,
  "succeeded": PaymentStatus.SUCCEEDED
});

enum ServiceStatus {
  APPROVED,
  COMPLETED,
  PROCESSING,
  REQUESTED
}

final serviceStatusValues = EnumValues({
  "approved": ServiceStatus.APPROVED,
  "completed": ServiceStatus.COMPLETED,
  "processing": ServiceStatus.PROCESSING,
  "requested": ServiceStatus.REQUESTED
});

class PatientReview {
  int id;
  int patientId;
  int caretakerId;
  int status;
  int rating;
  String reviewMsg;
  DateTime createdAt;
  DateTime updatedAt;

  PatientReview({
    required this.id,
    required this.patientId,
    required this.caretakerId,
    required this.status,
    required this.rating,
    required this.reviewMsg,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PatientReview.fromJson(Map<String, dynamic> json) => PatientReview(
    id: json["id"],
    patientId: json["patient_id"],
    caretakerId: json["caretaker_id"],
    status: json["status"],
    rating: json["rating"],
    reviewMsg: json["review_msg"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "patient_id": patientId,
    "caretaker_id": caretakerId,
    "status": status,
    "rating": rating,
    "review_msg": reviewMsg,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
