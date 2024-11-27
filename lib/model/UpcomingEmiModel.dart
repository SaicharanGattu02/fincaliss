class UpcomingEmiModel {
  Settings? settings;
  Data? data;

  UpcomingEmiModel({this.settings, this.data});

  UpcomingEmiModel.fromJson(Map<String, dynamic> json) {
    settings = json['settings'] != null
        ? Settings.fromJson(json['settings'])
        : null;
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
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
    result = json['result'] != null ? Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    return data;
  }
}

class Result {
  Upcoming? upcoming;

  Result({this.upcoming});

  Result.fromJson(Map<String, dynamic> json) {
    upcoming = json['upcoming'] != null
        ? new Upcoming.fromJson(json['upcoming'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.upcoming != null) {
      data['upcoming'] = this.upcoming!.toJson();
    }
    return data;
  }
}

class Upcoming {
  String? date;
  String? amount;

  Upcoming({this.date, this.amount});

  Upcoming.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['amount'] = this.amount;
    return data;
  }
}