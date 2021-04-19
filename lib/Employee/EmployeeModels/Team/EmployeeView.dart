class EmployeeView {
  Values values;
  List<EmpAssignData> empAssignData;

  EmployeeView({this.values, this.empAssignData});

  EmployeeView.fromJson(Map<String, dynamic> json) {
    values =
    json['values'] != null ? new Values.fromJson(json['values']) : null;
    if (json['emp_assign_data'] != null) {
      empAssignData = new List<EmpAssignData>();
      json['emp_assign_data'].forEach((v) {
        empAssignData.add(new EmpAssignData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.values != null) {
      data['values'] = this.values.toJson();
    }
    if (this.empAssignData != null) {
      data['emp_assign_data'] =
          this.empAssignData.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Values {
  String empId;
  String empName;
  String empCode;
  String empPhone;
  String empPhoneAlter;
  String empEmail;
  String empPassword;
  String empAddress;
  String empPincode;
  String empDistrict;
  String empState;
  String empDesignation;
  String empGender;
  List<EmpPhotos> empPhotos;
  List<EmpProofs> empProofs;
  String empBankDetails;
  String empEmpType;
  String reportingTo;
  String empDob;
  String empDoj;
  String totalPaidHoliday;
  String monthlySalary;
  String maxTravelAllowance;
  String maxExpense;
  String empStatus;
  String latitude;
  String longitude;
  String mapLocation;
  String stateName;
  String districtName;
  String serviceStationId;
  String stationSuperviserId;
  String uname;
  String station;
  String empOfcState;
  String empOfcDistrict;
  String empOfcAddress;
  String empOfcPincode;
  String ofcStateName;
  String ofcDistrictName;

  Values(
      {this.empId,
        this.empName,
        this.empCode,
        this.empPhone,
        this.empPhoneAlter,
        this.empEmail,
        this.empPassword,
        this.empAddress,
        this.empPincode,
        this.empDistrict,
        this.empState,
        this.empDesignation,
        this.empGender,
        this.empPhotos,
        this.empProofs,
        this.empBankDetails,
        this.empEmpType,
        this.reportingTo,
        this.empDob,
        this.empDoj,
        this.totalPaidHoliday,
        this.monthlySalary,
        this.maxTravelAllowance,
        this.maxExpense,
        this.empStatus,
        this.latitude,
        this.longitude,
        this.mapLocation,
        this.stateName,
        this.districtName,
        this.serviceStationId,
        this.stationSuperviserId,
        this.uname,
        this.station,
        this.empOfcState,
        this.empOfcDistrict,
        this.empOfcAddress,
        this.empOfcPincode,
        this.ofcStateName,
        this.ofcDistrictName});

  Values.fromJson(Map<String, dynamic> json) {
    empId = json['emp_id'];
    empName = json['emp_name'];
    empCode = json['emp_code'];
    empPhone = json['emp_phone'];
    empPhoneAlter = json['emp_phone_alter'];
    empEmail = json['emp_email'];
    empPassword = json['emp_password'];
    empAddress = json['emp_address'];
    empPincode = json['emp_pincode'];
    empDistrict = json['emp_district'];
    empState = json['emp_state'];
    empDesignation = json['emp_designation'];
    empGender = json['emp_gender'];
    if (json['emp_photos'] != null) {
      empPhotos = new List<EmpPhotos>();
      json['emp_photos'].forEach((v) {
        empPhotos.add(new EmpPhotos.fromJson(v));
      });
    }
    if (json['emp_proofs'] != null) {
      empProofs = new List<EmpProofs>();
      json['emp_proofs'].forEach((v) {
        empProofs.add(new EmpProofs.fromJson(v));
      });
    }
    empBankDetails = json['emp_bank_details'];
    empEmpType = json['emp_emp_type'];
    reportingTo = json['reporting_to'];
    empDob = json['emp_dob'];
    empDoj = json['emp_doj'];
    totalPaidHoliday = json['total_paid_holiday'];
    monthlySalary = json['monthly_salary'];
    maxTravelAllowance = json['max_travel_allowance'];
    maxExpense = json['max_expense'];
    empStatus = json['emp_status'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    mapLocation = json['map_location'];
    stateName = json['state_name'];
    districtName = json['district_name'];
    serviceStationId = json['service_station_id'];
    stationSuperviserId = json['station_superviser_id'];
    uname = json['uname'];
    station = json['station'];
    empOfcState = json['emp_ofc_state'];
    empOfcDistrict = json['emp_ofc_district'];
    empOfcAddress = json['emp_ofc_address'];
    empOfcPincode = json['emp_ofc_pincode'];
    ofcStateName = json['ofc_state_name'];
    ofcDistrictName = json['ofc_district_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['emp_id'] = this.empId;
    data['emp_name'] = this.empName;
    data['emp_code'] = this.empCode;
    data['emp_phone'] = this.empPhone;
    data['emp_phone_alter'] = this.empPhoneAlter;
    data['emp_email'] = this.empEmail;
    data['emp_password'] = this.empPassword;
    data['emp_address'] = this.empAddress;
    data['emp_pincode'] = this.empPincode;
    data['emp_district'] = this.empDistrict;
    data['emp_state'] = this.empState;
    data['emp_designation'] = this.empDesignation;
    data['emp_gender'] = this.empGender;
    if (this.empPhotos != null) {
      data['emp_photos'] = this.empPhotos.map((v) => v.toJson()).toList();
    }
    if (this.empProofs != null) {
      data['emp_proofs'] = this.empProofs.map((v) => v.toJson()).toList();
    }
    data['emp_bank_details'] = this.empBankDetails;
    data['emp_emp_type'] = this.empEmpType;
    data['reporting_to'] = this.reportingTo;
    data['emp_dob'] = this.empDob;
    data['emp_doj'] = this.empDoj;
    data['total_paid_holiday'] = this.totalPaidHoliday;
    data['monthly_salary'] = this.monthlySalary;
    data['max_travel_allowance'] = this.maxTravelAllowance;
    data['max_expense'] = this.maxExpense;
    data['emp_status'] = this.empStatus;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['map_location'] = this.mapLocation;
    data['state_name'] = this.stateName;
    data['district_name'] = this.districtName;
    data['service_station_id'] = this.serviceStationId;
    data['station_superviser_id'] = this.stationSuperviserId;
    data['uname'] = this.uname;
    data['station'] = this.station;
    data['emp_ofc_state'] = this.empOfcState;
    data['emp_ofc_district'] = this.empOfcDistrict;
    data['emp_ofc_address'] = this.empOfcAddress;
    data['emp_ofc_pincode'] = this.empOfcPincode;
    data['ofc_state_name'] = this.ofcStateName;
    data['ofc_district_name'] = this.ofcDistrictName;
    return data;
  }
}

class EmpPhotos {
  String imgId;
  String imgPath;

  EmpPhotos({this.imgId, this.imgPath});

  EmpPhotos.fromJson(Map<String, dynamic> json) {
    imgId = json['img_id'];
    imgPath = json['img_path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['img_id'] = this.imgId;
    data['img_path'] = this.imgPath;
    return data;
  }
}

class EmpProofs {
  String imgId;
  String imgPath;

  EmpProofs({this.imgId, this.imgPath});

  EmpProofs.fromJson(Map<String, dynamic> json) {
    imgId = json['img_id'];
    imgPath = json['img_path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['img_id'] = this.imgId;
    data['img_path'] = this.imgPath;
    return data;
  }
}

class EmpAssignData {
  String gmId;
  String stateId;
  String empId;
  String gmStatus;
  String stateName;

  EmpAssignData(
      {this.gmId, this.stateId, this.empId, this.gmStatus, this.stateName});

  EmpAssignData.fromJson(Map<String, dynamic> json) {
    gmId = json['gm_id'];
    stateId = json['state_id'];
    empId = json['emp_id'];
    gmStatus = json['gm_status'];
    stateName = json['state_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gm_id'] = this.gmId;
    data['state_id'] = this.stateId;
    data['emp_id'] = this.empId;
    data['gm_status'] = this.gmStatus;
    data['state_name'] = this.stateName;
    return data;
  }
}
class AccDetails {
  String empAccName;
  String empAccNo;
  String empAccBranch;
  String empAccBank;
  String empAccIfsc;

  AccDetails(
      {this.empAccName,
        this.empAccNo,
        this.empAccBranch,
        this.empAccBank,
        this.empAccIfsc});

  AccDetails.fromJson(Map<String, dynamic> json) {
    empAccName = json['emp_acc_name'];
    empAccNo = json['emp_acc_no'];
    empAccBranch = json['emp_acc_branch'];
    empAccBank = json['emp_acc_bank'];
    empAccIfsc = json['emp_acc_ifsc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['emp_acc_name'] = this.empAccName;
    data['emp_acc_no'] = this.empAccNo;
    data['emp_acc_branch'] = this.empAccBranch;
    data['emp_acc_bank'] = this.empAccBank;
    data['emp_acc_ifsc'] = this.empAccIfsc;
    return data;
  }
}