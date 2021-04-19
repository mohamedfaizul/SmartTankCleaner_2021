class MachineHistory {
  bool status;
  int totalCount;
  List<Values> values;

  MachineHistory({this.status, this.totalCount, this.values});

  MachineHistory.fromJson(Map<String, dynamic> json) {
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
  String historyType;
  String historyFromUtype;
  String historyFromUid;
  String historyToUtype;
  String historyToUid;
  String historyDate;
  String fromBy;
  String toBy;

  Values(
      {this.machineId,
      this.machineCode,
      this.machineName,
      this.machineType,
      this.historyType,
      this.historyFromUtype,
      this.historyFromUid,
      this.historyToUtype,
      this.historyToUid,
      this.historyDate,
      this.fromBy,
      this.toBy});

  Values.fromJson(Map<String, dynamic> json) {
    machineId = json['machine_id'];
    machineCode = json['machine_code'];
    machineName = json['machine_name'];
    machineType = json['machine_type'];
    historyType = json['history_type'];
    historyFromUtype = json['history_from_utype'];
    historyFromUid = json['history_from_uid'];
    historyToUtype = json['history_to_utype'];
    historyToUid = json['history_to_uid'];
    historyDate = json['history_date'];
    fromBy = json['from_by'];
    // toBy = json['to_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['machine_id'] = this.machineId;
    data['machine_code'] = this.machineCode;
    data['machine_name'] = this.machineName;
    data['machine_type'] = this.machineType;
    data['history_type'] = this.historyType;
    data['history_from_utype'] = this.historyFromUtype;
    data['history_from_uid'] = this.historyFromUid;
    data['history_to_utype'] = this.historyToUtype;
    data['history_to_uid'] = this.historyToUid;
    data['history_date'] = this.historyDate;
    data['from_by'] = this.fromBy;
    // data['to_by'] = this.toBy;
    return data;
  }
}
