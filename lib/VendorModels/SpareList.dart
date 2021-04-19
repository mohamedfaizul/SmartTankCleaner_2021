class SpareListings {
  bool status;
  int totalCount;
  List<Values> values;

  SpareListings({this.status, this.totalCount, this.values});

  SpareListings.fromJson(Map<String, dynamic> json) {
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
  String machineAssignUtype;
  String machineAssignUid;
  String ownerby;

  Values(
      {this.machineId,
      this.machineCode,
      this.machineName,
      this.machineType,
      this.machineAssignUtype,
      this.machineAssignUid,
      this.ownerby});

  Values.fromJson(Map<String, dynamic> json) {
    machineId = json['machine_id'];
    machineCode = json['machine_code'];
    machineName = json['machine_name'];
    machineType = json['machine_type'];
    machineAssignUtype = json['machine_assign_utype'];
    machineAssignUid = json['machine_assign_uid'];
    ownerby = json['ownerby'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['machine_id'] = this.machineId;
    data['machine_code'] = this.machineCode;
    data['machine_name'] = this.machineName;
    data['machine_type'] = this.machineType;
    data['machine_assign_utype'] = this.machineAssignUtype;
    data['machine_assign_uid'] = this.machineAssignUid;
    data['ownerby'] = this.ownerby;
    return data;
  }
}
