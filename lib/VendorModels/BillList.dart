class VendorBillListings {
  bool status;
  int totalCount;
  List<Items> items;

  VendorBillListings({this.status, this.totalCount, this.items});

  VendorBillListings.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    totalCount = json['total_count'];
    if (json['items'] != null) {
      items = new List<Items>();
      json['items'].forEach((v) {
        items.add(new Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['total_count'] = this.totalCount;
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
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

  Items(
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
      this.vendorPhone});

  Items.fromJson(Map<String, dynamic> json) {
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
    return data;
  }
}
