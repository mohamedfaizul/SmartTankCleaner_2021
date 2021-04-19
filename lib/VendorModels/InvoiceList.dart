class VendorInvoiceListings {
  bool status;
  int totalCount;
  List<Items> items;

  VendorInvoiceListings({this.status, this.totalCount, this.items});

  VendorInvoiceListings.fromJson(Map<String, dynamic> json) {
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
  String sbillInvno;
  String sbillInvDate;
  String totamnt;
  String totcnt;
  String vendorCode;
  String vendorName;
  String vendorCompanyname;
  String vendorPhone;

  Items(
      {this.sbillId,
      this.sbillInvno,
      this.sbillInvDate,
      this.totamnt,
      this.totcnt,
      this.vendorCode,
      this.vendorName,
      this.vendorCompanyname,
      this.vendorPhone});

  Items.fromJson(Map<String, dynamic> json) {
    sbillId = json['sbill_id'];
    sbillInvno = json['sbill_invno'];
    sbillInvDate = json['sbill_inv_date'];
    totamnt = json['totamnt'];
    totcnt = json['totcnt'];
    vendorCode = json['vendor_code'];
    vendorName = json['vendor_name'];
    vendorCompanyname = json['vendor_companyname'];
    vendorPhone = json['vendor_phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sbill_id'] = this.sbillId;
    data['sbill_invno'] = this.sbillInvno;
    data['sbill_inv_date'] = this.sbillInvDate;
    data['totamnt'] = this.totamnt;
    data['totcnt'] = this.totcnt;
    data['vendor_code'] = this.vendorCode;
    data['vendor_name'] = this.vendorName;
    data['vendor_companyname'] = this.vendorCompanyname;
    data['vendor_phone'] = this.vendorPhone;
    return data;
  }
}
