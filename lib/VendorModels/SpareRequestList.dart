class SpareRequestListings {
  bool status;
  int totalCount;
  List<Values> values;

  SpareRequestListings({this.status, this.totalCount, this.values});

  SpareRequestListings.fromJson(Map<String, dynamic> json) {
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
  String machineId;
  String machineCode;
  String machineName;
  String machineType;
  String reqUtype;
  String reqUid;
  String spareApproval;
  String reqby;

  Values(
      {this.machineId,
      this.machineCode,
      this.machineName,
      this.machineType,
      this.reqUtype,
      this.reqUid,
      this.spareApproval,
      this.reqby});

  Values.fromJson(Map<String, dynamic> json) {
    machineId = json['machine_id'];
    machineCode = json['machine_code'];
    machineName = json['machine_name'];
    machineType = json['machine_type'];
    reqUtype = json['req_utype'];
    reqUid = json['req_uid'];
    spareApproval = json['spare_approval'];
    reqby = json['reqby'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['machine_id'] = this.machineId;
    data['machine_code'] = this.machineCode;
    data['machine_name'] = this.machineName;
    data['machine_type'] = this.machineType;
    data['req_utype'] = this.reqUtype;
    data['req_uid'] = this.reqUid;
    data['spare_approval'] = this.spareApproval;
    data['reqby'] = this.reqby;
    return data;
  }
}
