class DVShopDetailModel {
  bool status;
  Values values;

  DVShopDetailModel({this.status, this.values});

  DVShopDetailModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    values =
        json['values'] != null ? new Values.fromJson(json['values']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.values != null) {
      data['values'] = this.values.toJson();
    }
    return data;
  }
}

class Values {
  String shopId;
  String shopCode;
  String shopName;
  String shopUid;
  String shopUtype;
  String shopRent;
  String shopDeposit;
  String shopOwnerName;
  String shopOwnerPhone;
  String shopAddress;
  String shopPincode;
  String shopCStartDate;
  String shopCYears;
  String shopStatus;
  String assignby;
  String stateId;
  String stateName;
  String districtId;
  String districtName;

  Values(
      {this.shopId,
      this.shopCode,
      this.shopName,
      this.shopUid,
      this.shopUtype,
      this.shopRent,
      this.shopDeposit,
      this.shopOwnerName,
      this.shopOwnerPhone,
      this.shopAddress,
      this.shopPincode,
      this.shopCStartDate,
      this.shopCYears,
      this.shopStatus,
      this.assignby,
      this.stateId,
      this.stateName,
      this.districtId,
      this.districtName});

  Values.fromJson(Map<String, dynamic> json) {
    shopId = json['shop_id'];
    shopCode = json['shop_code'];
    shopName = json['shop_name'];
    shopUid = json['shop_uid'];
    shopUtype = json['shop_utype'];
    shopRent = json['shop_rent'];
    shopDeposit = json['shop_deposit'];
    shopOwnerName = json['shop_owner_name'];
    shopOwnerPhone = json['shop_owner_phone'];
    shopAddress = json['shop_address'];
    shopPincode = json['shop_pincode'];
    shopCStartDate = json['shop_c_start_date'];
    shopCYears = json['shop_c_years'];
    shopStatus = json['shop_status'];
    assignby = json['assignby'];
    stateId = json['state_id'];
    stateName = json['state_name'];
    districtId = json['district_id'];
    districtName = json['district_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['shop_id'] = this.shopId;
    data['shop_code'] = this.shopCode;
    data['shop_name'] = this.shopName;
    data['shop_uid'] = this.shopUid;
    data['shop_utype'] = this.shopUtype;
    data['shop_rent'] = this.shopRent;
    data['shop_deposit'] = this.shopDeposit;
    data['shop_owner_name'] = this.shopOwnerName;
    data['shop_owner_phone'] = this.shopOwnerPhone;
    data['shop_address'] = this.shopAddress;
    data['shop_pincode'] = this.shopPincode;
    data['shop_c_start_date'] = this.shopCStartDate;
    data['shop_c_years'] = this.shopCYears;
    data['shop_status'] = this.shopStatus;
    data['assignby'] = this.assignby;
    data['state_id'] = this.stateId;
    data['state_name'] = this.stateName;
    data['district_id'] = this.districtId;
    data['district_name'] = this.districtName;
    return data;
  }
}
