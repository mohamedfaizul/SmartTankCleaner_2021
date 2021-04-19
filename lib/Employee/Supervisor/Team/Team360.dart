import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:tankcare/Customer/register.dart';
import 'package:tankcare/CustomerModels/districtlist.dart';
import 'package:tankcare/CustomerModels/groupadd.dart';
import 'package:tankcare/Employee/Dashboard.dart';
import 'package:tankcare/Employee/EmployeeModels/ExpenseList/EmployeeExpenseDropdownModel.dart';
import 'package:tankcare/Employee/EmployeeModels/Team360/AGM360.dart';
import 'package:tankcare/Employee/EmployeeModels/Team360/Dvendor360.dart';
import 'package:tankcare/Employee/EmployeeModels/Team360/GM360.dart';
import 'package:tankcare/Employee/EmployeeModels/Team360/RM360.dart';
import 'package:tankcare/Employee/EmployeeModels/Team360/Supervisor360.dart';
import 'package:tankcare/Employee/EmployeeModels/Team360/Vendor360.dart';
import 'package:tankcare/Employee/Supervisor/Team/FranchiseView.dart';
import 'package:tankcare/RM%20models/getuser.dart';
import 'package:tankcare/RM%20models/userDesignation.dart';
import 'package:tankcare/Vendor/ServiceStation/ViewServiceStation.dart';
import 'package:tankcare/Vendor/Staff/VendorStaffView.dart';
import 'package:tankcare/VendorModels/StationVendorListings.dart';
import 'package:tankcare/string_values.dart';

class EmployeeTeam360 extends StatefulWidget {
  @override
  EmployeeTeam360State createState() => EmployeeTeam360State();
}

class EmployeeTeam360State extends State<EmployeeTeam360> {
  Set<Marker> markers = Set();
  String dropdownValueuser = "-- User Type --";
  String dropdownValuedes = "-- Designation --";
  bool isenable = true;
  static String roleid;

