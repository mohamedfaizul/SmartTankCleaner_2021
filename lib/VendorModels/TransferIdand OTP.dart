class SPTranferandOTP {
  bool status;
  List<String> messages;
  String alert;
  int otp;
  int spTransferId;

  SPTranferandOTP(
      {this.status, this.messages, this.alert, this.otp, this.spTransferId});

  SPTranferandOTP.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    messages = json['messages'].cast<String>();
    alert = json['alert'];
    otp = json['otp'];
    spTransferId = json['sp_transfer_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['messages'] = this.messages;
    data['alert'] = this.alert;
    data['otp'] = this.otp;
    data['sp_transfer_id'] = this.spTransferId;
    return data;
  }
}
