class EmibrakeupModel {
  Settings? settings;
  Data? data;

  EmibrakeupModel({this.settings, this.data});

  factory EmibrakeupModel.fromJson(Map<String, dynamic> json) {
    return EmibrakeupModel(
      data: json['data'] != null ? Data.fromJson(json['data']) : null,
      settings: json['settings'] != null ? Settings.fromJson(json['settings']) : null,
    );
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

class Data {
  final List<RepaymentDetail>? result;

  Data({this.result});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      result: json['result'] != null
          ? List<RepaymentDetail>.from(
          json['result'].map((item) => RepaymentDetail.fromJson(item)))
          : null,
    );
  }
}

class RepaymentDetail {
  final String date;
  final double amount;  // Keep this as double

  RepaymentDetail({required this.date, required this.amount});

  // Factory constructor to create RepaymentDetail from JSON
  factory RepaymentDetail.fromJson(Map<String, dynamic> json) {
    // Convert amount from String to double
    final amount = double.tryParse(json['amount'].toString()) ?? 0.0;

    return RepaymentDetail(
      date: json['date'],
      amount: amount,
    );
  }
}
