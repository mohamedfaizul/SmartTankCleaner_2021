class DVStaffList {
  bool status;
  int totalCount;
  List<Values> values;

  DVStaffList({this.status, this.totalCount, this.values});

  DVStaffList.fromJson(Map<String, dynamic> json) {
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
  String dstaffId;
  String dstaffName;
  String dstaffCode;
  String dstaffEmail;
  String dstaffPhone;
  String dstaffPhoneAlter;
  String dstaffAddress;
  String dstaffState;
  String dstaffDistrict;
  String dstaffPincode;
  String dstaffApproval;
  String dstaffStatus;
  String dstaffPassword;
  String dvendorId;
  String dvendorCode;
  String dvendorCompanyname;
  String shopId;
  String shopName;
  String shopCode;

  Values(
      {this.dstaffId,
      this.dstaffName,
      this.dstaffCode,
      this.dstaffEmail,
      this.dstaffPhone,
      this.dstaffPhoneAlter,
      this.dstaffAddress,
      this.dstaffState,
      this.dstaffDistrict,
      this.dstaffPincode,
      this.dstaffApproval,
      this.dstaffStatus,
      this.dstaffPassword,
      this.dvendorId,
      this.dvendorCode,
      this.dvendorCompanyname,
      this.shopId,
      this.shopName,
      this.shopCode});

  Values.fromJson(Map<String, dynamic> json) {
    dstaffId = json['dstaff_id'];
    dstaffName = json['dstaff_name'];
    dstaffCode = json['dstaff_code'];
    dstaffEmail = json['dstaff_email'];
    dstaffPhone = json['dstaff_phone'];
    dstaffPhoneAlter = json['dstaff_phone_alter'];
    dstaffAddress = json['dstaff_address'];
    dstaffState = json['dstaff_state'];
    dstaffDistrict = json['dstaff_district'];
    dstaffPincode = json['dstaff_pincode'];
    dstaffApproval = json['dstaff_approval'];
    dstaffStatus = json['dstaff_status'];
    dstaffPassword = json['dstaff_password'];
    dvendorId = json['dvendor_id'];
    dvendorCode = json['dvendor_code'];
    dvendorCompanyname = json['dvendor_companyname'];
    shopId = json['shop_id'];
    shopName = json['shop_name'];
    shopCode = json['shop_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dstaff_id'] = this.dstaffId;
    data['dstaff_name'] = this.dstaffName;
    data['dstaff_code'] = this.dstaffCode;
    data['dstaff_email'] = this.dstaffEmail;
    data['dstaff_phone'] = this.dstaffPhone;
    data['dstaff_phone_alter'] = this.dstaffPhoneAlter;
    data['dstaff_address'] = this.dstaffAddress;
    data['dstaff_state'] = this.dstaffState;
    data['dstaff_district'] = this.dstaffDistrict;
    data['dstaff_pincode'] = this.dstaffPincode;
    data['dstaff_approval'] = this.dstaffApproval;
    data['dstaff_status'] = this.dstaffStatus;
    data['dstaff_password'] = this.dstaffPassword;
    data['dvendor_id'] = this.dvendorId;
    data['dvendor_code'] = this.dvendorCode;
    data['dvendor_companyname'] = this.dvendorCompanyname;
    data['shop_id'] = this.shopId;
    data['shop_name'] = this.shopName;
    data['shop_code'] = this.shopCode;
    return data;
  }
}
