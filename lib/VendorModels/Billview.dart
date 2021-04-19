class VendorBillView {
  bool status;
  Data data;

  VendorBillView({this.status, this.data});

  VendorBillView.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  String sbillId;
  String sbillCode;
  String sbillInvno;
  String vendorId;
  String serviceId;
  String sbillAmnt;
  String sbillApproval;
  String sbillStatus;
  String sbillPaymentStatus;
  String sbillDate;
  String sbillInvDate;
  String vendorCode;
  String vendorName;
  String vendorCompanyname;
  String vendorPhone;
  String vendorEmail;
  String vendorGst;
  String vendorAddress;
  String vendorPincode;
  String vendorDistrict;
  String vendorState;
  String vendorBankDetails;

  Data(
      {this.sbillId,
      this.sbillCode,
      this.sbillInvno,
      this.vendorId,
      this.serviceId,
      this.sbillAmnt,
      this.sbillApproval,
      this.sbillStatus,
      this.sbillPaymentStatus,
      this.sbillDate,
      this.sbillInvDate,
      this.vendorCode,
      this.vendorName,
      this.vendorCompanyname,
      this.vendorPhone,
      this.vendorEmail,
      this.vendorGst,
      this.vendorAddress,
      this.vendorPincode,
      this.vendorDistrict,
      this.vendorState,
      this.vendorBankDetails});

  Data.fromJson(Map<String, dynamic> json) {
    sbillId = json['sbill_id'];
    sbillCode = json['sbill_code'];
    sbillInvno = json['sbill_invno'];
    vendorId = json['vendor_id'];
    serviceId = json['service_id'];
    sbillAmnt = json['sbill_amnt'];
    sbillApproval = json['sbill_approval'];
    sbillStatus = json['sbill_status'];
    sbillPaymentStatus = json['sbill_payment_status'];
    sbillDate = json['sbill_date'];
    sbillInvDate = json['sbill_inv_date'];
    vendorCode = json['vendor_code'];
    vendorName = json['vendor_name'];
    vendorCompanyname = json['vendor_companyname'];
    vendorPhone = json['vendor_phone'];
    vendorEmail = json['vendor_email'];
    vendorGst = json['vendor_gst'];
    vendorAddress = json['vendor_address'];
    vendorPincode = json['vendor_pincode'];
    vendorDistrict = json['vendor_district'];
    vendorState = json['vendor_state'];
    vendorBankDetails = json['vendor_bank_details'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sbill_id'] = this.sbillId;
    data['sbill_code'] = this.sbillCode;
    data['sbill_invno'] = this.sbillInvno;
    data['vendor_id'] = this.vendorId;
    data['service_id'] = this.serviceId;
    data['sbill_amnt'] = this.sbillAmnt;
    data['sbill_approval'] = this.sbillApproval;
    data['sbill_status'] = this.sbillStatus;
    data['sbill_payment_status'] = this.sbillPaymentStatus;
    data['sbill_date'] = this.sbillDate;
    data['sbill_inv_date'] = this.sbillInvDate;
    data['vendor_code'] = this.vendorCode;
    data['vendor_name'] = this.vendorName;
    data['vendor_companyname'] = this.vendorCompanyname;
    data['vendor_phone'] = this.vendorPhone;
    data['vendor_email'] = this.vendorEmail;
    data['vendor_gst'] = this.vendorGst;
    data['vendor_address'] = this.vendorAddress;
    data['vendor_pincode'] = this.vendorPincode;
    data['vendor_district'] = this.vendorDistrict;
    data['vendor_state'] = this.vendorState;
    data['vendor_bank_details'] = this.vendorBankDetails;
    return data;
  }
}
