import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:tankcare/Customer/register.dart';
import 'package:tankcare/Employee/Dashboard.dart';
import 'package:tankcare/RM%20models/DamageView.dart';
import 'package:tankcare/RM%20models/getuser.dart';
import 'package:tankcare/Vendor/Login/Login.dart';
import 'package:tankcare/VendorModels/MachinetransferRole.dart';
import 'package:tankcare/VendorModels/RepairViewRepair.dart';
import 'package:tankcare/VendorModels/SpareRequestView.dart';
import 'package:tankcare/VendorModels/TransferIdand%20OTP.dart';

import '../../../string_values.dart';

class SpareRequestMachineTransfer extends StatefulWidget {
  SpareRequestMachineTransfer({Key key, this.machineid});

  String machineid;

  // String apid;
  @override
  SpareRequestMachineTransferState createState() =>
      SpareRequestMachineTransferState();
}

class SpareRequestMachineTransferState
    extends State<SpareRequestMachineTransfer> {
  bool loading = false;
  SpareRequestView li;

  List<File> files = [];
  var _kGooglePlex;
  Future<File> _imageFile;
  Repair li2;

  String usertype;

  MachineTransferRole li3;

  static String roleid;

  String userid;
  String tblid;
  String dropdownValue3 = '-Action-';

  num a;

  File image;

  var file;
  List<String> stringlist = ["-- Designation --"];
  final TextEditingController _typeAheadController = TextEditingController();
  int servicerating = 0;
  int servicerrating = 0;

  DateTime damageEndDate;

  bool damageenable = true;

  FranchaiseDamage li4;

  SPTranferandOTP li5;

  Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  Future<http.Response> getdesignation() async {
    var url = String_values.base_url + 'machine-assign-role';
    print(String_values.base_url);
    var response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer ${RegisterPagesState.token}'
      },
    );
    if (response.statusCode == 200) {
      setState(() {
        li3 = MachineTransferRole.fromJson(json.decode(response.body));

        stringlist.clear();
        stringlist.add("-- Designation --");

        for (int i = 0; i < li3.items.length; i++)
          stringlist.add(li3.items[i].roleName);
      });
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
        AssignbyController.text = li.data.reqby.toString();
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

  Future<int> machinerepairotp() async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer ${RegisterPagesState.token}'
    };

    var request = http.MultipartRequest(
        'POST', Uri.parse(String_values.base_url + 'machine-repair-otp'));
    //property_id plan_id pplan_name pplan_year pplan_service pplan_price pplan_tot_price pplan_start_date
    request.headers.addAll(headers);
    request.fields['repair_id'] = widget.machineid;
    request.fields['sp_tranfer_id'] = li5.spTransferId.toString();
    request.fields['transfer_otp'] = OTPController.text.toString();

    var response = await request.send();
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (BuildContext context) => RepairList(),
      //     ));
      return response.statusCode;
    });
  }

  Future<int> uploadImage(
    usertype,
    userid,
  ) async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer ${RegisterPagesState.token}'
    };

    var request = http.MultipartRequest(
        'POST', Uri.parse(String_values.base_url + 'machine-transfer'));
    //property_id plan_id pplan_name pplan_year pplan_service pplan_price pplan_tot_price pplan_start_date
    request.headers.addAll(headers);
    request.fields['tbl_id'] = "1";
    request.fields['machine_id'] = widget.machineid;
    request.fields['receiver_uid'] = userid;
    request.fields['receiver_utype'] = usertype;
    request.fields['sender_uid'] = VendorLoginPagesState.Userrole;
    request.fields['sender_utype'] = RegisterPagesState.cus_id;
    request.fields['machine_transfer_type'] = "REPAIR";
    print(VendorLoginPagesState.Userrole);
    print(RegisterPagesState.cus_id);
    var response = await request.send();
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
      li5 = SPTranferandOTP.fromJson(json.decode(value));
      if (value.contains("true")) {
        showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                "Receiver OTP",
                style: TextStyle(color: Colors.red),
              ),
              content: TextField(
                enabled: true,
                controller: OTPController,
                decoration: InputDecoration(
                  labelText: 'Receiver OTP',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 16.0,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    check().then((value) {
                      if (value) {
                        if (OTPController.text.length > 0)
                          machinerepairotp();
                        else
                          showDialog<void>(
                            context: context,
                            barrierDismissible: false, // user must tap button!
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Start Otp cannot be Empty"),
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
      }
      return response.statusCode;
    });
  }

  List<String> items = List<String>.generate(7, (index) {
    return "Item - $index";
  });
  TextEditingController OTPController = new TextEditingController();
  TextEditingController ClaimAmountController = new TextEditingController();
  TextEditingController StatusController = new TextEditingController();
  TextEditingController RepairStatusController = new TextEditingController();
  TextEditingController SpareNoteController = new TextEditingController();
  TextEditingController DamageCodeController = new TextEditingController();
  TextEditingController DamageStatusController = new TextEditingController();
  TextEditingController DamageNoteController = new TextEditingController();

  TextEditingController SpareCodeController = new TextEditingController();
  TextEditingController RepairChargeController = new TextEditingController();
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
    details(widget.machineid).then((value) => getdesignation());
    super.initState();
  }

  String searchAddr;

  DateTime _dateTime;
  String dropdownValueuser = "-- User Type --";
  String dropdownValuedes = "-- Designation --";

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
                          initiallyExpanded: false,
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
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
                              child: new TextField(
                                enabled: false,
                                controller: AssignbyController,
                                decoration: InputDecoration(
                                  labelText: 'Assigned Name',
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
                  SizedBox(
                    height: height / 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50))),
                          child: FlatButton(
                            onPressed: () {
                              check().then((value) {
                                setState(() {
                                  dropdownValueuser = "-- User Type --";
                                  dropdownValuedes = "-- Designation --";
                                  _typeAheadController.text = "";
                                });

                                showDialog<void>(
                                  context: context,
                                  barrierDismissible:
                                      false, // user must tap button!
                                  builder: (context) {
                                    return StatefulBuilder(builder:
                                        (context, StateSetter setState) {
                                      return AlertDialog(
                                          title: Text(
                                            "Choose Sender",
                                            style: TextStyle(color: Colors.red),
                                          ),
                                          content: loading
                                              ? Center(
                                                  child:
                                                      CircularProgressIndicator())
                                              : SingleChildScrollView(
                                                  child: Column(
                                                    children: [
                                                      StatefulBuilder(builder:
                                                          (context, setState) {
                                                        return Container(
                                                          height: 50,
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 20.0,
                                                                  right: 20.0),
                                                          decoration: new BoxDecoration(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          15.0)),
                                                              border: new Border
                                                                      .all(
                                                                  color: Colors
                                                                      .black38)),
                                                          child:
                                                              DropdownButtonHideUnderline(
                                                            child:
                                                                DropdownButton<
                                                                    String>(
                                                              isExpanded: true,
                                                              value:
                                                                  dropdownValuedes,
                                                              onChanged: (String
                                                                  newValue) {
                                                                for (int i = 0;
                                                                    i <
                                                                        li3.items
                                                                            .length;
                                                                    i++)
                                                                  if (li3
                                                                          .items[
                                                                              i]
                                                                          .roleName ==
                                                                      newValue) {
                                                                    roleid = li3
                                                                        .items[
                                                                            i]
                                                                        .roleId;
                                                                    print(
                                                                        "roleid: ${roleid}");
                                                                  }

                                                                setState(() {
                                                                  _typeAheadController
                                                                      .text = "";
                                                                  dropdownValuedes =
                                                                      newValue;
                                                                });
                                                              },
                                                              items: stringlist.map<
                                                                  DropdownMenuItem<
                                                                      String>>((String
                                                                  value) {
                                                                return DropdownMenuItem<
                                                                    String>(
                                                                  value: value,
                                                                  child: Text(
                                                                    value,
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .red),
                                                                  ),
                                                                );
                                                              }).toList(),
                                                            ),
                                                          ),
                                                        );
                                                      }),
                                                      SizedBox(
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height /
                                                              50),
                                                      TypeAheadFormField(
                                                        textFieldConfiguration:
                                                            TextFieldConfiguration(
                                                          enabled: true,
                                                          controller: this
                                                              ._typeAheadController,
                                                          // onTap: ()
                                                          // {
                                                          //   Navigator.push(
                                                          //       context,
                                                          //       MaterialPageRoute(
                                                          //           builder: (context) =>
                                                          //               Category(userid:HomeState.userid,mapselection: true)));
                                                          // },
                                                          keyboardType:
                                                              TextInputType
                                                                  .text,
                                                          decoration:
                                                              InputDecoration(
                                                            labelText:
                                                                'Choose User Name',
                                                            hintStyle:
                                                                TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontSize: 16.0,
                                                            ),
                                                            border:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15.0),
                                                            ),
                                                          ),
                                                        ),
                                                        suggestionsCallback:
                                                            (pattern) {
                                                          return BackendService
                                                              .getSuggestions(
                                                                  pattern);
                                                        },
                                                        itemBuilder: (context,
                                                            suggestion) {
                                                          return ListTile(
                                                            title: Text(
                                                                suggestion),
                                                          );
                                                        },
                                                        transitionBuilder:
                                                            (context,
                                                                suggestionsBox,
                                                                controller) {
                                                          return suggestionsBox;
                                                        },
                                                        onSuggestionSelected:
                                                            (suggestion) {
                                                          for (int i = 0;
                                                              i <
                                                                  BackendService
                                                                      .li1
                                                                      .items
                                                                      .length;
                                                              i++)
                                                            if (BackendService
                                                                    .li1
                                                                    .items[i]
                                                                    .uname ==
                                                                suggestion) {
                                                              userid =
                                                                  BackendService
                                                                      .li1
                                                                      .items[i]
                                                                      .uid;
                                                              usertype =
                                                                  BackendService
                                                                      .li1
                                                                      .items[i]
                                                                      .utype;
                                                              print(userid);
                                                              print(usertype);
                                                            }
                                                          // postRequest(suggestion);
                                                          // for(int i=0;i<BackendService.li1.items.length;i++)
                                                          // {
                                                          //   print(BackendService.li1.items[i].groupName);
                                                          //   if (BackendService.li1.items[i].groupName == suggestion) {
                                                          //     groupid=BackendService.li1.items[i].groupId.toString();
                                                          //     if(BackendService.li1.items[i].serviceType.toString()=="RES")
                                                          //       ServiceController.text = "Residential";
                                                          //     else
                                                          //       ServiceController.text = "Commercial";
                                                          //   }
                                                          // }
                                                          this
                                                              ._typeAheadController
                                                              .text = suggestion;
                                                        },
                                                        validator: (value) {
                                                          if (value.isEmpty) {
                                                            return 'Please select a city';
                                                          } else
                                                            return 'nothing';
                                                        },
                                                        // onSaved: (value) => this._selectedCity = value,
                                                      ),
                                                      // Padding(
                                                      //   padding: const EdgeInsets.all(8.0),
                                                      //   child: Text('Total Amount : ${totalamount}'),
                                                      // ),

                                                      SizedBox(
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height /
                                                              50),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(10.0),
                                                            child: Container(
                                                                width: MediaQuery
                                                                            .of(
                                                                                context)
                                                                        .size
                                                                        .width /
                                                                    4,
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                decoration: BoxDecoration(
                                                                    color: Colors
                                                                        .red,
                                                                    borderRadius:
                                                                        BorderRadius.all(Radius.circular(
                                                                            25))),
                                                                child:
                                                                    FlatButton(
                                                                  onPressed:
                                                                      () {
                                                                    if (dropdownValuedes !=
                                                                            "-- Designation --" &&
                                                                        this._typeAheadController.text.length !=
                                                                            0)
                                                                      uploadImage(
                                                                              usertype,
                                                                              userid)
                                                                          .then((value) =>
                                                                              Navigator.pop(context));
                                                                    else
                                                                      Fluttertoast.showToast(
                                                                          msg:
                                                                              "Please provide required details",
                                                                          toastLength: Toast
                                                                              .LENGTH_SHORT,
                                                                          gravity: ToastGravity
                                                                              .SNACKBAR,
                                                                          timeInSecForIosWeb:
                                                                              1,
                                                                          backgroundColor: Colors
                                                                              .red,
                                                                          textColor: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              16.0);
                                                                  },
                                                                  child: Text(
                                                                    "Save",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                )),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(10.0),
                                                            child: Container(
                                                                width: MediaQuery
                                                                            .of(
                                                                                context)
                                                                        .size
                                                                        .width /
                                                                    4,
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                decoration: BoxDecoration(
                                                                    color: Colors
                                                                        .grey,
                                                                    borderRadius:
                                                                        BorderRadius.all(Radius.circular(
                                                                            25))),
                                                                child:
                                                                    FlatButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child: Text(
                                                                    "Cancel",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                )),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ));
                                    });
                                  },
                                );

                                if (value)
                                  ;
                                // Navigator.pushReplacement(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) =>
                                //             GroupEdit(
                                //                 groupid: list
                                //                     .groupId)));
                                else
                                  showDialog<void>(
                                    context: context,
                                    barrierDismissible:
                                        false, // user must tap button!
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
                            },
                            child: Text(
                              "Machine Transfer",
                              style: TextStyle(color: Colors.white),
                            ),
                          )),
                      Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50))),
                          child: FlatButton(
                            onPressed: () {},
                            child: Text(
                              "Cancel",
                              style: TextStyle(color: Colors.white),
                            ),
                          )),
                    ],
                  ),
                  SizedBox(
                    height: height / 50,
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
}

class BackendService {
  static GetUserDetails li1;

  static Future<List> getSuggestions(String query) async {
    var url = //'http://35.184.156.126.xip.io/cyberhome/home.php?username=kavin&query=table';
        String_values.base_url +
            'role-user-list?search=${query}&urole_id=' +
            SpareRequestMachineTransferState.roleid;

    var response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer ${RegisterPagesState.token}'
      },
    );
    if (response.statusCode == 200) {
      print(response.body);
      li1 = GetUserDetails.fromJson(json.decode(response.body));
      List<String> s = new List();
      if (li1.items.length == 0) {
        // return ["No details"];
      } else {
        for (int i = 0; i < li1.items.length; i++)
          s.add(li1.items[i].uname.toString());
        print(s);
        return s;
      }
      // }
      // else {
      //
      //   print("not contains list");
      //   //return "" as List;
      // }

      //["result"];
      // print(json.decode(response.body)["result"]["categoryName"]);
    } else {
      print("Retry");
    }
  }
}
