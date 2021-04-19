class RMListModel {
  bool status;
  int totalCount;
  List<Values> values;

  RMListModel({this.status, this.totalCount, this.values});

  RMListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    totalCount = json['total_count'];
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
    data['total_count'] = this.totalCount;
    if (this.values != null) {
      data['values'] = this.values.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Values {
  String empId;
  String empCode;
  String empName;
  String empPhone;
  String empPhoneAlter;
  String empEmail;
  String empStatus;
  String roleName;
  String stateName;
  String agm;
  String gm;

  Values(
      {this.empId,
        this.empCode,
        this.empName,
        this.empPhone,
        this.empPhoneAlter,
        this.empEmail,
        this.empStatus,
        this.roleName,
        this.stateName,
        this.agm,
        this.gm});

  Values.fromJson(Map<String, dynamic> json) {
    empId = json['emp_id'];
    empCode = json['emp_code'];
    empName = json['emp_name'];
    empPhone = json['emp_phone'];
    empPhoneAlter = json['emp_phone_alter'];
    empEmail = json['emp_email'];
    empStatus = json['emp_status'];
    roleName = json['role_name'];
    stateName = json['state_name'];
    agm = json['agm'];
    gm = json['gm'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['emp_id'] = this.empId;
    data['emp_code'] = this.empCode;
    data['emp_name'] = this.empName;
    data['emp_phone'] = this.empPhone;
    data['emp_phone_alter'] = this.empPhoneAlter;
    data['emp_email'] = this.empEmail;
    data['emp_status'] = this.empStatus;
    data['role_name'] = this.roleName;
    data['state_name'] = this.stateName;
    data['agm'] = this.agm;
    data['gm'] = this.gm;
    return data;
  }
}