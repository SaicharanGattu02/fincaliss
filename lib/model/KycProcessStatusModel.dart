class KycProcessStatusModel {
  Data? data;
  Settings? settings;

  KycProcessStatusModel({this.data, this.settings});

  KycProcessStatusModel.fromJson(Map<String, dynamic> json) {
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
  String? provisionStatus;
  bool? isLoanAppComplete;
  int? id;
  bool? isContactAdded;
  String? createdAt;
  bool? isPanVerified;
  bool? isReferenceCompleted;
  bool? isWorkCompleted;
  bool? isBasicCompleted;
  bool? isBankVerified;
  bool? isLivenessCompleted;
  String? modifiedAt;
  bool? isAdhaarVerified;
  bool? isCreditReportAdded;
  bool? isPanImageUploaded;
  int? userId;
  bool? isAadharImageUploaded;
  String? uid;
  bool? isDocumentCompleted;
  bool? isActive;

  Result({
    this.provisionStatus,
    this.isLoanAppComplete,
    this.id,
    this.isContactAdded,
    this.createdAt,
    this.isPanVerified,
    this.isReferenceCompleted,
    this.isWorkCompleted,
    this.isBasicCompleted,
    this.isBankVerified,
    this.isLivenessCompleted,
    this.modifiedAt,
    this.isAdhaarVerified,
    this.isCreditReportAdded,
    this.isPanImageUploaded,
    this.userId,
    this.isAadharImageUploaded,
    this.uid,
    this.isDocumentCompleted,
    this.isActive,
  });

  Result.fromJson(Map<String, dynamic> json) {
    provisionStatus = json['provision_status'];
    isLoanAppComplete = json['is_loan_app_complete'];
    id = json['id'];
    isContactAdded = json['is_contact_added'];
    createdAt = json['created_at'];
    isPanVerified = json['is_pan_verified'];
    isReferenceCompleted = json['is_reference_completed'];
    isWorkCompleted = json['is_work_completed'];
    isBasicCompleted = json['is_basic_completed'];
    isBankVerified = json['is_bank_verified'];
    isLivenessCompleted = json['is_liveness_completed'];
    modifiedAt = json['modified_at'];
    isAdhaarVerified = json['is_adhaar_verified'];
    isCreditReportAdded = json['is_credit_report_added'];
    isPanImageUploaded = json['is_pan_image_uploaded'];
    userId = json['user_id'];
    isAadharImageUploaded = json['is_aadhar_image_uploaded'];
    uid = json['uid'];
    isDocumentCompleted = json['is_document_completed'];
    isActive = json['is_active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['provision_status'] = this.provisionStatus;
    data['is_loan_app_complete'] = this.isLoanAppComplete;
    data['id'] = this.id;
    data['is_contact_added'] = this.isContactAdded;
    data['created_at'] = this.createdAt;
    data['is_pan_verified'] = this.isPanVerified;
    data['is_reference_completed'] = this.isReferenceCompleted;
    data['is_work_completed'] = this.isWorkCompleted;
    data['is_basic_completed'] = this.isBasicCompleted;
    data['is_bank_verified'] = this.isBankVerified;
    data['is_liveness_completed'] = this.isLivenessCompleted;
    data['modified_at'] = this.modifiedAt;
    data['is_adhaar_verified'] = this.isAdhaarVerified;
    data['is_credit_report_added'] = this.isCreditReportAdded;
    data['is_pan_image_uploaded'] = this.isPanImageUploaded;
    data['user_id'] = this.userId;
    data['is_aadhar_image_uploaded'] = this.isAadharImageUploaded;
    data['uid'] = this.uid;
    data['is_document_completed'] = this.isDocumentCompleted;
    data['is_active'] = this.isActive;
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
