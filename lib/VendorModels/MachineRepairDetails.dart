class MachineRepairDetails {
  bool status;
  String messages;
  Data data;

  MachineRepairDetails({this.status, this.messages, this.data});

  MachineRepairDetails.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    messages = json['messages'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['messages'] = this.messages;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  String machineCode;
  String machineName;
  String purchaseDate;
  String machineType;
  String manufactureName;
  String manufactureNumber;
  String repairCode;
  String repairId;
  String machineId;
  String repairNote;
  String repairStatus;
  String machineUid;
  String machineUtype;
  String repairCharge;
  String stateId;
  String stateName;
  String districtId;
  String districtName;
  String assignby;
  List<RepairQuote> repairQuote;

  Data(
      {this.machineCode,
      this.machineName,
      this.purchaseDate,
      this.machineType,
      this.manufactureName,
      this.manufactureNumber,
      this.repairCode,
      this.repairId,
      this.machineId,
      this.repairNote,
      this.repairStatus,
      this.machineUid,
      this.machineUtype,
      this.repairCharge,
      this.stateId,
      this.stateName,
      this.districtId,
      this.districtName,
      this.assignby,
      this.repairQuote});

  Data.fromJson(Map<String, dynamic> json) {
    machineCode = json['machine_code'];
    machineName = json['machine_name'];
    purchaseDate = json['purchase_date'];
    machineType = json['machine_type'];
    manufactureName = json['manufacture_name'];
    manufactureNumber = json['manufacture_number'];
    repairCode = json['repair_code'];
    repairId = json['repair_id'];
    machineId = json['machine_id'];
    repairNote = json['repair_note'];
    repairStatus = json['repair_status'];
    machineUid = json['machine_uid'];
    machineUtype = json['machine_utype'];
    repairCharge = json['repair_charge'];
    stateId = json['state_id'];
    stateName = json['state_name'];
    districtId = json['district_id'];
    districtName = json['district_name'];
    assignby = json['assignby'];
    if (json['repair_quote'] != null) {
      repairQuote = new List<RepairQuote>();
      json['repair_quote'].forEach((v) {
        repairQuote.add(new RepairQuote.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['machine_code'] = this.machineCode;
    data['machine_name'] = this.machineName;
    data['purchase_date'] = this.purchaseDate;
    data['machine_type'] = this.machineType;
    data['manufacture_name'] = this.manufactureName;
    data['manufacture_number'] = this.manufactureNumber;
    data['repair_code'] = this.repairCode;
    data['repair_id'] = this.repairId;
    data['machine_id'] = this.machineId;
    data['repair_note'] = this.repairNote;
    data['repair_status'] = this.repairStatus;
    data['machine_uid'] = this.machineUid;
    data['machine_utype'] = this.machineUtype;
    data['repair_charge'] = this.repairCharge;
    data['state_id'] = this.stateId;
    data['state_name'] = this.stateName;
    data['district_id'] = this.districtId;
    data['district_name'] = this.districtName;
    data['assignby'] = this.assignby;
    if (this.repairQuote != null) {
      data['repair_quote'] = this.repairQuote.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RepairQuote {
  String sparePart;
  String spareQty;
  String sparePrice;
  String spareSubTotal;

  RepairQuote(
      {this.sparePart, this.spareQty, this.sparePrice, this.spareSubTotal});

  RepairQuote.fromJson(Map<String, dynamic> json) {
    sparePart = json['spare_part'];
    spareQty = json['spare_qty'];
    sparePrice = json['spare_price'];
    spareSubTotal = json['spare_sub_total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['spare_part'] = this.sparePart;
    data['spare_qty'] = this.spareQty;
    data['spare_price'] = this.sparePrice;
    data['spare_sub_total'] = this.spareSubTotal;
    return data;
  }
}