  String userid;
  bool cameramove = false;
  List<Object> images = List<Object>();
  Future<File> _imageFile;
  double latitudecamera, longitudecamera;
  List<String> items = List<String>.generate(7, (index) {
    return "Item - $index";
  });
  List<PlanListClass> listplan;
  var addressText;
  var first;
  static CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(11.127123, 78.656891),
    zoom: 14,
  );
  TextEditingController serviceyearcontroller = new TextEditingController();
  final TextEditingController _typeAheadController = TextEditingController();
  final TextEditingController _typeAheadController1 = TextEditingController();
  TextEditingController totalservicecontroller = new TextEditingController();
  TextEditingController DepositAmountController = new TextEditingController();
  TextEditingController literpricecontroller = new TextEditingController();
  TextEditingController fixedpricecontroller = new TextEditingController();
  TextEditingController CoverageRangeController = new TextEditingController();
  TextEditingController RemarkSumaryController = new TextEditingController();

  TextEditingController BillAmountController = new TextEditingController();
  TextEditingController AlertMobileController = new TextEditingController();
  TextEditingController EmailController = new TextEditingController();
  TextEditingController AccountNameController = new TextEditingController();
  TextEditingController AccountNoController = new TextEditingController();
  TextEditingController IFSCController = new TextEditingController();
  TextEditingController BankNameController = new TextEditingController();
  TextEditingController BranchNameController = new TextEditingController();

  List<PlanServiceYearClass> listplanyear;
  List<PlanListClass> selectedAvengers;
  bool sort;

  GetUserDesignation li3;

  String usertype;

  GM360model li;

  GM360model l360r10;
  AGM360Model l360r4;

  bool gmenable = false;

  var agmenable=false;
  var rmenable=false;

  RM360Model l360r5;

  bool vendorenable=false;

  Vendor360model l360r9;

  bool dvendorenable=false;

  DVendor360model l360r17;

  Supervisor360model l360r7;

  bool supervisorenable=false;
  Future<http.Response> getdesignation(dropvalue) async {
    if (dropvalue == "Employee")
      usertype = "EMP";
    else if (dropvalue == "Vendor")
      usertype = "VENDOR";
    else if (dropvalue == "District Vendor")
      usertype = "DVENDOR";
    else if (dropvalue == "Franchise") usertype = "FRANCHISE";
    var url = String_values.base_url + 'menu-role?rtype=' + usertype;
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
        li3 = GetUserDesignation.fromJson(json.decode(response.body));

        stringlist.clear();
        stringlist.add("-- Designation --");

        for (int i = 0; i < li3.values.length; i++)
          stringlist.add(li3.values[i].roleName);
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

  static String dropdownValue = '-- Select Gender --';
  List<String> stringlist = [
    "-- Designation --",
    "Tank",
    "Sump",
    "Sump-Tile",
    "Car",
    "Bike",
    "Floor"
  ];
  List<String> stringlist1 = [
    '-- Select District --',
    "Tank",
    "Sump",
    "Sump-Tile",
    "Car",
    "Bike",
    "Floor"
  ];

  String dropdownValue1 = '-- Select State --';
  int proprtytype = 0;
  List<Placemark> placemark;
  String dropdownValue2 = '-- Select District --';
  final dateFormatter = DateFormat('yyyy-MM-dd');
  String sql_dob_from;
  String sql_dob_to;
  TextEditingController datefromcontroller = new TextEditingController();
  TextEditingController datetocontroller = new TextEditingController();
  static List<String> friendsList = [null];
  static LatLng _initialPosition;
  TextEditingController BillNumberController = new TextEditingController();
  TextEditingController StationNameController = new TextEditingController();
  TextEditingController SizeControllerFrom = new TextEditingController();
  TextEditingController PincodeController = new TextEditingController();
  TextEditingController SizeControllerTo = new TextEditingController();
  Completer<GoogleMapController> _controller = Completer();
  var loading = false;
  Position position;
  TextEditingController GroupNameController = new TextEditingController();
  TextEditingController GroupNumberController = new TextEditingController();

  TextEditingController addressController = new TextEditingController();

  DistrictListings li1;
  Set<Circle> _circles = HashSet<Circle>();
  int statetype = 1;
  int districttype = 1;
  double radius = 500;
  GroupAdd li2;

  VendorListings li5;

  String shopid, empid;

  File image;

  Future<http.Response> postRequest() async {
    setState(() {
      loading = true;
    });

    var url = String_values.base_url + 'team-360/$roleid/$userid';
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
       if (roleid == "10") {
        l360r10 = GM360model.fromJson(json.decode(response.body));
        gmenable = true;
        agmenable = false;
        rmenable=false;
        vendorenable=false;
        dvendorenable=false;
        supervisorenable=false;
       }
      if (roleid == "4") {
        l360r4 = AGM360Model.fromJson(json.decode(response.body));
        gmenable = false;
        agmenable = true;
        rmenable=false;
        vendorenable=false;
        dvendorenable=false;
        supervisorenable=false;
      }
      if (roleid == "5") {
        l360r5 = RM360Model.fromJson(json.decode(response.body));
        gmenable = false;
        agmenable = false;
        rmenable=true;
        vendorenable=false;
        dvendorenable=false;
        supervisorenable=false;
      }
      if (roleid == "9") {
        l360r9 = Vendor360model.fromJson(json.decode(response.body));
        gmenable = false;
        agmenable = false;
        rmenable=false;
        vendorenable=true;
        dvendorenable=false;
        supervisorenable=false;
      }
      if (roleid == "17") {
        l360r17 = DVendor360model.fromJson(json.decode(response.body));
        gmenable = false;
        agmenable = false;
        rmenable=false;
        vendorenable=false;
        dvendorenable=true;
        supervisorenable=false;
      }
      if (roleid == "7") {
        l360r7 = Supervisor360model.fromJson(json.decode(response.body));
        gmenable = false;
        agmenable = false;
        rmenable=false;
        vendorenable=false;
        dvendorenable=false;
        supervisorenable=true;
      }
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

  void _setCircles(LatLng point) {
    _circles.add(Circle(
        circleId: CircleId("circleIdVal"),
        center: point,
        radius: double.parse(CoverageRangeController.text) * 100,
        fillColor: Colors.redAccent.withOpacity(0.2),
        strokeWidth: 3,
        strokeColor: Colors.redAccent));
  }

  void initState() {
    listplanyear = PlanServiceYearClass.getdata();
    List<PlanServiceYearClass> tags = PlanServiceYearClass.getdata();
    String jsonTags = jsonEncode(tags);
    // print("res:${jsonTags}");
//    print("response: ${PlanServiceYearClass.toJson()}");
    super.initState();
  }

  Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }


  String searchAddr;
  String station_assign_uid;
  DateTime _dateTime;
  List<File> files = [];
  List<File> files1 = [];

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
                          "Team 360",
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
                            "Choose Employee",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, color: Colors.red),
                          ),
                          children: [
                            SizedBox(
                              height: height / 50,
                            ),
                            Container(
                              height: 50,
                              margin:
                                  const EdgeInsets.only(left: 16, right: 16),
                              padding: const EdgeInsets.all(16),
                              decoration: new BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(2.0)),
                                  border:
                                      new Border.all(color: Colors.black38)),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  value: dropdownValueuser,
                                  onChanged: (String newValue) {
                                    if (newValue != "-- User Type --")
                                      getdesignation(newValue)
                                          .then((value) => setState(() {
                                                dropdownValueuser = newValue;
                                                dropdownValuedes =
                                                    "-- Designation --";
                                              }));
                                  },
                                  items: <String>[
                                    "-- User Type --",
                                    "Employee",
                                    "Vendor",
                                    "District Vendor",
                                    "Franchise"
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: height / 50,
                            ),
                            Container(
                              height: 50,
                              margin:
                                  const EdgeInsets.only(left: 16, right: 16),
                              padding: const EdgeInsets.all(16),
                              decoration: new BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(2.0)),
                                  border:
                                      new Border.all(color: Colors.black38)),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  value: dropdownValuedes,
                                  onChanged: (String newValue) {
                                    for (int i = 0; i < li3.values.length; i++)
                                      if (li3.values[i].roleName == newValue) {
                                        roleid = li3.values[i].roleId;
                                        print("roleid: ${roleid}");
                                      }

                                    setState(() {
                                      _typeAheadController1.text = "";
                                      dropdownValuedes = newValue;
                                    });
                                  },
                                  items: stringlist
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: TypeAheadFormField(
                                textFieldConfiguration: TextFieldConfiguration(
                                  enabled: true,
                                  controller: this._typeAheadController1,
                                  // onTap: ()
                                  // {
                                  //   Navigator.push(
                                  //       context,
                                  //       MaterialPageRoute(
                                  //           builder: (context) =>
                                  //               Category(userid:HomeState.userid,mapselection: true)));
                                  // },
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    labelText: 'Name',
                                    hintStyle: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16.0,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                  ),
                                ),
                                suggestionsCallback: (pattern) {
                                  return BackendService1.getSuggestions(
                                      pattern);
                                },
                                itemBuilder: (context, suggestion) {
                                  return ListTile(
                                    title: Text(suggestion),
                                  );
                                },
                                transitionBuilder:
                                    (context, suggestionsBox, controller) {
                                  return suggestionsBox;
                                },
                                onSuggestionSelected: (suggestion) {
                                  for (int i = 0;
                                      i < BackendService1.li1.items.length;
                                      i++)
                                    if (BackendService1.li1.items[i].uname ==
                                        suggestion) {
                                      userid = BackendService1.li1.items[i].uid;
                                      postRequest();
                                    }
                                  print(userid);
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
                                  this._typeAheadController1.text = suggestion;
                                },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please select a city';
                                  } else
                                    return 'nothing';
                                },
                                // onSaved: (value) => this._selectedCity = value,
                              ),
                            ),
                          ])),
                  Visibility(
  visible: gmenable,
  child:Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        width: width,
          color:Colors.red,
          child: Text("GM",style: TextStyle(color: Colors.white),),padding: EdgeInsets.all(16),
      ),
      SizedBox(height: 10),
      l360r10!=null?Padding(
        padding: const EdgeInsets.only(left:16.0,right:16.0,top:10),
        child: Text("Name : ${l360r10.data.gm.uname.toString()+'-'+l360r10.data.gm.ucode.toString()}"),
      ):Container(),
      l360r10!=null?Padding(
        padding: const EdgeInsets.only(left:16.0,right:16.0,top:10),
        child: Text("Mobile : ${l360r10.data.gm.uphone.toString()}"),
      ):Container(),
      // Text(l360r10.data.gm.uphone.toString()),
      //
      l360r10!=null?Container(
          margin: const EdgeInsets.only(top: 10),
          color: Colors.red.shade50,
          child: ExpansionTile(
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            backgroundColor: Colors.white,
            initiallyExpanded: false,
            title: Text(
              "AGM(${l360r10.data.agm.length})",
              style: TextStyle(
                  fontWeight: FontWeight.w600, color: Colors.red),
            ),
            children: [
          for(int i=0;i<l360r10.data.agm.length;i++)
            InkWell(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(l360r10.data.agm[i].ucode+'-'+l360r10.data.agm[i].uname,textAlign: TextAlign.start,),
              ),
              onTap: (){
                userid=l360r10.data.agm[i].uid;
                roleid="4";
postRequest();
                Fluttertoast.showToast(
                    msg: l360r10.data.agm[i].uname,
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.SNACKBAR,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0
                );
              },
            )
        ],)):Container(),
      l360r10!=null?Container(
          margin: const EdgeInsets.only(top: 10),
          color: Colors.red.shade50,
          child: ExpansionTile(
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            backgroundColor: Colors.white,
            initiallyExpanded: false,
            title: Text(
              "RM(${l360r10.data.rm.length})",
              style: TextStyle(
                  fontWeight: FontWeight.w600, color: Colors.red),
            ),
            children: [
              for(int i=0;i<l360r10.data.rm.length;i++)
                InkWell(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(l360r10.data.rm[i].ucode+'-'+l360r10.data.rm[i].uname,textAlign: TextAlign.start,),
                  ),
                  onTap: (){
                    userid=l360r10.data.rm[i].uid;
                    roleid="5";
                    postRequest();
                    Fluttertoast.showToast(
                        msg: l360r10.data.rm[i].uname,
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.SNACKBAR,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );
                  },
                )
            ],)):Container(),
      l360r10!=null?Container(
          margin: const EdgeInsets.only(top: 10),
          color: Colors.red.shade50,
          child: ExpansionTile(
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            backgroundColor: Colors.white,
            initiallyExpanded: false,
            title: Text(
              "FRANCHISE(${l360r10.data.franchise.length})",
              style: TextStyle(
                  fontWeight: FontWeight.w600, color: Colors.red),
            ),
            children: [
              for(int i=0;i<l360r10.data.franchise.length;i++)
                InkWell(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(l360r10.data.franchise[i].ucode+'-'+l360r10.data.franchise[i].uname,textAlign: TextAlign.start,),
                  ),
                  onTap: (){
                    // userid=l360r10.data.franchise[i].uid;
                    Navigator.push(context,MaterialPageRoute(builder: (context) => FranchiseView(id:l360r10.data.franchise[i].uid)));

                    Fluttertoast.showToast(
                        msg: l360r10.data.franchise[i].uname,
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.SNACKBAR,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );
                  },
                )
            ],)):Container(),
      l360r10!=null?Container(
          margin: const EdgeInsets.only(top: 10),
          color: Colors.red.shade50,
          child: ExpansionTile(
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            backgroundColor: Colors.white,
            initiallyExpanded: false,
            title: Text(
              "SUPERVISOR(${l360r10.data.superviser.length})",
              style: TextStyle(
                  fontWeight: FontWeight.w600, color: Colors.red),
            ),
            children: [
              for(int i=0;i<l360r10.data.superviser.length;i++)
                InkWell(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(l360r10.data.superviser[i].ucode+'-'+l360r10.data.superviser[i].uname,textAlign: TextAlign.start,),
                  ),
                  onTap: (){
                    userid=l360r10.data.superviser[i].uid;
                    roleid="7";
                    postRequest();
                    Fluttertoast.showToast(
                        msg: l360r10.data.superviser[i].uname,
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.SNACKBAR,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );
                  },
                )
            ],)):Container(),
      l360r10!=null?Container(
          margin: const EdgeInsets.only(top: 10),
          color: Colors.red.shade50,
          child: ExpansionTile(
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            backgroundColor: Colors.white,
            initiallyExpanded: false,
            title: Text(
              "SERVICER(${l360r10.data.servicer.length})",
              style: TextStyle(
                  fontWeight: FontWeight.w600, color: Colors.red),
            ),
            children: [
              for(int i=0;i<l360r10.data.servicer.length;i++)
                InkWell(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(l360r10.data.servicer[i].ucode+'-'+l360r10.data.servicer[i].uname,textAlign: TextAlign.start,),
                  ),
                  onTap: (){
                    userid=l360r10.data.servicer[i].uid;
                    roleid="14";
                    Fluttertoast.showToast(
                        msg: l360r10.data.servicer[i].uname,
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.SNACKBAR,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );
                  },
                )
            ],)):Container(),
      l360r10!=null?Container(
          margin: const EdgeInsets.only(top: 10),
          color: Colors.red.shade50,
          child: ExpansionTile(
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            backgroundColor: Colors.white,
            initiallyExpanded: false,
            title: Text(
              "Vendor(${l360r10.data.vendor.length})",
              style: TextStyle(
                  fontWeight: FontWeight.w600, color: Colors.red),
            ),
            children: [
              for(int i=0;i<l360r10.data.vendor.length;i++)
                InkWell(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(l360r10.data.vendor[i].ucode+'-'+l360r10.data.vendor[i].uname,textAlign: TextAlign.start,),
                  ),
                  onTap: (){
                    userid=l360r10.data.vendor[i].uid;
                    roleid="9";
                    postRequest();
                    Fluttertoast.showToast(
                        msg: l360r10.data.vendor[i].uname,
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.SNACKBAR,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );
                  },
                )
            ],)):Container(),
      // l360r10!=null?Container(
      //     margin: const EdgeInsets.only(top: 10),
      //     color: Colors.red.shade50,
      //     child: ExpansionTile(
      //       expandedCrossAxisAlignment: CrossAxisAlignment.start,
      //       backgroundColor: Colors.white,
      //       initiallyExpanded: false,
      //       title: Text(
      //         "SERVICER(${l360r10.data.servicer.length})",
      //         style: TextStyle(
      //             fontWeight: FontWeight.w600, color: Colors.red),
      //       ),
      //       children: [
      //         for(int i=0;i<l360r10.data.servicer.length;i++)
      //           InkWell(
      //             child: Padding(
      //               padding: const EdgeInsets.all(16.0),
      //               child: Text(l360r10.data.servicer[i].ucode+'-'+l360r10.data.servicer[i].uname,textAlign: TextAlign.start,),
      //             ),
      //             onTap: (){
      //               userid=l360r10.data.servicer[i].uid;
      //               roleid="14";
      //               Fluttertoast.showToast(
      //                   msg: l360r10.data.servicer[i].uname,
      //                   toastLength: Toast.LENGTH_SHORT,
      //                   gravity: ToastGravity.SNACKBAR,
      //                   timeInSecForIosWeb: 1,
      //                   backgroundColor: Colors.red,
      //                   textColor: Colors.white,
      //                   fontSize: 16.0
      //               );
      //             },
      //           )
      //       ],)):Container(),
      l360r10!=null?Container(
          margin: const EdgeInsets.only(top: 10),
          color: Colors.red.shade50,
          child: ExpansionTile(
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            backgroundColor: Colors.white,
            initiallyExpanded: false,
            title: Text(
              "IT(${l360r10.data.adminTeam.aDMIN.length})",
              style: TextStyle(
                  fontWeight: FontWeight.w600, color: Colors.red),
            ),
            children: [
              for(int i=0;i<l360r10.data.adminTeam.aDMIN.length;i++)
                InkWell(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(l360r10.data.adminTeam.aDMIN[i].ucode+'-'+l360r10.data.adminTeam.aDMIN[i].uname,textAlign: TextAlign.start,),
                  ),
                  onTap: (){
                    // userid=l360r10.data.adminTeam.aDMIN[i].uid;
                    // roleid="14";
                    Fluttertoast.showToast(
                        msg: l360r10.data.adminTeam.aDMIN[i].uname,
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.SNACKBAR,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );
                  },
                )
            ],)):Container(),
      l360r10!=null?l360r10.data.adminTeam.fINANCETEAM!=null?Container(
          margin: const EdgeInsets.only(top: 10),
          color: Colors.red.shade50,
          child: ExpansionTile(
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            backgroundColor: Colors.white,
            initiallyExpanded: false,
            title: Text(
              "FINANCE TEAM(${l360r10.data.adminTeam.fINANCETEAM.length})",
              style: TextStyle(
                  fontWeight: FontWeight.w600, color: Colors.red),
            ),
            children: [
              for(int i=0;i<l360r10.data.adminTeam.fINANCETEAM.length;i++)
                InkWell(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(l360r10.data.adminTeam.fINANCETEAM[i].ucode+'-'+l360r10.data.adminTeam.fINANCETEAM[i].uname,textAlign: TextAlign.start,),
                  ),
                  onTap: (){
                    userid=l360r10.data.adminTeam.fINANCETEAM[i].uid;
                    roleid="14";
                    Fluttertoast.showToast(
                        msg: l360r10.data.adminTeam.fINANCETEAM[i].uname,
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.SNACKBAR,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );
                  },
                )
            ],)):Container():Container(),
      l360r10!=null?l360r10.data.adminTeam.tECHNICIANTEAM!=null?Container(
          margin: const EdgeInsets.only(top: 10),
          color: Colors.red.shade50,
          child: ExpansionTile(
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            backgroundColor: Colors.white,
            initiallyExpanded: false,
            title: l360r10.data.adminTeam.tECHNICIANTEAM!=null?Text(
              "Maintanance(${l360r10.data.adminTeam.tECHNICIANTEAM.length})",
              style: TextStyle(
                  fontWeight: FontWeight.w600, color: Colors.red),
            ):Container(),
            children: [
              for(int i=0;i<l360r10.data.adminTeam.tECHNICIANTEAM.length;i++)
                InkWell(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(l360r10.data.adminTeam.tECHNICIANTEAM[i].ucode+'-'+l360r10.data.adminTeam.tECHNICIANTEAM[i].uname,textAlign: TextAlign.start,),
                  ),
                  onTap: (){
                    userid=l360r10.data.adminTeam.tECHNICIANTEAM[i].uid;
                    roleid="13";
                    Fluttertoast.showToast(
                        msg: l360r10.data.servicer[i].uname,
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.SNACKBAR,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );
                  },
                )
            ],)):Container():Container(),
    ],
  )
),
                  Visibility(
                      visible: agmenable,
                      child:Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: width,
                            color:Colors.red,
                            child: Text("AGM",style: TextStyle(color: Colors.white),),padding: EdgeInsets.all(16),
                          ),
                          SizedBox(height: 10),
                          l360r4!=null?Padding(
                            padding: const EdgeInsets.only(left:16.0,right:16.0,top:10),
                            child: Text("Name : ${l360r4.data.agm.uname.toString()+'-'+l360r4.data.agm.ucode.toString()}"),
                          ):Container(),
                          l360r4!=null?Padding(
                            padding: const EdgeInsets.only(left:16.0,right:16.0,top:10),
                            child: Text("Mobile : ${l360r4.data.agm.uphone.toString()}"),
                          ):Container(),
                          // Text(l360r4.data.gm.uphone.toString()),

                          l360r4!=null?Container(
                              margin: const EdgeInsets.only(top: 10),
                              color: Colors.red.shade50,
                              child: ExpansionTile(
                                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                                backgroundColor: Colors.white,
                                initiallyExpanded: false,
                                title: Text(
                                  "RM(${l360r4.data.rm.length})",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600, color: Colors.red),
                                ),
                                children: [
                                  for(int i=0;i<l360r4.data.rm.length;i++)
                                    InkWell(
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Text(l360r4.data.rm[i].ucode+'-'+l360r4.data.rm[i].uname,textAlign: TextAlign.start,),
                                      ),
                                      onTap: (){
                                        userid=l360r4.data.rm[i].uid;
                                        roleid="5";
                                        postRequest();
                                        Fluttertoast.showToast(
                                            msg: l360r4.data.rm[i].uname,
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.SNACKBAR,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            fontSize: 16.0
                                        );
                                      },
                                    )
                                ],)):Container(),
                          // l360r4!=null?Container(
                          //     margin: const EdgeInsets.only(top: 10),
                          //     color: Colors.red.shade50,
                          //     child: ExpansionTile(
                          //       expandedCrossAxisAlignment: CrossAxisAlignment.start,
                          //       backgroundColor: Colors.white,
                          //       initiallyExpanded: false,
                          //       title: Text(
                          //         "FRANCHISE(${l360r4.data.franchise.length})",
                          //         style: TextStyle(
                          //             fontWeight: FontWeight.w600, color: Colors.red),
                          //       ),
                          //       children: [
                          //         for(int i=0;i<l360r4.data.franchise.length;i++)
                          //           InkWell(
                          //             child: Padding(
                          //               padding: const EdgeInsets.all(16.0),
                          //               child: Text(l360r4.data.franchise[i].ucode+'-'+l360r4.data.franchise[i].uname,textAlign: TextAlign.start,),
                          //             ),
                          //             onTap: (){
                          //               Fluttertoast.showToast(
                          //                   msg: l360r4.data.franchise[i].uname,
                          //                   toastLength: Toast.LENGTH_SHORT,
                          //                   gravity: ToastGravity.SNACKBAR,
                          //                   timeInSecForIosWeb: 1,
                          //                   backgroundColor: Colors.red,
                          //                   textColor: Colors.white,
                          //                   fontSize: 16.0
                          //               );
                          //             },
                          //           )
                          //       ],)):Container(),
                          l360r4!=null?Container(
                              margin: const EdgeInsets.only(top: 10),
                              color: Colors.red.shade50,
                              child: ExpansionTile(
                                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                                backgroundColor: Colors.white,
                                initiallyExpanded: false,
                                title: Text(
                                  "SUPERVISOR(${l360r4.data.superviser.length})",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600, color: Colors.red),
                                ),
                                children: [
                                  for(int i=0;i<l360r4.data.superviser.length;i++)
                                    InkWell(
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Text(l360r4.data.superviser[i].ucode+'-'+l360r4.data.superviser[i].uname,textAlign: TextAlign.start,),
                                      ),
                                      onTap: (){
                                        userid=l360r4.data.superviser[i].uid;
                                        roleid="7";
                                        postRequest();
                                        Fluttertoast.showToast(
                                            msg: l360r4.data.superviser[i].uname,
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.SNACKBAR,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            fontSize: 16.0
                                        );
                                      },
                                    )
                                ],)):Container(),
                          l360r4!=null?Container(
                              margin: const EdgeInsets.only(top: 10),
                              color: Colors.red.shade50,
                              child: ExpansionTile(
                                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                                backgroundColor: Colors.white,
                                initiallyExpanded: false,
                                title: Text(
                                  "SERVICER(${l360r4.data.servicer.length})",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600, color: Colors.red),
                                ),
                                children: [
                                  for(int i=0;i<l360r4.data.servicer.length;i++)
                                    InkWell(
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Text(l360r4.data.servicer[i].ucode+'-'+l360r4.data.servicer[i].uname,textAlign: TextAlign.start,),
                                      ),
                                      onTap: (){
                                        Fluttertoast.showToast(
                                            msg: l360r4.data.servicer[i].uname,
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.SNACKBAR,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            fontSize: 16.0
                                        );
                                      },
                                    )
                                ],)):Container(),
                          l360r4!=null?Container(
                              margin: const EdgeInsets.only(top: 10),
                              color: Colors.red.shade50,
                              child: ExpansionTile(
                                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                                backgroundColor: Colors.white,
                                initiallyExpanded: false,
                                title: Text(
                                  "Vendor(${l360r4.data.vendor.length})",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600, color: Colors.red),
                                ),
                                children: [
                                  for(int i=0;i<l360r4.data.vendor.length;i++)
                                    InkWell(
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Text(l360r4.data.vendor[i].ucode+'-'+l360r4.data.vendor[i].uname,textAlign: TextAlign.start,),
                                      ),
                                      onTap: (){
                                        Fluttertoast.showToast(
                                            msg: l360r4.data.vendor[i].uname,
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.SNACKBAR,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            fontSize: 16.0
                                        );
                                      },
                                    )
                                ],)):Container(),
                        ],
                      )
                  ),
                  Visibility(
                      visible: rmenable,
                      child:Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: width,
                            color:Colors.red,
                            child: Text("RM",style: TextStyle(color: Colors.white),),padding: EdgeInsets.all(16),
                          ),
                          SizedBox(height: 10),
                          l360r5!=null?Padding(
                            padding: const EdgeInsets.only(left:16.0,right:16.0,top:10),
                            child: Text("Name : ${l360r5.data.rm.uname.toString()+'-'+l360r5.data.rm.ucode.toString()}"),
                          ):Container(),
                          l360r5!=null?Padding(
                            padding: const EdgeInsets.only(left:16.0,right:16.0,top:10),
                            child: Text("Mobile : ${l360r5.data.rm.uphone.toString()}"),
                          ):Container(),
                          // Text(l360r4.data.gm.uphone.toString()),

                          l360r5!=null?Container(
                              margin: const EdgeInsets.only(top: 10),
                              color: Colors.red.shade50,
                              child: ExpansionTile(
                                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                                backgroundColor: Colors.white,
                                initiallyExpanded: false,
                                title: Text(
                                  "FRANCHISE(${l360r5.data.franchise.length})",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600, color: Colors.red),
                                ),
                                children: [
                                  for(int i=0;i<l360r5.data.franchise.length;i++)
                                    InkWell(
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Text(l360r5.data.franchise[i].ucode+'-'+l360r5.data.franchise[i].uname,textAlign: TextAlign.start,),
                                      ),
                                      onTap: (){
                                        // userid=l360r10.data.franchise[i].uid;
                                        Navigator.push(context,MaterialPageRoute(builder: (context) => FranchiseView(id:l360r5.data.franchise[i].uid)));

                                        Fluttertoast.showToast(
                                            msg: l360r5.data.franchise[i].uname,
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.SNACKBAR,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            fontSize: 16.0
                                        );
                                      },
                                    )
                                ],)):Container(),
                          l360r5!=null?Container(
                              margin: const EdgeInsets.only(top: 10),
                              color: Colors.red.shade50,
                              child: ExpansionTile(
                                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                                backgroundColor: Colors.white,
                                initiallyExpanded: false,
                                title: Text(
                                  "SUPERVISOR(${l360r5.data.superviser.length})",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600, color: Colors.red),
                                ),
                                children: [
                                  for(int i=0;i<l360r5.data.superviser.length;i++)
                                    InkWell(
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Text(l360r5.data.superviser[i].ucode+'-'+l360r5.data.superviser[i].uname,textAlign: TextAlign.start,),
                                      ),
                                      onTap: (){
                                        Fluttertoast.showToast(
                                            msg: l360r5.data.superviser[i].uname,
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.SNACKBAR,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            fontSize: 16.0
                                        );
                                      },
                                    )
                                ],)):Container(),
                          l360r5!=null?Container(
                              margin: const EdgeInsets.only(top: 10),
                              color: Colors.red.shade50,
                              child: ExpansionTile(
                                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                                backgroundColor: Colors.white,
                                initiallyExpanded: false,
                                title: Text(
                                  "SERVICER(${l360r5.data.servicer.length})",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600, color: Colors.red),
                                ),
                                children: [
                                  for(int i=0;i<l360r5.data.servicer.length;i++)
                                    InkWell(
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Text(l360r5.data.servicer[i].ucode+'-'+l360r5.data.servicer[i].uname,textAlign: TextAlign.start,),
                                      ),
                                      onTap: (){
                                        Fluttertoast.showToast(
                                            msg: l360r5.data.servicer[i].uname,
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.SNACKBAR,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            fontSize: 16.0
                                        );
                                      },
                                    )
                                ],)):Container(),
                        ],
                      )
                  ),
                  Visibility(
                      visible: vendorenable,
                      child:Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: width,
                            color:Colors.red,
                            child: Text("Vendor",style: TextStyle(color: Colors.white),),padding: EdgeInsets.all(16),
                          ),
                          SizedBox(height: 10),
                          l360r9!=null?Padding(
                            padding: const EdgeInsets.only(left:16.0,right:16.0,top:10),
                            child: Text("Name : ${l360r9.data.vendor.uname.toString()+'-'+l360r9.data.vendor.ucode.toString()}"),
                          ):Container(),
                          l360r9!=null?Padding(
                            padding: const EdgeInsets.only(left:16.0,right:16.0,top:10),
                            child: Text("Mobile : ${l360r9.data.vendor.uphone.toString()}"),
                          ):Container(),
                          // Text(l360r4.data.gm.uphone.toString()),

                          l360r9!=null?Container(
                              margin: const EdgeInsets.only(top: 10),
                              color: Colors.red.shade50,
                              child: ExpansionTile(
                                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                                backgroundColor: Colors.white,
                                initiallyExpanded: false,
                                title: Text(
                                  "Vendor Staff(${l360r9.data.vendorStaff.length})",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600, color: Colors.red),
                                ),
                                children: [
                                  for(int i=0;i<l360r9.data.vendorStaff.length;i++)
                                    InkWell(
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Text(l360r9.data.vendorStaff[i].ucode+'-'+l360r9.data.vendorStaff[i].uname,textAlign: TextAlign.start,),
                                      ),
                                      onTap: (){
                                        // userid=l360r9.data.vendorStaff[i].uid;
                                        Navigator.push(context,MaterialPageRoute(builder: (context) => VendorStaffView(id:l360r9.data.vendorStaff[i].uid)));
                                        Fluttertoast.showToast(
                                            msg: l360r9.data.vendorStaff[i].uname,
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.SNACKBAR,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            fontSize: 16.0
                                        );
                                      },
                                    )
                                ],)):Container(),
                          l360r9!=null?Container(
                              margin: const EdgeInsets.only(top: 10),
                              color: Colors.red.shade50,
                              child: ExpansionTile(
                                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                                backgroundColor: Colors.white,
                                initiallyExpanded: false,
                                title: Text(
                                  "Station(${l360r9.data.serviceStation.length})",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600, color: Colors.red),
                                ),
                                children: [
                                  for(int i=0;i<l360r9.data.serviceStation.length;i++)
                                    InkWell(
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Text(l360r9.data.serviceStation[i].stationCode+'-'+l360r9.data.serviceStation[i].stationName,textAlign: TextAlign.start,),
                                      ),
                                      onTap: (){

                                        Navigator.push(context,MaterialPageRoute(builder: (context) => ViewServiceStation(id:l360r9.data.serviceStation[i].stationId)));

                                        Fluttertoast.showToast(
                                            msg: l360r9.data.serviceStation[i].stationName,
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.SNACKBAR,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            fontSize: 16.0
                                        );
                                      },
                                    )
                                ],)):Container(),
                        ],
                      )
                  ),
                  Visibility(
                      visible: dvendorenable,
                      child:Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: width,
                            color:Colors.red,
                            child: Text("DVendor",style: TextStyle(color: Colors.white),),padding: EdgeInsets.all(16),
                          ),
                          SizedBox(height: 10),
                          l360r17!=null?Padding(
                            padding: const EdgeInsets.only(left:16.0,right:16.0,top:10),
                            child: Text("Name : ${l360r17.data.dvendor.uname.toString()+'-'+l360r17.data.dvendor.ucode.toString()}"),
                          ):Container(),
                          l360r17!=null?Padding(
                            padding: const EdgeInsets.only(left:16.0,right:16.0,top:10),
                            child: Text("Mobile : ${l360r17.data.dvendor.uphone.toString()}"),
                          ):Container(),
                          // Text(l360r4.data.gm.uphone.toString()),

                          l360r17!=null?Container(
                              margin: const EdgeInsets.only(top: 10),
                              color: Colors.red.shade50,
                              child: ExpansionTile(
                                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                                backgroundColor: Colors.white,
                                initiallyExpanded: false,
                                title: Text(
                                  "Vendor(${l360r17.data.vendor.length})",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600, color: Colors.red),
                                ),
                                children: [
                                  for(int i=0;i<l360r17.data.vendor.length;i++)
                                    InkWell(
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Text(l360r17.data.vendor[i].ucode+'-'+l360r17.data.vendor[i].uname,textAlign: TextAlign.start,),
                                      ),
                                      onTap: (){
                                        userid=l360r17.data.vendor[i].uid;
                                        roleid="9";
                                        postRequest();
                                        Fluttertoast.showToast(
                                            msg: l360r17.data.vendor[i].uname,
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.SNACKBAR,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            fontSize: 16.0
                                        );
                                      },
                                    )
                                ],)):Container(),
                          l360r17!=null?Container(
                              margin: const EdgeInsets.only(top: 10),
                              color: Colors.red.shade50,
                              child: ExpansionTile(
                                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                                backgroundColor: Colors.white,
                                initiallyExpanded: false,
                                title: Text(
                                  "Servicer(${l360r17.data.servicer.length})",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600, color: Colors.red),
                                ),
                                children: [
                                  for(int i=0;i<l360r17.data.servicer.length;i++)
                                    InkWell(
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Text(l360r17.data.servicer[i].ucode+'-'+l360r17.data.servicer[i].uname,textAlign: TextAlign.start,),
                                      ),
                                      onTap: (){
                                        Fluttertoast.showToast(
                                            msg: l360r17.data.servicer[i].uname,
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.SNACKBAR,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            fontSize: 16.0
                                        );
                                      },
                                    )
                                ],)):Container(),
                          l360r17!=null?Container(
                              margin: const EdgeInsets.only(top: 10),
                              color: Colors.red.shade50,
                              child: ExpansionTile(
                                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                                backgroundColor: Colors.white,
                                initiallyExpanded: false,
                                title: Text(
                                  "Supervisor(${l360r17.data.superviser.length})",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600, color: Colors.red),
                                ),
                                children: [
                                  for(int i=0;i<l360r17.data.superviser.length;i++)
                                    InkWell(
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Text(l360r17.data.superviser[i].ucode+'-'+l360r17.data.superviser[i].uname,textAlign: TextAlign.start,),
                                      ),
                                      onTap: (){
                                        userid=l360r17.data.superviser[i].uid;
                                        roleid="7";
                                        postRequest();
                                        Fluttertoast.showToast(
                                            msg: l360r17.data.superviser[i].uname,
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.SNACKBAR,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            fontSize: 16.0
                                        );
                                      },
                                    )
                                ],)):Container(),
                          l360r17!=null?Container(
                              margin: const EdgeInsets.only(top: 10),
                              color: Colors.red.shade50,
                              child: ExpansionTile(
                                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                                backgroundColor: Colors.white,
                                initiallyExpanded: false,
                                title: Text(
                                  "Franchise(${l360r17.data.franchise.length})",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600, color: Colors.red),
                                ),
                                children: [
                                  for(int i=0;i<l360r17.data.franchise.length;i++)
                                    InkWell(
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Text(l360r17.data.franchise[i].ucode+'-'+l360r17.data.franchise[i].uname,textAlign: TextAlign.start,),
                                      ),
                                      onTap: (){
                                        userid=l360r17.data.franchise[i].uid;
                                        Navigator.push(context,MaterialPageRoute(builder: (context) => FranchiseView(id:userid)));

                                        Fluttertoast.showToast(
                                            msg: l360r17.data.franchise[i].uname,
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.SNACKBAR,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            fontSize: 16.0
                                        );
                                      },
                                    )
                                ],)):Container(),
                        ],
                      )
                  ),
                  Visibility(
                      visible: supervisorenable,
                      child:Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: width,
                            color:Colors.red,
                            child: Text("Supervisor",style: TextStyle(color: Colors.white),),padding: EdgeInsets.all(16),
                          ),
                          SizedBox(height: 10),
                          l360r7!=null?Padding(
                            padding: const EdgeInsets.only(left:16.0,right:16.0,top:10),
                            child: Text("Name : ${l360r7.data.superviser.uname.toString()+'-'+l360r7.data.superviser.ucode.toString()}"),
                          ):Container(),
                          l360r7!=null?Padding(
                            padding: const EdgeInsets.only(left:16.0,right:16.0,top:10),
                            child: Text("Mobile : ${l360r7.data.superviser.uphone.toString()}"),
                          ):Container(),
                          // Text(l360r4.data.gm.uphone.toString()),

                          l360r7!=null?Container(
                              margin: const EdgeInsets.only(top: 10),
                              color: Colors.red.shade50,
                              child: ExpansionTile(
                                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                                backgroundColor: Colors.white,
                                initiallyExpanded: false,
                                title: Text(
                                  "Servicer(${l360r7.data.servicer.length})",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600, color: Colors.red),
                                ),
                                children: [
                                  for(int i=0;i<l360r7.data.servicer.length;i++)
                                    InkWell(
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Text(l360r7.data.servicer[i].ucode+'-'+l360r7.data.servicer[i].uname,textAlign: TextAlign.start,),
                                      ),
                                      onTap: (){
                                        userid=l360r7.data.servicer[i].uid;
                                        Navigator.push(context,MaterialPageRoute(builder: (context) => VendorStaffView(id:userid)));
                                        Fluttertoast.showToast(
                                            msg: l360r7.data.servicer[i].uname,
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.SNACKBAR,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            fontSize: 16.0
                                        );
                                      },
                                    )
                                ],)):Container(),
                          l360r7!=null?Container(
                              margin: const EdgeInsets.only(top: 10),
                              color: Colors.red.shade50,
                              child: ExpansionTile(
                                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                                backgroundColor: Colors.white,
                                initiallyExpanded: false,
                                title: Text(
                                  "Station(${l360r7.data.serviceStation.length})",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600, color: Colors.red),
                                ),
                                children: [
                                  for(int i=0;i<l360r7.data.serviceStation.length;i++)
                                    InkWell(
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Text(l360r7.data.serviceStation[i].stationCode+'-'+l360r7.data.serviceStation[i].stationName,textAlign: TextAlign.start,),
                                      ),
                                      onTap: (){
                                        Navigator.push(context,MaterialPageRoute(builder: (context) => ViewServiceStation(id:l360r7.data.serviceStation[i].stationId)));

                                        Fluttertoast.showToast(
                                            msg: l360r7.data.serviceStation[i].stationName,
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.SNACKBAR,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            fontSize: 16.0
                                        );
                                      },
                                    )
                                ],)):Container(),
                        ],
                      )
                  ),
                  // Container(
                  //   padding: EdgeInsets.all(16),
                  //   width: width,
                  //   decoration: BoxDecoration(
                  //     color: Colors.white,
                  //     boxShadow: [
                  //       BoxShadow(
                  //         color: Colors.grey,
                  //         offset: Offset(0.0, 1.0), //(x,y)
                  //         blurRadius: 1.0,
                  //       ),
                  //     ],
                  //   ),
                  //   // color: Colors.white,
                  //   margin: EdgeInsets.only(top:10.0,bottom: 10),
                  //
                  //   child: new Text(
                  //     "Group",
                  //     textAlign: TextAlign.left,
                  //     style:
                  //         TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: height / 50,
                  // ),
                ],
              ),
            ),

      appBar: AppBar(
        title: Image.asset('logotitle.png', height: 40),
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


}

