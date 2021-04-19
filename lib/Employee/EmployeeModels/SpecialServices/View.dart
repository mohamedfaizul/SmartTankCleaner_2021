class SpecialServiceDetailsModel {
  bool status;
  Items items;

  SpecialServiceDetailsModel({this.status, this.items});

  SpecialServiceDetailsModel.fromJson(Map<String, dynamic> json) {
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
  String ssId;
  String ssCode;
  String ssDate;
  String ssRequestNote;
  String ssResponseNote;
  String ssUtype;
  String ssUid;
  String requestBy;

  Items(
      {this.ssId,
        this.ssCode,
        this.ssDate,
        this.ssRequestNote,
        this.ssResponseNote,
        this.ssUtype,
        this.ssUid,
        this.requestBy});

  Items.fromJson(Map<String, dynamic> json) {
    ssId = json['ss_id'];
    ssCode = json['ss_code'];
    ssDate = json['ss_date'];
    ssRequestNote = json['ss_request_note'];
    ssResponseNote = json['ss_response_note'];
    ssUtype = json['ss_utype'];
    ssUid = json['ss_uid'];
    requestBy = json['request_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ss_id'] = this.ssId;
    data['ss_code'] = this.ssCode;
    data['ss_date'] = this.ssDate;
    data['ss_request_note'] = this.ssRequestNote;
    data['ss_response_note'] = this.ssResponseNote;
    data['ss_utype'] = this.ssUtype;
    data['ss_uid'] = this.ssUid;
    data['request_by'] = this.requestBy;
    return data;
  }
}