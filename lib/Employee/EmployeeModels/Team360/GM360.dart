class GM360model {
  bool status;
  Data data;

  GM360model({this.status, this.data});

  GM360model.fromJson(Map<String, dynamic> json) {
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
  Gm gm;
  AdminTeam adminTeam;
  List<Agm> agm;
  List<Rm> rm;
  List<Dvendor> dvendor;
  List<Superviser> superviser;
  List<Vendor> vendor;
  List<Franchise> franchise;
  List<Servicer> servicer;

  Data(
      {this.gm,
        this.adminTeam,
        this.agm,
        this.rm,
        this.dvendor,
        this.superviser,
        this.vendor,
        this.franchise,
        this.servicer});

  Data.fromJson(Map<String, dynamic> json) {
    gm = json['gm'] != null ? new Gm.fromJson(json['gm']) : null;
    adminTeam = json['admin_team'] != null
        ? new AdminTeam.fromJson(json['admin_team'])
        : null;
    if (json['agm'] != null) {
      agm = new List<Agm>();
      json['agm'].forEach((v) {
        agm.add(new Agm.fromJson(v));
      });
    }
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
    if (this.gm != null) {
      data['gm'] = this.gm.toJson();
    }
    if (this.adminTeam != null) {
      data['admin_team'] = this.adminTeam.toJson();
    }
    if (this.agm != null) {
      data['agm'] = this.agm.map((v) => v.toJson()).toList();
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

class Gm {
  String uid;
  String ucode;
  String uname;
  String uphone;
  String uroleid;

  Gm({this.uid, this.ucode, this.uname, this.uphone, this.uroleid});

  Gm.fromJson(Map<String, dynamic> json) {
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

class AdminTeam {
  List<TELECALLER> tELECALLER;
  List<ADMIN> aDMIN;
  List<TECHNICIANTEAM> tECHNICIANTEAM;
  List<FINANCETEAM> fINANCETEAM;

  AdminTeam(
      {this.tELECALLER, this.aDMIN, this.tECHNICIANTEAM, this.fINANCETEAM});

  AdminTeam.fromJson(Map<String, dynamic> json) {
    if (json['TELECALLER'] != null) {
      tELECALLER = new List<TELECALLER>();
      json['TELECALLER'].forEach((v) {
        tELECALLER.add(new TELECALLER.fromJson(v));
      });
    }
    if (json['ADMIN'] != null) {
      aDMIN = new List<ADMIN>();
      json['ADMIN'].forEach((v) {
        aDMIN.add(new ADMIN.fromJson(v));
      });
    }
    if (json['TECHNICIANTEAM'] != null) {
      tECHNICIANTEAM = new List<TECHNICIANTEAM>();
      json['TECHNICIANTEAM'].forEach((v) {
        tECHNICIANTEAM.add(new TECHNICIANTEAM.fromJson(v));
      });
    }
    if (json['FINANCETEAM'] != null) {
      fINANCETEAM = new List<FINANCETEAM>();
      json['FINANCETEAM'].forEach((v) {
        fINANCETEAM.add(new FINANCETEAM.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.tELECALLER != null) {
      data['TELECALLER'] = this.tELECALLER.map((v) => v.toJson()).toList();
    }
    if (this.aDMIN != null) {
      data['ADMIN'] = this.aDMIN.map((v) => v.toJson()).toList();
    }
    if (this.tECHNICIANTEAM != null) {
      data['TECHNICIANTEAM'] =
          this.tECHNICIANTEAM.map((v) => v.toJson()).toList();
    }
    if (this.fINANCETEAM != null) {
      data['FINANCETEAM'] = this.fINANCETEAM.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TELECALLER {
  String uid;
  String ucode;
  String uname;
  String uphone;
  String uroleid;
  String roleName;

  TELECALLER(
      {this.uid,
        this.ucode,
        this.uname,
        this.uphone,
        this.uroleid,
        this.roleName});

  TELECALLER.fromJson(Map<String, dynamic> json) {
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
class TECHNICIANTEAM {
  String uid;
  String ucode;
  String uname;
  String uphone;
  String uroleid;
  String roleName;

  TECHNICIANTEAM(
      {this.uid,
        this.ucode,
        this.uname,
        this.uphone,
        this.uroleid,
        this.roleName});

  TECHNICIANTEAM.fromJson(Map<String, dynamic> json) {
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
class FINANCETEAM {
  String uid;
  String ucode;
  String uname;
  String uphone;
  String uroleid;
  String roleName;

  FINANCETEAM(
      {this.uid,
        this.ucode,
        this.uname,
        this.uphone,
        this.uroleid,
        this.roleName});

  FINANCETEAM.fromJson(Map<String, dynamic> json) {
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
class ADMIN {
  String uid;
  String ucode;
  String uname;
  String uphone;
  String uroleid;
  String roleName;

  ADMIN(
      {this.uid,
        this.ucode,
        this.uname,
        this.uphone,
        this.uroleid,
        this.roleName});

  ADMIN.fromJson(Map<String, dynamic> json) {
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

class Agm {
  String uid;
  String ucode;
  String uname;
  String uphone;
  String uroleid;
  String roleName;

  Agm(
      {this.uid,
        this.ucode,
        this.uname,
        this.uphone,
        this.uroleid,
        this.roleName});

  Agm.fromJson(Map<String, dynamic> json) {
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