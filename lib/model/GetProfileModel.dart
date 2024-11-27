class GetProfileModel {
  Settings? settings;
  Data? data;

  GetProfileModel({this.settings, this.data});

  factory GetProfileModel.fromJson(Map<String, dynamic> json) {
    return GetProfileModel(
      settings: json['settings'] != null
          ? Settings.fromJson(json['settings'])
          : null,
      data: json['data'] != null ? Data.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.settings != null) {
      data['settings'] = this.settings!.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Settings {
  String? message;
  int? status;
  int? success;

  Settings({this.message, this.status, this.success});

  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
      message: json['message'],
      status: json['status'],
      success: json['success'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['status'] = status;
    data['success'] = success;
    return data;
  }
}

class Data {
  Result? result;

  Data({this.result});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      result: json['result'] != null ? Result.fromJson(json['result']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    return data;
  }
}

class Result {
  bool? emailVerified;
  bool? is_contact_added;
  String? fcmToken;
  DateTime? modifiedAt;
  bool? isActive;
  String? uid;
  DateTime? createdAt;
  int? id;
  bool? isSuperuser;
  String? fullName;
  String? email;
  bool? isAdmin;
  String? image;
  bool? isBlocked;
  String? mobile;
  bool? isStaff;
  String? userType;
  String? password;

  Result({
    this.emailVerified,
    this.fcmToken,
    this.modifiedAt,
    this.isActive,
    this.uid,
    this.createdAt,
    this.id,
    this.isSuperuser,
    this.fullName,
    this.email,
    this.isAdmin,
    this.image,
    this.isBlocked,
    this.mobile,
    this.isStaff,
    this.userType,
    this.password,
    this.is_contact_added,
  });

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      emailVerified: json['email_verified'],
      fcmToken: json['fcm_token'],
      modifiedAt: json['modified_at'] != null
          ? DateTime.parse(json['modified_at'])
          : null,
      isActive: json['is_active'],
      uid: json['uid'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      id: json['id'],
      isSuperuser: json['is_superuser'],
      fullName: json['full_name'],
      email: json['email'],
      isAdmin: json['is_admin'],
      image: json['image'],
      isBlocked: json['is_blocked'],
      mobile: json['mobile'],
      isStaff: json['is_staff'],
      userType: json['user_type'],
      password: json['password'],
      is_contact_added: json['is_contact_added'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email_verified'] = emailVerified;
    data['fcm_token'] = fcmToken;
    data['modified_at'] = modifiedAt?.toIso8601String();
    data['is_active'] = isActive;
    data['uid'] = uid;
    data['created_at'] = createdAt?.toIso8601String();
    data['id'] = id;
    data['is_superuser'] = isSuperuser;
    data['full_name'] = fullName;
    data['email'] = email;
    data['is_admin'] = isAdmin;
    data['image'] = image;
    data['is_blocked'] = isBlocked;
    data['mobile'] = mobile;
    data['is_staff'] = isStaff;
    data['user_type'] = userType;
    data['password'] = password;
    data['is_contact_added'] = is_contact_added;
    return data;
  }
}
