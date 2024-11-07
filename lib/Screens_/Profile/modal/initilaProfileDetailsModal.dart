import 'dart:convert';

import '../../Document_Upload/controller/document_upload_controller.dart';

class InitilaProfileDetails {
  bool? success;
  int? status;
  String? type;
  Data? data;

  InitilaProfileDetails({
    this.success,
    this.status,
    this.type,
    this.data,
  });

  factory InitilaProfileDetails.fromJson(Map<String, dynamic> json) =>
      InitilaProfileDetails(
        success: json["success"] ?? false,
        status: json["status"] ?? 0,
        type: json["type"] ?? '',
        data: json["data"] != null ? Data.fromJson(json["data"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "status": status,
        "type": type,
        "data": data?.toJson(),
      };
}

class Data {
  int? id;
  int? mobilenum;
  String? otp;
  int? otpverified;
  DateTime? createdAt;
  DateTime? updatedAt;
  PatientInfo? patientInfo;
  PatientSchedule? patientSchedules;
  List<PatientDocument>? patientDocuments;

  Data({
    this.id,
    this.mobilenum,
    this.otp,
    this.otpverified,
    this.createdAt,
    this.updatedAt,
    this.patientInfo,
    this.patientSchedules,
    this.patientDocuments,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"] ?? 0,
        mobilenum: json["mobilenum"],
        otp: json["otp"] ?? '',
        otpverified: json["otpverified"] ?? 0,
        createdAt: json["created_at"] != null
            ? DateTime.parse(json["created_at"])
            : null,
        updatedAt: json["updated_at"] != null
            ? DateTime.parse(json["updated_at"])
            : null,
        patientInfo: json["patient_info"] != null
            ? PatientInfo.fromJson(json["patient_info"])
            : null,
        patientSchedules: json["patient_schedules"] != null
            ? PatientSchedule.fromJson(json["patient_schedules"])
            : null,
        patientDocuments: json["patient_documents"] == null
            ? []
            : List<PatientDocument>.from(json["patient_documents"]
                .map((x) => PatientDocument.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "mobilenum": mobilenum,
        "otp": otp,
        "otpverified": otpverified,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "patient_info": patientInfo?.toJson(),
        "patient_schedules": patientSchedules?.toJson(),
        "patient_documents": patientDocuments == null
            ? []
            : List<dynamic>.from(patientDocuments!.map((x) => x.toJson())),
      };
}

class PatientInfo {
  int? id;
  int? patientId;
  String? firstName;
  String? lastName;
  String? sex;
  int? age;
  DateTime? dob;
  String? height;
  String? weight;
  String? bmi;
  String? location;
  String? nationality;
  String? address;
  String? diagnosis;
  String? primaryCareGiverName;
  String? primaryContactName;
  String? primaryContactNumber;
  String? secondaryContactName;
  String? secondaryContactNumber;
  String? specialistName;
  String? specialistContactNumber;
  String? moreinfo;
  DateTime? createdAt;
  DateTime? updatedAt;

  PatientInfo({
    this.id,
    this.patientId,
    this.firstName,
    this.lastName,
    this.sex,
    this.age,
    this.dob,
    this.height,
    this.weight,
    this.bmi,
    this.location,
    this.nationality,
    this.address,
    this.diagnosis,
    this.primaryCareGiverName,
    this.primaryContactName,
    this.primaryContactNumber,
    this.secondaryContactName,
    this.secondaryContactNumber,
    this.specialistName,
    this.specialistContactNumber,
    this.moreinfo,
    this.createdAt,
    this.updatedAt,
  });

  factory PatientInfo.fromJson(Map<String, dynamic> json) => PatientInfo(
        id: json["id"] ?? 0,
        patientId: json["patient_id"] ?? 0,
        firstName: json["first_name"] ?? '',
        lastName: json["last_name"] ?? '',
        sex: json["sex"] ?? '',
        age: json["age"] ?? 0,
        dob: json["dob"] != null ? DateTime.parse(json["dob"]) : null,
        height: json["height"] ?? '',
        weight: json["weight"] ?? '',
        bmi: json["bmi"] ?? '',
        location: json["location"] ?? '',
        nationality: json["nationality"] ?? '',
        address: json["address"] ?? '',
        diagnosis: json["diagnosis"] ?? '',
        primaryCareGiverName: json["primary_care_giver_name"],
        primaryContactName: json["primary_contact_name"] ?? '',
        primaryContactNumber: json["primary_contact_number"] ?? '',
        secondaryContactName: json["secondary_contact_name"] ?? '',
        secondaryContactNumber: json["secondary_contact_number"] ?? '',
        specialistName: json["specialist_name"] ?? '',
        specialistContactNumber: json["specialist_contact_number"] ?? '',
        moreinfo: json["moreinfo"],
        createdAt: json["created_at"] != null
            ? DateTime.parse(json["created_at"])
            : null,
        updatedAt: json["updated_at"] != null
            ? DateTime.parse(json["updated_at"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "patient_id": patientId,
        "first_name": firstName,
        "last_name": lastName,
        "sex": sex,
        "age": age,
        "dob": dob?.toIso8601String(),
        "height": height,
        "weight": weight,
        "bmi": bmi,
        "location": location,
        "nationality": nationality,
        "address": address,
        "diagnosis": diagnosis,
        "primary_care_giver_name": primaryCareGiverName,
        "primary_contact_name": primaryContactName,
        "primary_contact_number": primaryContactNumber,
        "secondary_contact_name": secondaryContactName,
        "secondary_contact_number": secondaryContactNumber,
        "specialist_name": specialistName,
        "specialist_contact_number": specialistContactNumber,
        "moreinfo": moreinfo,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class PatientSchedule {
  int? id;
  int? patientId;
  List<String>? patientDietplan;
  String? patientActivitytype;
  List<String>? patientPastmedicalhistory;
  String? patientPastsurgicalhistory;
  String? patientBreakfasttime;
  String? patientLunchtime;
  String? patientSnackstime;
  String? patientDinnertime;
  String? patientMedications;
  String? patientHydration;
  String? patientOralcare;
  String? patientBathing;
  String? patientDressing;
  String? patientToileting;
  String? patientWalkingtime;
  VitalSigns? patientVitalsigns;
  String? patientBloodsugar;

  PatientSchedule({
    this.id,
    this.patientId,
    this.patientDietplan,
    this.patientActivitytype,
    this.patientPastmedicalhistory,
    this.patientPastsurgicalhistory,
    this.patientBreakfasttime,
    this.patientLunchtime,
    this.patientSnackstime,
    this.patientDinnertime,
    this.patientMedications,
    this.patientHydration,
    this.patientOralcare,
    this.patientBathing,
    this.patientDressing,
    this.patientToileting,
    this.patientWalkingtime,
    this.patientVitalsigns,
    this.patientBloodsugar,
  });

  factory PatientSchedule.fromJson(Map<String, dynamic> json) =>
      PatientSchedule(
        id: json["id"] ?? 0,
        patientId: json["patient_id"] ?? 0,
        patientActivitytype: json['patient_activitytype'] ?? '',
        patientDietplan: (jsonDecode(json["patient_dietplan"]) as List)
            .map((e) => e.toString())
            .toList(),
        patientPastmedicalhistory:
            (jsonDecode(json["patient_pastmedicalhistory"]) as List)
                .map((e) => e.toString())
                .toList(),
        patientPastsurgicalhistory: json["patient_pastsurgicalhistory"] ?? '',
        patientBreakfasttime: json["patient_breakfasttime"] ?? '',
        patientLunchtime: json["patient_lunchtime"] ?? '',
        patientSnackstime: json['patient_snackstime'] ?? '',
        patientDinnertime: json["patient_dinnertime"] ?? '',
        patientMedications: json["patient_medications"] ?? '',
        patientHydration: json["patient_hydration"] ?? '',
        patientOralcare: json["patient_oralcare"] ?? '',
        patientBathing: json["patient_bathing"] ?? '',
        patientDressing: json["patient_dressing"] ?? '',
        patientToileting: json["patient_toileting"] ?? '',
        patientWalkingtime: json["patient_walkingtime"] ?? '',
        patientVitalsigns: json["patient_vitalsigns"] != null
            ? VitalSigns.fromJson(jsonDecode(json["patient_vitalsigns"]))
            : null,
        patientBloodsugar: json["patient_bloodsugar"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "patient_id": patientId,
        "patient_dietplan": jsonEncode(patientDietplan),
        "patient_activitytype": patientActivitytype,
        "patient_pastmedicalhistory": jsonEncode(patientPastmedicalhistory),
        "patient_pastsurgicalhistory": patientPastsurgicalhistory,
        "patient_breakfasttime": patientBreakfasttime,
        'patient_snackstime': patientSnackstime,
        "patient_lunchtime": patientLunchtime,
        "patient_dinnertime": patientDinnertime,
        "patient_medications": patientMedications,
        "patient_hydration": patientHydration,
        "patient_oralcare": patientOralcare,
        "patient_bathing": patientBathing,
        "patient_dressing": patientDressing,
        "patient_toileting": patientToileting,
        "patient_walkingtime": patientWalkingtime,
        "patient_vitalsigns": patientVitalsigns?.toJson(),
        "patient_bloodsugar": patientBloodsugar,
      };
}

class VitalSigns {
  final String? bloodPressure;
  final String? heartRate;
  final String? respiratoryRate;
  final String? temperature;
  final String? weight; // Add weight as a String

  VitalSigns({
    this.bloodPressure,
    this.heartRate,
    this.respiratoryRate,
    this.temperature,
    this.weight, // Include in constructor
  });

  factory VitalSigns.fromJson(Map<String, dynamic> json) {
    return VitalSigns(
      bloodPressure: json['blood_pressure']?.toString(),
      heartRate: json['heart_rate']?.toString(),
      respiratoryRate: json['respiratory_rate']?.toString(),
      temperature: json['temperature']?.toString(),
      weight: json['weight']?.toString(), // Parse weight as String
    );
  }

  Map<String, dynamic> toJson() => {
        "blood_pressure": bloodPressure,
        "heart_rate": heartRate,
        "respiratory_rate": respiratoryRate,
        "temperature": temperature,
        "weight": weight,
      };
}

class Diet {
  final String name;
  final int id;

  Diet({required this.name, required this.id});

  factory Diet.fromJson(Map<String, dynamic> json) => Diet(
        name: json["name"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
      };

  @override
  String toString() {
    return name;
  }
}

class MedicalHistory {
  final String name;
  final int id;

  MedicalHistory({required this.name, required this.id});

  factory MedicalHistory.fromJson(Map<String, dynamic> json) => MedicalHistory(
        name: json["name"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
      };

  @override
  String toString() {
    return name;
  }
}
