class AGM360Model {
  bool status;
  Data data;

  AGM360Model({this.status, this.data});

  AGM360Model.fromJson(Map<String, dynamic> json) {
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
  Agm agm;
  List<Rm> rm;
  List<Dvendor> dvendor;
  List<Superviser> superviser;
  List<Vendor> vendor;
  List<Franchise> franchise;
  List<Servicer> servicer;

  Data(
      {this.agm,
        this.rm,
        this.dvendor,
        this.superviser,
        this.vendor,
        this.franchise,
        this.servicer});

  Data.fromJson(Map<String, dynamic> json) {
    agm = json['agm'] != null ? new Agm.fromJson(json['agm']) : null;
    if (json['rm'] != null) {
      rm = new List<Rm>();
      json['rm'].forEach((v) {
        rm.add(new Rm.fromJson(v));
      });
    }
    if (json['dvendor'] != null) {
      dvendor = new List<Dvendor>();
      json['dvendor'].forEach((v) {
        dvendor.add(new Dvendor.fromJson(v));
      });
    }
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
    if (this.agm != null) {
      data['agm'] = this.agm.toJson();
    }
    if (this.rm != null) {
      data['rm'] = this.rm.map((v) => v.toJson()).toList();
    }
    if (this.dvendor != null) {
      data['dvendor'] = this.dvendor.map((v) => v.toJson()).toList();
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

class Agm {
  String uid;
  String ucode;
  String uname;
  String uphone;
  String uroleid;

  Agm({this.uid, this.ucode, this.uname, this.uphone, this.uroleid});

  Agm.fromJson(Map<String, dynamic> json) {
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
class Rm {
  String uid;
  String ucode;
  String uname;
  String uphone;
  String uroleid;
  String roleName;

  Rm(
      {this.uid,
        this.ucode,
        this.uname,
        this.uphone,
        this.uroleid,
        this.roleName});

  Rm.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    ucode = json['ucode'];
    uname = json['uname'];
    uphone = json['uphone'];
    uroleid = json['uroleid'];
    roleName = json['role_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['ucode'] = this.ucode;
    data['uname'] = this.uname;
    data['uphone'] = this.uphone;
    data['uroleid'] = this.uroleid;
    data['role_name'] = this.roleName;
    return data;
  }
}
class Dvendor {
  String uid;
  String ucode;
  String uname;
  String uphone;
  String uroleid;
  String roleName;

  Dvendor(
      {this.uid,
        this.ucode,
        this.uname,
        this.uphone,
        this.uroleid,
        this.roleName});

  Dvendor.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    ucode = json['ucode'];
    uname = json['uname'];
    uphone = json['uphone'];
    uroleid = json['uroleid'];
    roleName = json['role_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['ucode'] = this.ucode;
    data['uname'] = this.uname;
    data['uphone'] = this.uphone;
    data['uroleid'] = this.uroleid;
    data['role_name'] = this.roleName;
    return data;
  }
}
class Superviser {
  String uid;
  String ucode;
  String uname;
  String uphone;
  String uroleid;
  String roleName;

  Superviser(
      {this.uid,
        this.ucode,
        this.uname,
        this.uphone,
        this.uroleid,
        this.roleName});

  Superviser.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    ucode = json['ucode'];
    uname = json['uname'];
    uphone = json['uphone'];
    uroleid = json['uroleid'];
    roleName = json['role_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['ucode'] = this.ucode;
    data['uname'] = this.uname;
    data['uphone'] = this.uphone;
    data['uroleid'] = this.uroleid;
    data['role_name'] = this.roleName;
    return data;
  }
}
class Vendor {
  String uid;
  String ucode;
  String uname;
  String uphone;
  String uroleid;
  String roleName;

  Vendor(
      {this.uid,
        this.ucode,
        this.uname,
        this.uphone,
        this.uroleid,
        this.roleName});

  Vendor.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    ucode = json['ucode'];
    uname = json['uname'];
    uphone = json['uphone'];
    uroleid = json['uroleid'];
    roleName = json['role_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['ucode'] = this.ucode;
    data['uname'] = this.uname;
    data['uphone'] = this.uphone;
    data['uroleid'] = this.uroleid;
    data['role_name'] = this.roleName;
    return data;
  }
}
class Franchise {
  String uid;
  String ucode;
  String uname;
  String uphone;
  String uroleid;
  String roleName;

  Franchise(
      {this.uid,
        this.ucode,
        this.uname,
        this.uphone,
        this.uroleid,
        this.roleName});

  Franchise.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    ucode = json['ucode'];
    uname = json['uname'];
    uphone = json['uphone'];
    uroleid = json['uroleid'];
    roleName = json['role_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['ucode'] = this.ucode;
    data['uname'] = this.uname;
    data['uphone'] = this.uphone;
    data['uroleid'] = this.uroleid;
    data['role_name'] = this.roleName;
    return data;
  }
}
class Servicer {
  String uid;
  String ucode;
  String uname;
  String uphone;
  String uroleid;
  String roleName;

  Servicer(
      {this.uid,
        this.ucode,
        this.uname,
        this.uphone,
        this.uroleid,
        this.roleName});

  Servicer.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    ucode = json['ucode'];
    uname = json['uname'];
    uphone = json['uphone'];
    uroleid = json['uroleid'];
    roleName = json['role_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['ucode'] = this.ucode;
    data['uname'] = this.uname;
    data['uphone'] = this.uphone;
    data['uroleid'] = this.uroleid;
    data['role_name'] = this.roleName;
    return data;
  }
}