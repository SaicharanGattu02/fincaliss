class Loantypes {
  int? processingFee;
  int? roi;
  int? additionalFee;
  String? uid;
  String? createdDate;
  bool? isActive;
  int? limit;
  String? name;
  int? gatewayFee;
  int? lateFee;
  int? id;
  Null? modifiedAt;

  Loantypes(
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

  Loantypes.fromJson(Map<String, dynamic> json) {
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