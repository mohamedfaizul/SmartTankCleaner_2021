class EmployeeFeedBackDetailModel {
  bool status;
  Items items;

  EmployeeFeedBackDetailModel({this.status, this.items});

  EmployeeFeedBackDetailModel.fromJson(Map<String, dynamic> json) {
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
  String feedbackId;
  String serviceId;
  String cleanRating;
  String servicerRating;
  String feedbackNote;
  List<FeedbackImg> feedbackImg;
  String createdAt;
  String updatedAt;
  String propertyCode;
  String propertyName;
  String propertyValue;
  String cusCode;
  String cusName;
  String cusPhone;
  String ptypeId;
  String ptypeName;
  String groupName;
  String groupCode;
  String serviceType;

  Items(
      {this.feedbackId,
        this.serviceId,
        this.cleanRating,
        this.servicerRating,
        this.feedbackNote,
        this.feedbackImg,
        this.createdAt,
        this.updatedAt,
        this.propertyCode,
        this.propertyName,
        this.propertyValue,
        this.cusCode,
        this.cusName,
        this.cusPhone,
        this.ptypeId,
        this.ptypeName,
        this.groupName,
        this.groupCode,
        this.serviceType});

  Items.fromJson(Map<String, dynamic> json) {
    feedbackId = json['feedback_id'];
    serviceId = json['service_id'];
    cleanRating = json['clean_rating'];
    servicerRating = json['servicer_rating'];
    feedbackNote = json['feedback_note'];
    if (json['feedback_img'] != null) {
      feedbackImg = new List<FeedbackImg>();
      json['feedback_img'].forEach((v) {
        feedbackImg.add(new FeedbackImg.fromJson(v));
      });
    }
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    propertyCode = json['property_code'];
    propertyName = json['property_name'];
    propertyValue = json['property_value'];
    cusCode = json['cus_code'];
    cusName = json['cus_name'];
    cusPhone = json['cus_phone'];
    ptypeId = json['ptype_id'];
    ptypeName = json['ptype_name'];
    groupName = json['group_name'];
    groupCode = json['group_code'];
    serviceType = json['service_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['feedback_id'] = this.feedbackId;
    data['service_id'] = this.serviceId;
    data['clean_rating'] = this.cleanRating;
    data['servicer_rating'] = this.servicerRating;
    data['feedback_note'] = this.feedbackNote;
    if (this.feedbackImg != null) {
      data['feedback_img'] = this.feedbackImg.map((v) => v.toJson()).toList();
    }
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['property_code'] = this.propertyCode;
    data['property_name'] = this.propertyName;
    data['property_value'] = this.propertyValue;
    data['cus_code'] = this.cusCode;
    data['cus_name'] = this.cusName;
    data['cus_phone'] = this.cusPhone;
    data['ptype_id'] = this.ptypeId;
    data['ptype_name'] = this.ptypeName;
    data['group_name'] = this.groupName;
    data['group_code'] = this.groupCode;
    data['service_type'] = this.serviceType;
    return data;
  }
}

class FeedbackImg {
  String imgId;
  String imgPath;

  FeedbackImg({this.imgId, this.imgPath});

  FeedbackImg.fromJson(Map<String, dynamic> json) {
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