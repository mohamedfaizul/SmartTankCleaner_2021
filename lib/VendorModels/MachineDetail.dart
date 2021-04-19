class MachineView {
  bool status;
  Values values;

  MachineView({this.status, this.values});

  MachineView.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    values =
    json['values'] != null ? new Values.fromJson(json['values']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.values != null) {
      data['values'] = this.values.toJson();
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
  String machineAssignUtype;
  String machineAssignUid;
  String assignby;
  ServiceStation serviceStation;
  List<RepairHistory> repairHistory;
  List<TransferHistory> transferHistory;

  Values(
      {this.machineId,
        this.machineCode,
        this.machineName,
        this.manufactureName,
        this.manufactureNumber,
        this.machineType,
        this.purchaseDate,
        this.machineStatus,
        this.machineAssignUtype,
        this.machineAssignUid,
        this.assignby,
        this.serviceStation,
        this.repairHistory,
        this.transferHistory});

  Values.fromJson(Map<String, dynamic> json) {
    machineId = json['machine_id'];
    machineCode = json['machine_code'];
    machineName = json['machine_name'];
    manufactureName = json['manufacture_name'];
    manufactureNumber = json['manufacture_number'];
    machineType = json['machine_type'];
    purchaseDate = json['purchase_date'];
    machineStatus = json['machine_status'];
    machineAssignUtype = json['machine_assign_utype'];
    machineAssignUid = json['machine_assign_uid'];
    assignby = json['assignby'];
    serviceStation = json['service_station'] != null
        ? new ServiceStation.fromJson(json['service_station'])
        : null;
    if (json['repair_history'] != null) {
      repairHistory = new List<RepairHistory>();
      json['repair_history'].forEach((v) {
        repairHistory.add(new RepairHistory.fromJson(v));
      });
    }
    if (json['transfer_history'] != null) {
      transferHistory = new List<TransferHistory>();
      json['transfer_history'].forEach((v) {
        transferHistory.add(new TransferHistory.fromJson(v));
      });
    }
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
    data['machine_assign_utype'] = this.machineAssignUtype;
    data['machine_assign_uid'] = this.machineAssignUid;
    data['assignby'] = this.assignby;
    if (this.serviceStation != null) {
      data['service_station'] = this.serviceStation.toJson();
    }
    if (this.repairHistory != null) {
      data['repair_history'] =
          this.repairHistory.map((v) => v.toJson()).toList();
    }
    if (this.transferHistory != null) {
      data['transfer_history'] =
          this.transferHistory.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ServiceStation {
  String stationId;
  String stationName;
  String stationCode;
  String stateId;
  String districtId;
  String stateName;
  String districtName;

  ServiceStation(
      {this.stationId,
        this.stationName,
        this.stationCode,
        this.stateId,
        this.districtId,
        this.stateName,
        this.districtName});

  ServiceStation.fromJson(Map<String, dynamic> json) {
    stationId = json['station_id'];
    stationName = json['station_name'];
    stationCode = json['station_code'];
    stateId = json['state_id'];
    districtId = json['district_id'];
    stateName = json['state_name'];
    districtName = json['district_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['station_id'] = this.stationId;
    data['station_name'] = this.stationName;
    data['station_code'] = this.stationCode;
    data['state_id'] = this.stateId;
    data['district_id'] = this.districtId;
    data['state_name'] = this.stateName;
    data['district_name'] = this.districtName;
    return data;
  }
}

class RepairHistory {
  String repairCode;
  String repairId;
  String machineId;
  String repairNote;
  String repairStatus;
  String repairCharge;

  RepairHistory(
      {this.repairCode,
        this.repairId,
        this.machineId,
        this.repairNote,
        this.repairStatus,
        this.repairCharge});

  RepairHistory.fromJson(Map<String, dynamic> json) {
    repairCode = json['repair_code'];
    repairId = json['repair_id'];
    machineId = json['machine_id'];
    repairNote = json['repair_note'];
    repairStatus = json['repair_status'];
    repairCharge = json['repair_charge'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['repair_code'] = this.repairCode;
    data['repair_id'] = this.repairId;
    data['machine_id'] = this.machineId;
    data['repair_note'] = this.repairNote;
    data['repair_status'] = this.repairStatus;
    data['repair_charge'] = this.repairCharge;
    return data;
  }
}

class TransferHistory {
  String spTransferId;
  String spTransferCode;
  String machineTransferType;
  String senderUtype;
  String senderUid;
  String receiverUtype;
  String receiverUid;
  String otpVerify;
  String sendby;
  String receiveby;

  TransferHistory(
      {this.spTransferId,
      this.spTransferCode,
      this.machineTransferType,
      this.senderUtype,
      this.senderUid,
      this.receiverUtype,
      this.receiverUid,
      this.otpVerify,
      this.sendby,
      this.receiveby});

  TransferHistory.fromJson(Map<String, dynamic> json) {
    spTransferId = json['sp_transfer_id'];
    spTransferCode = json['sp_transfer_code'];
    machineTransferType = json['machine_transfer_type'];
    senderUtype = json['sender_utype'];
    senderUid = json['sender_uid'];
    receiverUtype = json['receiver_utype'];
    receiverUid = json['receiver_uid'];
    otpVerify = json['otp_verify'];
    sendby = json['sendby'];
    receiveby = json['receiveby'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sp_transfer_id'] = this.spTransferId;
    data['sp_transfer_code'] = this.spTransferCode;
    data['machine_transfer_type'] = this.machineTransferType;
    data['sender_utype'] = this.senderUtype;
    data['sender_uid'] = this.senderUid;
    data['receiver_utype'] = this.receiverUtype;
    data['receiver_uid'] = this.receiverUid;
    data['otp_verify'] = this.otpVerify;
    data['sendby'] = this.sendby;
    data['receiveby'] = this.receiveby;
    return data;
  }
}
