class SchoolsListModel {
  Settings? settings;
  Data? data;

  SchoolsListModel({this.settings, this.data});

  SchoolsListModel.fromJson(Map<String, dynamic> json) {
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
  String? name;

  Result({this.name});

  Result.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    return data;
  }
}


