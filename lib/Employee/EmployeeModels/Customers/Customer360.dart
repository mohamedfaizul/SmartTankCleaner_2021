class Customer360Model {
  bool status;
  Data data;

  Customer360Model({this.status, this.data});

  Customer360Model.fromJson(Map<String, dynamic> json) {
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
  String cusId;
  String cusCode;
  String cusName;
  String cusPhone;
  String cusAddress;
  String cusPincode;
  String stateName;
  String districtName;
  Service service;
  List<Complaint> complaint;
  List<Damage> damage;
  List<Feedback> feedback;

  Data(
      {this.cusId,
        this.cusCode,
        this.cusName,
        this.cusPhone,
        this.cusAddress,
        this.cusPincode,
        this.stateName,
        this.districtName,
        this.service,
        this.complaint,
        this.damage,
        this.feedback});

  Data.fromJson(Map<String, dynamic> json) {
    cusId = json['cus_id'];
    cusCode = json['cus_code'];
    cusName = json['cus_name'];
    cusPhone = json['cus_phone'];
    cusAddress = json['cus_address'];
    cusPincode = json['cus_pincode'];
    stateName = json['state_name'];
    districtName = json['district_name'];
    service =
    json['service'] != null ? new Service.fromJson(json['service']) : null;
    if (json['complaint'] != null) {
      complaint = new List<Complaint>();
      json['complaint'].forEach((v) {
        complaint.add(new Complaint.fromJson(v));
      });
    }
    if (json['damage'] != null) {
      damage = new List<Damage>();
      json['damage'].forEach((v) {
        damage.add(new Damage.fromJson(v));
      });
    }
    if (json['feedback'] != null) {
      feedback = new List<Feedback>();
      json['feedback'].forEach((v) {
        feedback.add(new Feedback.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cus_id'] = this.cusId;
    data['cus_code'] = this.cusCode;
    data['cus_name'] = this.cusName;
    data['cus_phone'] = this.cusPhone;
    data['cus_address'] = this.cusAddress;
    data['cus_pincode'] = this.cusPincode;
    data['state_name'] = this.stateName;
    data['district_name'] = this.districtName;
    if (this.service != null) {
      data['service'] = this.service.toJson();
    }
    if (this.complaint != null) {
      data['complaint'] = this.complaint.map((v) => v.toJson()).toList();
    }
    if (this.damage != null) {
      data['damage'] = this.damage.map((v) => v.toJson()).toList();
    }
    if (this.feedback != null) {
      data['feedback'] = this.feedback.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Service {
  List<PENDING> pENDING;
  List<COMPLETED> cOMPLETED;
  List<RESERVICE> rESERVICE;
  List<ONGOING> oNGOING;

  Service({this.pENDING, this.cOMPLETED, this.rESERVICE, this.oNGOING});

  Service.fromJson(Map<String, dynamic> json) {
    if (json['PENDING'] != null) {
      pENDING = new List<PENDING>();
      json['PENDING'].forEach((v) {
        pENDING.add(new PENDING.fromJson(v));
      });
    }
    if (json['COMPLETED'] != null) {
      cOMPLETED = new List<COMPLETED>();
      json['COMPLETED'].forEach((v) {
        cOMPLETED.add(new COMPLETED.fromJson(v));
      });
    }
    if (json['RESERVICE'] != null) {
      rESERVICE = new List<RESERVICE>();
      json['RESERVICE'].forEach((v) {
        rESERVICE.add(new RESERVICE.fromJson(v));
      });
    }
    if (json['ONGOING'] != null) {
      oNGOING = new List<ONGOING>();
      json['ONGOING'].forEach((v) {
        oNGOING.add(new ONGOING.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.pENDING != null) {
      data['PENDING'] = this.pENDING.map((v) => v.toJson()).toList();
    }
    if (this.cOMPLETED != null) {
      data['COMPLETED'] = this.cOMPLETED.map((v) => v.toJson()).toList();
    }
    if (this.rESERVICE != null) {
      data['RESERVICE'] = this.rESERVICE.map((v) => v.toJson()).toList();
    }
    if (this.oNGOING != null) {
      data['ONGOING'] = this.oNGOING.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PENDING {
  String pserviceId;
  String pserviceCode;
  String pserviceDate;
  String pserviceServiceStatus;
  String propertyCode;
  String propertyName;

  PENDING(
      {this.pserviceId,
        this.pserviceCode,
        this.pserviceDate,
        this.pserviceServiceStatus,
        this.propertyCode,
        this.propertyName});

  PENDING.fromJson(Map<String, dynamic> json) {
    pserviceId = json['pservice_id'];
    pserviceCode = json['pservice_code'];
    pserviceDate = json['pservice_date'];
    pserviceServiceStatus = json['pservice_service_status'];
    propertyCode = json['property_code'];
    propertyName = json['property_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pservice_id'] = this.pserviceId;
    data['pservice_code'] = this.pserviceCode;
    data['pservice_date'] = this.pserviceDate;
    data['pservice_service_status'] = this.pserviceServiceStatus;
    data['property_code'] = this.propertyCode;
    data['property_name'] = this.propertyName;
    return data;
  }
}
class COMPLETED {
  String pserviceId;
  String pserviceCode;
  String pserviceDate;
  String pserviceServiceStatus;
  String propertyCode;
  String propertyName;

  COMPLETED(
      {this.pserviceId,
        this.pserviceCode,
        this.pserviceDate,
        this.pserviceServiceStatus,
        this.propertyCode,
        this.propertyName});

  COMPLETED.fromJson(Map<String, dynamic> json) {
    pserviceId = json['pservice_id'];
    pserviceCode = json['pservice_code'];
    pserviceDate = json['pservice_date'];
    pserviceServiceStatus = json['pservice_service_status'];
    propertyCode = json['property_code'];
    propertyName = json['property_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pservice_id'] = this.pserviceId;
    data['pservice_code'] = this.pserviceCode;
    data['pservice_date'] = this.pserviceDate;
    data['pservice_service_status'] = this.pserviceServiceStatus;
    data['property_code'] = this.propertyCode;
    data['property_name'] = this.propertyName;
    return data;
  }
}
class RESERVICE {
  String pserviceId;
  String pserviceCode;
  String pserviceDate;
  String pserviceServiceStatus;
  String propertyCode;
  String propertyName;

  RESERVICE(
      {this.pserviceId,
        this.pserviceCode,
        this.pserviceDate,
        this.pserviceServiceStatus,
        this.propertyCode,
        this.propertyName});

  RESERVICE.fromJson(Map<String, dynamic> json) {
    pserviceId = json['pservice_id'];
    pserviceCode = json['pservice_code'];
    pserviceDate = json['pservice_date'];
    pserviceServiceStatus = json['pservice_service_status'];
    propertyCode = json['property_code'];
    propertyName = json['property_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pservice_id'] = this.pserviceId;
    data['pservice_code'] = this.pserviceCode;
    data['pservice_date'] = this.pserviceDate;
    data['pservice_service_status'] = this.pserviceServiceStatus;
    data['property_code'] = this.propertyCode;
    data['property_name'] = this.propertyName;
    return data;
  }
}
class ONGOING {
  String pserviceId;
  String pserviceCode;
  String pserviceDate;
  String pserviceServiceStatus;
  String propertyCode;
  String propertyName;

  ONGOING(
      {this.pserviceId,
        this.pserviceCode,
        this.pserviceDate,
        this.pserviceServiceStatus,
        this.propertyCode,
        this.propertyName});

  ONGOING.fromJson(Map<String, dynamic> json) {
    pserviceId = json['pservice_id'];
    pserviceCode = json['pservice_code'];
    pserviceDate = json['pservice_date'];
    pserviceServiceStatus = json['pservice_service_status'];
    propertyCode = json['property_code'];
    propertyName = json['property_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pservice_id'] = this.pserviceId;
    data['pservice_code'] = this.pserviceCode;
    data['pservice_date'] = this.pserviceDate;
    data['pservice_service_status'] = this.pserviceServiceStatus;
    data['property_code'] = this.propertyCode;
    data['property_name'] = this.propertyName;
    return data;
  }
}
class Complaint {
  String complaintId;
  String complaintCode;
  String complaintNote;
  String complaintStatus;
  String complaintImage;
  String createdAt;
  String propertyCode;
  String propertyName;

  Complaint(
      {this.complaintId,
        this.complaintCode,
        this.complaintNote,
        this.complaintStatus,
        this.complaintImage,
        this.createdAt,
        this.propertyCode,
        this.propertyName});

  Complaint.fromJson(Map<String, dynamic> json) {
    complaintId = json['complaint_id'];
    complaintCode = json['complaint_code'];
    complaintNote = json['complaint_note'];
    complaintStatus = json['complaint_status'];
    complaintImage = json['complaint_image'];
    createdAt = json['created_at'];
    propertyCode = json['property_code'];
    propertyName = json['property_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['complaint_id'] = this.complaintId;
    data['complaint_code'] = this.complaintCode;
    data['complaint_note'] = this.complaintNote;
    data['complaint_status'] = this.complaintStatus;
    data['complaint_image'] = this.complaintImage;
    data['created_at'] = this.createdAt;
    data['property_code'] = this.propertyCode;
    data['property_name'] = this.propertyName;
    return data;
  }
}

class Damage {
  String damageId;
  String damageCode;
  String damageNote;
  String damageStatus;
  String damageImage;
  String createdAt;
  String propertyCode;
  String propertyName;

  Damage(
      {this.damageId,
        this.damageCode,
        this.damageNote,
        this.damageStatus,
        this.damageImage,
        this.createdAt,
        this.propertyCode,
        this.propertyName});

  Damage.fromJson(Map<String, dynamic> json) {
    damageId = json['damage_id'];
    damageCode = json['damage_code'];
    damageNote = json['damage_note'];
    damageStatus = json['damage_status'];
    damageImage = json['damage_image'];
    createdAt = json['created_at'];
    propertyCode = json['property_code'];
    propertyName = json['property_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['damage_id'] = this.damageId;
    data['damage_code'] = this.damageCode;
    data['damage_note'] = this.damageNote;
    data['damage_status'] = this.damageStatus;
    data['damage_image'] = this.damageImage;
    data['created_at'] = this.createdAt;
    data['property_code'] = this.propertyCode;
    data['property_name'] = this.propertyName;
    return data;
  }
}

class Feedback {
  String feedbackId;
  String serviceId;
  String cleanRating;
  String servicerRating;
  String feedbackNote;
  String createdAt;
  String pserviceCode;
  String propertyCode;
  String propertyName;

  Feedback(
      {this.feedbackId,
        this.serviceId,
        this.cleanRating,
        this.servicerRating,
        this.feedbackNote,
        this.createdAt,
        this.pserviceCode,
        this.propertyCode,
        this.propertyName});

  Feedback.fromJson(Map<String, dynamic> json) {
    feedbackId = json['feedback_id'];
    serviceId = json['service_id'];
    cleanRating = json['clean_rating'];
    servicerRating = json['servicer_rating'];
    feedbackNote = json['feedback_note'];
    createdAt = json['created_at'];
    pserviceCode = json['pservice_code'];
    propertyCode = json['property_code'];
    propertyName = json['property_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['feedback_id'] = this.feedbackId;
    data['service_id'] = this.serviceId;
    data['clean_rating'] = this.cleanRating;
    data['servicer_rating'] = this.servicerRating;
    data['feedback_note'] = this.feedbackNote;
    data['created_at'] = this.createdAt;
    data['pservice_code'] = this.pserviceCode;
    data['property_code'] = this.propertyCode;
    data['property_name'] = this.propertyName;
    return data;
  }
}