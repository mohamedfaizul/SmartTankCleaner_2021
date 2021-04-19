class DVendor360model {
  bool status;
  Data data;

  DVendor360model({this.status, this.data});

  DVendor360model.fromJson(Map<String, dynamic> json) {
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
  Dvendor dvendor;
  List<Superviser> superviser;
  List<Vendor> vendor;
  List<Franchise> franchise;
  List<Servicer> servicer;

  Data(
      {this.dvendor,
        this.superviser,
        this.vendor,
        this.franchise,
        this.servicer});

  Data.fromJson(Map<String, dynamic> json) {
    dvendor =
    json['dvendor'] != null ? new Dvendor.fromJson(json['dvendor']) : null;
    if (json['superviser'] != null) {
      superviser = new List<Superviser>();
      json['superviser'].forEach((v) {
        superviser.add(new Superviser.fromJson(v));
      });
    }
    if (json['vendor'] != null) {
      vendor = new List<Vendor>();
      json['vendor'].forEach((v) {
        vendor.add(new Vendor.fromJson(v));
      });
    }
    if (json['franchise'] != null) {
      franchise = new List<Franchise>();
      json['franchise'].forEach((v) {
        franchise.add(new Franchise.fromJson(v));
      });
    }
    if (json['servicer'] != null) {
      servicer = new List<Servicer>();
      json['servicer'].forEach((v) {
        servicer.add(new Servicer.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.dvendor != null) {
      data['dvendor'] = this.dvendor.toJson();
    }
    if (this.superviser != null) {
      data['superviser'] = this.superviser.map((v) => v.toJson()).toList();
    }
    if (this.vendor != null) {
      data['vendor'] = this.vendor.map((v) => v.toJson()).toList();
    }
    if (this.franchise != null) {
      data['franchise'] = this.franchise.map((v) => v.toJson()).toList();
    }
    if (this.servicer != null) {
      data['servicer'] = this.servicer.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Dvendor {
  String uid;
  String ucode;
  String uname;
  String uphone;
  String uroleid;

  Dvendor({this.uid, this.ucode, this.uname, this.uphone, this.uroleid});

  Dvendor.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    ucode = json['ucode'];
    uname = json['uname'];
    uphone = json['uphone'];
    uroleid = json['uroleid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['ucode'] = this.ucode;
    data['uname'] = this.uname;
    data['uphone'] = this.uphone;
    data['uroleid'] = this.uroleid;
    return data;
  }
}
class Superviser {
  String uid;
  String ucode;
  String uname;
  String uphone;
  String uroleid;

  Superviser({this.uid, this.ucode, this.uname, this.uphone, this.uroleid});

  Superviser.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    ucode = json['ucode'];
    uname = json['uname'];
    uphone = json['uphone'];
    uroleid = json['uroleid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['ucode'] = this.ucode;
    data['uname'] = this.uname;
    data['uphone'] = this.uphone;
    data['uroleid'] = this.uroleid;
    return data;
  }
}
class Vendor {
  String uid;
  String ucode;
  String uname;
  String uphone;
  String uroleid;

  Vendor({this.uid, this.ucode, this.uname, this.uphone, this.uroleid});

  Vendor.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    ucode = json['ucode'];
    uname = json['uname'];
    uphone = json['uphone'];
    uroleid = json['uroleid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['ucode'] = this.ucode;
    data['uname'] = this.uname;
    data['uphone'] = this.uphone;
    data['uroleid'] = this.uroleid;
    return data;
  }
}
class Franchise {
  String uid;
  String ucode;
  String uname;
  String uphone;
  String uroleid;

  Franchise({this.uid, this.ucode, this.uname, this.uphone, this.uroleid});

  Franchise.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    ucode = json['ucode'];
    uname = json['uname'];
    uphone = json['uphone'];
    uroleid = json['uroleid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['ucode'] = this.ucode;
    data['uname'] = this.uname;
    data['uphone'] = this.uphone;
    data['uroleid'] = this.uroleid;
    return data;
  }
}
class Servicer {
  String uid;
  String ucode;
  String uname;
  String uphone;
  String uroleid;

  Servicer({this.uid, this.ucode, this.uname, this.uphone, this.uroleid});

  Servicer.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    ucode = json['ucode'];
    uname = json['uname'];
    uphone = json['uphone'];
    uroleid = json['uroleid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['ucode'] = this.ucode;
    data['uname'] = this.uname;
    data['uphone'] = this.uphone;
    data['uroleid'] = this.uroleid;
    return data;
  }
}