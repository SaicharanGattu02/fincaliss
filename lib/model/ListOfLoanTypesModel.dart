class ListOfLoanTypesModel {
  Data? data;
  Settings? settings;

  ListOfLoanTypesModel({this.data, this.settings});

  ListOfLoanTypesModel.fromJson(Map<String, dynamic> json) {
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
  List<Result>? result;

  Data({this.result});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['result'] != null) {
      result = <Result>[];
      json['result'].forEach((v) {
        result!.add(new Result.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Result {
  double? processingFee;
  double? roi;
  double? additionalFee;
  String? uid;
  String? createdDate;
  bool? isActive;
  double? limit;
  String? name;
  double? gatewayFee;
  double? lateFee;
  int? id;
  String? modifiedAt;

  Result(
      {this.processingFee,
        this.roi,
        this.additionalFee,
        this.uid,
        this.createdDate,
        this.isActive,
        this.limit,
        this.name,
        this.gatewayFee,
        this.lateFee,
        this.id,
        this.modifiedAt});

  Result.fromJson(Map<String, dynamic> json) {
    processingFee = json['processing_fee'];
    roi = json['roi'];
    additionalFee = json['additional_fee'];
    uid = json['uid'];
    createdDate = json['created_date'];
    isActive = json['is_active'];
    limit = json['limit'];
    name = json['name'];
    gatewayFee = json['gateway_fee'];
    lateFee = json['late_fee'];
    id = json['id'];
    modifiedAt = json['modified_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['processing_fee'] = this.processingFee;
    data['roi'] = this.roi;
    data['additional_fee'] = this.additionalFee;
    data['uid'] = this.uid;
    data['created_date'] = this.createdDate;
    data['is_active'] = this.isActive;
    data['limit'] = this.limit;
    data['name'] = this.name;
    data['gateway_fee'] = this.gatewayFee;
    data['late_fee'] = this.lateFee;
    data['id'] = this.id;
    data['modified_at'] = this.modifiedAt;
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
