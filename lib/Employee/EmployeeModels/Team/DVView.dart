class DVViewModel {
  bool status;
  Items items;

  DVViewModel({this.status, this.items});

  DVViewModel.fromJson(Map<String, dynamic> json) {
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
  String dvendorId;
  String dvendorCode;
  String dvendorName;
  String dvendorCompanyname;
  String dvendorWallet;
  String dvendorPhone;
  String dvendorPhoneAlter;
  String dvendorEmail;
  String dvendorPassword;
  String dvendorGender;
  String dvendorDob;
  String dvendorDoj;
  List<DvendorPhotos> dvendorPhotos;
  List<DvendorProofs> dvendorProofs;
  String dvendorGst;
  String dvendorAddress;
  String dvendorPincode;
  String dvendorDistrict;
  String dvendorState;
  String dvendorBankDetails;
  String locationId;
  String otp;
  String districtName;
  String stateName;
  String dvendorStatus;
  String dvendorApproval;
  String dvendorContract;
  String createdAt;
  String updatedAt;
  String updatedBy;
  String createdBy;
  String latitude;
  String longitude;
  String mapLocation;
  List<DvendorZone> dvendorZone;

  Items(
      {this.dvendorId,
        this.dvendorCode,
        this.dvendorName,
        this.dvendorCompanyname,
        this.dvendorWallet,
        this.dvendorPhone,
        this.dvendorPhoneAlter,
        this.dvendorEmail,
        this.dvendorPassword,
        this.dvendorGender,
        this.dvendorDob,
        this.dvendorDoj,
        this.dvendorPhotos,
        this.dvendorProofs,
        this.dvendorGst,
        this.dvendorAddress,
        this.dvendorPincode,
        this.dvendorDistrict,
        this.dvendorState,
        this.dvendorBankDetails,
        this.locationId,
        this.otp,
        this.districtName,
        this.stateName,
        this.dvendorStatus,
        this.dvendorApproval,
        this.dvendorContract,
        this.createdAt,
        this.updatedAt,
        this.updatedBy,
        this.createdBy,
        this.latitude,
        this.longitude,
        this.mapLocation,
        this.dvendorZone});

  Items.fromJson(Map<String, dynamic> json) {
    dvendorId = json['dvendor_id'];
    dvendorCode = json['dvendor_code'];
    dvendorName = json['dvendor_name'];
    dvendorCompanyname = json['dvendor_companyname'];
    dvendorWallet = json['dvendor_wallet'];
    dvendorPhone = json['dvendor_phone'];
    dvendorPhoneAlter = json['dvendor_phone_alter'];
    dvendorEmail = json['dvendor_email'];
    dvendorPassword = json['dvendor_password'];
    dvendorGender = json['dvendor_gender'];
    dvendorDob = json['dvendor_dob'];
    dvendorDoj = json['dvendor_doj'];
    if (json['dvendor_photos'] != null) {
      dvendorPhotos = new List<DvendorPhotos>();
      json['dvendor_photos'].forEach((v) {
        dvendorPhotos.add(new DvendorPhotos.fromJson(v));
      });
    }
    if (json['dvendor_proofs'] != null) {
      dvendorProofs = new List<DvendorProofs>();
      json['dvendor_proofs'].forEach((v) {
        dvendorProofs.add(new DvendorProofs.fromJson(v));
      });
    }
    dvendorGst = json['dvendor_gst'];
    dvendorAddress = json['dvendor_address'];
    dvendorPincode = json['dvendor_pincode'];
    dvendorDistrict = json['dvendor_district'];
    dvendorState = json['dvendor_state'];
    dvendorBankDetails = json['dvendor_bank_details'];
    locationId = json['location_id'];
    otp = json['otp'];
    districtName = json['district_name'];
    stateName = json['state_name'];
    dvendorStatus = json['dvendor_status'];
    dvendorApproval = json['dvendor_approval'];
    dvendorContract = json['dvendor_contract'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    updatedBy = json['updated_by'];
    createdBy = json['created_by'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    mapLocation = json['map_location'];
    if (json['dvendor_zone'] != null) {
      dvendorZone = new List<DvendorZone>();
      json['dvendor_zone'].forEach((v) {
        dvendorZone.add(new DvendorZone.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dvendor_id'] = this.dvendorId;
    data['dvendor_code'] = this.dvendorCode;
    data['dvendor_name'] = this.dvendorName;
    data['dvendor_companyname'] = this.dvendorCompanyname;
    data['dvendor_wallet'] = this.dvendorWallet;
    data['dvendor_phone'] = this.dvendorPhone;
    data['dvendor_phone_alter'] = this.dvendorPhoneAlter;
    data['dvendor_email'] = this.dvendorEmail;
    data['dvendor_password'] = this.dvendorPassword;
    data['dvendor_gender'] = this.dvendorGender;
    data['dvendor_dob'] = this.dvendorDob;
    data['dvendor_doj'] = this.dvendorDoj;
    if (this.dvendorPhotos != null) {
      data['dvendor_photos'] =
          this.dvendorPhotos.map((v) => v.toJson()).toList();
    }
    if (this.dvendorProofs != null) {
      data['dvendor_proofs'] =
          this.dvendorProofs.map((v) => v.toJson()).toList();
    }
    data['dvendor_gst'] = this.dvendorGst;
    data['dvendor_address'] = this.dvendorAddress;
    data['dvendor_pincode'] = this.dvendorPincode;
    data['dvendor_district'] = this.dvendorDistrict;
    data['dvendor_state'] = this.dvendorState;
    data['dvendor_bank_details'] = this.dvendorBankDetails;
    data['location_id'] = this.locationId;
    data['otp'] = this.otp;
    data['district_name'] = this.districtName;
    data['state_name'] = this.stateName;
    data['dvendor_status'] = this.dvendorStatus;
    data['dvendor_approval'] = this.dvendorApproval;
    data['dvendor_contract'] = this.dvendorContract;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['updated_by'] = this.updatedBy;
    data['created_by'] = this.createdBy;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['map_location'] = this.mapLocation;
    if (this.dvendorZone != null) {
      data['dvendor_zone'] = this.dvendorZone.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DvendorPhotos {
  String imgId;
  String imgPath;

  DvendorPhotos({this.imgId, this.imgPath});

  DvendorPhotos.fromJson(Map<String, dynamic> json) {
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

class DvendorZone {
  String stateId;
  String districtId;
  String stateName;
  String districtName;

  DvendorZone(
      {this.stateId, this.districtId, this.stateName, this.districtName});

  DvendorZone.fromJson(Map<String, dynamic> json) {
    stateId = json['state_id'];
    districtId = json['district_id'];
    stateName = json['state_name'];
    districtName = json['district_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['state_id'] = this.stateId;
    data['district_id'] = this.districtId;
    data['state_name'] = this.stateName;
    data['district_name'] = this.districtName;
    return data;
  }
}
class DvendorProofs {
  String imgId;
  String imgPath;

  DvendorProofs({this.imgId, this.imgPath});

  DvendorProofs.fromJson(Map<String, dynamic> json) {
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
  String dvendorAccName;
  String dvendorAccNo;
  String dvendorAccBranch;
  String dvendorAccBank;
  String dvendorAccIfsc;

  AccDetails(
      {this.dvendorAccName,
        this.dvendorAccNo,
        this.dvendorAccBranch,
        this.dvendorAccBank,
        this.dvendorAccIfsc});

  AccDetails.fromJson(Map<String, dynamic> json) {
    dvendorAccName = json['dvendor_acc_name'];
    dvendorAccNo = json['dvendor_acc_no'];
    dvendorAccBranch = json['dvendor_acc_branch'];
    dvendorAccBank = json['dvendor_acc_bank'];
    dvendorAccIfsc = json['dvendor_acc_ifsc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dvendor_acc_name'] = this.dvendorAccName;
    data['dvendor_acc_no'] = this.dvendorAccNo;
    data['dvendor_acc_branch'] = this.dvendorAccBranch;
    data['dvendor_acc_bank'] = this.dvendorAccBank;
    data['dvendor_acc_ifsc'] = this.dvendorAccIfsc;
    return data;
  }
}