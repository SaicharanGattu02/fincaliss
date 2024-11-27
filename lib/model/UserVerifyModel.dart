class UserVerifyModel {
  final Data? data;
  final Settings? settings;

  UserVerifyModel({this.data, this.settings});

  factory UserVerifyModel.fromJson(Map<String, dynamic> json) {
    return UserVerifyModel(
      data: Data.fromJson(json['data']),
      settings: Settings.fromJson(json['settings']),
    );
  }
}

class Data {
  final Result? result;

  Data({this.result});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      result: Result.fromJson(json['result']),
    );
  }
}

class Result {
  final String? name;
  final String? phone;
  final String? email;
  final String? accountNumber;
  final String? accountHolderName;
  final String? ifsc;
  final String? bankName;

  Result({
    this.name,
    this.phone,
    this.email,
    this.accountNumber,
    this.accountHolderName,
    this.ifsc,
    this.bankName,
  });

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      name: json['Name'],
      phone: json['Phone'],
      email: json['Email'],
      accountNumber: json['accountNumber'],
      accountHolderName: json['accountHolderName'],
      ifsc: json['ifsc'],
      bankName: json['bankName'],
    );
  }
}

class Settings {
  final String? message;
  final int? status;
  final int? success;

  Settings({this.message, this.status, this.success});

  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
      message: json['message'],
      status: json['status'],
      success: json['success'],
    );
  }
}