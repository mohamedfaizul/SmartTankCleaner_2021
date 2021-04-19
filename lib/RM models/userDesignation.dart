class GetUserDesignation {
  bool status;
  List<Values> values;

  GetUserDesignation({this.status, this.values});

  GetUserDesignation.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['values'] != null) {
      values = new List<Values>();
      json['values'].forEach((v) {
        values.add(new Values.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.values != null) {
      data['values'] = this.values.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Values {
  String roleId;
  String roleName;
  String roleType;
  String roleOrderBy;

  Values({this.roleId, this.roleName, this.roleType, this.roleOrderBy});

  Values.fromJson(Map<String, dynamic> json) {
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
