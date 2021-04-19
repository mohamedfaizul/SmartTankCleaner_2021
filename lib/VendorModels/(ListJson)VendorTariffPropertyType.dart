class VendorTariffPropertyDetailModelList {
  final List<VendorTariffPropertyDetailModel> tariff;

  VendorTariffPropertyDetailModelList({
    this.tariff,
  });

  factory VendorTariffPropertyDetailModelList.fromJson(
      List<dynamic> parsedJson) {
    List<VendorTariffPropertyDetailModel> tariffs =
        new List<VendorTariffPropertyDetailModel>();
    tariffs = parsedJson
        .map((i) => VendorTariffPropertyDetailModel.fromJson(i))
        .toList();

    return new VendorTariffPropertyDetailModelList(tariff: tariffs);
  }
}

class VendorTariffPropertyDetailModel {
  String ptypeId;
  String ptypeName;
  String ptypeUnit;

  VendorTariffPropertyDetailModel(
      {this.ptypeId, this.ptypeName, this.ptypeUnit});

  VendorTariffPropertyDetailModel.fromJson(Map<String, dynamic> json) {
    ptypeId = json['ptype_id'];
    ptypeName = json['ptype_name'];
    ptypeUnit = json['ptype_unit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ptype_id'] = this.ptypeId;
    data['ptype_name'] = this.ptypeName;
    data['ptype_unit'] = this.ptypeUnit;
    return data;
  }
}
