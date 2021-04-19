class SpareRequestView {
  bool status;
  String messages;
  Data data;

  SpareRequestView({this.status, this.messages, this.data});

  SpareRequestView.fromJson(Map<String, dynamic> json) {
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
  String machineId;
  String machineCode;
  String machineName;
  String purchaseDate;
  String machineType;
  String manufactureName;
  String manufactureNumber;
  String spareCode;
  String spareId;
  String spareNote;
  String reqUtype;
  String reqUid;
  String stateId;
  String districtId;
  String stateName;
  String districtName;
  String reqby;

  Data(
      {this.machineId,
      this.machineCode,
      this.machineName,
      this.purchaseDate,
      this.machineType,
      this.manufactureName,
      this.manufactureNumber,
      this.spareCode,
      this.spareId,
      this.spareNote,
      this.reqUtype,
      this.reqUid,
      this.stateId,
      this.districtId,
      this.stateName,
      this.districtName,
      this.reqby});

  Data.fromJson(Map<String, dynamic> json) {
    machineId = json['machine_id'];
    machineCode = json['machine_code'];
    machineName = json['machine_name'];
    purchaseDate = json['purchase_date'];
    machineType = json['machine_type'];
    manufactureName = json['manufacture_name'];
    manufactureNumber = json['manufacture_number'];
    spareCode = json['spare_code'];
    spareId = json['spare_id'];
    spareNote = json['spare_note'];
    reqUtype = json['req_utype'];
    reqUid = json['req_uid'];
    stateId = json['state_id'];
    districtId = json['district_id'];
    stateName = json['state_name'];
    districtName = json['district_name'];
    reqby = json['reqby'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['machine_id'] = this.machineId;
    data['machine_code'] = this.machineCode;
    data['machine_name'] = this.machineName;
    data['purchase_date'] = this.purchaseDate;
    data['machine_type'] = this.machineType;
    data['manufacture_name'] = this.manufactureName;
    data['manufacture_number'] = this.manufactureNumber;
    data['spare_code'] = this.spareCode;
    data['spare_id'] = this.spareId;
    data['spare_note'] = this.spareNote;
    data['req_utype'] = this.reqUtype;
    data['req_uid'] = this.reqUid;
    data['state_id'] = this.stateId;
    data['district_id'] = this.districtId;
    data['state_name'] = this.stateName;
    data['district_name'] = this.districtName;
    data['reqby'] = this.reqby;
    return data;
  }
}
