// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

CaretakersListModel caretakersListModel(String str) => CaretakersListModel.fromJson(json.decode(str));

String welcomeToJson(CaretakersListModel data) => json.encode(data.toJson());

class CaretakersListModel {
  bool success;
  int status;
  String type;
  Data data;
  String profilePath;

  CaretakersListModel({
    required this.success,
    required this.status,
    required this.type,
    required this.data,
    required this.profilePath,
  });

  factory CaretakersListModel.fromJson(Map<String, dynamic> json) => CaretakersListModel(
    success: json["success"],
    status: json["status"],
    type: json["type"],
    data: Data.fromJson(json["data"]),
    profilePath: json["profile_path"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "status": status,
    "type": type,
    "data": data.toJson(),
    "profile_path": profilePath,
  };
}

class Data {
  int currentPage;
  List<CaretakersListData> data;
  String firstPageUrl;
  int from;
  int lastPage;
  String lastPageUrl;
  List<Link> links;
  dynamic nextPageUrl;
  String path;
  int perPage;
  dynamic prevPageUrl;
  int to;
  int total;

  Data({
    required this.currentPage,
    required this.data,
    required this.firstPageUrl,
    required this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.links,
    required this.nextPageUrl,
    required this.path,
    required this.perPage,
    required this.prevPageUrl,
    required this.to,
    required this.total,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    currentPage: json["current_page"],
    data: List<CaretakersListData>.from(json["data"].map((x) => CaretakersListData.fromJson(x))),
    firstPageUrl: json["first_page_url"],
    from: json["from"] ?? 0,
    lastPage: json["last_page"] ?? 0,
    lastPageUrl: json["last_page_url"],
    links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
    nextPageUrl: json["next_page_url"],
    path: json["path"],
    perPage: json["per_page"],
    prevPageUrl: json["prev_page_url"],
    to: json["to"] ?? 0,
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "current_page": currentPage,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "first_page_url": firstPageUrl,
    "from": from,
    "last_page": lastPage,
    "last_page_url": lastPageUrl,
    "links": List<dynamic>.from(links.map((x) => x.toJson())),
    "next_page_url": nextPageUrl,
    "path": path,
    "per_page": perPage,
    "prev_page_url": prevPageUrl,
    "to": to,
    "total": total,
  };
}

class CaretakersListData {
  int id;
  String mobilenum;
  String fcmToken;
  String otp;
  int otpverified;
  String profileImageUrl;
  DateTime createdAt;
  DateTime updatedAt;
  String ?averageRating;
  String ?about;
  CaretakerInfo3 caretakerInfo;
  List<CaretakerDocument> caretakerDocuments;
  List<PatientAppointment> patientAppointments;
  List<PatientReview> patientReviews;

  CaretakersListData({
    required this.id,
    required this.mobilenum,
    required this.fcmToken,
    required this.otp,
    required this.otpverified,
    required this.profileImageUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.caretakerInfo,
    required this.caretakerDocuments,
    required this.patientAppointments,
    required this.patientReviews,
    this.averageRating,
    this.about
  });

  factory CaretakersListData.fromJson(Map<String, dynamic> json) => CaretakersListData(
    id: json["id"],
    mobilenum: json["mobilenum"],
    fcmToken: json["fcm_token"],
    otp: json["otp"],
    about: json["aboutme"],
    otpverified: json["otpverified"],
    profileImageUrl: json["profile_image_url"] ?? "",
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    caretakerInfo: CaretakerInfo3.fromJson(json["caretaker_info"]),
    caretakerDocuments: List<CaretakerDocument>.from(json["caretaker_documents"].map((x) => CaretakerDocument.fromJson(x))),
    patientAppointments: List<PatientAppointment>.from(json["patient_appointments"].map((x) => PatientAppointment.fromJson(x))),
    patientReviews: List<PatientReview>.from(json["patient_reviews"].map((x) => PatientReview.fromJson(x))),
    averageRating: json["average_rating"] ?? null,
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

class CaretakerInfo3 {
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
  String ?about;
  DateTime createdAt;
  DateTime updatedAt;

  CaretakerInfo3({
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
    this.about
  });

  factory CaretakerInfo3.fromJson(Map<String, dynamic> json) => CaretakerInfo3(
    id: json["id"],
    caretakerId: json["caretaker_id"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    email: json["email"],
    sex: json["sex"],
    age: json["age"],
    about: json["aboutme"] ?? "",
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

class Link {
  String? url;
  String label;
  bool active;

  Link({
    required this.url,
    required this.label,
    required this.active,
  });

  factory Link.fromJson(Map<String, dynamic> json) => Link(
    url: json["url"],
    label: json["label"],
    active: json["active"],
  );

  Map<String, dynamic> toJson() => {
    "url": url,
    "label": label,
    "active": active,
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
