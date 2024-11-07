// To parse this JSON data, do
//
//     final appointmentStatus = appointmentStatusFromJson(jsonString);

import 'dart:convert';

AppointmentStatus appointmentStatusFromJson(String str) => AppointmentStatus.fromJson(json.decode(str));

String appointmentStatusToJson(AppointmentStatus data) => json.encode(data.toJson());

class AppointmentStatus {
  bool? success;
  int? status;
  String? type;
  List<StatusData>? data;
  String? profilePath;

  AppointmentStatus({
    this.success,
    this.status,
    this.type,
    this.data,
    this.profilePath,
  });

  factory AppointmentStatus.fromJson(Map<String, dynamic> json) => AppointmentStatus(
    success: json["success"],
    status: json["status"],
    type: json["type"],
    data: json["data"] == null ? [] : List<StatusData>.from(json["data"]!.map((x) => StatusData.fromJson(x))),
    profilePath: json["profile_path"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "status": status,
    "type": type,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "profile_path": profilePath,
  };
}

class StatusData {
  int? id;
  int ?appointmentId;
  int? patientId;
  int? caretakerId;
  DateTime? appointmentDate;
  String? appointmentStartTime;
  String? appointmentEndTime;
  String? serviceStatus;
  String?cancelReason;
  String? paymentStatus;
  DateTime? createdAt;
  DateTime? updatedAt;
  Caretaker? caretaker;

  StatusData({
    this.id,
     this.appointmentId,
    this.patientId,
    this.caretakerId,
    this.appointmentDate,
    this.appointmentStartTime,
    this.appointmentEndTime,
    this.serviceStatus,
    this.cancelReason,
    this.paymentStatus,
    this.createdAt,
    this.updatedAt,
    this.caretaker,
  });

  factory StatusData.fromJson(Map<String, dynamic> json) => StatusData(
    id: json["id"],
    appointmentId: json['appointment_id'],
    patientId: json["patient_id"],
    caretakerId: json["caretaker_id"],
    appointmentDate: json["appointment_date"] == null ? null : DateTime.parse(json["appointment_date"]),
    appointmentStartTime: json["appointment_start_time"],
    appointmentEndTime: json["appointment_end_time"],
    serviceStatus: json["service_status"],
    cancelReason: json['cancel_reason'],
    paymentStatus: json["payment_status"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    caretaker: json["caretaker"] == null ? null : Caretaker.fromJson(json["caretaker"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    'appointment_id':appointmentId,
    "patient_id": patientId,
    "caretaker_id": caretakerId,
    "appointment_date": "${appointmentDate!.year.toString().padLeft(4, '0')}-${appointmentDate!.month.toString().padLeft(2, '0')}-${appointmentDate!.day.toString().padLeft(2, '0')}",
    "appointment_start_time": appointmentStartTime,
    "appointment_end_time": appointmentEndTime,
    "service_status": serviceStatus,
    'cancel_reason':cancelReason,
    "payment_status": paymentStatus,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "caretaker": caretaker?.toJson(),
  };
}

class Caretaker {
  int? id;
  String? mobilenum;
  String? fcmToken;
  String? otp;
  int? otpverified;
  String? profileImageUrl;
  DateTime? createdAt;
  DateTime? updatedAt;
  CaretakerInfo? caretakerInfo;

  Caretaker({
    this.id,
    this.mobilenum,
    this.fcmToken,
    this.otp,
    this.otpverified,
    this.profileImageUrl,
    this.createdAt,
    this.updatedAt,
    this.caretakerInfo,
  });

  factory Caretaker.fromJson(Map<String, dynamic> json) => Caretaker(
    id: json["id"],
    mobilenum: json["mobilenum"],
    fcmToken: json["fcm_token"],
    otp: json["otp"],
    otpverified: json["otpverified"],
    profileImageUrl: json["profile_image_url"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    caretakerInfo: json["caretaker_info"] == null ? null : CaretakerInfo.fromJson(json["caretaker_info"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "mobilenum": mobilenum,
    "fcm_token": fcmToken,
    "otp": otp,
    "otpverified": otpverified,
    "profile_image_url": profileImageUrl,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "caretaker_info": caretakerInfo?.toJson(),
  };
}

class CaretakerInfo {
  int? id;
  int? caretakerId;
  String? firstName;
  String? lastName;
  String? email;
  String? sex;
  int? age;
  DateTime? dob;
  String? medicalLicense;
  String? location;
  String? nationality;
  String? address;
  String? uploadedDocuments;
  String? yearOfExperiences;
  String? primaryContactNumber;
  String? secondaryContactNumber;
  String? serviceCharge;
  String? totalPatientsAttended;
  DateTime? createdAt;
  DateTime? updatedAt;

  CaretakerInfo({
    this.id,
    this.caretakerId,
    this.firstName,
    this.lastName,
    this.email,
    this.sex,
    this.age,
    this.dob,
    this.medicalLicense,
    this.location,
    this.nationality,
    this.address,
    this.uploadedDocuments,
    this.yearOfExperiences,
    this.primaryContactNumber,
    this.secondaryContactNumber,
    this.serviceCharge,
    this.totalPatientsAttended,
    this.createdAt,
    this.updatedAt,
  });

  factory CaretakerInfo.fromJson(Map<String, dynamic> json) => CaretakerInfo(
    id: json["id"],
    caretakerId: json["caretaker_id"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    email: json["email"],
    sex: json["sex"],
    age: json["age"],
    dob: json["dob"] == null ? null : DateTime.parse(json["dob"]),
    medicalLicense: json["medical_license"],
    location: json["location"],
    nationality: json["nationality"],
    address: json["address"],
    uploadedDocuments: json["uploaded_documents"],
    yearOfExperiences: json["year_of_experiences"],
    primaryContactNumber: json["primary_contact_number"],
    secondaryContactNumber: json["secondary_contact_number"],
    serviceCharge: json["service_charge"],
    totalPatientsAttended: json["total_patients_attended"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "caretaker_id": caretakerId,
    "first_name": firstName,
    "last_name": lastName,
    "email": email,
    "sex": sex,
    "age": age,
    "dob": "${dob!.year.toString().padLeft(4, '0')}-${dob!.month.toString().padLeft(2, '0')}-${dob!.day.toString().padLeft(2, '0')}",
    "medical_license": medicalLicense,
    "location": location,
    "nationality": nationality,
    "address": address,
    "uploaded_documents": uploadedDocuments,
    "year_of_experiences": yearOfExperiences,
    "primary_contact_number": primaryContactNumber,
    "secondary_contact_number": secondaryContactNumber,
    "service_charge": serviceCharge,
    "total_patients_attended": totalPatientsAttended,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
