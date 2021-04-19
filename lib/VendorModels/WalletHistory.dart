class WalletHistoryList {
  Data data;
  bool status;

  WalletHistoryList({this.data, this.status});

  WalletHistoryList.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['status'] = this.status;
    return data;
  }
}

class Data {
  List<Credit> credit;
  List<Debit> debit;

  Data({this.credit, this.debit});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['credit'] != null) {
      credit = new List<Credit>();
      json['credit'].forEach((v) {
        credit.add(new Credit.fromJson(v));
      });
    }
    if (json['debit'] != null) {
      debit = new List<Debit>();
      json['debit'].forEach((v) {
        debit.add(new Debit.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.credit != null) {
      data['credit'] = this.credit.map((v) => v.toJson()).toList();
    }
    if (this.debit != null) {
      data['debit'] = this.debit.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Credit {
  String cnoteId;
  String cnoteUtype;
  String cnoteUid;
  String cnoteType;
  String cnoteAccType;
  String tblId;
  String cnoteAmnt;
  String cnoteDate;
  String cnoteStatus;
  String createdUtype;
  String updatedUtype;
  String createdAt;
  String createdBy;
  String updatedAt;
  String updatedBy;
  String vendorId;
  String vendorCode;
  String vendorName;

  Credit(
      {this.cnoteId,
      this.cnoteUtype,
      this.cnoteUid,
      this.cnoteType,
      this.cnoteAccType,
      this.tblId,
      this.cnoteAmnt,
      this.cnoteDate,
      this.cnoteStatus,
      this.createdUtype,
      this.updatedUtype,
      this.createdAt,
      this.createdBy,
      this.updatedAt,
      this.updatedBy,
      this.vendorId,
      this.vendorCode,
      this.vendorName});

  Credit.fromJson(Map<String, dynamic> json) {
    cnoteId = json['cnote_id'];
    cnoteUtype = json['cnote_utype'];
    cnoteUid = json['cnote_uid'];
    cnoteType = json['cnote_type'];
    cnoteAccType = json['cnote_acc_type'];
    tblId = json['tbl_id'];
    cnoteAmnt = json['cnote_amnt'];
    cnoteDate = json['cnote_date'];
    cnoteStatus = json['cnote_status'];
    createdUtype = json['created_utype'];
    updatedUtype = json['updated_utype'];
    createdAt = json['created_at'];
    createdBy = json['created_by'];
    updatedAt = json['updated_at'];
    updatedBy = json['updated_by'];
    vendorId = json['vendor_id'];
    vendorCode = json['vendor_code'];
    vendorName = json['vendor_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cnote_id'] = this.cnoteId;
    data['cnote_utype'] = this.cnoteUtype;
    data['cnote_uid'] = this.cnoteUid;
    data['cnote_type'] = this.cnoteType;
    data['cnote_acc_type'] = this.cnoteAccType;
    data['tbl_id'] = this.tblId;
    data['cnote_amnt'] = this.cnoteAmnt;
    data['cnote_date'] = this.cnoteDate;
    data['cnote_status'] = this.cnoteStatus;
    data['created_utype'] = this.createdUtype;
    data['updated_utype'] = this.updatedUtype;
    data['created_at'] = this.createdAt;
    data['created_by'] = this.createdBy;
    data['updated_at'] = this.updatedAt;
    data['updated_by'] = this.updatedBy;
    data['vendor_id'] = this.vendorId;
    data['vendor_code'] = this.vendorCode;
    data['vendor_name'] = this.vendorName;
    return data;
  }
}

class Debit {
  String cnoteId;
  String cnoteUtype;
  String cnoteUid;
  String cnoteType;
  String cnoteAccType;
  String tblId;
  String cnoteAmnt;
  String cnoteDate;
  String cnoteStatus;
  String createdUtype;
  String updatedUtype;
  String createdAt;
  String createdBy;
  String updatedAt;
  String updatedBy;
  String vendorId;
  String vendorCode;
  String vendorName;

  Debit(
      {this.cnoteId,
      this.cnoteUtype,
      this.cnoteUid,
      this.cnoteType,
      this.cnoteAccType,
      this.tblId,
      this.cnoteAmnt,
      this.cnoteDate,
      this.cnoteStatus,
      this.createdUtype,
      this.updatedUtype,
      this.createdAt,
      this.createdBy,
      this.updatedAt,
      this.updatedBy,
      this.vendorId,
      this.vendorCode,
      this.vendorName});

  Debit.fromJson(Map<String, dynamic> json) {
    cnoteId = json['cnote_id'];
    cnoteUtype = json['cnote_utype'];
    cnoteUid = json['cnote_uid'];
    cnoteType = json['cnote_type'];
    cnoteAccType = json['cnote_acc_type'];
    tblId = json['tbl_id'];
    cnoteAmnt = json['cnote_amnt'];
    cnoteDate = json['cnote_date'];
    cnoteStatus = json['cnote_status'];
    createdUtype = json['created_utype'];
    updatedUtype = json['updated_utype'];
    createdAt = json['created_at'];
    createdBy = json['created_by'];
    updatedAt = json['updated_at'];
    updatedBy = json['updated_by'];
    vendorId = json['vendor_id'];
    vendorCode = json['vendor_code'];
    vendorName = json['vendor_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cnote_id'] = this.cnoteId;
    data['cnote_utype'] = this.cnoteUtype;
    data['cnote_uid'] = this.cnoteUid;
    data['cnote_type'] = this.cnoteType;
    data['cnote_acc_type'] = this.cnoteAccType;
    data['tbl_id'] = this.tblId;
    data['cnote_amnt'] = this.cnoteAmnt;
    data['cnote_date'] = this.cnoteDate;
    data['cnote_status'] = this.cnoteStatus;
    data['created_utype'] = this.createdUtype;
    data['updated_utype'] = this.updatedUtype;
    data['created_at'] = this.createdAt;
    data['created_by'] = this.createdBy;
    data['updated_at'] = this.updatedAt;
    data['updated_by'] = this.updatedBy;
    data['vendor_id'] = this.vendorId;
    data['vendor_code'] = this.vendorCode;
    data['vendor_name'] = this.vendorName;
    return data;
  }
}
