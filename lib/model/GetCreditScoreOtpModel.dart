class GetCreditScoreOtpModel {
  Msg? msg;
  int? status;

  GetCreditScoreOtpModel({this.msg, this.status});

  GetCreditScoreOtpModel.fromJson(Map<String, dynamic> json) {
    msg = json['msg'] != null ? new Msg.fromJson(json['msg']) : null;
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.msg != null) {
      data['msg'] = this.msg!.toJson();
    }
    data['status'] = this.status;
    return data;
  }
}

class Msg {
  String? msg;
  String? tsTransID;

  Msg({this.msg, this.tsTransID});

  Msg.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    tsTransID = json['tsTransID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    data['tsTransID'] = this.tsTransID;
    return data;
  }
}