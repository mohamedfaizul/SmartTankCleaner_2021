class SupervisorListings {
  bool status;
  int totalCount;
  List<Values> values;

  SupervisorListings({this.status, this.totalCount, this.values});

  SupervisorListings.fromJson(Map<String, dynamic> json) {
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
  String empCode;
  String empId;
  String empName;
  String empPhone;
  String empPhoneAlter;
  String empEmail;

  Values(
      {this.empCode,
      this.empId,
      this.empName,
      this.empPhone,
      this.empPhoneAlter,
      this.empEmail});

  Values.fromJson(Map<String, dynamic> json) {
    empCode = json['emp_code'];
    empId = json['emp_id'];
    empName = json['emp_name'];
    empPhone = json['emp_phone'];
    empPhoneAlter = json['emp_phone_alter'];
    empEmail = json['emp_email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['emp_code'] = this.empCode;
    data['emp_id'] = this.empId;
    data['emp_name'] = this.empName;
    data['emp_phone'] = this.empPhone;
    data['emp_phone_alter'] = this.empPhoneAlter;
    data['emp_email'] = this.empEmail;
    return data;
  }
}
