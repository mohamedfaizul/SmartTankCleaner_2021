class EmployeeLeadDetailModel {
  bool status;
  Items items;

  EmployeeLeadDetailModel({this.status, this.items});

  EmployeeLeadDetailModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    items = json['items'] != null ? new Items.fromJson(json['items']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.items != null) {
      data['items'] = this.items.toJson();
    }
    return data;
  }
}

class Items {
  String leadId;
  String leadCode;
  String leadNotes;
  String leadFollowUtype;
  String leadFollowUid;
  String createdAt;
  String leadFollowupStatus;
  String cusId;
  String cusCode;
  String cusName;
  String cusPhone;
  String cusEmail;
  String cusAddress;
  String cusPincode;
  String stateName;
  String stateId;
  String districtName;
  String districtId;
  String followerBy;
  List<FollowupDetails> followupDetails;

  Items(
      {this.leadId,
      this.leadCode,
      this.leadNotes,
      this.leadFollowUtype,
      this.leadFollowUid,
      this.createdAt,
      this.leadFollowupStatus,
      this.cusId,
      this.cusCode,
      this.cusName,
      this.cusPhone,
      this.cusEmail,
      this.cusAddress,
      this.cusPincode,
      this.stateName,
      this.stateId,
      this.districtName,
      this.districtId,
      this.followerBy,
      this.followupDetails});

  Items.fromJson(Map<String, dynamic> json) {
    leadId = json['lead_id'];
    leadCode = json['lead_code'];
    leadNotes = json['lead_notes'];
    leadFollowUtype = json['lead_follow_utype'];
    leadFollowUid = json['lead_follow_uid'];
    createdAt = json['created_at'];
    leadFollowupStatus = json['lead_followup_status'];
    cusId = json['cus_id'];
    cusCode = json['cus_code'];
    cusName = json['cus_name'];
    cusPhone = json['cus_phone'];
    cusEmail = json['cus_email'];
    cusAddress = json['cus_address'];
    cusPincode = json['cus_pincode'];
    stateName = json['state_name'];
    stateId = json['state_id'];
    districtName = json['district_name'];
    districtId = json['district_id'];
    followerBy = json['follower_by'];
    if (json['followup_details'] != null) {
      followupDetails = new List<FollowupDetails>();
      json['followup_details'].forEach((v) {
        followupDetails.add(new FollowupDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lead_id'] = this.leadId;
    data['lead_code'] = this.leadCode;
    data['lead_notes'] = this.leadNotes;
    data['lead_follow_utype'] = this.leadFollowUtype;
    data['lead_follow_uid'] = this.leadFollowUid;
    data['created_at'] = this.createdAt;
    data['lead_followup_status'] = this.leadFollowupStatus;
    data['cus_id'] = this.cusId;
    data['cus_code'] = this.cusCode;
    data['cus_name'] = this.cusName;
    data['cus_phone'] = this.cusPhone;
    data['cus_email'] = this.cusEmail;
    data['cus_address'] = this.cusAddress;
    data['cus_pincode'] = this.cusPincode;
    data['state_name'] = this.stateName;
    data['state_id'] = this.stateId;
    data['district_name'] = this.districtName;
    data['district_id'] = this.districtId;
    data['follower_by'] = this.followerBy;
    if (this.followupDetails != null) {
      data['followup_details'] =
          this.followupDetails.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FollowupDetails {
  String followupId;
  String leadId;
  String followupDate;
  String followupNotes;
  String followupStatus;

  FollowupDetails(
      {this.followupId,
      this.leadId,
      this.followupDate,
      this.followupNotes,
      this.followupStatus});

  FollowupDetails.fromJson(Map<String, dynamic> json) {
    followupId = json['followup_id'];
    leadId = json['lead_id'];
    followupDate = json['followup_date'];
    followupNotes = json['followup_notes'];
    followupStatus = json['followup_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['followup_id'] = this.followupId;
    data['lead_id'] = this.leadId;
    data['followup_date'] = this.followupDate;
    data['followup_notes'] = this.followupNotes;
    data['followup_status'] = this.followupStatus;
    return data;
  }
}
