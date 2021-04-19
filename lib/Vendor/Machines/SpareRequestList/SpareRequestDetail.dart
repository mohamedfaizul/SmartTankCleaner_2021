import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:io';
import 'dart:ui';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:tankcare/Customer/register.dart';
import 'package:tankcare/Employee/Dashboard.dart';
import 'package:tankcare/RM%20models/DamageView.dart';
import 'package:tankcare/RM/ApprovalList.dart';
import 'package:tankcare/VendorModels/RepairViewRepair.dart';
import 'package:tankcare/VendorModels/RepairViewRepairQuote.dart';
import 'package:tankcare/VendorModels/SpareRequestView.dart';

import '../../../string_values.dart';

class SpareRequestDetail extends StatefulWidget {
  SpareRequestDetail({Key key, this.machineid});

  String machineid;

  // String apid;
  @override
  SpareRequestDetailState createState() => SpareRequestDetailState();
}

class SpareRequestDetailState extends State<SpareRequestDetail> {
  bool loading = false;
  SpareRequestView li;

  List<File> files = [];
  var _kGooglePlex;
  Future<File> _imageFile;
  Repair li2;

  RepairViewRepairQuote li3;
  String tblid;
  String dropdownValue3 = '-Action-';

  num a;

  File image;

  var file;

  int servicerating = 0;
  int servicerrating = 0;

  DateTime damageEndDate;

  bool damageenable = true;

