class CreditNoteView {
  bool status;
  Items items;

  CreditNoteView({this.status, this.items});

  CreditNoteView.fromJson(Map<String, dynamic> json) {
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
  String cnoteId;
  String cnoteUtype;
  String cnoteUid;
  String cnoteAccType;
  String tblId;
  String cnoteAmnt;
  String cnoteDate;
  String vendorId;
  String vendorCode;
  String vendorName;

  Items(
      {this.cnoteId,
      this.cnoteUtype,
      this.cnoteUid,
      this.cnoteAccType,
      this.tblId,
      this.cnoteAmnt,
      this.cnoteDate,
      this.vendorId,
      this.vendorCode,
      this.vendorName});

  Items.fromJson(Map<String, dynamic> json) {
    cnoteId = json['cnote_id'];
    cnoteUtype = json['cnote_utype'];
    cnoteUid = json['cnote_uid'];
    cnoteAccType = json['cnote_acc_type'];
    tblId = json['tbl_id'];
    cnoteAmnt = json['cnote_amnt'];
    cnoteDate = json['cnote_date'];
    vendorId = json['vendor_id'];
    vendorCode = json['vendor_code'];
    vendorName = json['vendor_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cnote_id'] = this.cnoteId;
    data['cnote_utype'] = this.cnoteUtype;
    data['cnote_uid'] = this.cnoteUid;
    data['cnote_acc_type'] = this.cnoteAccType;
    data['tbl_id'] = this.tblId;
    data['cnote_amnt'] = this.cnoteAmnt;
    data['cnote_date'] = this.cnoteDate;
    data['vendor_id'] = this.vendorId;
    data['vendor_code'] = this.vendorCode;
    data['vendor_name'] = this.vendorName;
    return data;
  }
}
