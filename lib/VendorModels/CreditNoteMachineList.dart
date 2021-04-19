class CreditNoteMachineList {
  bool status;
  int totalCount;
  List<Values> values;

  CreditNoteMachineList({this.status, this.totalCount, this.values});

  CreditNoteMachineList.fromJson(Map<String, dynamic> json) {
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
  String manufactureName;
  String manufactureNumber;
  String machineType;
  String purchaseDate;
  String machineStatus;
  String machineAssignId;
  String machineAssignUtype;
  String assignby;

  Values(
      {this.machineId,
      this.machineCode,
      this.machineName,
      this.manufactureName,
      this.manufactureNumber,
      this.machineType,
      this.purchaseDate,
      this.machineStatus,
      this.machineAssignId,
      this.machineAssignUtype,
      this.assignby});

  Values.fromJson(Map<String, dynamic> json) {
    machineId = json['machine_id'];
    machineCode = json['machine_code'];
    machineName = json['machine_name'];
    manufactureName = json['manufacture_name'];
    manufactureNumber = json['manufacture_number'];
    machineType = json['machine_type'];
    purchaseDate = json['purchase_date'];
    machineStatus = json['machine_status'];
    machineAssignId = json['machine_assign_id'];
    machineAssignUtype = json['machine_assign_utype'];
    assignby = json['assignby'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['machine_id'] = this.machineId;
    data['machine_code'] = this.machineCode;
    data['machine_name'] = this.machineName;
    data['manufacture_name'] = this.manufactureName;
    data['manufacture_number'] = this.manufactureNumber;
    data['machine_type'] = this.machineType;
    data['purchase_date'] = this.purchaseDate;
    data['machine_status'] = this.machineStatus;
    data['machine_assign_id'] = this.machineAssignId;
    data['machine_assign_utype'] = this.machineAssignUtype;
    data['assignby'] = this.assignby;
    return data;
  }
}
