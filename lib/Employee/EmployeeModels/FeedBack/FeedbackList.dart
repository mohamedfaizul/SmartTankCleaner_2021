class FeedBackListModel {
  int totalCount;
  List<Items> items;

  FeedBackListModel({this.totalCount, this.items});

  FeedBackListModel.fromJson(Map<String, dynamic> json) {
    totalCount = json['total_count'];
    if (json['items'] != null) {
      items = new List<Items>();
      json['items'].forEach((v) {
        items.add(new Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_count'] = this.totalCount;
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
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
  String createdAt;
  String updatedAt;
  String pserviceCode;
  String propertyCode;
  String propertyName;
  String cusCode;
  String cusName;
  String cusPhone;

  Items(
      {this.feedbackId,
      this.serviceId,
      this.cleanRating,
      this.servicerRating,
      this.feedbackNote,
      this.createdAt,
      this.updatedAt,
      this.pserviceCode,
      this.propertyCode,
      this.propertyName,
      this.cusCode,
      this.cusName,
      this.cusPhone});

  Items.fromJson(Map<String, dynamic> json) {
    feedbackId = json['feedback_id'];
    serviceId = json['service_id'];
    cleanRating = json['clean_rating'];
    servicerRating = json['servicer_rating'];
    feedbackNote = json['feedback_note'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    pserviceCode = json['pservice_code'];
    propertyCode = json['property_code'];
    propertyName = json['property_name'];
    cusCode = json['cus_code'];
    cusName = json['cus_name'];
    cusPhone = json['cus_phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['feedback_id'] = this.feedbackId;
    data['service_id'] = this.serviceId;
    data['clean_rating'] = this.cleanRating;
    data['servicer_rating'] = this.servicerRating;
    data['feedback_note'] = this.feedbackNote;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['pservice_code'] = this.pserviceCode;
    data['property_code'] = this.propertyCode;
    data['property_name'] = this.propertyName;
    data['cus_code'] = this.cusCode;
    data['cus_name'] = this.cusName;
    data['cus_phone'] = this.cusPhone;
    return data;
  }
}
