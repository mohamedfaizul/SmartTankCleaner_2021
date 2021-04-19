class PlanDetails {
  bool msg;
  Res res;

  PlanDetails({this.msg, this.res});

  PlanDetails.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    res = json['res'] != null ? new Res.fromJson(json['res']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    if (this.res != null) {
      data['res'] = this.res.toJson();
    }
    return data;
  }
}

class Res {
  PlanDatas planDatas;
  List<Pricing> pricing;
  List<Condition> condition;

  Res({this.planDatas, this.pricing, this.condition});

  Res.fromJson(Map<String, dynamic> json) {
    planDatas = json['plan_datas'] != null
        ? new PlanDatas.fromJson(json['plan_datas'])
        : null;
    if (json['pricing'] != null) {
      pricing = new List<Pricing>();
      json['pricing'].forEach((v) {
        pricing.add(new Pricing.fromJson(v));
      });
    }
    if (json['condition'] != null) {
      condition = new List<Condition>();
      json['condition'].forEach((v) {
        condition.add(new Condition.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.planDatas != null) {
      data['plan_datas'] = this.planDatas.toJson();
    }
    if (this.pricing != null) {
      data['pricing'] = this.pricing.map((v) => v.toJson()).toList();
    }
    if (this.condition != null) {
      data['condition'] = this.condition.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PlanDatas {
  String planName;
  String planServicetype;
  String planPropertytypeId;
  String planUnit;
  String planSizeFrom;
  String planSizeTo;
  String planStatus;

  PlanDatas(
      {this.planName,
      this.planServicetype,
      this.planPropertytypeId,
      this.planUnit,
      this.planSizeFrom,
      this.planSizeTo,
      this.planStatus});

  PlanDatas.fromJson(Map<String, dynamic> json) {
    planName = json['plan_name'];
    planServicetype = json['plan_servicetype'];
    planPropertytypeId = json['plan_propertytype_id'];
    planUnit = json['plan_unit'];
    planSizeFrom = json['plan_size_from'];
    planSizeTo = json['plan_size_to'];
    planStatus = json['plan_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['plan_name'] = this.planName;
    data['plan_servicetype'] = this.planServicetype;
    data['plan_propertytype_id'] = this.planPropertytypeId;
    data['plan_unit'] = this.planUnit;
    data['plan_size_from'] = this.planSizeFrom;
    data['plan_size_to'] = this.planSizeTo;
    data['plan_status'] = this.planStatus;
    return data;
  }
}

class Pricing {
  String priceId;
  String serviceYear;
  String totalService;
  String literPrice;
  String fixedPrice;

  Pricing(
      {this.priceId,
      this.serviceYear,
      this.totalService,
      this.literPrice,
      this.fixedPrice});

  Pricing.fromJson(Map<String, dynamic> json) {
    priceId = json['price_id'];
    serviceYear = json['service_year'];
    totalService = json['total_service'];
    literPrice = json['liter_price'];
    fixedPrice = json['fixed_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['price_id'] = this.priceId;
    data['service_year'] = this.serviceYear;
    data['total_service'] = this.totalService;
    data['liter_price'] = this.literPrice;
    data['fixed_price'] = this.fixedPrice;
    return data;
  }
}

class Condition {
  String conditionId;
  String planName;
  String totalService;

  Condition({this.conditionId, this.planName, this.totalService});

  Condition.fromJson(Map<String, dynamic> json) {
    conditionId = json['condition_id'];
    planName = json['plan_name'];
    totalService = json['total_service'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['condition_id'] = this.conditionId;
    data['plan_name'] = this.planName;
    data['total_service'] = this.totalService;
    return data;
  }
}
