class RemarksDetailsModel {
  bool status;
  Items items;

  RemarksDetailsModel({this.status, this.items});

  RemarksDetailsModel.fromJson(Map<String, dynamic> json) {
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
  String remarkId;
  String remarkCode;
  String remarkAmount;
  String rtypeId;
  String remarkType;
  String remarkSummary;
  String roleName;
  String roleId;
  String remarkUid;
  String remarkBy;

  Items(
      {this.remarkId,
      this.remarkCode,
      this.remarkAmount,
      this.rtypeId,
      this.remarkType,
      this.remarkSummary,
      this.roleName,
      this.roleId,
      this.remarkUid,
      this.remarkBy});

  Items.fromJson(Map<String, dynamic> json) {
    remarkId = json['remark_id'];
    remarkCode = json['remark_code'];
    remarkAmount = json['remark_amount'];
    rtypeId = json['rtype_id'];
    remarkType = json['remark_type'];
    remarkSummary = json['remark_summary'];
    roleName = json['role_name'];
    roleId = json['role_id'];
    remarkUid = json['remark_uid'];
    remarkBy = json['remark_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['remark_id'] = this.remarkId;
    data['remark_code'] = this.remarkCode;
    data['remark_amount'] = this.remarkAmount;
    data['rtype_id'] = this.rtypeId;
    data['remark_type'] = this.remarkType;
    data['remark_summary'] = this.remarkSummary;
    data['role_name'] = this.roleName;
    data['role_id'] = this.roleId;
    data['remark_uid'] = this.remarkUid;
    data['remark_by'] = this.remarkBy;
    return data;
  }
}
