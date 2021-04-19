class StationDetail {
  bool status;
  Data data;

  StationDetail({this.status, this.data});

  StationDetail.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  String stationId;
  String stationCode;
  String stationName;
  String stationAssignUtype;
  String stationAssignUid;
  String stationPincode;
  String vendorContract;
  String stationAddress;
  String locationCoverage;
  String stationStatus;
  String stateId;
  String districtId;
  String stateName;
  String districtName;
  String latitude;
  String longitude;
  String mapLocation;
  String assignby;
  List<MachineDetails> machineDetails;
  List<Staff> staff;

  Data(
      {this.stationId,
      this.stationCode,
      this.stationName,
      this.stationAssignUtype,
      this.stationAssignUid,
      this.stationPincode,
      this.vendorContract,
      this.stationAddress,
      this.locationCoverage,
      this.stationStatus,
      this.stateId,
      this.districtId,
      this.stateName,
      this.districtName,
      this.latitude,
      this.longitude,
      this.mapLocation,
      this.assignby,
      this.machineDetails,
      this.staff});

  Data.fromJson(Map<String, dynamic> json) {
    stationId = json['station_id'];
    stationCode = json['station_code'];
    stationName = json['station_name'];
    stationAssignUtype = json['station_assign_utype'];
    stationAssignUid = json['station_assign_uid'];
    stationPincode = json['station_pincode'];
    vendorContract = json['vendor_contract'];
    stationAddress = json['station_address'];
    locationCoverage = json['location_coverage'];
    stationStatus = json['station_status'];
    stateId = json['state_id'];
    districtId = json['district_id'];
    stateName = json['state_name'];
    districtName = json['district_name'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    mapLocation = json['map_location'];
    assignby = json['assignby'];
    if (json['machine_details'] != null) {
      machineDetails = new List<MachineDetails>();
      json['machine_details'].forEach((v) {
        machineDetails.add(new MachineDetails.fromJson(v));
      });
    }
    if (json['staff'] != null) {
      staff = new List<Staff>();
      json['staff'].forEach((v) {
        staff.add(new Staff.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['station_id'] = this.stationId;
    data['station_code'] = this.stationCode;
    data['station_name'] = this.stationName;
    data['station_assign_utype'] = this.stationAssignUtype;
    data['station_assign_uid'] = this.stationAssignUid;
    data['station_pincode'] = this.stationPincode;
    data['vendor_contract'] = this.vendorContract;
    data['station_address'] = this.stationAddress;
    data['location_coverage'] = this.locationCoverage;
    data['station_status'] = this.stationStatus;
    data['state_id'] = this.stateId;
    data['district_id'] = this.districtId;
    data['state_name'] = this.stateName;
    data['district_name'] = this.districtName;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['map_location'] = this.mapLocation;
    data['assignby'] = this.assignby;
    if (this.machineDetails != null) {
      data['machine_details'] =
          this.machineDetails.map((v) => v.toJson()).toList();
    }
    if (this.staff != null) {
      data['staff'] = this.staff.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MachineDetails {
  String machineId;
  String machineCode;
  String machineName;
  String machineType;

  MachineDetails(
      {this.machineId, this.machineCode, this.machineName, this.machineType});

  MachineDetails.fromJson(Map<String, dynamic> json) {
    machineId = json['machine_id'];
    machineCode = json['machine_code'];
    machineName = json['machine_name'];
    machineType = json['machine_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['machine_id'] = this.machineId;
    data['machine_code'] = this.machineCode;
    data['machine_name'] = this.machineName;
    data['machine_type'] = this.machineType;
    return data;
  }
}

class Staff {
  String staffId;
  String staffName;
  String staffCode;

  Staff({this.staffId, this.staffName, this.staffCode});

  Staff.fromJson(Map<String, dynamic> json) {
    staffId = json['staff_id'];
    staffName = json['staff_name'];
    staffCode = json['staff_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['staff_id'] = this.staffId;
    data['staff_name'] = this.staffName;
    data['staff_code'] = this.staffCode;
    return data;
  }
}

class ContractDetail {
  String regFee;
  String accsTax;
  String accsAmnt;
  String cEnddate;
  String cStardate;
  String refundAmnt;
  String accsTaxAmnt;
  String totalDeposit;

  ContractDetail(
      {this.regFee,
      this.accsTax,
      this.accsAmnt,
      this.cEnddate,
      this.cStardate,
      this.refundAmnt,
      this.accsTaxAmnt,
      this.totalDeposit});

  ContractDetail.fromJson(Map<String, dynamic> json) {
    regFee = json['reg_fee'];
    accsTax = json['accs_tax'];
    accsAmnt = json['accs_amnt'];
    cEnddate = json['c_enddate'];
    cStardate = json['c_stardate'];
    refundAmnt = json['refund_amnt'];
    accsTaxAmnt = json['accs_tax_amnt'];
    totalDeposit = json['total_deposit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['reg_fee'] = this.regFee;
    data['accs_tax'] = this.accsTax;
    data['accs_amnt'] = this.accsAmnt;
    data['c_enddate'] = this.cEnddate;
    data['c_stardate'] = this.cStardate;
    data['refund_amnt'] = this.refundAmnt;
    data['accs_tax_amnt'] = this.accsTaxAmnt;
    data['total_deposit'] = this.totalDeposit;
    return data;
  }
}
