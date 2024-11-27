class LoanOverView {
  Data? data;
  Settings? settings;

  LoanOverView({this.data, this.settings});

  LoanOverView.fromJson(Map<String, dynamic> json) {
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
  String? loan_id;
  double? loanRequired;
  double? emiValue;
  String? emiDate;

  Result({this.loan_id, this.loanRequired, this.emiValue, this.emiDate});

  Result.fromJson(Map<String, dynamic> json) {
    loan_id = json['loan_id'];
    loanRequired = json['loan_required']?.toDouble(); // Ensure it converts to double
    emiValue = json['emi_value']; // Convert String to int
    emiDate = json['emi_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['loan_id'] = this.loan_id;
    data['loan_required'] = this.loanRequired;
    data['emi_value'] = this.emiValue;
    data['emi_date'] = this.emiDate;
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