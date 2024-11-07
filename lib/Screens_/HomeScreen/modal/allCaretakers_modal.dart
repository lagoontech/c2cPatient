// To parse this JSON data, do
//
//     final viewAllCareTakers = viewAllCareTakersFromJson(jsonString);

import 'dart:convert';

ViewAllCareTakers viewAllCareTakersFromJson(String str) =>
    ViewAllCareTakers.fromJson(json.decode(str));

String viewAllCareTakersToJson(ViewAllCareTakers data) =>
    json.encode(data.toJson());

class ViewAllCareTakers {
  bool? success;
  int? status;
  String? type;
  List<Datum>? data;
  String? profilePath;

  ViewAllCareTakers({
    this.success,
    this.status,
    this.type,
    this.data,
    this.profilePath,
  });

  factory ViewAllCareTakers.fromJson(Map<String, dynamic> json) =>
      ViewAllCareTakers(
        success: json["success"],
        status: json["status"],
        type: json["type"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
        profilePath: json["profile_path"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "status": status,
        "type": type,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "profile_path": profilePath,
      };
}

class Datum {
  int? id;
  String? mobilenum;
  String? otp;
  int? otpverified;
  String? profileImageUrl;
  DateTime? createdAt;
  DateTime? updatedAt;
  CaretakerInfo? caretakerInfo;
  List<CaretakerDocument>? caretakerDocuments;

  Datum({
    this.id,
    this.mobilenum,
    this.otp,
    this.otpverified,
    this.profileImageUrl,
    this.createdAt,
    this.updatedAt,
    this.caretakerInfo,
    this.caretakerDocuments,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        mobilenum: json["mobilenum"],
        otp: json["otp"],
        otpverified: json["otpverified"],
        profileImageUrl: json["profile_image_url"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        caretakerInfo: json["caretaker_info"] == null
            ? null
            : CaretakerInfo.fromJson(json["caretaker_info"]),
        caretakerDocuments: json["caretaker_documents"] == null
            ? []
            : List<CaretakerDocument>.from(json["caretaker_documents"]!
                .map((x) => CaretakerDocument.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "mobilenum": mobilenum,
        "otp": otp,
        "otpverified": otpverified,
        "profile_image_url": profileImageUrl,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "caretaker_info": caretakerInfo?.toJson(),
        "caretaker_documents": caretakerDocuments == null
            ? []
            : List<dynamic>.from(caretakerDocuments!.map((x) => x.toJson())),
      };
}

class CaretakerDocument {
  int? id;
  int? caretakerId;
  String? documentName;
  String? fileName;
  String? filePath;
  DateTime? createdAt;
  DateTime? updatedAt;

  CaretakerDocument({
    this.id,
    this.caretakerId,
    this.documentName,
    this.fileName,
    this.filePath,
    this.createdAt,
    this.updatedAt,
  });

  factory CaretakerDocument.fromJson(Map<String, dynamic> json) =>
      CaretakerDocument(
        id: json["id"],
        caretakerId: json["caretaker_id"],
        documentName: json["document_name"],
        fileName: json["file_name"],
        filePath: json["file_path"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "caretaker_id": caretakerId,
        "document_name": documentName,
        "file_name": fileName,
        "file_path": filePath,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
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
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "caretaker_id": caretakerId,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "sex": sex,
        "age": age,
        "dob":
            "${dob!.year.toString().padLeft(4, '0')}-${dob!.month.toString().padLeft(2, '0')}-${dob!.day.toString().padLeft(2, '0')}",
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

