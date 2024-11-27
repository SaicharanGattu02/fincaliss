class StudentModel {
  Data? data;
  Settings? settings;

  StudentModel({this.data, this.settings});

  StudentModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    settings = json['settings'] != null
        ? new Settings.fromJson(json['settings'])
        : null;
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
    result =
    json['result'] != null ? new Result.fromJson(json['result']) : null;
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
  String? branch;
  String? studentClass;
  double? fee;
  String? guardianMobile;
  String? guardianPan;
  int? userId;
  int? id;
  String? modifiedAt;
  String? studentName;
  String? schoolName;
  String? guardianName;
  String? guardianAadhaar;
  bool? isActive;
  String? uid;
  String? createdDate;

  Result(
      {this.branch,
        this.studentClass,
        this.fee,
        this.guardianMobile,
        this.guardianPan,
        this.userId,
        this.id,
        this.modifiedAt,
        this.studentName,
        this.schoolName,
        this.guardianName,
        this.guardianAadhaar,
        this.isActive,
        this.uid,
        this.createdDate});

  Result.fromJson(Map<String, dynamic> json) {
    branch = json['branch'];
    studentClass = json['student_class'];
    fee = json['fee'];
    guardianMobile = json['guardian_mobile'];
    guardianPan = json['guardian_pan'];
    userId = json['user_id'];
    id = json['id'];
    modifiedAt = json['modified_at'];
    studentName = json['student_name'];
    schoolName = json['school_name'];
    guardianName = json['guardian_name'];
    guardianAadhaar = json['guardian_aadhaar'];
    isActive = json['is_active'];
    uid = json['uid'];
    createdDate = json['created_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['branch'] = this.branch;
    data['student_class'] = this.studentClass;
    data['fee'] = this.fee;
    data['guardian_mobile'] = this.guardianMobile;
    data['guardian_pan'] = this.guardianPan;
    data['user_id'] = this.userId;
    data['id'] = this.id;
    data['modified_at'] = this.modifiedAt;
    data['student_name'] = this.studentName;
    data['school_name'] = this.schoolName;
    data['guardian_name'] = this.guardianName;
    data['guardian_aadhaar'] = this.guardianAadhaar;
    data['is_active'] = this.isActive;
    data['uid'] = this.uid;
    data['created_date'] = this.createdDate;
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
    data['message'] = this.message;
    data['status'] = this.status;
    data['success'] = this.success;
    return data;
  }
}