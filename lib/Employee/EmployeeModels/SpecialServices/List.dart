class SpecialServiceList {
  int totalCount;
  List<Items> items;

  SpecialServiceList({this.totalCount, this.items});

  SpecialServiceList.fromJson(Map<String, dynamic> json) {
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