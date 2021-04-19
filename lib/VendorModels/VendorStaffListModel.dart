class VendorStaffListModel {
  bool status;
  int totalCount;
  List<Values> values;

  VendorStaffListModel({this.status, this.totalCount, this.values});

  VendorStaffListModel.fromJson(Map<String, dynamic> json) {
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
  String staffId;
  String staffName;
  String staffCode;
  String staffEmail;
  String staffPhone;
  String staffPhoneAlter;
  String staffAddress;
  String staffState;
  String staffDistrict;
  String staffPincode;
  String staffApproval;
  String staffStatus;
  String staffPassword;
  String vendorId;
  String vendorCode;
  String vendorCompanyname;
  String stationId;
  String stationName;
  String stationCode;

  Values(
      {this.staffId,
      this.staffName,
      this.staffCode,
      this.staffEmail,
      this.staffPhone,
      this.staffPhoneAlter,
      this.staffAddress,
      this.staffState,
      this.staffDistrict,
      this.staffPincode,
      this.staffApproval,
      this.staffStatus,
      this.staffPassword,
      this.vendorId,
      this.vendorCode,
      this.vendorCompanyname,
      this.stationId,
      this.stationName,
      this.stationCode});

  Values.fromJson(Map<String, dynamic> json) {
    staffId = json['staff_id'];
    staffName = json['staff_name'];
    staffCode = json['staff_code'];
    staffEmail = json['staff_email'];
    staffPhone = json['staff_phone'];
    staffPhoneAlter = json['staff_phone_alter'];
    staffAddress = json['staff_address'];
    staffState = json['staff_state'];
    staffDistrict = json['staff_district'];
    staffPincode = json['staff_pincode'];
    staffApproval = json['staff_approval'];
    staffStatus = json['staff_status'];
    staffPassword = json['staff_password'];
    vendorId = json['vendor_id'];
    vendorCode = json['vendor_code'];
    vendorCompanyname = json['vendor_companyname'];
    stationId = json['station_id'];
    stationName = json['station_name'];
    stationCode = json['station_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['staff_id'] = this.staffId;
    data['staff_name'] = this.staffName;
    data['staff_code'] = this.staffCode;
    data['staff_email'] = this.staffEmail;
    data['staff_phone'] = this.staffPhone;
    data['staff_phone_alter'] = this.staffPhoneAlter;
    data['staff_address'] = this.staffAddress;
    data['staff_state'] = this.staffState;
    data['staff_district'] = this.staffDistrict;
    data['staff_pincode'] = this.staffPincode;
    data['staff_approval'] = this.staffApproval;
    data['staff_status'] = this.staffStatus;
    data['staff_password'] = this.staffPassword;
    data['vendor_id'] = this.vendorId;
    data['vendor_code'] = this.vendorCode;
    data['vendor_companyname'] = this.vendorCompanyname;
    data['station_id'] = this.stationId;
    data['station_name'] = this.stationName;
    data['station_code'] = this.stationCode;
    return data;
  }
}
