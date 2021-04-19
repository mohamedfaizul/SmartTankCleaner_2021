class EmployeeRemarkTypeModel {
  bool status;
  List<Items> items;

  EmployeeRemarkTypeModel({this.status, this.items});

  EmployeeRemarkTypeModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
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
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  String rtypeId;
  String remarkType;
  String remarkAmount;

  Items({this.rtypeId, this.remarkType, this.remarkAmount});

  Items.fromJson(Map<String, dynamic> json) {
    rtypeId = json['rtype_id'];
    remarkType = json['remark_type'];
    remarkAmount = json['remark_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rtype_id'] = this.rtypeId;
    data['remark_type'] = this.remarkType;
    data['remark_amount'] = this.remarkAmount;
    return data;
  }
}
