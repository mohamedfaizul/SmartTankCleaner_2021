class Supervisor360model {
  bool status;
  Data data;

  Supervisor360model({this.status, this.data});

  Supervisor360model.fromJson(Map<String, dynamic> json) {
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
  Superviser superviser;
  List<Servicer> servicer;
  List<ServiceStation> serviceStation;

  Data({this.superviser, this.servicer, this.serviceStation});

  Data.fromJson(Map<String, dynamic> json) {
    superviser = json['superviser'] != null
        ? new Superviser.fromJson(json['superviser'])
        : null;
    if (json['servicer'] != null) {
      servicer = new List<Null>();
      json['servicer'].forEach((v) {
        servicer.add(new Servicer.fromJson(v));
      });
    }
    if (json['service_station'] != null) {
      serviceStation = new List<Null>();
      json['service_station'].forEach((v) {
        serviceStation.add(new ServiceStation.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.superviser != null) {
      data['superviser'] = this.superviser.toJson();
    }
    if (this.servicer != null) {
      data['servicer'] = this.servicer.map((v) => v.toJson()).toList();
    }
    if (this.serviceStation != null) {
      data['service_station'] =
          this.serviceStation.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Superviser {
  String uid;
  String ucode;
  String uname;
  String uphone;
  String uroleid;

  Superviser({this.uid, this.ucode, this.uname, this.uphone, this.uroleid});

  Superviser.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    ucode = json['ucode'];
    uname = json['uname'];
    uphone = json['uphone'];
    uroleid = json['uroleid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['ucode'] = this.ucode;
    data['uname'] = this.uname;
    data['uphone'] = this.uphone;
    data['uroleid'] = this.uroleid;
    return data;
  }
}
class Servicer {
  String uid;
  String ucode;
  String uname;
  String uphone;
  String uroleid;

  Servicer({this.uid, this.ucode, this.uname, this.uphone, this.uroleid});

  Servicer.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    ucode = json['ucode'];
    uname = json['uname'];
    uphone = json['uphone'];
    uroleid = json['uroleid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['ucode'] = this.ucode;
    data['uname'] = this.uname;
    data['uphone'] = this.uphone;
    data['uroleid'] = this.uroleid;
    return data;
  }
}
class ServiceStation {
  String stationId;
  String stationCode;
  String stationName;
  String stationAssignUtype;
  String stationAssignUid;
  String vendorContract;
  String locationCoverage;
  String stationStatus;
  String assignby;

  ServiceStation(
      {this.stationId,
        this.stationCode,
        this.stationName,
        this.stationAssignUtype,
        this.stationAssignUid,
        this.vendorContract,
        this.locationCoverage,
        this.stationStatus,
        this.assignby});

  ServiceStation.fromJson(Map<String, dynamic> json) {
    stationId = json['station_id'];
    stationCode = json['station_code'];
    stationName = json['station_name'];
    stationAssignUtype = json['station_assign_utype'];
    stationAssignUid = json['station_assign_uid'];
    vendorContract = json['vendor_contract'];
    locationCoverage = json['location_coverage'];
    stationStatus = json['station_status'];
    assignby = json['assignby'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['station_id'] = this.stationId;
    data['station_code'] = this.stationCode;
    data['station_name'] = this.stationName;
    data['station_assign_utype'] = this.stationAssignUtype;
    data['station_assign_uid'] = this.stationAssignUid;
    data['vendor_contract'] = this.vendorContract;
    data['location_coverage'] = this.locationCoverage;
    data['station_status'] = this.stationStatus;
    data['assignby'] = this.assignby;
    return data;
  }
}