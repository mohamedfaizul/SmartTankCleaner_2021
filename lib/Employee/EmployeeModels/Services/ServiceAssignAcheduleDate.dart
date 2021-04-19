class ScheduleDate {
  bool status;
  List<String> messages;
  String alert;
  List<Items> items;

  ScheduleDate({this.status, this.messages, this.alert, this.items});

  ScheduleDate.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    messages = json['messages'].cast<String>();
    alert = json['alert'];
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
    data['messages'] = this.messages;
    data['alert'] = this.alert;
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  String pserviceCode;
  String pserviceId;
  String pserviceDate;
  String pserviceServiceStatus;
  Null pserviceAsignStartAt;
  Null pserviceAsignEndAt;

  Items(
      {this.pserviceCode,
        this.pserviceId,
        this.pserviceDate,
        this.pserviceServiceStatus,
        this.pserviceAsignStartAt,
        this.pserviceAsignEndAt});

  Items.fromJson(Map<String, dynamic> json) {
    pserviceCode = json['pservice_code'];
    pserviceId = json['pservice_id'];
    pserviceDate = json['pservice_date'];
    pserviceServiceStatus = json['pservice_service_status'];
    pserviceAsignStartAt = json['pservice_asign_start_at'];
    pserviceAsignEndAt = json['pservice_asign_end_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pservice_code'] = this.pserviceCode;
    data['pservice_id'] = this.pserviceId;
    data['pservice_date'] = this.pserviceDate;
    data['pservice_service_status'] = this.pserviceServiceStatus;
    data['pservice_asign_start_at'] = this.pserviceAsignStartAt;
    data['pservice_asign_end_at'] = this.pserviceAsignEndAt;
    return data;
  }
}