  FranchaiseDamage li4;

  Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  Future<http.Response> details(planid) async {
    setState(() {
      loading = true;
    });
    var url =
        String_values.base_url + 'machine-spare-request-details/' + planid;
    print(url);
    var response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer ${RegisterPagesState.token}'
      },
    );
    if (response.statusCode == 200) {
      setState(() {
        loading = false;
      });
      li = SpareRequestView.fromJson(json.decode(response.body));
      setState(() {
        SpareCodeController.text = li.data.spareCode.toString();
        SpareNoteController.text = li.data.spareNote.toString();
        MachineNameController.text = li.data.machineName.toString();
        MachineCodeController.text = li.data.machineCode.toString();
        MachineTypeController.text = li.data.machineType.toString();
        ManufacturerNameController.text = li.data.manufactureName.toString();
        ManufacturerNoController.text = li.data.manufactureNumber.toString();
        PurchaseDateController.text = DateFormat('dd/MM/yyyy').format(
            DateTime.parse(li.data.purchaseDate.toString()));
        StateController.text = li.data.stateName.toString();
        DistrictController.text = li.data.districtName.toString();
        // AssignbyController.text = li.data.assignby.toString();
      });

      //    GroupCodeController.text="Group Code: "+li.groupCode;
      //    GroupContactNameController.text="Group Contact Name: "+li.groupContactName;
      //    GroupContactMobileController.text="Group Contact Mobile : "+li.groupContactPhone;
      //    addressController.text="Address:\n\n"+li.groupAddress;
      //    if(li.serviceType=="COM")
      //    servicetypeController.text="Service Type: Commercial";
      //    else
      //      servicetypeController.text="Service Type: Residential";
      //
      // _kGooglePlex = CameraPosition(
      //   // bearing: 192.8334901395799,
      //     target: LatLng(double.parse(li.latitude),double.parse(li.longitude)),
      //     zoom: 17);
      // if(li.res.planDatas.planServicetype.toString()=="RES")
      // ServiceTypeController.text="Service Type: Residential";
      // else
      //  ServiceTypeController.text="Service Type: Commercial";
      //  PropertyTypeController.text="Property Type: "+li.res.planDatas.planPropertytypeId;
      // // ServiceTypeController.text="Service Type: "+li.res.planDatas.planServicetype;
      //  SizeRangeControllermin.text=li.res.planDatas.planSizeFrom;
      //  SizeRangeControllermax.text=li.res.planDatas.planSizeTo;
    } else {
      setState(() {
        loading = false;
      });
      print("Retry");
    }
    print("response: ${response.statusCode}");
    print("response: ${response.body}");
    return response;
  }

  Future<http.Response> repairdetails(planid) async {
    setState(() {
      loading = true;
    });
    var url =
        String_values.base_url + 'ap-verify-details/' + planid + '/spare_req';
    print(url);
    var response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer ${RegisterPagesState.token}'
      },
    );
    if (response.statusCode == 200) {
      setState(() {
        loading = false;
      });
      li2 = Repair.fromJson(json.decode(response.body));
      setState(() {
        // RepairCodeController.text=li.data.repairCode.toString();
        // RepairNoteController.text=li.data.repairNote.toString();
        // RepairStatusController.text=li.data.repairStatus.toString();
        // MachineNameController.text = li.data.machineName.toString();
        // MachineCodeController.text = li.data.machineCode.toString();
        // MachineTypeController.text = li.data.machineType.toString();
        // ManufacturerNameController.text = li.data.manufactureName.toString();
        // ManufacturerNoController.text = li.data.manufactureNumber.toString();
        // PurchaseDateController.text = li.data.purchaseDate.toString();
        // StateController.text = li.data.stateName.toString();
        // DistrictController.text = li.data.districtName.toString();
        // AssignbyController.text = li.data.assignby.toString();
      });

      //    GroupCodeController.text="Group Code: "+li.groupCode;
      //    GroupContactNameController.text="Group Contact Name: "+li.groupContactName;
      //    GroupContactMobileController.text="Group Contact Mobile : "+li.groupContactPhone;
      //    addressController.text="Address:\n\n"+li.groupAddress;
      //    if(li.serviceType=="COM")
      //    servicetypeController.text="Service Type: Commercial";
      //    else
      //      servicetypeController.text="Service Type: Residential";
      //
      // _kGooglePlex = CameraPosition(
      //   // bearing: 192.8334901395799,
      //     target: LatLng(double.parse(li.latitude),double.parse(li.longitude)),
      //     zoom: 17);
      // if(li.res.planDatas.planServicetype.toString()=="RES")
      // ServiceTypeController.text="Service Type: Residential";
      // else
      //  ServiceTypeController.text="Service Type: Commercial";
      //  PropertyTypeController.text="Property Type: "+li.res.planDatas.planPropertytypeId;
      // // ServiceTypeController.text="Service Type: "+li.res.planDatas.planServicetype;
      //  SizeRangeControllermin.text=li.res.planDatas.planSizeFrom;
      //  SizeRangeControllermax.text=li.res.planDatas.planSizeTo;
    } else {
      setState(() {
        loading = false;
      });
      print("Retry");
    }
    print("response: ${response.statusCode}");
    print("response: ${response.body}");
    return response;
  }

  Future<http.Response> repairquotedetails(planid) async {
    setState(() {
      loading = true;
    });
    var url = String_values.base_url +
        'ap-verify-details/' +
        planid +
        '/repair_quote';
    print(url);
    var response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer ${RegisterPagesState.token}'
      },
    );
    if (response.statusCode == 200) {
      setState(() {
        loading = false;
      });
      li3 = RepairViewRepairQuote.fromJson(json.decode(response.body));
      setState(() {
        // RepairCodeController.text=li.data.repairCode.toString();
        // RepairNoteController.text=li.data.repairNote.toString();
        // RepairStatusController.text=li.data.repairStatus.toString();
        // MachineNameController.text = li.data.machineName.toString();
        // MachineCodeController.text = li.data.machineCode.toString();
        // MachineTypeController.text = li.data.machineType.toString();
        // ManufacturerNameController.text = li.data.manufactureName.toString();
        // ManufacturerNoController.text = li.data.manufactureNumber.toString();
        // PurchaseDateController.text = li.data.purchaseDate.toString();
        // StateController.text = li.data.stateName.toString();
        // DistrictController.text = li.data.districtName.toString();
        // AssignbyController.text = li.data.assignby.toString();
      });

      //    GroupCodeController.text="Group Code: "+li.groupCode;
      //    GroupContactNameController.text="Group Contact Name: "+li.groupContactName;
      //    GroupContactMobileController.text="Group Contact Mobile : "+li.groupContactPhone;
      //    addressController.text="Address:\n\n"+li.groupAddress;
      //    if(li.serviceType=="COM")
      //    servicetypeController.text="Service Type: Commercial";
      //    else
      //      servicetypeController.text="Service Type: Residential";
      //
      // _kGooglePlex = CameraPosition(
      //   // bearing: 192.8334901395799,
      //     target: LatLng(double.parse(li.latitude),double.parse(li.longitude)),
      //     zoom: 17);
      // if(li.res.planDatas.planServicetype.toString()=="RES")
      // ServiceTypeController.text="Service Type: Residential";
      // else
      //  ServiceTypeController.text="Service Type: Commercial";
      //  PropertyTypeController.text="Property Type: "+li.res.planDatas.planPropertytypeId;
      // // ServiceTypeController.text="Service Type: "+li.res.planDatas.planServicetype;
      //  SizeRangeControllermin.text=li.res.planDatas.planSizeFrom;
      //  SizeRangeControllermax.text=li.res.planDatas.planSizeTo;
    } else {
      setState(() {
        loading = false;
      });
      print("Retry");
    }
    print("response: ${response.statusCode}");
    print("response: ${response.body}");
    return response;
  }

  Future<int> uploadImage(apid, aptblid, Aorr) async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer ${RegisterPagesState.token}'
    };

    var request = http.MultipartRequest('POST',
        Uri.parse(String_values.base_url + 'approval-repair-quote-verify'));
    //property_id plan_id pplan_name pplan_year pplan_service pplan_price pplan_tot_price pplan_start_date
    request.headers.addAll(headers);
    request.fields['ap_id'] = apid;
    request.fields['eap_status'] = Aorr;
    request.fields['ap_tbl_id'] = aptblid;
    var response = await request.send();
    response.stream.transform(utf8.decoder).listen((value) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => RMApprovalList(),
          ));
      return response.statusCode;
    });
  }

  Future<String> DamageOTPSave(damageid) async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer ${RegisterPagesState.token}'
    };

    var request = http.MultipartRequest('POST',
        Uri.parse(String_values.base_url + 'service-damage-amount-save'));
    //property_id plan_id pplan_name pplan_year pplan_service pplan_price pplan_tot_price pplan_start_date
    request.headers.addAll(headers);
    request.fields['damage_id'] = damageid;
    request.fields['damage_otp'] = OTPController.text;
    request.fields['damage_amount'] = ClaimAmountController.text;
    var response = await request.send();
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);

      return value;
    });
  }

  Future<int> DamageClaim(damageid) async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer ${RegisterPagesState.token}'
    };

    var request = http.MultipartRequest(
        'POST', Uri.parse(String_values.base_url + 'service-damage-otp'));
    //property_id plan_id pplan_name pplan_year pplan_service pplan_price pplan_tot_price pplan_start_date
    request.headers.addAll(headers);
    request.fields['damage_id'] = damageid;
    var response = await request.send();
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
      if (value.contains("true"))
        showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                "Claim Amount",
                style: TextStyle(color: Colors.red),
              ),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      enabled: true,
                      controller: ClaimAmountController,
                      decoration: InputDecoration(
                        labelText: 'Claim Amount',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 16.0,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 40,
                    ),
                    TextField(
                      enabled: true,
                      controller: OTPController,
                      decoration: InputDecoration(
                        labelText: 'Enter OTP',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 16.0,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: Text('Save & Approve'),
                  onPressed: () {
                    check().then((value) {
                      if (value) {
                        if ((OTPController.text.length > 0) &&
                            (ClaimAmountController.text.length > 0))
                          DamageOTPSave(li4.items.damageId).then((value) {
                            // uploadImage(widget.apid, tblid, "a");
                          });
                        else
                          Fluttertoast.showToast(
                              msg: "OTP or Claim Amount Cannot be Empty",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.SNACKBAR,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                      } else
                        showDialog<void>(
                          context: context,
                          barrierDismissible: false, // user must tap button!
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("No Internet Connection"),
                              actions: <Widget>[
                                TextButton(
                                  child: Text('OK'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                    });
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );

      return response.statusCode;
    });
  }

  List<String> items = List<String>.generate(7, (index) {
    return "Item - $index";
  });
  List<PlanListClass> listplan;
  TextEditingController OTPController = new TextEditingController();
  TextEditingController ClaimAmountController = new TextEditingController();
  TextEditingController StatusController = new TextEditingController();
  TextEditingController RepairStatusController = new TextEditingController();
  TextEditingController SpareNoteController = new TextEditingController();
  TextEditingController DamageCodeController = new TextEditingController();
  TextEditingController DamageStatusController = new TextEditingController();
  TextEditingController DamageNoteController = new TextEditingController();

  TextEditingController SpareCodeController = new TextEditingController();
  TextEditingController ComplaintController = new TextEditingController();
  TextEditingController DamageController = new TextEditingController();
  TextEditingController ServiceController = new TextEditingController();
  TextEditingController PlanPaidStatusController = new TextEditingController();
  TextEditingController PlanCurrentStatusController =
      new TextEditingController();
  TextEditingController PropertyCodeController = new TextEditingController();
  TextEditingController FeedBackController = new TextEditingController();
  TextEditingController PropertyNameController = new TextEditingController();
  TextEditingController valuecontroller = new TextEditingController();
  TextEditingController CusNameController = new TextEditingController();
  TextEditingController PhoneController = new TextEditingController();
  List<PlanServiceYearClass> listplanyear;
  TextEditingController GroupContactNameController =
      new TextEditingController();
  TextEditingController GroupNameController = new TextEditingController();
  Completer<GoogleMapController> _controller = Completer();
  TextEditingController GroupContactMobileController =
      new TextEditingController();
  TextEditingController GroupContactMobilController =
      new TextEditingController();
  TextEditingController TotalServicesController = new TextEditingController();
  TextEditingController GroupCodeController = new TextEditingController();
  TextEditingController servicetypeController = new TextEditingController();
  TextEditingController PropertyTypeController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();
  TextEditingController statusController = new TextEditingController();
  TextEditingController CusCodeController = new TextEditingController();
  TextEditingController ServiceStartAtController = new TextEditingController();
  TextEditingController ServiceEndAtController = new TextEditingController();

//  TextEditingController SizeRangeControllermax = new TextEditingController();
  List<PlanListClass> selectedAvengers;
  bool sort;

  String dropdownValue = '-- Service Type --';

  String dropdownValue1 = '-- Property Type --';

  String dropdownValue2 = '-- Select Plan --';

  static List<String> friendsList = [null];

  TextEditingController MachineNameController = new TextEditingController();
  TextEditingController MachineCodeController = new TextEditingController();
  TextEditingController MachineTypeController = new TextEditingController();
  TextEditingController ManufacturerNameController =
      new TextEditingController();
  TextEditingController ManufacturerNoController = new TextEditingController();
  TextEditingController PurchaseDateController = new TextEditingController();
  TextEditingController StateController = new TextEditingController();
  TextEditingController DistrictController = new TextEditingController();
  TextEditingController AssignbyController = new TextEditingController();

  void initState() {
    print(widget.machineid);
    // print(widget.apid);
    details(widget.machineid).then((value) => repairdetails(widget.machineid));
    ;
    sort = false;
    //stateRequest();
    //  districtRequest();
    selectedAvengers = [];
    listplan = PlanListClass.getdata();
    listplanyear = PlanServiceYearClass.getdata();
    super.initState();
  }

  String searchAddr;

  DateTime _dateTime;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      //backgroundColor: Colors.redAccent[100],
      body: loading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: new Column(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 1.0), //(x,y)
                          blurRadius: 6.0,
                        ),
                      ],
                    ),
                    // color: Colors.white,
                    margin: EdgeInsets.all(3.0),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: new Text(
                          "Spare Request Details",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                              fontSize: 17),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height / 40,
                  ),
                  Container(
                      margin: const EdgeInsets.only(top: 10),
                      color: Colors.red.shade50,
                      child: ExpansionTile(
                          backgroundColor: Colors.white,
                          initiallyExpanded: true,
                          title: Text(
                            "Spare Details",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, color: Colors.red),
                          ),
                          children: [
                            SizedBox(
                              height: height / 50,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
                              child: new TextField(
                                enabled: false,
                                controller: SpareCodeController,
                                decoration: InputDecoration(
                                  labelText: 'Spare Code',
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16.0,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: height / 50,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
                              child: new TextField(
                                enabled: false,
                                controller: SpareNoteController,
                                decoration: InputDecoration(
                                  labelText: 'Spare Note',
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16.0,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: height / 50,
                            ),
                          ])),
                  Container(
                      margin: const EdgeInsets.only(top: 10),
                      color: Colors.red.shade50,
                      child: ExpansionTile(
                          backgroundColor: Colors.white,
                          initiallyExpanded: true,
                          title: Text(
                            "Machine Details",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, color: Colors.red),
                          ),
                          children: [
                            SizedBox(
                              height: height / 50,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
                              child: new TextField(
                                enabled: false,
                                controller: MachineNameController,
                                decoration: InputDecoration(
                                  labelText: 'Machine Name',
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16.0,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: height / 50,
                            ),

                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
                              child: new TextField(
                                enabled: false,
                                controller: MachineCodeController,
                                decoration: InputDecoration(
                                  labelText: 'Machine Code',
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16.0,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: height / 50,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
                              child: new TextField(
                                enabled: false,
                                controller: MachineTypeController,
                                decoration: InputDecoration(
                                  labelText: 'Machine Type',
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16.0,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: height / 50,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
                              child: new TextField(
                                enabled: false,
                                controller: ManufacturerNameController,
                                decoration: InputDecoration(
                                  labelText: 'Manufacturer Name',
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16.0,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: height / 50,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
                              child: new TextField(
                                enabled: false,
                                controller: ManufacturerNoController,
                                decoration: InputDecoration(
                                  labelText: 'Manufacturer No',
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16.0,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: height / 50,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
                              child: new TextField(
                                enabled: false,
                                controller: PurchaseDateController,
                                decoration: InputDecoration(
                                  labelText: 'Purchase Date',
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16.0,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: height / 50,
                            ),
                            SizedBox(
                              height: height / 50,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
                              child: new TextField(
                                enabled: false,
                                controller: StateController,
                                decoration: InputDecoration(
                                  labelText: 'State Name',
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16.0,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: height / 50,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
                              child: new TextField(
                                enabled: false,
                                controller: DistrictController,
                                decoration: InputDecoration(
                                  labelText: 'District Name',
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16.0,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: height / 50,
                            ),
                            SizedBox(
                              height: height / 50,
                            ),

                            // Padding(
                            //   padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                            //   child: new TextField(
                            //     enabled: false,
                            //     controller: AssignbyController,
                            //     decoration: InputDecoration(
                            //       labelText: 'Assign Name',
                            //       hintStyle: TextStyle(
                            //         color: Colors.grey,
                            //         fontSize: 16.0,
                            //       ),
                            //       border: OutlineInputBorder(
                            //         borderRadius: BorderRadius.circular(5.0),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            // SizedBox(
                            //   height: height / 50,
                            // ),
                          ])),
                  Container(
                    padding: EdgeInsets.all(16),
                    width: width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 1.0), //(x,y)
                          blurRadius: 1.0,
                        ),
                      ],
                    ),
                    // color: Colors.white,
                    margin: EdgeInsets.only(top: 10.0, bottom: 10),

                    child: new Text(
                      "Approval Process",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      sortAscending: sort,
                      sortColumnIndex: 0,
                      columnSpacing: width / 20,
                      columns: [
                        DataColumn(
                          label: Center(
                              child: Wrap(
                            direction: Axis.vertical, //default
                            alignment: WrapAlignment.center,
                            children: [
                              Text("Order By",
                                  softWrap: true,
                                  style: TextStyle(fontSize: 12),
                                  textAlign: TextAlign.center),
                            ],
                          )),
                          numeric: false,

                          // onSort: (columnIndex, ascending) {
                          //   onSortColum(columnIndex, ascending);
                          //   setState(() {
                          //     sort = !sort;
                          //   });
                          // }
                        ),
                        DataColumn(
                          label: Center(
                              child: Wrap(
                            direction: Axis.vertical, //default
                            alignment: WrapAlignment.center,
                            children: [
                              Text("Designation",
                                  softWrap: true,
                                  style: TextStyle(fontSize: 12),
                                  textAlign: TextAlign.center),
                            ],
                          )),
                          numeric: false,

                          // onSort: (columnIndex, ascending) {
                          //   onSortColum(columnIndex, ascending);
                          //   setState(() {
                          //     sort = !sort;
                          //   });
                          // }
                        ),
                        DataColumn(
                          label: Center(
                              child: Wrap(
                            direction: Axis.vertical, //default
                            alignment: WrapAlignment.center,
                            children: [
                              Text("Approver",
                                  softWrap: true,
                                  style: TextStyle(fontSize: 12),
                                  textAlign: TextAlign.center),
                            ],
                          )),
                          numeric: false,

                          // onSort: (columnIndex, ascending) {
                          //   onSortColum(columnIndex, ascending);
                          //   setState(() {
                          //     sort = !sort;
                          //   });
                          // }
                        ),
                        DataColumn(
                          label: Center(
                              child: Wrap(
                            direction: Axis.vertical, //default
                            alignment: WrapAlignment.center,
                            children: [
                              Text("Status",
                                  softWrap: true,
                                  style: TextStyle(fontSize: 12),
                                  textAlign: TextAlign.center),
                            ],
                          )),
                          numeric: false,

                          // onSort: (columnIndex, ascending) {
                          //   onSortColum(columnIndex, ascending);
                          //   setState(() {
                          //     sort = !sort;
                          //   });
                          // }
                        ),
                      ],
                      rows: li2.items
                          .map(
                            (list) => DataRow(cells: [
                              DataCell(Center(
                                  child: Center(
                                child: Wrap(
                                    direction: Axis.vertical, //default
                                    alignment: WrapAlignment.center,
                                    children: [
                                      Text(
                                        list.apDetailsOrderby.toString(),
                                        textAlign: TextAlign.center,
                                      )
                                    ]),
                              ))),
                              DataCell(Center(
                                  child: Center(
                                child: Wrap(
                                    direction: Axis.vertical, //default
                                    alignment: WrapAlignment.center,
                                    children: [
                                      Text(list.urole.toString(),
                                          textAlign: TextAlign.center)
                                    ]),
                              ))),
                              DataCell(
                                Center(
                                    child: Center(
                                        child: Wrap(
                                            direction: Axis.vertical, //default
                                            alignment: WrapAlignment.center,
                                            children: [
                                      Text(list.assignby.toString(),
                                          textAlign: TextAlign.center)
                                    ]))),
                              ),
                              list.apStatus.toString() == "P"
                                  ? DataCell(
                                      Center(
                                          child: Center(
                                              child: Wrap(
                                                  direction:
                                                      Axis.vertical, //default
                                                  alignment:
                                                      WrapAlignment.center,
                                                  children: [
                                            Text("Pending",
                                                textAlign: TextAlign.center)
                                          ]))),
                                    )
                                  : DataCell(
                                      Center(
                                          child: Center(
                                              child: Wrap(
                                                  direction:
                                                      Axis.vertical, //default
                                                  alignment:
                                                      WrapAlignment.center,
                                                  children: [
                                            Text("Approved",
                                                textAlign: TextAlign.center)
                                          ]))),
                                    ),
                            ]),
                          )
                          .toList(),
                    ),
                  ),
                                SizedBox(
                    height: height / 4,
                  ),
                ],
              ),
            ),

     appBar: AppBar(
  title: Image.asset('logotitle.png',height: 40),
),
floatingActionButton: FloatingActionButton.extended(
  onPressed: () {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (context) => EmployeeDashboard(firsttime: false)),
          (Route<dynamic> route) => false,
    );
  },
  icon: Icon(Icons.dashboard_outlined),
  label: Text('Dashboard'),
  backgroundColor: Colors.red,
),
    );
  }

  onSortColum(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      if (ascending) {
        listplan.sort((a, b) => a.name.compareTo(b.name));
      } else {
        listplan.sort((a, b) => b.name.compareTo(a.name));
      }
    }
  }

  _onAddImageClick() async {
    image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) return image;

    // print("Uploaded Image: $_imageFile");
    // _imageFile.then((file) async {
    //   return file;
    // setState(() {
    //   files.add(file);
    //
    // });
    // });
  }

  getFileImage(file) {}
}

class PlanListClass {
  String name;
  String totalservices;

  PlanListClass({this.name, this.totalservices});

  static List<PlanListClass> getdata() {
    return <PlanListClass>[
      PlanListClass(name: "Below 1000L", totalservices: "1 "),
      PlanListClass(name: "1000L - 2000L", totalservices: "5"),
      PlanListClass(name: "Above 2000L", totalservices: "2"),
      PlanListClass(name: "2000L -  4000L ", totalservices: "6"),
    ];
  }
}

class PlanServiceYearClass {
  String serviceyear;
  String totalservices;
  String literprice;
  String fixedprice;

  PlanServiceYearClass(
      {this.serviceyear, this.totalservices, this.literprice, this.fixedprice});

  static List<PlanServiceYearClass> getdata() {
    return <PlanServiceYearClass>[
      PlanServiceYearClass(
          serviceyear: "1999"
              "",
          totalservices: "1 ",
          literprice: "10",
          fixedprice: "299"),
      PlanServiceYearClass(
          serviceyear: "2003",
          totalservices: "5",
          literprice: "10",
          fixedprice: "299"),
      PlanServiceYearClass(
          serviceyear: "2019",
          totalservices: "2",
          literprice: "10",
          fixedprice: "299"),
      PlanServiceYearClass(
          serviceyear: "2020",
          totalservices: "6",
          literprice: "10",
          fixedprice: "299"),
    ];
  }
}
