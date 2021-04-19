class DVListModel {
  int totalCount;
  List<Items> items;

  DVListModel({this.totalCount, this.items});

  DVListModel.fromJson(Map<String, dynamic> json) {
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
  String dvendorId;
  String dvendorCode;
  String dvendorName;
  String dvendorCompanyname;
  String dvendorPhone;
  String dvendorEmail;
  String dvendorPassword;
  String createdAt;
  String stateId;
  String stateName;
  String districtId;
  String districtName;

  Items(
      {this.dvendorId,
        this.dvendorCode,
        this.dvendorName,
        this.dvendorCompanyname,
        this.dvendorPhone,
        this.dvendorEmail,
        this.dvendorPassword,
        this.createdAt,
        this.stateId,
        this.stateName,
        this.districtId,
        this.districtName});

  Items.fromJson(Map<String, dynamic> json) {
    dvendorId = json['dvendor_id'];
    dvendorCode = json['dvendor_code'];
    dvendorName = json['dvendor_name'];
    dvendorCompanyname = json['dvendor_companyname'];
    dvendorPhone = json['dvendor_phone'];
    dvendorEmail = json['dvendor_email'];
    dvendorPassword = json['dvendor_password'];
    createdAt = json['created_at'];
    stateId = json['state_id'];
    stateName = json['state_name'];
    districtId = json['district_id'];
    districtName = json['district_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dvendor_id'] = this.dvendorId;
    data['dvendor_code'] = this.dvendorCode;
    data['dvendor_name'] = this.dvendorName;
    data['dvendor_companyname'] = this.dvendorCompanyname;
    data['dvendor_phone'] = this.dvendorPhone;
    data['dvendor_email'] = this.dvendorEmail;
    data['dvendor_password'] = this.dvendorPassword;
    data['created_at'] = this.createdAt;
    data['state_id'] = this.stateId;
    data['state_name'] = this.stateName;
    data['district_id'] = this.districtId;
    data['district_name'] = this.districtName;
    return data;
  }
}