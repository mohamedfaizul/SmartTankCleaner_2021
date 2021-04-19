class LoginRes {
  bool status;
  List<String> messages;
  String alert;
  String uid;
  String utype;

  //String uroleId;
  String uroleName;
  String token;

  LoginRes(
      {this.status,
      this.messages,
      this.alert,
      this.uid,
      this.utype,
      //   this.uroleId,
      this.uroleName,
      this.token});

  LoginRes.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    messages = json['messages'].cast<String>();
    alert = json['alert'];
    uid = json['uid'];
    utype = json['utype'];
    // uroleId = json['urole_id'];
    uroleName = json['urole_name'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['messages'] = this.messages;
    data['alert'] = this.alert;
    data['uid'] = this.uid;
    data['utype'] = this.utype;
    // data['urole_id'] = this.uroleId;
    data['urole_name'] = this.uroleName;
    data['token'] = this.token;
    return data;
  }
}
