class ServiceAssignModelList {
  final List<ServiceAssignModel> tariff;

  ServiceAssignModelList({
    this.tariff,
  });

  factory ServiceAssignModelList.fromJson(List<dynamic> parsedJson) {
    List<ServiceAssignModel> tariffs = new List<ServiceAssignModel>();
    tariffs = parsedJson.map((i) => ServiceAssignModel.fromJson(i)).toList();

    return new ServiceAssignModelList(tariff: tariffs);
  }
}

class ServiceAssignModel {
  String stationId;
  String stationCode;
  String stationName;
  String latitude;
  String longitude;
  String mapLocation;
  String locationCoverage;
  String assignby;
  String phone;
  String assignUid;
  String assignUtype;
  int serviceCount;

  ServiceAssignModel(
      {this.stationId,
      this.stationCode,
      this.stationName,
      this.latitude,
      this.longitude,
      this.mapLocation,
      this.locationCoverage,
      this.assignby,
      this.phone,
      this.assignUid,
      this.assignUtype,
      this.serviceCount});

  ServiceAssignModel.fromJson(Map<String, dynamic> json) {
    stationId = json['station_id'];
    stationCode = json['station_code'];
    stationName = json['station_name'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    mapLocation = json['map_location'];
    locationCoverage = json['location_coverage'];
    assignby = json['assignby'];
    phone = json['phone'];
    assignUid = json['assign_uid'];
    assignUtype = json['assign_utype'];
    serviceCount = json['service_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['station_id'] = this.stationId;
    data['station_code'] = this.stationCode;
    data['station_name'] = this.stationName;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['map_location'] = this.mapLocation;
    data['location_coverage'] = this.locationCoverage;
    data['assignby'] = this.assignby;
    data['phone'] = this.phone;
    data['assign_uid'] = this.assignUid;
    data['assign_utype'] = this.assignUtype;
    data['service_count'] = this.serviceCount;
    return data;
  }
}
