class PlanListings {
  bool status;
  int totalCount;
  List<Items> items;

  PlanListings({this.status, this.totalCount, this.items});

  PlanListings.fromJson(Map<String, dynamic> json) {
    status = json['status'];
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
    data['status'] = this.status;
    data['total_count'] = this.totalCount;
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  String planId;
  String planCode;
  String planName;
  String planServicetype;
  String planUnit;
  String planSizeFrom;
  String planSizeTo;
  String planServicerCost;
  String planServiceTime;
  String planStatus;
  String ptypeName;

  Items(
      {this.planId,
        this.planCode,
        this.planName,
        this.planServicetype,
        this.planUnit,
        this.planSizeFrom,
        this.planSizeTo,
        this.planServicerCost,
        this.planServiceTime,
        this.planStatus,
        this.ptypeName});

  Items.fromJson(Map<String, dynamic> json) {
    planId = json['plan_id'];
    planCode = json['plan_code'];
    planName = json['plan_name'];
    planServicetype = json['plan_servicetype'];
    planUnit = json['plan_unit'];
    planSizeFrom = json['plan_size_from'];
    planSizeTo = json['plan_size_to'];
    planServicerCost = json['plan_servicer_cost'];
    planServiceTime = json['plan_service_time'];
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
    data['plan_servicer_cost'] = this.planServicerCost;
    data['plan_service_time'] = this.planServiceTime;
    data['plan_status'] = this.planStatus;
    data['ptype_name'] = this.ptypeName;
    return data;
  }
}