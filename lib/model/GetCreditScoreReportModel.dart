class GetCreditScoreReportModel {
  Settings? settings;
  Data? data;

  GetCreditScoreReportModel({this.settings, this.data});

  GetCreditScoreReportModel.fromJson(Map<String, dynamic> json) {
    settings = json['settings'] != null
        ? new Settings.fromJson(json['settings'])
        : null;
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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
  ApplicationInformation? applicationInformation;
  InsightsCredit? insightsCredit;
  Persona? persona;
  String? reportFile;

  Result(
      {this.applicationInformation,
        this.insightsCredit,
        this.persona,
        this.reportFile});

  Result.fromJson(Map<String, dynamic> json) {
    applicationInformation = json['application_information'] != null
        ? new ApplicationInformation.fromJson(json['application_information'])
        : null;
    insightsCredit = json['insights_credit'] != null
        ? new InsightsCredit.fromJson(json['insights_credit'])
        : null;
    persona =
    json['persona'] != null ? new Persona.fromJson(json['persona']) : null;
    reportFile = json['report_file'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.applicationInformation != null) {
      data['application_information'] = this.applicationInformation!.toJson();
    }
    if (this.insightsCredit != null) {
      data['insights_credit'] = this.insightsCredit!.toJson();
    }
    if (this.persona != null) {
      data['persona'] = this.persona!.toJson();
    }
    data['report_file'] = this.reportFile;
    return data;
  }
}

class ApplicationInformation {
  String? address;
  String? city;
  String? dob;
  String? emailAddress;
  String? firstName;
  String? gender;
  String? idNumber;
  String? idType;
  String? lastName;
  String? mobileNumber;
  String? pincode;
  String? reportPullDate;
  String? state;

  ApplicationInformation(
      {this.address,
        this.city,
        this.dob,
        this.emailAddress,
        this.firstName,
        this.gender,
        this.idNumber,
        this.idType,
        this.lastName,
        this.mobileNumber,
        this.pincode,
        this.reportPullDate,
        this.state});

  ApplicationInformation.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    city = json['city'];
    dob = json['dob'];
    emailAddress = json['email_address'];
    firstName = json['first_name'];
    gender = json['gender'];
    idNumber = json['id_number'];
    idType = json['id_type'];
    lastName = json['last_name'];
    mobileNumber = json['mobile_number'];
    pincode = json['pincode'];
    reportPullDate = json['report_pull_date'];
    state = json['state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['city'] = this.city;
    data['dob'] = this.dob;
    data['email_address'] = this.emailAddress;
    data['first_name'] = this.firstName;
    data['gender'] = this.gender;
    data['id_number'] = this.idNumber;
    data['id_type'] = this.idType;
    data['last_name'] = this.lastName;
    data['mobile_number'] = this.mobileNumber;
    data['pincode'] = this.pincode;
    data['report_pull_date'] = this.reportPullDate;
    data['state'] = this.state;
    return data;
  }
}

class InsightsCredit {
  String? accountClosed;
  String? accountOpen;
  String? creditAge;
  String? creditUtilization;
  String? newCreditAccount;
  String? securedLoan;
  String? unsecuredLoan;

  InsightsCredit(
      {this.accountClosed,
        this.accountOpen,
        this.creditAge,
        this.creditUtilization,
        this.newCreditAccount,
        this.securedLoan,
        this.unsecuredLoan});

  InsightsCredit.fromJson(Map<String, dynamic> json) {
    accountClosed = json['account_closed'];
    accountOpen = json['account_open'];
    creditAge = json['credit_age'];
    creditUtilization = json['credit_utilization'];
    newCreditAccount = json['new_credit_account'];
    securedLoan = json['secured_loan'];
    unsecuredLoan = json['unsecured_loan'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['account_closed'] = this.accountClosed;
    data['account_open'] = this.accountOpen;
    data['credit_age'] = this.creditAge;
    data['credit_utilization'] = this.creditUtilization;
    data['new_credit_account'] = this.newCreditAccount;
    data['secured_loan'] = this.securedLoan;
    data['unsecured_loan'] = this.unsecuredLoan;
    return data;
  }
}

class Persona {
  String? creditScore;

  Persona({this.creditScore});

  Persona.fromJson(Map<String, dynamic> json) {
    creditScore = json['credit_score'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['credit_score'] = this.creditScore;
    return data;
  }
}

