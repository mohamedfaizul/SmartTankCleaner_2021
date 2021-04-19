class DamageListings {
  int totalCount;
  List<Items> items;

  DamageListings({this.totalCount, this.items});

  DamageListings.fromJson(Map<String, dynamic> json) {
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
  String damageId;
  String damageCode;
  String damageNote;
  String damageStatus;
  String damageImage;
  String createdAt;
  String propertyCode;
  String propertyName;
  String cusCode;
  String cusName;
  String cusPhone;

  Items(
      {this.damageId,
      this.damageCode,
      this.damageNote,
      this.damageStatus,
      this.damageImage,
      this.createdAt,
      this.propertyCode,
      this.propertyName,
      this.cusCode,
      this.cusName,
      this.cusPhone});

  Items.fromJson(Map<String, dynamic> json) {
    damageId = json['damage_id'];
    damageCode = json['damage_code'];
    damageNote = json['damage_note'];
    damageStatus = json['damage_status'];
    damageImage = json['damage_image'];
    createdAt = json['created_at'];
    propertyCode = json['property_code'];
    propertyName = json['property_name'];
    cusCode = json['cus_code'];
    cusName = json['cus_name'];
    cusPhone = json['cus_phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['damage_id'] = this.damageId;
    data['damage_code'] = this.damageCode;
    data['damage_note'] = this.damageNote;
    data['damage_status'] = this.damageStatus;
    data['damage_image'] = this.damageImage;
    data['created_at'] = this.createdAt;
    data['property_code'] = this.propertyCode;
    data['property_name'] = this.propertyName;
    data['cus_code'] = this.cusCode;
    data['cus_name'] = this.cusName;
    data['cus_phone'] = this.cusPhone;
    return data;
  }
}
