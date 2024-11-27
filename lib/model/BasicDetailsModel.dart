class BasicDetailsModel {
  Data? data;
  Settings? settings;

  BasicDetailsModel({this.data, this.settings});

  BasicDetailsModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    settings = json['settings'] != null ? Settings.fromJson(json['settings']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (this.settings != null) {
      data['settings'] = this.settings!.toJson();
    }
    return data;
  }
}

class Data {
  Result? result;

  Data({this.result});

  Data.fromJson(Map<String, dynamic> json) {
    result = json['result'] != null ? Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    return data;
  }
}

class Result {
  String? fatherName;
  String? dob;
  String? address;
  String? gender;
  String? profession;
  String? uid;
  String? createdDate;
  String? modifiedAt;
  String? fullName;
  String? motherName;
  String? maritalStatus;
  int? pincode;
  String? loanPurpose;
  String? aadhaar;
  String? pan;
  String? pan_image;
  String? email;
  int? userId;
  int? id;

  Result({
    this.fatherName,
    this.dob,
    this.address,
    this.gender,
    this.profession,
    this.uid,
    this.createdDate,
    this.modifiedAt,
    this.fullName,
    this.motherName,
    this.maritalStatus,
    this.pincode,
    this.loanPurpose,
    this.aadhaar,
    this.pan,
    this.pan_image,
    this.userId,
    this.id,
    this.email,
  });

  Result.fromJson(Map<String, dynamic> json) {
    fatherName = json['father_name'];
    dob = json['dob'];
    address = json['address'];
    gender = json['gender'];
    profession = json['profession'];
    uid = json['uid'];
    createdDate = json['created_date'];
    modifiedAt = json['modified_at'];
    fullName = json['full_name'];
    motherName = json['mother_name'];
    maritalStatus = json['marital_status'];
    pincode = json['pincode'];
    loanPurpose = json['loan_purpose'];
    aadhaar = json['aadhaar'];
    pan = json['pan'];
    pan_image = json['pan_image'];
    userId = json['user_id'];
    id = json['id'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['father_name'] = fatherName;
    data['dob'] = dob;
    data['address'] = address;
    data['gender'] = gender;
    data['profession'] = profession;
    data['uid'] = uid;
    data['created_date'] = createdDate;
    data['modified_at'] = modifiedAt;
    data['full_name'] = fullName;
    data['mother_name'] = motherName;
    data['marital_status'] = maritalStatus;
    data['pincode'] = pincode;
    data['loan_purpose'] = loanPurpose;
    data['aadhaar'] = aadhaar;
    data['pan'] = pan;
    data['pan_image'] = pan_image;
    data['user_id'] = userId;
    data['id'] = id;
    data['email'] = email;
    return data;
  }
}

class Settings {
  String? message;
  int? status;
  int? success;

  Settings({this.message, this.status, this.success});

  Settings.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = message;
    data['status'] = status;
    data['success'] = success;
    return data;
  }
}