class BackendService1 {
  static GetUserDetails li1;

  static Future<List> getSuggestions(String query) async {
    var url = //'http://35.184.156.126.xip.io/cyberhome/home.php?username=kavin&query=table';
        String_values.base_url +
            'role-user-list?search=${query}&urole_id=' +
            EmployeeTeam360State.roleid;

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

class BackendService {
  static EmployeeExpenseDropdownModel li1;

  static Future<List> getSuggestions(String query) async {
    var url;

    url =
        //'http://35.184.156.126.xip.io/cyberhome/home.php?username=kavin&query=table';
        String_values.base_url + 'my-etype-list?search=' + query;
    var response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer ${RegisterPagesState.token}'
      },
    );
    if (response.statusCode == 200) {
      print(response.body);

      li1 = EmployeeExpenseDropdownModel.fromJson(json.decode(response.body));
      List<String> s = new List();
      if (li1.items.length == 0) {
        // return ["No details"];
      } else {
        for (int i = 0; i < li1.items.length; i++)
          s.add(li1.items[i].etypeName.toString());
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

class PlanListClass {
  String name;
  String totalservices;

  PlanListClass({this.name, this.totalservices});

  Map<String, dynamic> toJson() {
    return {
      'plan_name': name,
      'total_service': totalservices,
    };
  }

  static List<PlanListClass> getdata() {
    return <PlanListClass>[];
  }
}

class PlanServiceYearClass {
  String serviceyear;
  String totalservices;
  String literprice;
  String fixedprice;

  PlanServiceYearClass(
      {this.serviceyear, this.totalservices, this.literprice, this.fixedprice});

  Map<String, dynamic> toJson() {
    return {
      'service_year': serviceyear,
      'total_service': totalservices,
      'liter_price': literprice,
      'fixed_price': fixedprice
    };
  }

  static List<PlanServiceYearClass> getdata() {
    return <PlanServiceYearClass>[];
  }
}
