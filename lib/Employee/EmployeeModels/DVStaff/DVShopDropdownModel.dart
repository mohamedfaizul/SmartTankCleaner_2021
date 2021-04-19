class DVShopDropdownModel {
  bool status;
  int totalCount;
  List<Values> values;

  DVShopDropdownModel({this.status, this.totalCount, this.values});

  DVShopDropdownModel.fromJson(Map<String, dynamic> json) {
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
      this.assignby});

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
    return data;
  }
}
