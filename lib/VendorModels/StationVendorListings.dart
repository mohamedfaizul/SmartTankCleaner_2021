class VendorListings {
  bool status;
  int totalCount;
  List<Values> values;

  VendorListings({this.status, this.totalCount, this.values});

  VendorListings.fromJson(Map<String, dynamic> json) {
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
  String vendorId;
  String vendorName;
  String vendorCode;
  String vendorEmail;
  String vendorPhone;
  String vendorPhoneAlter;
  String vendorCompanyname;
  String vendorAddress;
  String vendorState;
  String vendorDistrict;
  String vendorWallet;
  String vendorPincode;
  String vendorApproval;
  String vendorStatus;
  String vendorPassword;

  Values(
      {this.vendorId,
      this.vendorName,
      this.vendorCode,
      this.vendorEmail,
      this.vendorPhone,
      this.vendorPhoneAlter,
      this.vendorCompanyname,
      this.vendorAddress,
      this.vendorState,
      this.vendorDistrict,
      this.vendorWallet,
      this.vendorPincode,
      this.vendorApproval,
      this.vendorStatus,
      this.vendorPassword});

  Values.fromJson(Map<String, dynamic> json) {
    vendorId = json['vendor_id'];
    vendorName = json['vendor_name'];
    vendorCode = json['vendor_code'];
    vendorEmail = json['vendor_email'];
    vendorPhone = json['vendor_phone'];
    vendorPhoneAlter = json['vendor_phone_alter'];
    vendorCompanyname = json['vendor_companyname'];
    vendorAddress = json['vendor_address'];
    vendorState = json['vendor_state'];
    vendorDistrict = json['vendor_district'];
    vendorWallet = json['vendor_wallet'];
    vendorPincode = json['vendor_pincode'];
    vendorApproval = json['vendor_approval'];
    vendorStatus = json['vendor_status'];
    vendorPassword = json['vendor_password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vendor_id'] = this.vendorId;
    data['vendor_name'] = this.vendorName;
    data['vendor_code'] = this.vendorCode;
    data['vendor_email'] = this.vendorEmail;
    data['vendor_phone'] = this.vendorPhone;
    data['vendor_phone_alter'] = this.vendorPhoneAlter;
    data['vendor_companyname'] = this.vendorCompanyname;
    data['vendor_address'] = this.vendorAddress;
    data['vendor_state'] = this.vendorState;
    data['vendor_district'] = this.vendorDistrict;
    data['vendor_wallet'] = this.vendorWallet;
    data['vendor_pincode'] = this.vendorPincode;
    data['vendor_approval'] = this.vendorApproval;
    data['vendor_status'] = this.vendorStatus;
    data['vendor_password'] = this.vendorPassword;
    return data;
  }
}
