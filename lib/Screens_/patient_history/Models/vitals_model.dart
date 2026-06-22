// To parse this JSON data, do
//
//     final vitalsModel = vitalsModelFromJson(jsonString);

import 'dart:convert';

VitalsModel vitalsModelFromJson(String str) => VitalsModel.fromJson(json.decode(str));

String vitalsModelToJson(VitalsModel data) => json.encode(data.toJson());

class VitalsModel {
  bool? success;
  int? status;
  String? message;
  Data? data;

  VitalsModel({
    this.success,
    this.status,
    this.message,
    this.data,
  });

  factory VitalsModel.fromJson(Map<String, dynamic> json) => VitalsModel(
    success: json["success"],
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  dynamic appointmentId;
  int? patientId;
  List<VitalsByDay>? vitalsByDay;

  Data({
    this.appointmentId,
    this.patientId,
    this.vitalsByDay,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    appointmentId: json["appointment_id"],
    patientId: json["patient_id"],
    vitalsByDay: json["vitals_by_day"] == null ? [] : List<VitalsByDay>.from(json["vitals_by_day"]!.map((x) => VitalsByDay.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "appointment_id": appointmentId,
    "patient_id": patientId,
    "vitals_by_day": vitalsByDay == null ? [] : List<dynamic>.from(vitalsByDay!.map((x) => x.toJson())),
  };
}

class VitalsByDay {
  DateTime? appointmentDate;
  VitalSigns? vitalSigns;

  VitalsByDay({
    this.appointmentDate,
    this.vitalSigns,
  });

  factory VitalsByDay.fromJson(Map<String, dynamic> json) => VitalsByDay(
    appointmentDate: json["appointment_date"] == null ? null : DateTime.parse(json["appointment_date"]),
    vitalSigns: json["vital_signs"] == null ? null : VitalSigns.fromJson(json["vital_signs"]),
  );

  Map<String, dynamic> toJson() {
    final date = appointmentDate;
    return {
      "appointment_date": date == null ? null : "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
      "vital_signs": vitalSigns?.toJson(),
    };
  }
}

class VitalSigns {
  String? bloodPressure;
  String? heartRate;
  String? respiratoryRate;
  String? temperature;

  VitalSigns({
    this.bloodPressure,
    this.heartRate,
    this.respiratoryRate,
    this.temperature,
  });

  factory VitalSigns.fromJson(Map<String, dynamic> json) => VitalSigns(
    bloodPressure:   json["blood_pressure"],
    heartRate:       json["heart_rate"],
    respiratoryRate: json["respiratory_rate"],
    temperature:     json["temperature"],
  );

  Map<String, dynamic> toJson() => {
    "blood_pressure": bloodPressure,
    "heart_rate": heartRate,
    "respiratory_rate": respiratoryRate,
    "temperature": temperature,
  };
}
