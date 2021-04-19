class DVStaffDetailModel {
  bool status;
  Items items;

  DVStaffDetailModel({this.status, this.items});

  DVStaffDetailModel.fromJson(Map<String, dynamic> json) {
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
  String dstaffId;
  String dvendorId;
  String dstaffCode;
  String dstaffName;
  String dstaffPhone;
  String dstaffPhoneAlter;
  String dstaffEmail;
  String dstaffPassword;
  String dstaffGender;
  String dstaffDob;
  String dstaffDoj;
  List<DstaffPhotos> dstaffPhotos;
  List<DstaffProofs> dstaffProofs;
  String dstaffAddress;
  String dstaffPincode;
  String dstaffDistrict;
  String dstaffState;
  String dstaffBankDetails;
  String dstaffShop;
  String dstaffStatus;
  String dstaffApproval;
  String createdUtype;
  String updatedUtype;
  String createdAt;
  String updatedAt;
  String updatedBy;
  String createdBy;
  String dvendorCode;
  String dvendorCompanyname;
  String stateName;
  String districtName;
  String shopId;
  String shopName;
  String shopCode;

  Items(
      {this.dstaffId,
      this.dvendorId,
      this.dstaffCode,
      this.dstaffName,
      this.dstaffPhone,
      this.dstaffPhoneAlter,
      this.dstaffEmail,
      this.dstaffPassword,
      this.dstaffGender,
      this.dstaffDob,
      this.dstaffDoj,
      this.dstaffPhotos,
      this.dstaffProofs,
      this.dstaffAddress,
      this.dstaffPincode,
      this.dstaffDistrict,
      this.dstaffState,
      this.dstaffBankDetails,
      this.dstaffShop,
      this.dstaffStatus,
      this.dstaffApproval,
      this.createdUtype,
      this.updatedUtype,
      this.createdAt,
      this.updatedAt,
      this.updatedBy,
      this.createdBy,
      this.dvendorCode,
      this.dvendorCompanyname,
      this.stateName,
      this.districtName,
      this.shopId,
      this.shopName,
      this.shopCode});

  Items.fromJson(Map<String, dynamic> json) {
    dstaffId = json['dstaff_id'];
    dvendorId = json['dvendor_id'];
    dstaffCode = json['dstaff_code'];
    dstaffName = json['dstaff_name'];
    dstaffPhone = json['dstaff_phone'];
    dstaffPhoneAlter = json['dstaff_phone_alter'];
    dstaffEmail = json['dstaff_email'];
    dstaffPassword = json['dstaff_password'];
    dstaffGender = json['dstaff_gender'];
    dstaffDob = json['dstaff_dob'];
    dstaffDoj = json['dstaff_doj'];
    if (json['dstaff_photos'] != null) {
      dstaffPhotos = new List<DstaffPhotos>();
      json['dstaff_photos'].forEach((v) {
        dstaffPhotos.add(new DstaffPhotos.fromJson(v));
      });
    }
    if (json['dstaff_proofs'] != null) {
      dstaffProofs = new List<DstaffProofs>();
      json['dstaff_proofs'].forEach((v) {
        dstaffProofs.add(new DstaffProofs.fromJson(v));
      });
    }
    dstaffAddress = json['dstaff_address'];
    dstaffPincode = json['dstaff_pincode'];
    dstaffDistrict = json['dstaff_district'];
    dstaffState = json['dstaff_state'];
    dstaffBankDetails = json['dstaff_bank_details'];
    dstaffShop = json['dstaff_shop'];
    dstaffStatus = json['dstaff_status'];
    dstaffApproval = json['dstaff_approval'];
    createdUtype = json['created_utype'];
    updatedUtype = json['updated_utype'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    updatedBy = json['updated_by'];
    createdBy = json['created_by'];
    dvendorCode = json['dvendor_code'];
    dvendorCompanyname = json['dvendor_companyname'];
    stateName = json['state_name'];
    districtName = json['district_name'];
    shopId = json['shop_id'];
    shopName = json['shop_name'];
    shopCode = json['shop_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dstaff_id'] = this.dstaffId;
    data['dvendor_id'] = this.dvendorId;
    data['dstaff_code'] = this.dstaffCode;
    data['dstaff_name'] = this.dstaffName;
    data['dstaff_phone'] = this.dstaffPhone;
    data['dstaff_phone_alter'] = this.dstaffPhoneAlter;
    data['dstaff_email'] = this.dstaffEmail;
    data['dstaff_password'] = this.dstaffPassword;
    data['dstaff_gender'] = this.dstaffGender;
    data['dstaff_dob'] = this.dstaffDob;
    data['dstaff_doj'] = this.dstaffDoj;
    if (this.dstaffPhotos != null) {
      data['dstaff_photos'] = this.dstaffPhotos.map((v) => v.toJson()).toList();
    }
    if (this.dstaffProofs != null) {
      data['dstaff_proofs'] = this.dstaffProofs.map((v) => v.toJson()).toList();
    }
    data['dstaff_address'] = this.dstaffAddress;
    data['dstaff_pincode'] = this.dstaffPincode;
    data['dstaff_district'] = this.dstaffDistrict;
    data['dstaff_state'] = this.dstaffState;
    data['dstaff_bank_details'] = this.dstaffBankDetails;
    data['dstaff_shop'] = this.dstaffShop;
    data['dstaff_status'] = this.dstaffStatus;
    data['dstaff_approval'] = this.dstaffApproval;
    data['created_utype'] = this.createdUtype;
    data['updated_utype'] = this.updatedUtype;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['updated_by'] = this.updatedBy;
    data['created_by'] = this.createdBy;
    data['dvendor_code'] = this.dvendorCode;
    data['dvendor_companyname'] = this.dvendorCompanyname;
    data['state_name'] = this.stateName;
    data['district_name'] = this.districtName;
    data['shop_id'] = this.shopId;
    data['shop_name'] = this.shopName;
    data['shop_code'] = this.shopCode;
    return data;
  }
}

class DstaffPhotos {
  String imgId;
  String imgPath;

  DstaffPhotos({this.imgId, this.imgPath});

  DstaffPhotos.fromJson(Map<String, dynamic> json) {
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

class DstaffProofs {
  String imgId;
  String imgPath;

  DstaffProofs({this.imgId, this.imgPath});

  DstaffProofs.fromJson(Map<String, dynamic> json) {
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

class DAccDetails {
  String dstaffAccName;
  String dstaffAccNo;
  String dstaffAccBranch;
  String dstaffAccBank;
  String dstaffAccIfsc;

  DAccDetails(
      {this.dstaffAccName,
      this.dstaffAccNo,
      this.dstaffAccBranch,
      this.dstaffAccBank,
      this.dstaffAccIfsc});

  DAccDetails.fromJson(Map<String, dynamic> json) {
    dstaffAccName = json['dstaff_acc_name'];
    dstaffAccNo = json['dstaff_acc_no'];
    dstaffAccBranch = json['dstaff_acc_branch'];
    dstaffAccBank = json['dstaff_acc_bank'];
    dstaffAccIfsc = json['dstaff_acc_ifsc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['staff_acc_name'] = this.dstaffAccName;
    data['staff_acc_no'] = this.dstaffAccNo;
    data['staff_acc_branch'] = this.dstaffAccBranch;
    data['staff_acc_bank'] = this.dstaffAccBank;
    data['staff_acc_ifsc'] = this.dstaffAccIfsc;
    return data;
  }
}
