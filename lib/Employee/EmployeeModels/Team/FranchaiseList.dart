class FranchaiseList {
  bool status;
  int totalCount;
  List<Values> values;

  FranchaiseList({this.status, this.totalCount, this.values});

  FranchaiseList.fromJson(Map<String, dynamic> json) {
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
  String franchiseId;
  String franchiseCode;
  String franchiseName;
  String franchisePhone;
  String stateName;
  String districtName;
  String dvendor;
  String rm;
  String agm;
  String gm;

  Values(
      {this.franchiseId,
      this.franchiseCode,
      this.franchiseName,
      this.franchisePhone,
      this.stateName,
      this.districtName,
      this.dvendor,
      this.rm,
      this.agm,
      this.gm});

  Values.fromJson(Map<String, dynamic> json) {
    franchiseId = json['franchise_id'];
    franchiseCode = json['franchise_code'];
    franchiseName = json['franchise_name'];
    franchisePhone = json['franchise_phone'];
    stateName = json['state_name'];
    districtName = json['district_name'];
    dvendor = json['dvendor'];
    rm = json['rm'];
    agm = json['agm'];
    gm = json['gm'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['franchise_id'] = this.franchiseId;
    data['franchise_code'] = this.franchiseCode;
    data['franchise_name'] = this.franchiseName;
    data['franchise_phone'] = this.franchisePhone;
    data['state_name'] = this.stateName;
    data['district_name'] = this.districtName;
    data['dvendor'] = this.dvendor;
    data['rm'] = this.rm;
    data['agm'] = this.agm;
    data['gm'] = this.gm;
    return data;
  }
}
