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
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:tankcare/Customer/register.dart';
import 'package:tankcare/CustomerModels/districtlist.dart';
import 'package:tankcare/CustomerModels/servicedetail.dart';
import 'package:tankcare/Employee/Dashboard.dart';
import 'package:tankcare/FINANCE%20TEAM/ApprovalList.dart';
import 'package:tankcare/RM%20models/DamageView.dart';
import 'package:tankcare/RM%20models/appviewlist.dart';
import 'package:tankcare/Vendor/Login/Login.dart';

import '../string_values.dart';

class DirectorDamageView extends StatefulWidget {
  DirectorDamageView({Key key, this.propertyid, this.apid});

  String propertyid;
  String apid;

  @override
  DirectorDamageViewState createState() => DirectorDamageViewState();
}

class DirectorDamageViewState extends State<DirectorDamageView> {
  bool loading = false;
  ServiceDetailListings li;

  List<File> files = [];
  var _kGooglePlex;
  Future<File> _imageFile;
  RMApprovalListingsView li2;

  DistrictListings li3;
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
    var url = String_values.base_url +
        'property-plan-services-view?serviceid=' +
        planid;
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
      li = ServiceDetailListings.fromJson(json.decode(response.body));
      setState(() {
        // ServiceByController.text=li.planServices.se

        PropertyNameController.text = li.property.propertyName.toString();
        GroupNameController.text = li.property.groupName.toString();
        // if (li.serviceType.toString() == "RES")
        //   ServiceController.text = "Residential";
        // else
        //   ServiceController.text = "Commercial";

        PropertyCodeController.text = li.property.propertyCode.toString();
        PropertyTypeController.text = li.property.propertyTypeName.toString();
        valuecontroller.text = li.property.mapLocation.toString();

        CusNameController.text = li.property.cusName.toString();
        CusCodeController.text = li.property.cusCode.toString();
        PhoneController.text = li.property.cusPhone.toString();
        GroupContactNameController.text =
            li.property.groupContactName.toString();
        GroupContactMobilController.text =
            li.property.groupContactPhone.toString();

        ServiceStartDateController.text =
            li.planServices.pserviceDate.toString();
        ServiceStatusController.text =
            li.planServices.pserviceServiceStatus.toString();
        if (li.planServices.pserviceStatus.toString() == "A")
          StatusController.text = "Active";
        else if (li.planServices.pserviceStatus.toString() == "P")
          StatusController.text = "Pending";
        ServiceStartAtController.text =
            li.planServices.pserviceStartAt.toString();
        ServiceEndAtController.text = li.planServices.pserviceEndAt.toString();
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

  Future<http.Response> damage(planid) async {
    setState(() {
      loading = true;
    });
    var url =
        String_values.base_url + 'service-damage-view?damage_id=' + planid;
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
      li4 = FranchaiseDamage.fromJson(json.decode(response.body));
      setState(() {
        // ServiceByController.text=li.planServices.se

        DamageCodeController.text = li4.items.damageCode;
        DamageStatusController.text = li4.items.damageStatus;
        DamageNoteController.text = li4.items.damageNote;
        DamageAmountController.text = li4.items.damageAmount;
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
        Uri.parse(String_values.base_url + 'approval-damage-claim-verify'));
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
            builder: (BuildContext context) => FinanceApprovalList(),
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
                            uploadImage(widget.apid, tblid, "a");
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

  Future<http.Response> apprdetails(planid) async {
    setState(() {
      loading = true;
    });
    var url = String_values.base_url + 'ap-verify-list/' + planid;
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
      li2 = RMApprovalListingsView.fromJson(json.decode(response.body));

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

  Future<http.Response> stateRequest() async {
    setState(() {
      loading = true;
    });

    var url = String_values.base_url + 'state-list?page=1&limit=50';
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
        li2 = RMApprovalListingsView.fromJson(json.decode(response.body));
        // stateController.text=li2.items[int.parse(li.stateId)-1].stateName;
      });
      // for(int i=0;i<li.items.length;i++)
      //   stringlist.add(li.items[i].stateName);
      //dropdownValue1=stringlist[0];

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

  List<String> items = List<String>.generate(7, (index) {
    return "Item - $index";
  });
  List<PlanListClass> listplan;
  TextEditingController OTPController = new TextEditingController();
  TextEditingController ClaimAmountController = new TextEditingController();
  TextEditingController StatusController = new TextEditingController();
  TextEditingController ServiceStatusController = new TextEditingController();
  TextEditingController ServiceStartDateController =
      new TextEditingController();
  TextEditingController DamageCodeController = new TextEditingController();
  TextEditingController DamageStatusController = new TextEditingController();
  TextEditingController DamageNoteController = new TextEditingController();
  TextEditingController DamageAmountController = new TextEditingController();
  TextEditingController ServiceByController = new TextEditingController();
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

  void initState() {
    damage(widget.propertyid)
        .then((value) => apprdetails(widget.apid))
        .then((value) => details(li4.items.serviceId));
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
                      margin: const EdgeInsets.only(top: 10),
                      color: Colors.red.shade50,
                      child: ExpansionTile(
                          backgroundColor: Colors.white,
                          initiallyExpanded: true,
                          title: Text(
                            "Damage Details",
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
                                controller: DamageCodeController,
                                decoration: InputDecoration(
                                  labelText: 'Damage Code',
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
                                controller: DamageNoteController,
                                decoration: InputDecoration(
                                  labelText: 'Damage Note',
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
                                controller: DamageAmountController,
                                decoration: InputDecoration(
                                  labelText: 'Damage Amount',
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
                            "Service Details",
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
                                controller: ServiceByController,
                                decoration: InputDecoration(
                                  labelText: 'Service By',
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
                                controller: ServiceStartDateController,
                                decoration: InputDecoration(
                                  labelText: 'Service Start Date',
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
                                controller: ServiceStatusController,
                                decoration: InputDecoration(
                                  labelText: 'Service Status',
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
                                controller: ServiceStartAtController,
                                decoration: InputDecoration(
                                  labelText: 'Service Start At',
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
                                controller: ServiceEndAtController,
                                decoration: InputDecoration(
                                  labelText: 'Service End At',
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
                                controller: StatusController,
                                decoration: InputDecoration(
                                  labelText: 'Status',
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
                            (li.planServices.pserviceServiceStatus.toString() ==
                                    "COMPLETED")
                                ? Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.0),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey,
                                          offset: Offset(0.0, 1.0), //(x,y)
                                          blurRadius: 2.0,
                                        ),
                                      ],
                                    ),
                                    // color: Colors.white,
                                    margin: EdgeInsets.all(3.0),
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            new Text(
                                              "Service Before Images",
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 14),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(),
                            (li.planServices.pserviceServiceStatus.toString() ==
                                    "COMPLETED")
                                ? Container(
                                    child: GridView.count(
                                      physics: ScrollPhysics(),
                                      shrinkWrap: true,
                                      crossAxisCount: 2,
                                      childAspectRatio: 1,
                                      children: List.generate(
                                        json
                                            .decode(li
                                                .planServices.pserviceBeforeImg)
                                            .length,
                                        (index) {
                                          return Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Card(
                                                  elevation: 5,
                                                  clipBehavior: Clip.antiAlias,
                                                  child: InkWell(
                                                    onTap: () {
                                                      showDialog(
                                                          context: context,
                                                          child: Image.network(
                                                              json.decode(li
                                                                      .planServices
                                                                      .pserviceBeforeImg)[
                                                                  index]));
                                                    },
                                                    child: Image.network(
                                                      json.decode(li
                                                              .planServices
                                                              .pserviceBeforeImg)[
                                                          index],
                                                      height: 300,
                                                      width: 300,
                                                    ),
                                                  )));
                                        },
                                      ),
                                    ),
                                  )
                                : Container(),
                            SizedBox(
                              height: height / 50,
                            ),
                            (li.planServices.pserviceServiceStatus.toString() ==
                                    "COMPLETED")
                                ? Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.0),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey,
                                          offset: Offset(0.0, 1.0), //(x,y)
                                          blurRadius: 2.0,
                                        ),
                                      ],
                                    ),
                                    // color: Colors.white,
                                    margin: EdgeInsets.all(3.0),
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            new Text(
                                              "Service After Images",
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 14),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(),
                            (li.planServices.pserviceServiceStatus.toString() ==
                                    "COMPLETED")
                                ? Container(
                                    child: GridView.count(
                                      physics: ScrollPhysics(),
                                      shrinkWrap: true,
                                      crossAxisCount: 2,
                                      childAspectRatio: 1,
                                      children: List.generate(
                                        json
                                            .decode(li
                                                .planServices.pserviceAfterImg)
                                            .length,
                                        (index) {
                                          return Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Card(
                                                  elevation: 5,
                                                  clipBehavior: Clip.antiAlias,
                                                  child: InkWell(
                                                    onTap: () {
                                                      showDialog(
                                                          context: context,
                                                          child: Image.network(
                                                              json.decode(li
                                                                      .planServices
                                                                      .pserviceAfterImg)[
                                                                  index]));
                                                    },
                                                    child: Image.network(
                                                      json.decode(li
                                                              .planServices
                                                              .pserviceAfterImg)[
                                                          index],
                                                      height: 300,
                                                      width: 300,
                                                    ),
                                                  )));
                                        },
                                      ),
                                    ),
                                  )
                                : Container(),
                          ])),

                  Container(
                      margin: const EdgeInsets.only(top: 10),
                      color: Colors.red.shade50,
                      child: ExpansionTile(
                          backgroundColor: Colors.white,
                          initiallyExpanded: false,
                          title: Text(
                            "Property Details",
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
                                controller: PropertyNameController,
                                decoration: InputDecoration(
                                  labelText: 'Property Name',
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
                                controller: GroupNameController,
                                decoration: InputDecoration(
                                  labelText: 'Group Name',
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
                                controller: PropertyCodeController,
                                decoration: InputDecoration(
                                  labelText: 'Property Code',
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
                                controller: PropertyTypeController,
                                decoration: InputDecoration(
                                  labelText: 'Property Type',
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
                              child: new TextFormField(
                                minLines: 3,
                                maxLines: 20,
                                enabled: false,
                                controller: valuecontroller,
                                decoration: InputDecoration(
                                  labelText: 'Location',
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
                  // Container(
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(5.0),
                  //     color: Colors.white,
                  //     boxShadow: [
                  //       BoxShadow(
                  //         color: Colors.grey,
                  //         offset: Offset(0.0, 1.0), //(x,y)
                  //         blurRadius: 2.0,
                  //       ),
                  //     ],
                  //   ),
                  //   // color: Colors.white,
                  //   margin: EdgeInsets.all(3.0),
                  //   child: Center(
                  //     child: Padding(
                  //       padding: const EdgeInsets.all(16.0),
                  //       child: Row(
                  //         mainAxisAlignment: MainAxisAlignment.start,
                  //         children: [
                  //           new Text(
                  //             "Photos",
                  //             textAlign: TextAlign.left,
                  //             style: TextStyle(
                  //                 fontWeight: FontWeight.bold,
                  //                 color: Colors.red,
                  //                 fontSize: 14),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // for(int i=0;i<json.decode(li.propertyImages).length;i++)
                  //   Padding(
                  //     padding: const EdgeInsets.all(18.0),
                  //     child: Container(
                  //         width:width/2,
                  //         child: Image.network(json.decode(li.propertyImages)[i])),
                  //   ),
                  Container(
                      margin: const EdgeInsets.only(top: 10),
                      color: Colors.red.shade50,
                      child: ExpansionTile(
                          backgroundColor: Colors.white,
                          initiallyExpanded: false,
                          title: Text(
                            "Customer Details",
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
                                controller: CusNameController,
                                decoration: InputDecoration(
                                  labelText: 'Customer Name',
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
                                controller: CusCodeController,
                                decoration: InputDecoration(
                                  labelText: 'Customer Code',
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
                                controller: PhoneController,
                                decoration: InputDecoration(
                                  labelText: 'Contact Mobile',
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
                                controller: GroupContactNameController,
                                decoration: InputDecoration(
                                  labelText: 'Group Contact Name',
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
                        DataColumn(
                          label: Center(
                              child: Wrap(
                            direction: Axis.vertical, //default
                            alignment: WrapAlignment.center,
                            children: [
                              Text("Actions",
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
                              DataCell(
                                (list.apStatus == "P" &&
                                        list.urole ==
                                            VendorLoginPagesState.Userrole)
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                              height: 30,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  color: Colors.red,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(50))),
                                              child: FlatButton(
                                                onPressed: () {
                                                  print("claim");
                                                  tblid = list.apTblId;
                                                  uploadImage(
                                                      widget.apid, tblid, "a");
                                                },
                                                child: Text(
                                                  "Approve",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              )),
                                          Container(width: 10),
                                          Container(
                                              height: 30,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  color: Colors.grey,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(50))),
                                              child: FlatButton(
                                                onPressed: () {
                                                  uploadImage(list.apId,
                                                      list.apTblId, "r");

                                                  check().then((value) {
                                                    if (value)
                                                      ;
                                                    else
                                                      showDialog<void>(
                                                        context: context,
                                                        barrierDismissible:
                                                            false, // user must tap button!
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                            title: Text(
                                                                "No Internet Connection"),
                                                            actions: <Widget>[
                                                              TextButton(
                                                                child:
                                                                    Text('OK'),
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                  });
                                                },
                                                child: Text(
                                                  "Reject",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              )),
                                        ],
                                      )
                                    : (list.apStatus == "A")
                                        ? Container(child: Text("-"))
                                        : Center(
                                            child: Container(
                                                child: Text("Not Assigned"))),
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