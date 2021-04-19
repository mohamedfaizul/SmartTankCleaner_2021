class WalletTotalAmount {
  bool status;
  Data data;

  WalletTotalAmount({this.status, this.data});

  WalletTotalAmount.fromJson(Map<String, dynamic> json) {
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
  String currentAmnt;

  Data({this.currentAmnt});

  Data.fromJson(Map<String, dynamic> json) {
    currentAmnt = json['current_amnt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_amnt'] = this.currentAmnt;
    return data;
  }
}
