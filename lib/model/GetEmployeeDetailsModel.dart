class GetEmployeeDetailsModel {
  Data? data;
  Settings? settings;

  GetEmployeeDetailsModel({this.data, this.settings});

  GetEmployeeDetailsModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    settings = json['settings'] != null ? Settings.fromJson(json['settings']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
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
    final Map<String, dynamic> data = {};
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    return data;
  }
}

class Result {
  String? designation;
  String? mobile;
  String? officeId; // If this should be an int, adjust accordingly.
  int? industry_type_id; // Changed from String? to int?
  String? companyAddress;
  int? userId; // Changed from String? to int?
  String? uid;
  String? createdDate; // This can stay as String if the API provides it as a string.
  String? officeEmail;
  String? companyName;
  double? workExp; // Use double for numerical values
  int? pincode; // This is likely a String, as it's a postal code.
  int? id; // Changed from String? to int?
  String? modifiedAt; // Use String? for date-time strings
  double? salary; // Use double for numerical values

  Result({
    this.designation,
    this.officeId,
    this.industry_type_id,
    this.companyAddress,
    this.userId,
    this.uid,
    this.createdDate,
    this.officeEmail,
    this.companyName,
    this.workExp,
    this.pincode,
    this.id,
    this.modifiedAt,
    this.salary,
    this.mobile,
  });

  Result.fromJson(Map<String, dynamic> json) {
    designation = json['designation'];
    officeId = json['office_id']; // Adjust if this is supposed to be an int
    industry_type_id = json['industry_type_id'];
    companyAddress = json['company_address'];
    userId = json['user_id'];
    uid = json['uid'];
    createdDate = json['created_at']; // Changed from 'created_date' to 'created_at' to match API
    officeEmail = json['office_email'];
    companyName = json['company_name'];
    workExp = json['work_exp'] is int ? (json['work_exp'] as int).toDouble() : json['work_exp']?.toDouble(); // Handle both int and double
    pincode = json['pincode'];
    id = json['id'];
    modifiedAt = json['modified_at'];
    salary = json['salary'];
    mobile = json['mobile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['designation'] = this.designation;
    data['office_id'] = this.officeId; // Adjust if this is supposed to be an int
    data['industry_type_id'] = this.industry_type_id;
    data['company_address'] = this.companyAddress;
    data['user_id'] = this.userId;
    data['uid'] = this.uid;
    data['created_at'] = this.createdDate; // Changed from 'created_date' to 'created_at'
    data['office_email'] = this.officeEmail;
    data['company_name'] = this.companyName;
    data['work_exp'] = this.workExp;
    data['pincode'] = this.pincode;
    data['id'] = this.id;
    data['modified_at'] = this.modifiedAt;
    data['salary'] = this.salary;
    data['mobile'] = this.mobile;
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
    final Map<String, dynamic> data = {};
    data['message'] = this.message;
    data['status'] = this.status;
    data['success'] = this.success;
    return data;
  }
}
