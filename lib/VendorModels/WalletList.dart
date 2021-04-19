class WalletListings {
  int totalCount;
  List<Items> items;

  WalletListings({this.totalCount, this.items});

  WalletListings.fromJson(Map<String, dynamic> json) {
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
    data['total_count'] = this.totalCount;
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  String vtId;
  String vtCode;
  String vendorId;
  String vtAmount;
  String vtApplyDate;
  String vtStatus;
  String vtPaymentStatus;
  String vtCancelNote;
  String vtPaidRefno;
  String vtType;
  String createdUtype;
  String updatedUtype;
  String createdAt;
  String createdBy;
  String updatedAt;
  String updatedBy;
  String vendorCode;
  String vendorName;

  Items(
      {this.vtId,
      this.vtCode,
      this.vendorId,
      this.vtAmount,
      this.vtApplyDate,
      this.vtStatus,
      this.vtPaymentStatus,
      this.vtCancelNote,
      this.vtPaidRefno,
      this.vtType,
      this.createdUtype,
      this.updatedUtype,
      this.createdAt,
      this.createdBy,
      this.updatedAt,
      this.updatedBy,
      this.vendorCode,
      this.vendorName});

  Items.fromJson(Map<String, dynamic> json) {
    vtId = json['vt_id'];
    vtCode = json['vt_code'];
    vendorId = json['vendor_id'];
    vtAmount = json['vt_amount'];
    vtApplyDate = json['vt_apply_date'];
    vtStatus = json['vt_status'];
    vtPaymentStatus = json['vt_payment_status'];
    vtCancelNote = json['vt_cancel_note'];
    vtPaidRefno = json['vt_paid_refno'];
    vtType = json['vt_type'];
    createdUtype = json['created_utype'];
    updatedUtype = json['updated_utype'];
    createdAt = json['created_at'];
    createdBy = json['created_by'];
    updatedAt = json['updated_at'];
    updatedBy = json['updated_by'];
    vendorCode = json['vendor_code'];
    vendorName = json['vendor_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vt_id'] = this.vtId;
    data['vt_code'] = this.vtCode;
    data['vendor_id'] = this.vendorId;
    data['vt_amount'] = this.vtAmount;
    data['vt_apply_date'] = this.vtApplyDate;
    data['vt_status'] = this.vtStatus;
    data['vt_payment_status'] = this.vtPaymentStatus;
    data['vt_cancel_note'] = this.vtCancelNote;
    data['vt_paid_refno'] = this.vtPaidRefno;
    data['vt_type'] = this.vtType;
    data['created_utype'] = this.createdUtype;
    data['updated_utype'] = this.updatedUtype;
    data['created_at'] = this.createdAt;
    data['created_by'] = this.createdBy;
    data['updated_at'] = this.updatedAt;
    data['updated_by'] = this.updatedBy;
    data['vendor_code'] = this.vendorCode;
    data['vendor_name'] = this.vendorName;
    return data;
  }
}
