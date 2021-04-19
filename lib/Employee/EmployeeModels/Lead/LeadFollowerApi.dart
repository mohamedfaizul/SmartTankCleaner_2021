class LeadFollowerModel {
  bool status;
  List<String> messages;
  String alert;
  Data data;

  LeadFollowerModel({this.status, this.messages, this.alert, this.data});

  LeadFollowerModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    messages = json['messages'].cast<String>();
    alert = json['alert'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['messages'] = this.messages;
    data['alert'] = this.alert;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  String followUid;
  String followUname;

  Data({this.followUid, this.followUname});

  Data.fromJson(Map<String, dynamic> json) {
    followUid = json['follow_uid'];
    followUname = json['follow_uname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['follow_uid'] = this.followUid;
    data['follow_uname'] = this.followUname;
    return data;
  }
}