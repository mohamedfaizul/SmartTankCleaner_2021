class MachineListings {
  bool status;
  int totalCount;
  List<Items> items;

  MachineListings({this.status, this.totalCount, this.items});

  MachineListings.fromJson(Map<String, dynamic> json) {
    status = json['status'];
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
    data['status'] = this.status;
    data['total_count'] = this.totalCount;
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  String machineId;
  String machineCode;
  String machineName;
  String machineAssignUid;
  String machineAssignUtype;
  String machineAssignId;
  String ownerby;
  String holdby;
  String machineType;

  Items(
      {this.machineId,
      this.machineCode,
      this.machineName,
      this.machineAssignUid,
      this.machineAssignUtype,
      this.machineAssignId,
      this.machineType,
      this.ownerby,
      this.holdby});

  Items.fromJson(Map<String, dynamic> json) {
    machineId = json['machine_id'];
    machineCode = json['machine_code'];
    machineType = json['machine_type'];
    machineName = json['machine_name'];
    machineAssignUid = json['machine_assign_uid'];
    machineAssignUtype = json['machine_assign_utype'];
    machineAssignId = json['machine_assign_id'];
    ownerby = json['ownerby'];
    holdby = json['holdby'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['machine_id'] = this.machineId;
    data['machine_code'] = this.machineCode;
    data['machine_type'] = this.machineType;
    data['machine_name'] = this.machineName;
    data['machine_assign_uid'] = this.machineAssignUid;
    data['machine_assign_utype'] = this.machineAssignUtype;
    data['machine_assign_id'] = this.machineAssignId;
    data['ownerby'] = this.ownerby;
    data['holdby'] = this.holdby;
    return data;
  }
}
