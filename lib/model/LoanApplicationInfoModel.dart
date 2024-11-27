class LoanApplicationInfoModel {
  Data? data;
  Settings? settings;

  LoanApplicationInfoModel({this.data, this.settings});

  LoanApplicationInfoModel.fromJson(Map<String, dynamic> json) {
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
  int? tenure; // Change this to String to match JSON
  double? loanApproved;
  double? processingFee; // Update type to double if JSON provides a decimal value
  double? gatewayFee; // Update type to double
  double? additionalFee; // Update type to double

  Result({
    this.tenure,
    this.loanApproved,
    this.processingFee,
    this.gatewayFee,
    this.additionalFee,
  });

  Result.fromJson(Map<String, dynamic> json) {
    tenure = json['tenure']; // No need for type conversion here
    loanApproved = json['loan_approved'];
    processingFee = (json['processing_fee'] as num?)?.toDouble(); // Handle decimal numbers
    gatewayFee = (json['gateway_fee'] as num?)?.toDouble(); // Handle decimal numbers
    additionalFee = (json['additional_fee'] as num?)?.toDouble(); // Handle decimal numbers
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tenure'] = this.tenure;
    data['loan_approved'] = this.loanApproved;
    data['processing_fee'] = this.processingFee;
    data['gateway_fee'] = this.gatewayFee;
    data['additional_fee'] = this.additionalFee;
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
