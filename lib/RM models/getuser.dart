class GetUserDetails {
  bool status;
  List<Items> items;

  GetUserDetails({this.status, this.items});

  GetUserDetails.fromJson(Map<String, dynamic> json) {
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
  String uid;
  String uname;
  String utype;

  Items({this.uid, this.uname, this.utype});

  Items.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    uname = json['uname'];
    utype = json['utype'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['uname'] = this.uname;
    data['utype'] = this.utype;
    return data;
  }
}
