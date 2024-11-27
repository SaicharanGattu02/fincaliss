
class BusinessDetailsModel {
  final Settings settings;
  final Data data;

  BusinessDetailsModel({
    required this.settings,
    required this.data,
  });

  factory BusinessDetailsModel.fromJson(Map<String, dynamic> json) {
    return BusinessDetailsModel(
      settings: Settings.fromJson(json['settings']),
      data: Data.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'settings': settings.toJson(),
      'data': data.toJson(),
    };
  }
}

class Settings {
  final String message;
  final int status;
  final int success;

  Settings({
    required this.message,
    required this.status,
    required this.success,
  });

  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
      message: json['message'],
      status: json['status'],
      success: json['success'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'status': status,
      'success': success,
    };
  }
}

class Data {
  final Result? result;

  Data({
    this.result,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      result: json['result'] != null ? Result.fromJson(json['result']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'result': result?.toJson(),
    };
  }
}


class Result {
  final String registeredAddress;
  final double annualIncome;
  final int registrationTypeId;
  final int natureOfBusinessId;
  final String uid;
  final bool isActive;
  final String officialEmail;
  final int pincode;
  final String businessName;
  final int userId;
  final int id;
  final DateTime createdAt;
  final DateTime modifiedAt;

  Result({
    required this.registeredAddress,
    required this.annualIncome,
    required this.registrationTypeId,
    required this.natureOfBusinessId,
    required this.uid,
    required this.isActive,
    required this.officialEmail,
    required this.pincode,
    required this.businessName,
    required this.userId,
    required this.id,
    required this.createdAt,
    required this.modifiedAt,
  });

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      registeredAddress: json['registered_address'],
      annualIncome: json['annual_income'].toDouble(),
      registrationTypeId: json['registration_type_id'],
      natureOfBusinessId: json['nature_of_business_id'],
      uid: json['uid'],
      isActive: json['is_active'],
      officialEmail: json['official_email'],
      pincode: json['pincode'],
      businessName: json['business_name'],
      userId: json['user_id'],
      id: json['id'],
      createdAt: DateTime.parse(json['created_at']),
      modifiedAt: DateTime.parse(json['modified_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'registered_address': registeredAddress,
      'annual_income': annualIncome,
      'registration_type_id': registrationTypeId,
      'nature_of_business_id': natureOfBusinessId,
      'uid': uid,
      'is_active': isActive,
      'official_email': officialEmail,
      'pincode': pincode,
      'business_name': businessName,
      'user_id': userId,
      'id': id,
      'created_at': createdAt.toIso8601String(),
      'modified_at': modifiedAt.toIso8601String(),
    };
  }
}

