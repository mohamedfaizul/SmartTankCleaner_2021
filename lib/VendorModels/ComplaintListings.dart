class ComplaintListings {
  int totalCount;
  List<Items> items;

  ComplaintListings({this.totalCount, this.items});

  ComplaintListings.fromJson(Map<String, dynamic> json) {
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
  String complaintId;
  String complaintCode;
  String complaintNote;
  String complaintStatus;
  String complaintImage;
  String createdAt;
  String propertyCode;
  String propertyName;
  String cusCode;
  String cusName;
  String cusPhone;

  Items(
      {this.complaintId,
      this.complaintCode,
      this.complaintNote,
      this.complaintStatus,
      this.complaintImage,
      this.createdAt,
      this.propertyCode,
      this.propertyName,
      this.cusCode,
      this.cusName,
      this.cusPhone});

  Items.fromJson(Map<String, dynamic> json) {
    complaintId = json['complaint_id'];
    complaintCode = json['complaint_code'];
    complaintNote = json['complaint_note'];
    complaintStatus = json['complaint_status'];
    complaintImage = json['complaint_image'];
    createdAt = json['created_at'];
    propertyCode = json['property_code'];
    propertyName = json['property_name'];
    cusCode = json['cus_code'];
    cusName = json['cus_name'];
    cusPhone = json['cus_phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['complaint_id'] = this.complaintId;
    data['complaint_code'] = this.complaintCode;
    data['complaint_note'] = this.complaintNote;
    data['complaint_status'] = this.complaintStatus;
    data['complaint_image'] = this.complaintImage;
    data['created_at'] = this.createdAt;
    data['property_code'] = this.propertyCode;
    data['property_name'] = this.propertyName;
    data['cus_code'] = this.cusCode;
    data['cus_name'] = this.cusName;
    data['cus_phone'] = this.cusPhone;
    return data;
  }
}
