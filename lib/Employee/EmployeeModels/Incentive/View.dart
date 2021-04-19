class IncentiveViewModel {
  bool status;
  Items items;

  IncentiveViewModel({this.status, this.items});

  IncentiveViewModel.fromJson(Map<String, dynamic> json) {
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
  String comId;
  String comType;
  String comCount;
  String comUtype;
  String comUid;
  String comUroleId;
  String comAmount;
  String comMonth;
  String comApproval;
  String paymentStatus;
  String roleName;
  String comBy;

  Items(
      {this.comId,
        this.comType,
        this.comCount,
        this.comUtype,
        this.comUid,
        this.comUroleId,
        this.comAmount,
        this.comMonth,
        this.comApproval,
        this.paymentStatus,
        this.roleName,
        this.comBy});

  Items.fromJson(Map<String, dynamic> json) {
    comId = json['com_id'];
    comType = json['com_type'];
    comCount = json['com_count'];
    comUtype = json['com_utype'];
    comUid = json['com_uid'];
    comUroleId = json['com_urole_id'];
    comAmount = json['com_amount'];
    comMonth = json['com_month'];
    comApproval = json['com_approval'];
    paymentStatus = json['payment_status'];
    roleName = json['role_name'];
    comBy = json['com_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['com_id'] = this.comId;
    data['com_type'] = this.comType;
    data['com_count'] = this.comCount;
    data['com_utype'] = this.comUtype;
    data['com_uid'] = this.comUid;
    data['com_urole_id'] = this.comUroleId;
    data['com_amount'] = this.comAmount;
    data['com_month'] = this.comMonth;
    data['com_approval'] = this.comApproval;
    data['payment_status'] = this.paymentStatus;
    data['role_name'] = this.roleName;
    data['com_by'] = this.comBy;
    return data;
  }
}
