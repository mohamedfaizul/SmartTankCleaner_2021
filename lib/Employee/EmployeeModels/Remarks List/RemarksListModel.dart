class EmployeeLRemarksListModel {
  int totalCount;
  List<Items> items;

  EmployeeLRemarksListModel({this.totalCount, this.items});

  EmployeeLRemarksListModel.fromJson(Map<String, dynamic> json) {
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
  String remarkId;
  String remarkCode;
  String remarkAmount;
  String rtypeId;
  String remarkType;
  String roleName;
  String remarkBy;

  Items(
      {this.remarkId,
      this.remarkCode,
      this.remarkAmount,
      this.rtypeId,
      this.remarkType,
      this.roleName,
      this.remarkBy});

  Items.fromJson(Map<String, dynamic> json) {
    remarkId = json['remark_id'];
    remarkCode = json['remark_code'];
    remarkAmount = json['remark_amount'];
    rtypeId = json['rtype_id'];
    remarkType = json['remark_type'];
    roleName = json['role_name'];
    remarkBy = json['remark_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['remark_id'] = this.remarkId;
    data['remark_code'] = this.remarkCode;
    data['remark_amount'] = this.remarkAmount;
    data['rtype_id'] = this.rtypeId;
    data['remark_type'] = this.remarkType;
    data['role_name'] = this.roleName;
    data['remark_by'] = this.remarkBy;
    return data;
  }
}
