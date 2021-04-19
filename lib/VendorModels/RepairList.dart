class MachineRepairListings {
  bool status;
  int totalCount;
  List<Values> values;

  MachineRepairListings({this.status, this.totalCount, this.values});

  MachineRepairListings.fromJson(Map<String, dynamic> json) {
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
  String machineCode;
  String machineName;
  String repairCode;
  String repairId;
  String machineId;
  String repairNote;
  String repairStatus;
  String machineUid;
  String machineUtype;
  String repairCharge;
  String repairApproval;
  String repairQuoteApproval;
  String assignby;

  Values(
      {this.machineCode,
      this.machineName,
      this.repairCode,
      this.repairId,
      this.machineId,
      this.repairNote,
      this.repairStatus,
      this.machineUid,
      this.machineUtype,
      this.repairCharge,
      this.repairApproval,
      this.repairQuoteApproval,
      this.assignby});

  Values.fromJson(Map<String, dynamic> json) {
    machineCode = json['machine_code'];
    machineName = json['machine_name'];
    repairCode = json['repair_code'];
    repairId = json['repair_id'];
    machineId = json['machine_id'];
    repairNote = json['repair_note'];
    repairStatus = json['repair_status'];
    machineUid = json['machine_uid'];
    machineUtype = json['machine_utype'];
    repairCharge = json['repair_charge'];
    repairApproval = json['repair_approval'];
    repairQuoteApproval = json['repair_quote_approval'];
    assignby = json['assignby'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['machine_code'] = this.machineCode;
    data['machine_name'] = this.machineName;
    data['repair_code'] = this.repairCode;
    data['repair_id'] = this.repairId;
    data['machine_id'] = this.machineId;
    data['repair_note'] = this.repairNote;
    data['repair_status'] = this.repairStatus;
    data['machine_uid'] = this.machineUid;
    data['machine_utype'] = this.machineUtype;
    data['repair_charge'] = this.repairCharge;
    data['repair_approval'] = this.repairApproval;
    data['repair_quote_approval'] = this.repairQuoteApproval;
    data['assignby'] = this.assignby;
    return data;
  }
}
