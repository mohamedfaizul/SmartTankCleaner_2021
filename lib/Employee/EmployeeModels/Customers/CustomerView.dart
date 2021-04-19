class EmployeeCusView {
  bool status;
  Items items;

  EmployeeCusView({this.status, this.items});

  EmployeeCusView.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    items = json['items'] != null ? new Items.fromJson(json['items']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.items != null) {
      data['items'] = this.items.toJson();
    }
    return data;
  }
}

class Items {
  String cusId;
  String cusCode;
  String cusRegNo;
  String cusName;
  String cusPhone;
  String cusEmail;
  String cusGender;
  String cusPassword;
  String cusAddress;
  String cusDistrict;
  String cusState;
  String cusPincode;
  String cusStatus;
  String cusGst;
  String accVerify;
  String otp;
  String refCount;
  String regType;
  String createdUtype;
  String updatedUtype;
  String createdAt;
  String createdBy;
  String updatedAt;
  String updatedBy;
  String districtName;
  String stateName;

  Items(
      {this.cusId,
      this.cusCode,
      this.cusRegNo,
      this.cusName,
      this.cusPhone,
      this.cusEmail,
      this.cusGender,
      this.cusPassword,
      this.cusAddress,
      this.cusDistrict,
      this.cusState,
      this.cusPincode,
      this.cusStatus,
      this.cusGst,
      this.accVerify,
      this.otp,
      this.refCount,
      this.regType,
      this.createdUtype,
      this.updatedUtype,
      this.createdAt,
      this.createdBy,
      this.updatedAt,
      this.updatedBy,
      this.districtName,
      this.stateName});

  Items.fromJson(Map<String, dynamic> json) {
    cusId = json['cus_id'];
    cusCode = json['cus_code'];
    cusRegNo = json['cus_reg_no'];
    cusName = json['cus_name'];
    cusPhone = json['cus_phone'];
    cusEmail = json['cus_email'];
    cusGender = json['cus_gender'];
    cusPassword = json['cus_password'];
    cusAddress = json['cus_address'];
    cusDistrict = json['cus_district'];
    cusState = json['cus_state'];
    cusPincode = json['cus_pincode'];
    cusStatus = json['cus_status'];
    cusGst = json['cus_gst'];
    accVerify = json['acc_verify'];
    otp = json['otp'];
    refCount = json['ref_count'];
    regType = json['reg_type'];
    createdUtype = json['created_utype'];
    updatedUtype = json['updated_utype'];
    createdAt = json['created_at'];
    createdBy = json['created_by'];
    updatedAt = json['updated_at'];
    updatedBy = json['updated_by'];
    districtName = json['district_name'];
    stateName = json['state_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cus_id'] = this.cusId;
    data['cus_code'] = this.cusCode;
    data['cus_reg_no'] = this.cusRegNo;
    data['cus_name'] = this.cusName;
    data['cus_phone'] = this.cusPhone;
    data['cus_email'] = this.cusEmail;
    data['cus_gender'] = this.cusGender;
    data['cus_password'] = this.cusPassword;
    data['cus_address'] = this.cusAddress;
    data['cus_district'] = this.cusDistrict;
    data['cus_state'] = this.cusState;
    data['cus_pincode'] = this.cusPincode;
    data['cus_status'] = this.cusStatus;
    data['cus_gst'] = this.cusGst;
    data['acc_verify'] = this.accVerify;
    data['otp'] = this.otp;
    data['ref_count'] = this.refCount;
    data['reg_type'] = this.regType;
    data['created_utype'] = this.createdUtype;
    data['updated_utype'] = this.updatedUtype;
    data['created_at'] = this.createdAt;
    data['created_by'] = this.createdBy;
    data['updated_at'] = this.updatedAt;
    data['updated_by'] = this.updatedBy;
    data['district_name'] = this.districtName;
    data['state_name'] = this.stateName;
    return data;
  }
}
