class EmployeeExpenseDropdownModel {
  bool status;
  List<Items> items;

  EmployeeExpenseDropdownModel({this.status, this.items});

  EmployeeExpenseDropdownModel.fromJson(Map<String, dynamic> json) {
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
  String etypeId;
  String etypeName;

  Items({this.etypeId, this.etypeName});

  Items.fromJson(Map<String, dynamic> json) {
    etypeId = json['etype_id'];
    etypeName = json['etype_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['etype_id'] = this.etypeId;
    data['etype_name'] = this.etypeName;
    return data;
  }
}
