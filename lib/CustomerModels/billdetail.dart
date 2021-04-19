class BillView {
  bool status;
  Data data;

  BillView({this.status, this.data});

  BillView.fromJson(Map<String, dynamic> json) {
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
  String billId;
  String billNo;
  String invNo;
  String invDatetime;
  String cusId;
  String totalItems;
  String discount;
  String billAmount;
  String billPaidAmount;
  String billRegFee;
  String refDiscountId;
  String paidStatus;
  String paymentReceived;
  String paymentType;
  String paymentRemarks;
  String paidRefNo;
  List<PaidRefImage> paidRefImage;
  String billNotes;
  String billApproval;
  String billStatus;
  String createdUtype;
  String updatedUtype;
  String createdAt;
  String createdBy;
  String updatedAt;
  String updatedBy;
  String cusCode;
  String cusName;
  String cusPhone;
  String cusEmail;
  String cusAddress;
  String cusDistrict;
  String cusState;
  String cusPincode;
  String stateId;
  String stateName;
  String districtId;
  String districtName;
  List<BillDetails> billDetails;

  Data(
      {this.billId,
        this.billNo,
        this.invNo,
        this.invDatetime,
        this.cusId,
        this.totalItems,
        this.discount,
        this.billAmount,
        this.billPaidAmount,
        this.billRegFee,
        this.refDiscountId,
        this.paidStatus,
        this.paymentReceived,
        this.paymentType,
        this.paymentRemarks,
        this.paidRefNo,
        this.paidRefImage,
        this.billNotes,
        this.billApproval,
        this.billStatus,
        this.createdUtype,
        this.updatedUtype,
        this.createdAt,
        this.createdBy,
        this.updatedAt,
        this.updatedBy,
        this.cusCode,
        this.cusName,
        this.cusPhone,
        this.cusEmail,
        this.cusAddress,
        this.cusDistrict,
        this.cusState,
        this.cusPincode,
        this.stateId,
        this.stateName,
        this.districtId,
        this.districtName,
        this.billDetails});

  Data.fromJson(Map<String, dynamic> json) {
    billId = json['bill_id'];
    billNo = json['bill_no'];
    invNo = json['inv_no'];
    invDatetime = json['inv_datetime'];
    cusId = json['cus_id'];
    totalItems = json['total_items'];
    discount = json['discount'];
    billAmount = json['bill_amount'];
    billPaidAmount = json['bill_paid_amount'];
    billRegFee = json['bill_reg_fee'];
    refDiscountId = json['ref_discount_id'];
    paidStatus = json['paid_status'];
    paymentReceived = json['payment_received'];
    paymentType = json['payment_type'];
    paymentRemarks = json['payment_remarks'];
    paidRefNo = json['paid_ref_no'];
    if (json['paid_ref_image'] != null) {
      paidRefImage = new List<PaidRefImage>();
      json['paid_ref_image'].forEach((v) {
        paidRefImage.add(new PaidRefImage.fromJson(v));
      });
    }
    billNotes = json['bill_notes'];
    billApproval = json['bill_approval'];
    billStatus = json['bill_status'];
    createdUtype = json['created_utype'];
    updatedUtype = json['updated_utype'];
    createdAt = json['created_at'];
    createdBy = json['created_by'];
    updatedAt = json['updated_at'];
    updatedBy = json['updated_by'];
    cusCode = json['cus_code'];
    cusName = json['cus_name'];
    cusPhone = json['cus_phone'];
    cusEmail = json['cus_email'];
    cusAddress = json['cus_address'];
    cusDistrict = json['cus_district'];
    cusState = json['cus_state'];
    cusPincode = json['cus_pincode'];
    stateId = json['state_id'];
    stateName = json['state_name'];
    districtId = json['district_id'];
    districtName = json['district_name'];
    if (json['bill_details'] != null) {
      billDetails = new List<BillDetails>();
      json['bill_details'].forEach((v) {
        billDetails.add(new BillDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bill_id'] = this.billId;
    data['bill_no'] = this.billNo;
    data['inv_no'] = this.invNo;
    data['inv_datetime'] = this.invDatetime;
    data['cus_id'] = this.cusId;
    data['total_items'] = this.totalItems;
    data['discount'] = this.discount;
    data['bill_amount'] = this.billAmount;
    data['bill_paid_amount'] = this.billPaidAmount;
    data['bill_reg_fee'] = this.billRegFee;
    data['ref_discount_id'] = this.refDiscountId;
    data['paid_status'] = this.paidStatus;
    data['payment_received'] = this.paymentReceived;
    data['payment_type'] = this.paymentType;
    data['payment_remarks'] = this.paymentRemarks;
    data['paid_ref_no'] = this.paidRefNo;
    if (this.paidRefImage != null) {
      data['paid_ref_image'] =
          this.paidRefImage.map((v) => v.toJson()).toList();
    }
    data['bill_notes'] = this.billNotes;
    data['bill_approval'] = this.billApproval;
    data['bill_status'] = this.billStatus;
    data['created_utype'] = this.createdUtype;
    data['updated_utype'] = this.updatedUtype;
    data['created_at'] = this.createdAt;
    data['created_by'] = this.createdBy;
    data['updated_at'] = this.updatedAt;
    data['updated_by'] = this.updatedBy;
    data['cus_code'] = this.cusCode;
    data['cus_name'] = this.cusName;
    data['cus_phone'] = this.cusPhone;
    data['cus_email'] = this.cusEmail;
    data['cus_address'] = this.cusAddress;
    data['cus_district'] = this.cusDistrict;
    data['cus_state'] = this.cusState;
    data['cus_pincode'] = this.cusPincode;
    data['state_id'] = this.stateId;
    data['state_name'] = this.stateName;
    data['district_id'] = this.districtId;
    data['district_name'] = this.districtName;
    if (this.billDetails != null) {
      data['bill_details'] = this.billDetails.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PaidRefImage {
  String imgId;
  String imgPath;

  PaidRefImage({this.imgId, this.imgPath});

  PaidRefImage.fromJson(Map<String, dynamic> json) {
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

class BillDetails {
  String billDetailsId;
  String billId;
  String planId;
  String pplanId;
  String propertyId;
  String pplanName;
  String pplanYear;
  String pplanService;
  String pplanPrice;
  String pplanStartDate;
  String billDetailsStatus;
  String pplanCurrentStatus;

  BillDetails(
      {this.billDetailsId,
        this.billId,
        this.planId,
        this.pplanId,
        this.propertyId,
        this.pplanName,
        this.pplanYear,
        this.pplanService,
        this.pplanPrice,
        this.pplanStartDate,
        this.billDetailsStatus,
        this.pplanCurrentStatus});

  BillDetails.fromJson(Map<String, dynamic> json) {
    billDetailsId = json['bill_details_id'];
    billId = json['bill_id'];
    planId = json['plan_id'];
    pplanId = json['pplan_id'];
    propertyId = json['property_id'];
    pplanName = json['pplan_name'];
    pplanYear = json['pplan_year'];
    pplanService = json['pplan_service'];
    pplanPrice = json['pplan_price'];
    pplanStartDate = json['pplan_start_date'];
    billDetailsStatus = json['bill_details_status'];
    pplanCurrentStatus = json['pplan_current_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bill_details_id'] = this.billDetailsId;
    data['bill_id'] = this.billId;
    data['plan_id'] = this.planId;
    data['pplan_id'] = this.pplanId;
    data['property_id'] = this.propertyId;
    data['pplan_name'] = this.pplanName;
    data['pplan_year'] = this.pplanYear;
    data['pplan_service'] = this.pplanService;
    data['pplan_price'] = this.pplanPrice;
    data['pplan_start_date'] = this.pplanStartDate;
    data['bill_details_status'] = this.billDetailsStatus;
    data['pplan_current_status'] = this.pplanCurrentStatus;
    return data;
  }
}