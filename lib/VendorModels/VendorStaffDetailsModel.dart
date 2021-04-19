class VendorStaffDetails {
  bool status;
  Items items;

  VendorStaffDetails({this.status, this.items});

  VendorStaffDetails.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    items = json['items'] != null ? new Items.fromJson(json['items']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.items != null) {
      data['items'] = this.items.toJson();
    }
    return data;
  }
}

class Items {
  String staffId;
  String vendorId;
  String staffCode;
  String staffName;
  String staffPhone;
  String staffPhoneAlter;
  String staffEmail;
  String staffPassword;
  String staffGender;
  String staffDob;
  String staffDoj;
  List<StaffPhotos> staffPhotos;
  List<StaffProofs> staffProofs;
  String staffAddress;
  String staffPincode;
  String staffDistrict;
  String staffState;
  String staffBankDetails;
  String serviceStationId;
  String staffStatus;
  String staffApproval;
  String createdUtype;
  String updatedUtype;
  String createdAt;
  String updatedAt;
  String updatedBy;
  String createdBy;
  String vendorCode;
  String vendorCompanyname;
  String stateName;
  String districtName;
  String stationName;
  String stationCode;

  Items(
      {this.staffId,
      this.vendorId,
      this.staffCode,
      this.staffName,
      this.staffPhone,
      this.staffPhoneAlter,
      this.staffEmail,
      this.staffPassword,
      this.staffGender,
      this.staffDob,
      this.staffDoj,
      this.staffPhotos,
      this.staffProofs,
      this.staffAddress,
      this.staffPincode,
      this.staffDistrict,
      this.staffState,
      this.staffBankDetails,
      this.serviceStationId,
      this.staffStatus,
      this.staffApproval,
      this.createdUtype,
      this.updatedUtype,
      this.createdAt,
      this.updatedAt,
      this.updatedBy,
      this.createdBy,
      this.vendorCode,
      this.vendorCompanyname,
      this.stateName,
      this.districtName,
      this.stationName,
      this.stationCode});

  Items.fromJson(Map<String, dynamic> json) {
    staffId = json['staff_id'];
    vendorId = json['vendor_id'];
    staffCode = json['staff_code'];
    staffName = json['staff_name'];
    staffPhone = json['staff_phone'];
    staffPhoneAlter = json['staff_phone_alter'];
    staffEmail = json['staff_email'];
    staffPassword = json['staff_password'];
    staffGender = json['staff_gender'];
    staffDob = json['staff_dob'];
    staffDoj = json['staff_doj'];
    if (json['staff_photos'] != "null") {
      staffPhotos = new List<StaffPhotos>();
      json['staff_photos'].forEach((v) {
        staffPhotos.add(new StaffPhotos.fromJson(v));
      });
    }
    if (json['staff_proofs'] != "null") {
      staffProofs = new List<StaffProofs>();
      json['staff_proofs'].forEach((v) {
        staffProofs.add(new StaffProofs.fromJson(v));
      });
    }
    staffAddress = json['staff_address'];
    staffPincode = json['staff_pincode'];
    staffDistrict = json['staff_district'];
    staffState = json['staff_state'];
    staffBankDetails = json['staff_bank_details'];
    serviceStationId = json['service_station_id'];
    staffStatus = json['staff_status'];
    staffApproval = json['staff_approval'];
    createdUtype = json['created_utype'];
    updatedUtype = json['updated_utype'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    updatedBy = json['updated_by'];
    createdBy = json['created_by'];
    vendorCode = json['vendor_code'];
    vendorCompanyname = json['vendor_companyname'];
    stateName = json['state_name'];
    districtName = json['district_name'];
    stationName = json['station_name'];
    stationCode = json['station_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['staff_id'] = this.staffId;
    data['vendor_id'] = this.vendorId;
    data['staff_code'] = this.staffCode;
    data['staff_name'] = this.staffName;
    data['staff_phone'] = this.staffPhone;
    data['staff_phone_alter'] = this.staffPhoneAlter;
    data['staff_email'] = this.staffEmail;
    data['staff_password'] = this.staffPassword;
    data['staff_gender'] = this.staffGender;
    data['staff_dob'] = this.staffDob;
    data['staff_doj'] = this.staffDoj;
    if (this.staffPhotos != null) {
      data['staff_photos'] = this.staffPhotos.map((v) => v.toJson()).toList();
    }
    if (this.staffProofs != null) {
      data['staff_proofs'] = this.staffProofs.map((v) => v.toJson()).toList();
    }
    data['staff_address'] = this.staffAddress;
    data['staff_pincode'] = this.staffPincode;
    data['staff_district'] = this.staffDistrict;
    data['staff_state'] = this.staffState;
    data['staff_bank_details'] = this.staffBankDetails;
    data['service_station_id'] = this.serviceStationId;
    data['staff_status'] = this.staffStatus;
    data['staff_approval'] = this.staffApproval;
    data['created_utype'] = this.createdUtype;
    data['updated_utype'] = this.updatedUtype;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['updated_by'] = this.updatedBy;
    data['created_by'] = this.createdBy;
    data['vendor_code'] = this.vendorCode;
    data['vendor_companyname'] = this.vendorCompanyname;
    data['state_name'] = this.stateName;
    data['district_name'] = this.districtName;
    data['station_name'] = this.stationName;
    data['station_code'] = this.stationCode;
    return data;
  }
}

class StaffPhotos {
  String imgId;
  String imgPath;

  StaffPhotos({this.imgId, this.imgPath});

  StaffPhotos.fromJson(Map<String, dynamic> json) {
    imgId = json['img_id'];
    imgPath = json['img_path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['img_id'] = this.imgId;
    data['img_path'] = this.imgPath;
    return data;
  }
}

class StaffProofs {
  String imgId;
  String imgPath;

  StaffProofs({this.imgId, this.imgPath});

  StaffProofs.fromJson(Map<String, dynamic> json) {
    imgId = json['img_id'];
    imgPath = json['img_path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['img_id'] = this.imgId;
    data['img_path'] = this.imgPath;
    return data;
  }
}

class AccDetails {
  String staffAccName;
  String staffAccNo;
  String staffAccBranch;
  String staffAccBank;
  String staffAccIfsc;

  AccDetails(
      {this.staffAccName,
      this.staffAccNo,
      this.staffAccBranch,
      this.staffAccBank,
      this.staffAccIfsc});

  AccDetails.fromJson(Map<String, dynamic> json) {
    staffAccName = json['staff_acc_name'];
    staffAccNo = json['staff_acc_no'];
    staffAccBranch = json['staff_acc_branch'];
    staffAccBank = json['staff_acc_bank'];
    staffAccIfsc = json['staff_acc_ifsc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['staff_acc_name'] = this.staffAccName;
    data['staff_acc_no'] = this.staffAccNo;
    data['staff_acc_branch'] = this.staffAccBranch;
    data['staff_acc_bank'] = this.staffAccBank;
    data['staff_acc_ifsc'] = this.staffAccIfsc;
    return data;
  }
}
