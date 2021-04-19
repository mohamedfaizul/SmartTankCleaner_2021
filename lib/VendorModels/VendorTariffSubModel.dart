class VendorTariffSubModel {
  String transport;
  String serviceLabour;
  String serviceProfit;

  VendorTariffSubModel(
      {this.transport, this.serviceLabour, this.serviceProfit});

  VendorTariffSubModel.fromJson(Map<String, dynamic> json) {
    transport = json['transport'];
    serviceLabour = json['service_labour'];
    serviceProfit = json['service_profit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['transport'] = this.transport;
    data['service_labour'] = this.serviceLabour;
    data['service_profit'] = this.serviceProfit;
    return data;
  }
}
