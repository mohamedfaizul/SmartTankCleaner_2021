class ReferalListings {
  int totalCount;
  List<Items> items;

  ReferalListings({this.totalCount, this.items});

  ReferalListings.fromJson(Map<String, dynamic> json) {
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
  String rdId;
  String discountCode;
  String rdRefCount;
  String rdPercentage;
  String rdStatus;
  Null createdAt;
  Null createdBy;
  Null updatedAt;
  Null updatedBy;

  Items(
      {this.rdId,
        this.discountCode,
        this.rdRefCount,
        this.rdPercentage,
        this.rdStatus,
        this.createdAt,
        this.createdBy,
        this.updatedAt,
        this.updatedBy});

  Items.fromJson(Map<String, dynamic> json) {
    rdId = json['rd_id'];
    discountCode = json['discount_code'];
    rdRefCount = json['rd_ref_count'];
    rdPercentage = json['rd_percentage'];
    rdStatus = json['rd_status'];
    createdAt = json['created_at'];
    createdBy = json['created_by'];
    updatedAt = json['updated_at'];
    updatedBy = json['updated_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rd_id'] = this.rdId;
    data['discount_code'] = this.discountCode;
    data['rd_ref_count'] = this.rdRefCount;
    data['rd_percentage'] = this.rdPercentage;
    data['rd_status'] = this.rdStatus;
    data['created_at'] = this.createdAt;
    data['created_by'] = this.createdBy;
    data['updated_at'] = this.updatedAt;
    data['updated_by'] = this.updatedBy;
    return data;
  }
}