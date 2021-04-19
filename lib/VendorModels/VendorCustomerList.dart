class VendorCustomerListModel {
  bool status;
  int totalCount;
  List<Values> values;

  VendorCustomerListModel({this.status, this.totalCount, this.values});

  VendorCustomerListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    totalCount = json['total_count'];
    if (json['values'] != null) {
      values = new List<Values>();
      json['values'].forEach((v) {
        values.add(new Values.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['total_count'] = this.totalCount;
    if (this.values != null) {
      data['values'] = this.values.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Values {
  String cusId;
  String cusName;
  String cusCode;
  String cusPhone;
  String cusEmail;
  String cusStatus;

  Values(
      {this.cusId,
      this.cusName,
      this.cusCode,
      this.cusPhone,
      this.cusEmail,
      this.cusStatus});

  Values.fromJson(Map<String, dynamic> json) {
    cusId = json['cus_id'];
    cusName = json['cus_name'];
    cusCode = json['cus_code'];
    cusPhone = json['cus_phone'];
    cusEmail = json['cus_email'];
    cusStatus = json['cus_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cus_id'] = this.cusId;
    data['cus_name'] = this.cusName;
    data['cus_code'] = this.cusCode;
    data['cus_phone'] = this.cusPhone;
    data['cus_email'] = this.cusEmail;
    data['cus_status'] = this.cusStatus;
    return data;
  }
}
