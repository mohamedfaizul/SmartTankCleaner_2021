class VendorStaffSearch {
  bool status;
  List<Items> items;

  VendorStaffSearch({this.status, this.items});

  VendorStaffSearch.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['items'] != null) {
      items = new List<Items>();
      json['items'].forEach((v) {
        items.add(new Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  String staffId;
  String staffCode;
  String staffName;
  String vendorId;

  Items({this.staffId, this.staffCode, this.staffName, this.vendorId});

  Items.fromJson(Map<String, dynamic> json) {
    staffId = json['staff_id'];
    staffCode = json['staff_code'];
    staffName = json['staff_name'];
    vendorId = json['vendor_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['staff_id'] = this.staffId;
    data['staff_code'] = this.staffCode;
    data['staff_name'] = this.staffName;
    data['vendor_id'] = this.vendorId;
    return data;
  }
}
