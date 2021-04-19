class EmployeeLeadListModel {
  int totalCount;
  List<Items> items;

  EmployeeLeadListModel({this.totalCount, this.items});

  EmployeeLeadListModel.fromJson(Map<String, dynamic> json) {
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
  String leadId;
  String createdAt;
  String leadCode;
  String leadFollowupStatus;
  String leadFollowUid;
  String leadFollowUtype;
  String cusName;
  String cusId;
  String cusCode;
  String followerBy;

  Items(
      {this.leadId,
      this.createdAt,
      this.leadCode,
      this.leadFollowupStatus,
      this.leadFollowUid,
      this.leadFollowUtype,
      this.cusName,
      this.cusId,
      this.cusCode,
      this.followerBy});

  Items.fromJson(Map<String, dynamic> json) {
    leadId = json['lead_id'];
    createdAt = json['created_at'];
    leadCode = json['lead_code'];
    leadFollowupStatus = json['lead_followup_status'];
    leadFollowUid = json['lead_follow_uid'];
    leadFollowUtype = json['lead_follow_utype'];
    cusName = json['cus_name'];
    cusId = json['cus_id'];
    cusCode = json['cus_code'];
    followerBy = json['follower_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lead_id'] = this.leadId;
    data['created_at'] = this.createdAt;
    data['lead_code'] = this.leadCode;
    data['lead_followup_status'] = this.leadFollowupStatus;
    data['lead_follow_uid'] = this.leadFollowUid;
    data['lead_follow_utype'] = this.leadFollowUtype;
    data['cus_name'] = this.cusName;
    data['cus_id'] = this.cusId;
    data['cus_code'] = this.cusCode;
    data['follower_by'] = this.followerBy;
    return data;
  }
}
