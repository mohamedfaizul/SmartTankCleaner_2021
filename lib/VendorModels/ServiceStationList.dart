class ServiceStationListings {
  bool status;
  int totalCount;
  List<Values> values;

  ServiceStationListings({this.status, this.totalCount, this.values});

  ServiceStationListings.fromJson(Map<String, dynamic> json) {
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
  String stationId;
  String stationCode;
  String stationName;
  String stationAssignUtype;
  String stationAssignUid;
  String vendorDepositeAmount;
  String locationCoverage;
  String stationStatus;
  String assignby;
  String stateName;
  String districtName;

  Values(
      {this.stationId,
      this.stationCode,
      this.stationName,
      this.stationAssignUtype,
      this.stationAssignUid,
      this.vendorDepositeAmount,
      this.locationCoverage,
      this.stationStatus,
      this.assignby,
      this.stateName,
      this.districtName});

  Values.fromJson(Map<String, dynamic> json) {
    stationId = json['station_id'];
    stationCode = json['station_code'];
    stationName = json['station_name'];
    stationAssignUtype = json['station_assign_utype'];
    stationAssignUid = json['station_assign_uid'];
    vendorDepositeAmount = json['vendor_deposite_amount'];
    locationCoverage = json['location_coverage'];
    stationStatus = json['station_status'];
    assignby = json['assignby'];
    stateName = json['state_name'];
    districtName = json['district_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['station_id'] = this.stationId;
    data['station_code'] = this.stationCode;
    data['station_name'] = this.stationName;
    data['station_assign_utype'] = this.stationAssignUtype;
    data['station_assign_uid'] = this.stationAssignUid;
    data['vendor_deposite_amount'] = this.vendorDepositeAmount;
    data['location_coverage'] = this.locationCoverage;
    data['station_status'] = this.stationStatus;
    data['assignby'] = this.assignby;
    data['state_name'] = this.stateName;
    data['district_name'] = this.districtName;
    return data;
  }
}
