class PlanListings {
  List<Values> values;

  PlanListings({this.values});

  PlanListings.fromJson(Map<String, dynamic> json) {
    if (json['values'] != null) {
      values = new List<Values>();
      json['values'].forEach((v) {
        values.add(new Values.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.values != null) {
      data['values'] = this.values.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Values {
  String planId;
  String planCode;
  String planName;
  String planServicetype;
  String planUnit;
  String planSizeFrom;
  String planSizeTo;
  String planStatus;
  String ptypeName;

  Values(
      {this.planId,
      this.planCode,
      this.planName,
      this.planServicetype,
      this.planUnit,
      this.planSizeFrom,
      this.planSizeTo,
      this.planStatus,
      this.ptypeName});

  Values.fromJson(Map<String, dynamic> json) {
    planId = json['plan_id'];
    planCode = json['plan_code'];
    planName = json['plan_name'];
    planServicetype = json['plan_servicetype'];
    planUnit = json['plan_unit'];
    planSizeFrom = json['plan_size_from'];
    planSizeTo = json['plan_size_to'];
    planStatus = json['plan_status'];
    ptypeName = json['ptype_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['plan_id'] = this.planId;
    data['plan_code'] = this.planCode;
    data['plan_name'] = this.planName;
    data['plan_servicetype'] = this.planServicetype;
    data['plan_unit'] = this.planUnit;
    data['plan_size_from'] = this.planSizeFrom;
    data['plan_size_to'] = this.planSizeTo;
    data['plan_status'] = this.planStatus;
    data['ptype_name'] = this.ptypeName;
    return data;
  }
}
