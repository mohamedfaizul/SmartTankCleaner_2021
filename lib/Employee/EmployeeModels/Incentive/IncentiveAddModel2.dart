class IncentiveAddModel {
  List<Data> data;
  bool status;
  String alert;

  IncentiveAddModel({this.data, this.status, this.alert});

  IncentiveAddModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
    status = json['status'];
    alert = json['alert'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['alert'] = this.alert;
    return data;
  }
}

class Data {
  String tblColumn;
  String ctype;
  String commCnt;

  Data({this.tblColumn, this.ctype, this.commCnt});

  Data.fromJson(Map<String, dynamic> json) {
    tblColumn = json['tbl_column'];
    ctype = json['ctype'];
    commCnt = json['comm_cnt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tbl_column'] = this.tblColumn;
    data['ctype'] = this.ctype;
    data['comm_cnt'] = this.commCnt;
    return data;
  }
}