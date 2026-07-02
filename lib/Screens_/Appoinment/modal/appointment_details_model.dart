class AppointmentDetails {
  bool? success;
  int? status;
  String? type;
  AppointmentDetail? data;
  String? profilePath;

  AppointmentDetails(
      {this.success, this.status, this.type, this.data, this.profilePath});

  AppointmentDetails.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    status = json['status'];
    type = json['type'];
    data = json['data'] != null ? new AppointmentDetail.fromJson(json['data']) : null;
    profilePath = json['profile_path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['status'] = this.status;
    data['type'] = this.type;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['profile_path'] = this.profilePath;
    return data;
  }
}

class AppointmentDetail {
  int? id;
  int? patientId;
  int? caretakerId;
  String? appointmentDates;
  String? appointmentStartTime;
  String? appointmentEndTime;
  String? serviceStatus;
  String? paymentStatus;
  String? createdAt;
  String? updatedAt;
  Caretaker? caretaker;
  Patient? patient;
  List<ServiceHistories>? serviceHistories;
  List<PaymentHistories>? paymentHistories;

  AppointmentDetail(
      {this.id,
        this.patientId,
        this.caretakerId,
        this.appointmentDates,
        this.appointmentStartTime,
        this.appointmentEndTime,
        this.serviceStatus,
        this.paymentStatus,
        this.createdAt,
        this.updatedAt,
        this.caretaker,
        this.patient,
        this.serviceHistories,
        this.paymentHistories});

  AppointmentDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    patientId = json['patient_id'];
    caretakerId = json['caretaker_id'];
    appointmentDates = json['appointment_dates'];
    appointmentStartTime = json['appointment_start_time'];
    appointmentEndTime = json['appointment_end_time'];
    serviceStatus = json['service_status'];
    paymentStatus = json['payment_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    caretaker = json['caretaker'] != null
        ? new Caretaker.fromJson(json['caretaker'])
        : null;
    patient =
    json['patient'] != null ? new Patient.fromJson(json['patient']) : null;
    if (json['service_histories'] != null) {
      serviceHistories = <ServiceHistories>[];
      json['service_histories'].forEach((v) {
        serviceHistories!.add(new ServiceHistories.fromJson(v));
      });
    }
    if (json['payment_histories'] != null) {
      paymentHistories = <PaymentHistories>[];
      json['payment_histories'].forEach((v) {
        paymentHistories!.add(new PaymentHistories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['patient_id'] = this.patientId;
    data['caretaker_id'] = this.caretakerId;
    data['appointment_dates'] = this.appointmentDates;
    data['appointment_start_time'] = this.appointmentStartTime;
    data['appointment_end_time'] = this.appointmentEndTime;
    data['service_status'] = this.serviceStatus;
    data['payment_status'] = this.paymentStatus;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.caretaker != null) {
      data['caretaker'] = this.caretaker!.toJson();
    }
    if (this.patient != null) {
      data['patient'] = this.patient!.toJson();
    }
    if (this.serviceHistories != null) {
      data['service_histories'] =
          this.serviceHistories!.map((v) => v.toJson()).toList();
    }
    if (this.paymentHistories != null) {
      data['payment_histories'] =
          this.paymentHistories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Caretaker {
  int? id;
  String? mobilenum;
  String? fcmToken;
  String? otp;
  int? otpverified;
  String? profileImageUrl;
  String? createdAt;
  String? updatedAt;
  CaretakerInfo? caretakerInfo;

  Caretaker(
      {this.id,
        this.mobilenum,
        this.fcmToken,
        this.otp,
        this.otpverified,
        this.profileImageUrl,
        this.createdAt,
        this.updatedAt,
        this.caretakerInfo});

  Caretaker.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mobilenum = json['mobilenum'];
    fcmToken = json['fcm_token'];
    otp = json['otp'];
    otpverified = json['otpverified'];
    profileImageUrl = json['profile_image_url'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    caretakerInfo = json['caretaker_info'] != null
        ? new CaretakerInfo.fromJson(json['caretaker_info'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['mobilenum'] = this.mobilenum;
    data['fcm_token'] = this.fcmToken;
    data['otp'] = this.otp;
    data['otpverified'] = this.otpverified;
    data['profile_image_url'] = this.profileImageUrl;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.caretakerInfo != null) {
      data['caretaker_info'] = this.caretakerInfo!.toJson();
    }
    return data;
  }
}

class CaretakerInfo {
  int? id;
  int? caretakerId;
  String? firstName;
  String? lastName;
  String? email;
  String? sex;
  int? age;
  String? dob;
  String? medicalLicense;
  String? location;
  String? nationality;
  String? address;
  String? yearOfExperiences;
  String? primaryContactNumber;
  Null? secondaryContactNumber;
  String? serviceCharge;
  String? totalPatientsAttended;
  Null? aboutme;
  String? createdAt;
  String? updatedAt;

  CaretakerInfo(
      {this.id,
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
        this.yearOfExperiences,
        this.primaryContactNumber,
        this.secondaryContactNumber,
        this.serviceCharge,
        this.totalPatientsAttended,
        this.aboutme,
        this.createdAt,
        this.updatedAt});

  CaretakerInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    caretakerId = json['caretaker_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    sex = json['sex'];
    age = json['age'];
    dob = json['dob'];
    medicalLicense = json['medical_license'];
    location = json['location'];
    nationality = json['nationality'];
    address = json['address'];
    yearOfExperiences = json['year_of_experiences'];
    primaryContactNumber = json['primary_contact_number'];
    secondaryContactNumber = json['secondary_contact_number'];
    serviceCharge = json['service_charge'];
    totalPatientsAttended = json['total_patients_attended'];
    aboutme = json['aboutme'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['caretaker_id'] = this.caretakerId;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['sex'] = this.sex;
    data['age'] = this.age;
    data['dob'] = this.dob;
    data['medical_license'] = this.medicalLicense;
    data['location'] = this.location;
    data['nationality'] = this.nationality;
    data['address'] = this.address;
    data['year_of_experiences'] = this.yearOfExperiences;
    data['primary_contact_number'] = this.primaryContactNumber;
    data['secondary_contact_number'] = this.secondaryContactNumber;
    data['service_charge'] = this.serviceCharge;
    data['total_patients_attended'] = this.totalPatientsAttended;
    data['aboutme'] = this.aboutme;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Patient {
  int? id;
  String? mobilenum;
  String? fcmToken;
  String? otp;
  int? otpverified;
  String? profileImageUrl;
  String? createdAt;
  String? updatedAt;
  PatientInfo? patientInfo;

  Patient(
      {this.id,
        this.mobilenum,
        this.fcmToken,
        this.otp,
        this.otpverified,
        this.profileImageUrl,
        this.createdAt,
        this.updatedAt,
        this.patientInfo});

  Patient.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mobilenum = json['mobilenum'];
    fcmToken = json['fcm_token'];
    otp = json['otp'];
    otpverified = json['otpverified'];
    profileImageUrl = json['profile_image_url'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    patientInfo = json['patient_info'] != null
        ? new PatientInfo.fromJson(json['patient_info'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['mobilenum'] = this.mobilenum;
    data['fcm_token'] = this.fcmToken;
    data['otp'] = this.otp;
    data['otpverified'] = this.otpverified;
    data['profile_image_url'] = this.profileImageUrl;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.patientInfo != null) {
      data['patient_info'] = this.patientInfo!.toJson();
    }
    return data;
  }
}

class PatientInfo {
  int? id;
  int? patientId;
  String? firstName;
  String? lastName;
  String? email;
  String? sex;
  int? age;
  String? dob;
  int? height;
  int? weight;
  double? bmi;
  String? location;
  String? nationality;
  String? address;
  String? diagnosis;
  Null? primaryCareGiverName;
  String? primaryContactName;
  String? primaryContactNumber;
  Null? secondaryContactName;
  Null? secondaryContactNumber;
  Null? specialistName;
  Null? specialistContactNumber;
  Null? moreinfo;
  String? createdAt;
  String? updatedAt;

  PatientInfo(
      {this.id,
        this.patientId,
        this.firstName,
        this.lastName,
        this.email,
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
        this.updatedAt});

  PatientInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    patientId = json['patient_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    sex = json['sex'];
    age = json['age'];
    dob = json['dob'];
    height = json['height'];
    weight = json['weight'];
    bmi = json['bmi'];
    location = json['location'];
    nationality = json['nationality'];
    address = json['address'];
    diagnosis = json['diagnosis'];
    primaryCareGiverName = json['primary_care_giver_name'];
    primaryContactName = json['primary_contact_name'];
    primaryContactNumber = json['primary_contact_number'];
    secondaryContactName = json['secondary_contact_name'];
    secondaryContactNumber = json['secondary_contact_number'];
    specialistName = json['specialist_name'];
    specialistContactNumber = json['specialist_contact_number'];
    moreinfo = json['moreinfo'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['patient_id'] = this.patientId;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['sex'] = this.sex;
    data['age'] = this.age;
    data['dob'] = this.dob;
    data['height'] = this.height;
    data['weight'] = this.weight;
    data['bmi'] = this.bmi;
    data['location'] = this.location;
    data['nationality'] = this.nationality;
    data['address'] = this.address;
    data['diagnosis'] = this.diagnosis;
    data['primary_care_giver_name'] = this.primaryCareGiverName;
    data['primary_contact_name'] = this.primaryContactName;
    data['primary_contact_number'] = this.primaryContactNumber;
    data['secondary_contact_name'] = this.secondaryContactName;
    data['secondary_contact_number'] = this.secondaryContactNumber;
    data['specialist_name'] = this.specialistName;
    data['specialist_contact_number'] = this.specialistContactNumber;
    data['moreinfo'] = this.moreinfo;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class ServiceHistories {
  int? id;
  int? appointmentId;
  String? appointmentDate;
  int? patientId;
  int? caretakerId;
  String? patientBreakfasttime;
  String? patientBreakfasttimeDetails;
  String? patientLunchtime;
  String? patientLunchtimeDetails;
  String? patientSnackstime;
  String? patientSnackstimeDetails;
  String? patientDinnertime;
  String? patientDinnertimeDetails;
  String? patientMedicationsDetails;
  String? patientHydration;
  String? patientOralcare;
  String? patientBathing;
  String? patientDressing;
  String? patientToileting;
  String? patientWalkingtime;
  String? patientVitalsigns;
  String? patientBloodsugar;
  int? serviceStatus;
  String? createdAt;
  String? updatedAt;

  ServiceHistories(
      {this.id,
        this.appointmentId,
        this.appointmentDate,
        this.patientId,
        this.caretakerId,
        this.patientBreakfasttime,
        this.patientBreakfasttimeDetails,
        this.patientLunchtime,
        this.patientLunchtimeDetails,
        this.patientSnackstime,
        this.patientSnackstimeDetails,
        this.patientDinnertime,
        this.patientDinnertimeDetails,
        this.patientMedicationsDetails,
        this.patientHydration,
        this.patientOralcare,
        this.patientBathing,
        this.patientDressing,
        this.patientToileting,
        this.patientWalkingtime,
        this.patientVitalsigns,
        this.patientBloodsugar,
        this.serviceStatus,
        this.createdAt,
        this.updatedAt});

  ServiceHistories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    appointmentId = json['appointment_id'];
    appointmentDate = json['appointment_date'];
    patientId = json['patient_id'];
    caretakerId = json['caretaker_id'];
    patientBreakfasttime = json['patient_breakfasttime'];
    patientBreakfasttimeDetails = json['patient_breakfasttime_details'];
    patientLunchtime = json['patient_lunchtime'];
    patientLunchtimeDetails = json['patient_lunchtime_details'];
    patientSnackstime = json['patient_snackstime'];
    patientSnackstimeDetails = json['patient_snackstime_details'];
    patientDinnertime = json['patient_dinnertime'];
    patientDinnertimeDetails = json['patient_dinnertime_details'];
    patientMedicationsDetails = json['patient_medications_details'];
    patientHydration = json['patient_hydration'];
    patientOralcare = json['patient_oralcare'];
    patientBathing = json['patient_bathing'];
    patientDressing = json['patient_dressing'];
    patientToileting = json['patient_toileting'];
    patientWalkingtime = json['patient_walkingtime'];
    patientVitalsigns = json['patient_vitalsigns'];
    patientBloodsugar = json['patient_bloodsugar'];
    serviceStatus = json['service_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['appointment_id'] = this.appointmentId;
    data['appointment_date'] = this.appointmentDate;
    data['patient_id'] = this.patientId;
    data['caretaker_id'] = this.caretakerId;
    data['patient_breakfasttime'] = this.patientBreakfasttime;
    data['patient_breakfasttime_details'] = this.patientBreakfasttimeDetails;
    data['patient_lunchtime'] = this.patientLunchtime;
    data['patient_lunchtime_details'] = this.patientLunchtimeDetails;
    data['patient_snackstime'] = this.patientSnackstime;
    data['patient_snackstime_details'] = this.patientSnackstimeDetails;
    data['patient_dinnertime'] = this.patientDinnertime;
    data['patient_dinnertime_details'] = this.patientDinnertimeDetails;
    data['patient_medications_details'] = this.patientMedicationsDetails;
    data['patient_hydration'] = this.patientHydration;
    data['patient_oralcare'] = this.patientOralcare;
    data['patient_bathing'] = this.patientBathing;
    data['patient_dressing'] = this.patientDressing;
    data['patient_toileting'] = this.patientToileting;
    data['patient_walkingtime'] = this.patientWalkingtime;
    data['patient_vitalsigns'] = this.patientVitalsigns;
    data['patient_bloodsugar'] = this.patientBloodsugar;
    data['service_status'] = this.serviceStatus;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class PaymentHistories {
  int? id;
  int? appointmentId;
  int? patientId;
  int? caretakerId;
  String? patientName;
  String? caretakerName;
  String? amountPaid;
  String? caretakerFee;
  String? commissionFee;
  String? paymentGateway;
  String? paypalOrderId;
  String? payerId;
  String? payerName;
  String? payerEmail;
  String? currency;
  String? paymentStatus;
  String? createdAt;
  String? updatedAt;

  PaymentHistories(
      {this.id,
        this.appointmentId,
        this.patientId,
        this.caretakerId,
        this.patientName,
        this.caretakerName,
        this.amountPaid,
        this.caretakerFee,
        this.commissionFee,
        this.paymentGateway,
        this.paypalOrderId,
        this.payerId,
        this.payerName,
        this.payerEmail,
        this.currency,
        this.paymentStatus,
        this.createdAt,
        this.updatedAt});

  PaymentHistories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    appointmentId = json['appointment_id'];
    patientId = json['patient_id'];
    caretakerId = json['caretaker_id'];
    patientName = json['patient_name'];
    caretakerName = json['caretaker_name'];
    amountPaid = json['amount_paid'];
    caretakerFee = json['caretaker_fee'];
    commissionFee = json['commission_fee'];
    paymentGateway = json['payment_gateway'];
    paypalOrderId = json['paypal_order_id'];
    payerId = json['payer_id'];
    payerName = json['payer_name'];
    payerEmail = json['payer_email'];
    currency = json['currency'];
    paymentStatus = json['payment_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['appointment_id'] = this.appointmentId;
    data['patient_id'] = this.patientId;
    data['caretaker_id'] = this.caretakerId;
    data['patient_name'] = this.patientName;
    data['caretaker_name'] = this.caretakerName;
    data['amount_paid'] = this.amountPaid;
    data['caretaker_fee'] = this.caretakerFee;
    data['commission_fee'] = this.commissionFee;
    data['payment_gateway'] = this.paymentGateway;
    data['paypal_order_id'] = this.paypalOrderId;
    data['payer_id'] = this.payerId;
    data['payer_name'] = this.payerName;
    data['payer_email'] = this.payerEmail;
    data['currency'] = this.currency;
    data['payment_status'] = this.paymentStatus;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
