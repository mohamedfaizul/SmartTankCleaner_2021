class FranchaiseView {
  bool status;
  Items items;

  FranchaiseView({this.status, this.items});

  FranchaiseView.fromJson(Map<String, dynamic> json) {
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
  String franchiseId;
  String franchiseCode;
  String franchiseName;
  String franchiseCompanyname;
  String franchiseWallet;
  String franchisePhone;
  String franchisePhoneAlter;
  String franchiseEmail;
  String franchisePassword;
  String franchiseGender;
  String franchiseDob;
  String franchiseDoj;
  List<FranchisePhotos> franchisePhotos;
  List<FranchiseProofs> franchiseProofs;
  String franchiseGst;
  String franchiseAddress;
  String franchisePincode;
  String franchiseDistrict;
  String franchiseState;
  String franchiseBankDetails;
  String locationId;
  String franchiseStatus;
  String franchiseApproval;
  String franchiseContract;
  String otp;
  String createdAt;
  String updatedAt;
  String updatedBy;
  String createdBy;
  String latitude;
  String longitude;
  String mapLocation;
  String stateName;
  String districtName;
  List<FranchiseZone> franchiseZone;

  Items(
      {this.franchiseId,
      this.franchiseCode,
      this.franchiseName,
      this.franchiseCompanyname,
      this.franchiseWallet,
      this.franchisePhone,
      this.franchisePhoneAlter,
      this.franchiseEmail,
      this.franchisePassword,
      this.franchiseGender,
      this.franchiseDob,
      this.franchiseDoj,
      this.franchisePhotos,
      this.franchiseProofs,
      this.franchiseGst,
      this.franchiseAddress,
      this.franchisePincode,
      this.franchiseDistrict,
      this.franchiseState,
      this.franchiseBankDetails,
      this.locationId,
      this.franchiseStatus,
      this.franchiseApproval,
      this.franchiseContract,
      this.otp,
      this.createdAt,
      this.updatedAt,
      this.updatedBy,
      this.createdBy,
      this.latitude,
      this.longitude,
      this.mapLocation,
      this.stateName,
      this.districtName,
      this.franchiseZone});

  Items.fromJson(Map<String, dynamic> json) {
    franchiseId = json['franchise_id'];
    franchiseCode = json['franchise_code'];
    franchiseName = json['franchise_name'];
    franchiseCompanyname = json['franchise_companyname'];
    franchiseWallet = json['franchise_wallet'];
    franchisePhone = json['franchise_phone'];
    franchisePhoneAlter = json['franchise_phone_alter'];
    franchiseEmail = json['franchise_email'];
    franchisePassword = json['franchise_password'];
    franchiseGender = json['franchise_gender'];
    franchiseDob = json['franchise_dob'];
    franchiseDoj = json['franchise_doj'];
    if (json['franchise_photos'] != "null") {
      franchisePhotos = new List<FranchisePhotos>();
      json['franchise_photos'].forEach((v) {
        franchisePhotos.add(new FranchisePhotos.fromJson(v));
      });
    }
    if (json['franchise_proofs'] != "null") {
      franchiseProofs = new List<FranchiseProofs>();
      json['franchise_proofs'].forEach((v) {
        franchiseProofs.add(new FranchiseProofs.fromJson(v));
      });
    }
    franchiseGst = json['franchise_gst'];
    franchiseAddress = json['franchise_address'];
    franchisePincode = json['franchise_pincode'];
    franchiseDistrict = json['franchise_district'];
    franchiseState = json['franchise_state'];
    franchiseBankDetails = json['franchise_bank_details'];
    locationId = json['location_id'];
    franchiseStatus = json['franchise_status'];
    franchiseApproval = json['franchise_approval'];
    franchiseContract = json['franchise_contract'];
    otp = json['otp'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    updatedBy = json['updated_by'];
    createdBy = json['created_by'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    mapLocation = json['map_location'];
    stateName = json['state_name'];
    districtName = json['district_name'];
    if (json['franchise_zone'] != null) {
      franchiseZone = new List<FranchiseZone>();
      json['franchise_zone'].forEach((v) {
        franchiseZone.add(new FranchiseZone.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['franchise_id'] = this.franchiseId;
    data['franchise_code'] = this.franchiseCode;
    data['franchise_name'] = this.franchiseName;
    data['franchise_companyname'] = this.franchiseCompanyname;
    data['franchise_wallet'] = this.franchiseWallet;
    data['franchise_phone'] = this.franchisePhone;
    data['franchise_phone_alter'] = this.franchisePhoneAlter;
    data['franchise_email'] = this.franchiseEmail;
    data['franchise_password'] = this.franchisePassword;
    data['franchise_gender'] = this.franchiseGender;
    data['franchise_dob'] = this.franchiseDob;
    data['franchise_doj'] = this.franchiseDoj;
    if (this.franchisePhotos != null) {
      data['franchise_photos'] =
          this.franchisePhotos.map((v) => v.toJson()).toList();
    }
    if (this.franchiseProofs != null) {
      data['franchise_proofs'] =
          this.franchiseProofs.map((v) => v.toJson()).toList();
    }
    data['franchise_gst'] = this.franchiseGst;
    data['franchise_address'] = this.franchiseAddress;
    data['franchise_pincode'] = this.franchisePincode;
    data['franchise_district'] = this.franchiseDistrict;
    data['franchise_state'] = this.franchiseState;
    data['franchise_bank_details'] = this.franchiseBankDetails;
    data['location_id'] = this.locationId;
    data['franchise_status'] = this.franchiseStatus;
    data['franchise_approval'] = this.franchiseApproval;
    data['franchise_contract'] = this.franchiseContract;
    data['otp'] = this.otp;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['updated_by'] = this.updatedBy;
    data['created_by'] = this.createdBy;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['map_location'] = this.mapLocation;
    data['state_name'] = this.stateName;
    data['district_name'] = this.districtName;
    if (this.franchiseZone != null) {
      data['franchise_zone'] =
          this.franchiseZone.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FranchisePhotos {
  String imgId;
  String imgPath;

  FranchisePhotos({this.imgId, this.imgPath});

  FranchisePhotos.fromJson(Map<String, dynamic> json) {
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

class FranchiseZone {
  String stateId;
  String districtId;
  String pincode;
  String stateName;
  String districtName;

  FranchiseZone(
      {this.stateId,
      this.districtId,
      this.pincode,
      this.stateName,
      this.districtName});

  FranchiseZone.fromJson(Map<String, dynamic> json) {
    stateId = json['state_id'];
    districtId = json['district_id'];
    pincode = json['pincode'];
    stateName = json['state_name'];
    districtName = json['district_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['state_id'] = this.stateId;
    data['district_id'] = this.districtId;
    data['pincode'] = this.pincode;
    data['state_name'] = this.stateName;
    data['district_name'] = this.districtName;
    return data;
  }
}

class FranchiseProofs {
  String imgId;
  String imgPath;

  FranchiseProofs({this.imgId, this.imgPath});

  FranchiseProofs.fromJson(Map<String, dynamic> json) {
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
  String franchiseAccName;
  String franchiseAccNo;
  String franchiseAccBranch;
  String franchiseAccBank;
  String franchiseAccIfsc;

  AccDetails(
      {this.franchiseAccName,
      this.franchiseAccNo,
      this.franchiseAccBranch,
      this.franchiseAccBank,
      this.franchiseAccIfsc});

  AccDetails.fromJson(Map<String, dynamic> json) {
    franchiseAccName = json['franchise_acc_name'];
    franchiseAccNo = json['franchise_acc_no'];
    franchiseAccBranch = json['franchise_acc_branch'];
    franchiseAccBank = json['franchise_acc_bank'];
    franchiseAccIfsc = json['franchise_acc_ifsc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['franchise_acc_name'] = this.franchiseAccName;
    data['franchise_acc_no'] = this.franchiseAccNo;
    data['franchise_acc_branch'] = this.franchiseAccBranch;
    data['franchise_acc_bank'] = this.franchiseAccBank;
    data['franchise_acc_ifsc'] = this.franchiseAccIfsc;
    return data;
  }
}
