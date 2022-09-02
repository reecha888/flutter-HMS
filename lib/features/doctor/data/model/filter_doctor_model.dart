class FilterDoctorModel {
  bool? success;
  List<Data>? data;
  String? message;
  String? error;

  FilterDoctorModel({this.success, this.data, this.message, this.error});

  FilterDoctorModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    message = json['message'];
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    data['error'] = this.error;
    return data;
  }
}

class Data {
  String? specialistField;
  int? id;
  String? about;
  String? createAt;
  String? yearsOfExperience;
  String? nextAvailableAt;
  String? education;
  String? inClinicAppointmentFees;
  String? profilePic;
  String? firstName;
  String? lastName;
  String? gender;
  String? bloodGroup;
  String? contactNumber;
  String? email;
  String? dateOfBirth;
  List<Feedbacks>? feedbacks;

  Data(
      {this.specialistField,
        this.id,
        this.about,
        this.createAt,
        this.yearsOfExperience,
        this.nextAvailableAt,
        this.education,
        this.inClinicAppointmentFees,
        this.profilePic,
        this.firstName,
        this.lastName,
        this.gender,
        this.bloodGroup,
        this.contactNumber,
        this.email,
        this.dateOfBirth,
        this.feedbacks});

  Data.fromJson(Map<String, dynamic> json) {
    specialistField = json['specialist_field'];
    id = json['id'];
    about = json['about'];
    createAt = json['create_at'];
    yearsOfExperience = json['years_of_experience'];
    nextAvailableAt = json['next_available_at'];
    education = json['education'];
    inClinicAppointmentFees = json['in_clinic_appointment_fees'];
    profilePic = json['profile_pic'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    gender = json['gender'];
    bloodGroup = json['blood_group'];
    contactNumber = json['contact_number'];
    email = json['email'];
    dateOfBirth = json['date_of_birth'];
    if (json['feedbacks'] != null) {
      feedbacks = <Feedbacks>[];
      json['feedbacks'].forEach((v) {
        feedbacks!.add(new Feedbacks.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['specialist_field'] = this.specialistField;
    data['id'] = this.id;
    data['about'] = this.about;
    data['create_at'] = this.createAt;
    data['years_of_experience'] = this.yearsOfExperience;
    data['next_available_at'] = this.nextAvailableAt;
    data['education'] = this.education;
    data['in_clinic_appointment_fees'] = this.inClinicAppointmentFees;
    data['profile_pic'] = this.profilePic;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['gender'] = this.gender;
    data['blood_group'] = this.bloodGroup;
    data['contact_number'] = this.contactNumber;
    data['email'] = this.email;
    data['date_of_birth'] = this.dateOfBirth;
    if (this.feedbacks != null) {
      data['feedbacks'] = this.feedbacks!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Feedbacks {
  int? id;
  String? comment;
  String? rating;
  String? patientName;

  Feedbacks({this.id, this.comment, this.rating, this.patientName});

  Feedbacks.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    comment = json['comment'];
    rating = json['rating'];
    patientName = json['patient_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['comment'] = this.comment;
    data['rating'] = this.rating;
    data['patient_name'] = this.patientName;
    return data;
  }
}