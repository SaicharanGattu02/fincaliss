class LoanEMITenuresModel {
  final Data data;
  final Settings settings;

  LoanEMITenuresModel({required this.data, required this.settings});

  factory LoanEMITenuresModel.fromJson(Map<String, dynamic> json) {
    return LoanEMITenuresModel(
      data: Data.fromJson(json['data']),
      settings: Settings.fromJson(json['settings']),
    );
  }
}

class Data {
  final Result result;

  Data({required this.result});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      result: Result.fromJson(json['result']),
    );
  }
}

class Result {
  final String tenure;
  final double totalLoanAmount;
  final dynamic loanApproved;
  final double processingFee;
  final double gatewayFee;
  final double additionalFee;
  final double monthlyEmi;
  final Map<String, double> emiDates;
  final List<String> emiRepayDate;

  Result({
    required this.tenure,
    required this.totalLoanAmount,
    required this.loanApproved,
    required this.processingFee,
    required this.gatewayFee,
    required this.additionalFee,
    required this.monthlyEmi,
    required this.emiDates,
    required this.emiRepayDate,
  });

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      tenure: json['tenure'],
      totalLoanAmount: json['total_loan_amount'].toDouble(),
      loanApproved: json['loan_approved'],
      processingFee: json['processing_fee'].toDouble(),
      gatewayFee: json['gateway_fee'].toDouble(),
      additionalFee: json['additional_fee'].toDouble(),
      monthlyEmi: json['monthly emi'].toDouble(),
      emiDates: Map<String, double>.from(json['emi_dates'].map((k, v) => MapEntry(k, v.toDouble()))),
      emiRepayDate: List<String>.from(json['emi_repay_date']),
    );
  }
}

class Settings {
  final String message;
  final int status;
  final int success;

  Settings({required this.message, required this.status, required this.success});

  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
      message: json['message'],
      status: json['status'],
      success: json['success'],
    );
  }
}
