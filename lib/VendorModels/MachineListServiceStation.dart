class MachineListServiceStation {
  bool status;
  List<Items> items;

  MachineListServiceStation({this.status, this.items});

  MachineListServiceStation.fromJson(Map<String, dynamic> json) {
    status = json['status'];
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
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  String machineId;
  String machineCode;
  String machineName;
  String machineType;

  Items({this.machineId, this.machineCode, this.machineName, this.machineType});

  Items.fromJson(Map<String, dynamic> json) {
    machineId = json['machine_id'];
    machineCode = json['machine_code'];
    machineName = json['machine_name'];
    machineType = json['machine_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['machine_id'] = this.machineId;
    data['machine_code'] = this.machineCode;
    data['machine_name'] = this.machineName;
    data['machine_type'] = this.machineType;
    return data;
  }
}
