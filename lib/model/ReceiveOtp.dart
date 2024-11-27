class RecieveOtp {
  String? requestId;
  String? type;

  RecieveOtp({this.requestId, this.type});

  RecieveOtp.fromJson(Map<String, dynamic> json) {
    requestId = json['request_id'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['request_id'] = this.requestId;
    data['type'] = this.type;
    return data;
  }
}
