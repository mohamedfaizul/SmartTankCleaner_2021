class MachineTransferRole {
  bool status;
  List<Items> items;

  MachineTransferRole({this.status, this.items});

  MachineTransferRole.fromJson(Map<String, dynamic> json) {
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
  String roleId;
  String roleName;
  String roleType;
  String roleOrderBy;

  Items({this.roleId, this.roleName, this.roleType, this.roleOrderBy});

  Items.fromJson(Map<String, dynamic> json) {
    roleId = json['role_id'];
    roleName = json['role_name'];
    roleType = json['role_type'];
    roleOrderBy = json['role_order_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['role_id'] = this.roleId;
    data['role_name'] = this.roleName;
    data['role_type'] = this.roleType;
    data['role_order_by'] = this.roleOrderBy;
    return data;
  }
}
