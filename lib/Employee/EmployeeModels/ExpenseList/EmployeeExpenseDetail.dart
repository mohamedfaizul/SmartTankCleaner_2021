class EmployeeExpenseDetailsModel {
  bool status;
  Items items;

  EmployeeExpenseDetailsModel({this.status, this.items});

  EmployeeExpenseDetailsModel.fromJson(Map<String, dynamic> json) {
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
  String expenseId;
  String expenseCode;
  String expenseAmount;
  String expenseRemark;
  String expenseDate;
  String billNumber;
  List<BillImage> billImage;
  String paymentStatus;
  String expenseUtype;
  String expenseUid;
  String expenseUroleId;
  String etypeId;
  String etypeCode;
  String etypeName;
  String roleName;
  String expenseBy;

  Items(
      {this.expenseId,
        this.expenseCode,
        this.expenseAmount,
        this.expenseRemark,
        this.expenseDate,
        this.billNumber,
        this.billImage,
        this.paymentStatus,
        this.expenseUtype,
        this.expenseUid,
        this.expenseUroleId,
        this.etypeId,
        this.etypeCode,
        this.etypeName,
        this.roleName,
        this.expenseBy});

  Items.fromJson(Map<String, dynamic> json) {
    expenseId = json['expense_id'];
    expenseCode = json['expense_code'];
    expenseAmount = json['expense_amount'];
    expenseRemark = json['expense_remark'];
    expenseDate = json['expense_date'];
    billNumber = json['bill_number'];
    if (json['bill_image'] != null) {
      billImage = new List<BillImage>();
      json['bill_image'].forEach((v) {
        billImage.add(new BillImage.fromJson(v));
      });
    }
    paymentStatus = json['payment_status'];
    expenseUtype = json['expense_utype'];
    expenseUid = json['expense_uid'];
    expenseUroleId = json['expense_urole_id'];
    etypeId = json['etype_id'];
    etypeCode = json['etype_code'];
    etypeName = json['etype_name'];
    roleName = json['role_name'];
    expenseBy = json['expense_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['expense_id'] = this.expenseId;
    data['expense_code'] = this.expenseCode;
    data['expense_amount'] = this.expenseAmount;
    data['expense_remark'] = this.expenseRemark;
    data['expense_date'] = this.expenseDate;
    data['bill_number'] = this.billNumber;
    if (this.billImage != null) {
      data['bill_image'] = this.billImage.map((v) => v.toJson()).toList();
    }
    data['payment_status'] = this.paymentStatus;
    data['expense_utype'] = this.expenseUtype;
    data['expense_uid'] = this.expenseUid;
    data['expense_urole_id'] = this.expenseUroleId;
    data['etype_id'] = this.etypeId;
    data['etype_code'] = this.etypeCode;
    data['etype_name'] = this.etypeName;
    data['role_name'] = this.roleName;
    data['expense_by'] = this.expenseBy;
    return data;
  }
}

class BillImage {
  String imgId;
  String imgPath;

  BillImage({this.imgId, this.imgPath});

  BillImage.fromJson(Map<String, dynamic> json) {
    imgId = json['img_id'];
    imgPath = json['img_path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['img_id'] = this.imgId;
    data['img_path'] = this.imgPath;
    return data;
  }
}