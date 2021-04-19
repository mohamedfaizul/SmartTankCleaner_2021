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
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:tankcare/Customer/register.dart';
import 'package:tankcare/CustomerModels/districtlist.dart';
import 'package:tankcare/CustomerModels/groupadd.dart';
import 'package:tankcare/Employee/Dashboard.dart';
import 'package:tankcare/Employee/EmployeeModels/ExpenseList/EmployeeExpenseDetail.dart';
import 'package:tankcare/Employee/EmployeeModels/ExpenseList/EmployeeExpenseDropdownModel.dart';
import 'package:tankcare/Employee/Supervisor/Expense/EmployeeExpenseList.dart';
import 'package:tankcare/RM%20models/getuser.dart';
import 'package:tankcare/RM%20models/userDesignation.dart';
import 'package:tankcare/Vendor/Staff/VendorStaffList.dart';
import 'package:tankcare/string_values.dart';

class EmployeeEditExpenseType extends StatefulWidget {
  EmployeeEditExpenseType({Key key, this.id});

  String id;

  @override
  EmployeeEditExpenseTypeState createState() => EmployeeEditExpenseTypeState();
}

class EmployeeEditExpenseTypeState extends State<EmployeeEditExpenseType> {
  Set<Marker> markers = Set();
  bool isenable = true;
  bool cameramove = false;
  List<Object> images = List<Object>();
  Future<File> _imageFile;
  String dropdownValueuser = "-- User Type --";
  String dropdownValuedes = "-- Designation --";

  String usertype;
  String userid;
  GetUserDesignation li3;
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
  static String roleid;
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
    "-- Designation --",
    "Tank",
    "Sump",
    "Sump-Tile",
    "Car",
    "Bike",
    "Floor"
  ];

  Future<http.Response> deleteimage(String imgId) async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer ${RegisterPagesState.token}}'
    };
    var request = http.MultipartRequest(
        'POST', Uri.parse(String_values.base_url + 'img-delete'));
    request.headers.addAll(headers);
    request.fields['img_id'] = imgId;
    var res = await request.send();
    print(res.statusCode);
  }

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

  EmployeeExpenseDetailsModel li5;

  String shopid, empid;

  File image;

  Future<http.Response> details(planid) async {
    setState(() {
      loading = true;
    });
    var url = String_values.base_url + 'expense-details/' + planid;
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
      li5 = EmployeeExpenseDetailsModel.fromJson(json.decode(response.body));
      setState(() {
        datefromcontroller.text =   DateFormat('dd/MM/yyyy').format(
            DateTime.parse(li5.items.expenseDate.toString()));
        _typeAheadController.text = li5.items.etypeName.toString();
        BillNumberController.text = li5.items.billNumber.toString();
        BillAmountController.text = li5.items.expenseAmount.toString();
        RemarkSumaryController.text = li5.items.expenseRemark.toString();
        if (li5.items.expenseUtype == "EMP")
          dropdownValueuser="Employee";
        else if (li5.items.expenseUtype == "VENDOR")
          dropdownValueuser = "Vendor";
        else if (li5.items.expenseUtype == "DVENDOR")
          dropdownValueuser = "District Vendor";
        else if (li5.items.expenseUtype == "FRANCHISE") dropdownValueuser = "FRANCHISE";
        usertype=li5.items.expenseUtype;
        getdesignation(dropdownValueuser).then((value) => dropdownValuedes=li5.items.roleName);
        _typeAheadController1.text=li5.items.expenseBy;
        roleid=li5.items.expenseUroleId;
userid=li5.items.expenseUid;
shopid=li5.items.etypeId;
sql_dob_from=li5.items.expenseDate;
        // ShopDepositController.text = li5.values.shopDeposit.toString();
        // addressController.text = li5.values.shopAddress.toString();
        // StateController.text=li5.values.stateName.toString();
        // DistrictController.text=li5.values.districtName.toString();
        // OwnerNameController.text = li5.values.shopOwnerName.toString();
        // OwnerPhoneController.text = li5.values.shopOwnerPhone.toString();
        // datefromcontroller.text=li5.values.shopCStartDate.toString();
        // ContractYearsController.text=li5.values.shopCYears.toString();
        // PincodeController.text = li5.values.shopPincode.toString();
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
    details(widget.id);
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



  Future<http.Response> districtRequest(stateid) async {
    var url = String_values.base_url + 'district/' + stateid;
    var response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer ${RegisterPagesState.token}'
      },
    );
    if (response.statusCode == 200) {
      setState(() {
        li1 = DistrictListings.fromJson(json.decode(response.body));
        stringlist1.clear();

        stringlist1.add('-- Select District --');
        for (int i = 0; i < li1.items.length; i++)
          stringlist1.add(li1.items[i].districtName);
      });

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

  Future<void> _currentposition() async {
    position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    placemark = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);
    final coordinates = new Coordinates(position.latitude, position.longitude);
    addressText =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    this.first = addressText.first;
    print("test" "${this.first.featureName} : ${this.first.addressLine}");
    setState(() {
      _initialPosition = LatLng(position.latitude, position.longitude);
      Marker resultMarker = Marker(
        //  onTap: (){Navigator.push(context,MaterialPageRoute(builder: (context) => MapSample()));},

        markerId: MarkerId("I'm Here"),

        draggable: true,

        onDragEnd: ((value) async {
          placemark = await Geolocator()
              .placemarkFromCoordinates(value.latitude, value.longitude);
          //   print("Full Address - " + address.toString());
          print("dragged" + value.latitude.toString());

          final coordinates =
              new Coordinates(position.latitude, position.longitude);
          addressText =
              await Geocoder.local.findAddressesFromCoordinates(coordinates);
          this.first = addressText.first;
          print("test" "${this.first.featureName} : ${this.first.addressLine}");
          setState(() {
            _kGooglePlex = CameraPosition(
                // bearing: 192.8334901395799,
                target: LatLng(value.latitude, value.longitude),
                zoom: 12);
            addressController.text = "";
            if (this.first != "")
              addressController.text = '${this.first.addressLine}';
            // if (placemark[0].subLocality != "")
            //   addressController.text =
            //       addressController.text + " ${placemark[0].subLocality}, ";
            // if (placemark[0].locality != "")
            //   addressController.text =
            //       addressController.text + " ${placemark[0].locality}, ";
            // if (placemark[0].subAdministrativeArea != "")
            //   addressController.text = addressController.text +
            //       " ${placemark[0].subAdministrativeArea}, ";
            // if (placemark[0].administrativeArea != "")
            //   addressController.text = addressController.text +
            //       " ${placemark[0].administrativeArea}, ";
            // if (placemark[0].country != "")
            //   addressController.text =
            //       addressController.text + " ${placemark[0].country}";
          });
          // print(value.longitude);
        }),

        position: LatLng(position.latitude, position.longitude),
      );
      markers.add(resultMarker);
      // print('${placemark[0].name}');
      // print('${placemark[0].locality}');
      // print('${placemark[0].administrativeArea}');
      print('${placemark[0].postalCode}');
      print('${this.first.addressLine}');

      addressController.text = "";
      if (this.first != "")
        addressController.text = '${this.first.addressLine}';
      // if (placemark[0].subLocality != "")
      //   addressController.text =
      //       addressController.text + " ${placemark[0].subLocality}, ";
      // if (placemark[0].locality != "")
      //   addressController.text =
      //       addressController.text + " ${placemark[0].locality}, ";
      // if (placemark[0].subAdministrativeArea != "")
      //   addressController.text =
      //       addressController.text + " ${placemark[0].subAdministrativeArea}, ";
      // if (placemark[0].administrativeArea != "")
      //   addressController.text =
      //       addressController.text + " ${placemark[0].administrativeArea}, ";
      // if (placemark[0].country != "")
      //   addressController.text =
      //       addressController.text + " ${placemark[0].country}";
    });
    GoogleMapController controller = await _controller.future;
    _kGooglePlex = CameraPosition(
        // bearing: 192.8334901395799,
        target: LatLng(position.latitude, position.longitude),
        zoom: 12);
    print(position.latitude);
    print(position.longitude);
    controller.moveCamera(CameraUpdate.newCameraPosition(_kGooglePlex));
  }

  String searchAddr;
  String station_assign_uid;
  DateTime _dateTime;
  List<File> files = [];
  List<File> files1 = [];

  @override
  Widget build(BuildContext context) {
    Future<int> uploadImage() async {
      setState(() {
        loading = true;
      });
      String servicetype;
      if (dropdownValue == "Vendor")
        servicetype = "VENDOR";
      else if (dropdownValue == "Supervisor") servicetype = "EMP";
      Map<String, String> headers = {
        "Content-Type": "application/json",
        'Authorization': 'Bearer ${RegisterPagesState.token}'
      };

      var request = http.MultipartRequest(
          'POST', Uri.parse(String_values.base_url + 'expense-save'));
      //property_id plan_id pplan_name pplan_year pplan_service pplan_price pplan_tot_price pplan_start_date
      request.headers.addAll(headers);
      for (int i = 0; i < files.length; i++) {
        request.files.add(
            await http.MultipartFile.fromPath('bill_image[]', files[i].path));
        print(files[i].path);
      }

      request.fields['etype_id'] = shopid;
      request.fields['expense_id'] = widget.id;
      request.fields['expense_date'] = sql_dob_from;
      request.fields['expense_amount'] = BillAmountController.text;
      request.fields['expense_remark'] = RemarkSumaryController.text;
      request.fields['bill_number'] = BillNumberController.text;
      request.fields['expense_urole_id']=roleid;
      request.fields['expense_uid']=userid;
      request.fields['expense_utype']= usertype;
      var response = await request.send();
      response.stream.transform(utf8.decoder).listen((value) {
        print(value);

        if (value.contains("true")) {
          setState(() {
            loading = false;
          });
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => EmployeeEXPENSEList()));
        } else {
          Fluttertoast.showToast(
              msg: "Please Check Details",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.SNACKBAR,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }
        return response.statusCode;
      });
    }

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
                          "Add Expense Type",
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
                            "Expensive Details",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, color: Colors.red),
                          ),
                          children: [
                            SizedBox(
                              height: height / 50,
                            ),
                            Container(
                              height:
                              50,
                              margin: const EdgeInsets
                                  .only(left:16,right:16),
                              padding: const EdgeInsets
                                  .all(
                                  16),
                              decoration: new BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(
                                      2.0)),
                                  border:
                                  new Border.all(color: Colors.black38)),
                              child:
                              DropdownButtonHideUnderline(
                                child: DropdownButton<
                                    String>(
                                  isExpanded:
                                  true,
                                  value:
                                  dropdownValueuser,
                                  onChanged:
                                      (String newValue) {
                                    if (newValue !=
                                        "-- User Type --")
                                      getdesignation(newValue).then((value) => setState(() {
                                        dropdownValueuser = newValue;
                                        dropdownValuedes = "-- Designation --";
                                      }));
                                  },
                                  items: <
                                      String>[
                                    "-- User Type --",
                                    "Employee",
                                    "Vendor",
                                    "District Vendor",
                                    "Franchise"
                                  ].map<DropdownMenuItem<String>>((String
                                  value) {
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
                              height:
                              50,
                              margin: const EdgeInsets
                                  .only(left:16,right:16),
                              padding: const EdgeInsets.all(
                                  16),
                              decoration: new BoxDecoration(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(2.0)),
                                  border: new Border.all(color: Colors.black38)),
                              child:
                              DropdownButtonHideUnderline(
                                child:
                                DropdownButton<String>(
                                  isExpanded:
                                  true,
                                  value:
                                  dropdownValuedes,
                                  onChanged:
                                      (String newValue) {
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
                                  items:
                                  stringlist.map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),),


                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: TypeAheadFormField(
                                textFieldConfiguration:
                                TextFieldConfiguration(
                                  enabled:
                                  true,
                                  controller:
                                  this._typeAheadController1,
                                  // onTap: ()
                                  // {
                                  //   Navigator.push(
                                  //       context,
                                  //       MaterialPageRoute(
                                  //           builder: (context) =>
                                  //               Category(userid:HomeState.userid,mapselection: true)));
                                  // },
                                  keyboardType:
                                  TextInputType.text,
                                  decoration:
                                  InputDecoration(
                                    labelText:
                                    'Name',
                                    hintStyle:
                                    TextStyle(
                                      color:
                                      Colors.grey,
                                      fontSize:
                                      16.0,
                                    ),
                                    border:
                                    OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.circular(5.0),
                                    ),
                                  ),
                                ),
                                suggestionsCallback:
                                    (pattern) {
                                  return BackendService1.getSuggestions(
                                      pattern);
                                },
                                itemBuilder:
                                    (context,
                                    suggestion) {
                                  return ListTile(
                                    title:
                                    Text(suggestion),
                                  );
                                },
                                transitionBuilder: (context,
                                    suggestionsBox,
                                    controller) {
                                  return suggestionsBox;
                                },
                                onSuggestionSelected:
                                    (suggestion) {
                                  for (int i =
                                  0;
                                  i <
                                      BackendService1
                                          .li1.items.length;
                                  i++)
                                    if (BackendService1.li1.items[i].uname ==
                                        suggestion)
                                      userid =
                                          BackendService1.li1.items[i].uid;
                                  print(
                                      userid);
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
                                  this._typeAheadController1.text =
                                      suggestion;
                                },
                                validator:
                                    (value) {
                                  if (value
                                      .isEmpty) {
                                    return 'Please select a city';
                                  } else
                                    return 'nothing';
                                },
                                // onSaved: (value) => this._selectedCity = value,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10.0),
                              child: TextField(
                                onTap: () async {
                                  DateTime date = DateTime(1900);
                                  FocusScope.of(context)
                                      .requestFocus(new FocusNode());

                                  date = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now()
                                          .subtract(new Duration(days: 23725)),
                                      lastDate: DateTime.now()
                                          .add(new Duration(days: 365)));
                                  /*    var time =await showTimePicker(
                                initialTime: TimeOfDay.now(),
                                context: context,
                              );*/
                                  sql_dob_from = dateFormatter.format(date);
                                  print("date" + sql_dob_from);
                                  datefromcontroller.text =
                                      date.day.toString() +
                                          '/' +
                                          date.month.toString() +
                                          '/' +
                                          date.year.toString();
                                },
                                enabled: true,
                                controller: datefromcontroller,
                                decoration: InputDecoration(
                                  prefixIcon:
                                      Icon(Icons.calendar_today_outlined),
                                  labelText: 'Bill Date',
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16.0,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0),
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
                                enabled: true,
                                controller: BillNumberController,
                                decoration: InputDecoration(
                                  labelText: 'Bill Number',
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
                              child: TypeAheadFormField(
                                textFieldConfiguration: TextFieldConfiguration(
                                  enabled: true,
                                  controller: this._typeAheadController,
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
                                    labelText: 'Expense Type Name',
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
                                  return BackendService.getSuggestions(pattern);
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
                                      i < BackendService.li1.items.length;
                                      i++) {
                                    print(
                                        BackendService.li1.items[i].etypeName);
                                    if (BackendService.li1.items[i].etypeName ==
                                        suggestion)
                                      shopid = BackendService
                                          .li1.items[i].etypeId
                                          .toString();
                                    //    station_assign_uid=BackendService.li1.values[i].vendorId.toString();

                                  }

                                  this._typeAheadController.text = suggestion;
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
                            SizedBox(
                              height: height / 50,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
                              child: new TextField(
                                enabled: true,
                                controller: BillAmountController,
                                decoration: InputDecoration(
                                  labelText: 'Bill Amount',
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

                  Container(
                      margin: const EdgeInsets.only(top: 10),
                      color: Colors.red.shade50,
                      child: ExpansionTile(
                          backgroundColor: Colors.white,
                          initiallyExpanded: true,
                          title: Text(
                            "Attachment Details",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, color: Colors.red),
                          ),
                          children: [
                            SizedBox(
                              height: height / 50,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                color: Colors.red.withOpacity(0.2),
                                // boxShadow: [
                                //   BoxShadow(
                                //     color: Colors.grey,
                                //     offset: Offset(0.0, 1.0), //(x,y)
                                //     blurRadius: 1.0,
                                //   ),
                                // ],
                              ),
                              // color: Colors.white,
                              margin: EdgeInsets.all(3.0),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: new Text(
                                    "Bill Images",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 15),
                                  ),
                                ),
                              ),
                            ),
                            buildGridView3(),
                            buildGridView(),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
                              child: new TextField(
                                enabled: true,
                                minLines: 6,
                                maxLines: 25,
                                controller: RemarkSumaryController,
                                decoration: InputDecoration(
                                  labelText: 'Remark Summary',
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
                          ])),

                  SizedBox(
                    height: height / 40,
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
                              if (_typeAheadController.text.length != 0)
                                showDialog(context: context,
                                    child: AlertDialog(title: Column(
                                      children: [
                                        Image.asset("tenor.gif",height: 100,),
                                        Text("Are you sure?"),
                                      ],
                                    ),content: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          Text("Do you want to Edit!"),
                                          SizedBox(height: height/20,),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              RaisedButton(
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(25))),
                                                color: Colors.green,
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  uploadImage();
                                                },
                                                child: Text(
                                                  "Edit",
                                                  style: TextStyle(color: Colors.white),
                                                ),
                                              ),
                                              RaisedButton(
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(25))),
                                                color: Colors.grey,
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  "Cancel",
                                                  style: TextStyle(color: Colors.white),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    )
                                );
                              else {
                                if (_typeAheadController.text.length == 0)
                                  showDialog<void>(
                                    context: context,
                                    barrierDismissible: false,
                                    // user must tap button!
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text(
                                            "Service Station name cannot be empty"),
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
                                else if (PincodeController.text.length != 6)
                                  showDialog<void>(
                                    context: context,
                                    barrierDismissible: false,
                                    // user must tap button!
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title:
                                            Text("Pincode Should be 6 digits"),
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
                                else if (dropdownValue == '-- Select Gender --')
                                  showDialog<void>(
                                    context: context,
                                    barrierDismissible: false,
                                    // user must tap button!
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("Please Choose Gender"),
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
                                else if (dropdownValue1 == '-- Select State --')
                                  showDialog<void>(
                                    context: context,
                                    barrierDismissible: false,
                                    // user must tap button!
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("Please Choose State"),
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
                                else if (dropdownValue2 ==
                                    '-- Select District --')
                                  showDialog<void>(
                                    context: context,
                                    barrierDismissible: false,
                                    // user must tap button!
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("Please Choose District"),
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
                              }
                            },
                            child: Text(
                              "Save",
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
                    height: height / 80,
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

  Widget buildGridView() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.count(
        physics: ScrollPhysics(),
        shrinkWrap: true,
        crossAxisCount: 2,
        childAspectRatio: 1,
        children: List.generate(
          files.length + 1,
          (index) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                  elevation: 5,
                  clipBehavior: Clip.antiAlias,
                  child: Stack(children: <Widget>[
                    index < files.length
                        ? InkWell(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  child: Image.file(files[index]));
                            },
                            child: Image.file(
                              files[index],
                              width: 300,
                              height: 300,
                            ),
                          )
                        : Container(
                            width: 300,
                            height: 300,
                            child: IconButton(
                              icon: Icon(
                                Icons.add,
                              ),
                              onPressed: () {
                                _onAddImageClick(index);
                              },
                            ),
                          ),
                    index < files.length
                        ? Positioned(
                            right: 5,
                            top: 5,
                            child: InkWell(
                                child: Icon(
                                  Icons.remove_circle,
                                  size: 20,
                                  color: Colors.red,
                                ),
                                onTap: () {
                                  setState(() {
                                    files.removeAt(index);
                                    print(files);
                                    // images.replaceRange(index, index + 1, ['Add Image']);
                                  });
                                }))
                        : Container()
                  ])),
            );
          },
        ),
      ),
      // child: GridView.count(
      //         physics: ScrollPhysics(),
      //   shrinkWrap: true,
      //   crossAxisCount: 3,
      //   childAspectRatio: 1,
      //   children: List.generate(images.length+1, (index) {
      //     if (images[index] is ImageUploadModel)
      //     {
      //       ImageUploadModel uploadModel = images[index];
      //       return Card(
      //         elevation: 20,
      //         clipBehavior: Clip.antiAlias,
      //         child: Stack(
      //           children: <Widget>[
      //             Image.file(
      //               uploadModel.imageFile,
      //               width: 300,
      //               height: 300,
      //             ),
      //             Positioned(
      //               right: 5,
      //               top: 5,
      //               child: InkWell(
      //                 child: Icon(
      //                   Icons.remove_circle,
      //                   size: 20,
      //                   color: Colors.red,
      //                 ),
      //                 onTap: () {
      //                   setState(() {
      //                     imagefile.removeAt(index);
      //                     images.replaceRange(index, index + 1, ['Add Image']);
      //                   });
      //                 },
      //               ),
      //             ),
      //           ],
      //         ),
      //       );
      //     } else {
      //       return Card(
      //         elevation: 3,
      //         child: IconButton(
      //           icon: Icon(Icons.add),
      //           onPressed: () {
      //             _onAddImageClick(index);
      //           },
      //         ),
      //       );
      //     }
      //   }),
      // ),
    );
  }

  Future _onAddImageClick(int index) async {
    image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image != null)
      setState(() {
        files.add(image);
      });
  }

  Future getFileImage(int index) async {
//    var dir = await path_provider.getTemporaryDirectory();
    _imageFile.then((file) async {
      setState(() {
        files.add(file);
      });
    });
  }

  Widget buildGridView1() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.count(
        physics: ScrollPhysics(),
        shrinkWrap: true,
        crossAxisCount: 2,
        childAspectRatio: 1,
        children: List.generate(
          files1.length + 1,
          (index) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                  elevation: 5,
                  clipBehavior: Clip.antiAlias,
                  child: Stack(children: <Widget>[
                    index < files1.length
                        ? InkWell(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  child: Image.file(files1[index]));
                            },
                            child: Image.file(
                              files1[index],
                              width: 300,
                              height: 300,
                            ),
                          )
                        : Container(
                            width: 300,
                            height: 300,
                            child: IconButton(
                              icon: Icon(
                                Icons.add,
                              ),
                              onPressed: () {
                                _onAddImageClick1(index);
                              },
                            ),
                          ),
                    index < files1.length
                        ? Positioned(
                            right: 5,
                            top: 5,
                            child: InkWell(
                                child: Icon(
                                  Icons.remove_circle,
                                  size: 20,
                                  color: Colors.red,
                                ),
                                onTap: () {
                                  setState(() {
                                    files1.removeAt(index);
                                    print(files1);
                                    // images.replaceRange(index, index + 1, ['Add Image']);
                                  });
                                }))
                        : Container()
                  ])),
            );
          },
        ),
      ),
      // child: GridView.count(
      //         physics: ScrollPhysics(),
      //   shrinkWrap: true,
      //   crossAxisCount: 3,
      //   childAspectRatio: 1,
      //   children: List.generate(images.length+1, (index) {
      //     if (images[index] is ImageUploadModel)
      //     {
      //       ImageUploadModel uploadModel = images[index];
      //       return Card(
      //         elevation: 20,
      //         clipBehavior: Clip.antiAlias,
      //         child: Stack(
      //           children: <Widget>[
      //             Image.file(
      //               uploadModel.imageFile,
      //               width: 300,
      //               height: 300,
      //             ),
      //             Positioned(
      //               right: 5,
      //               top: 5,
      //               child: InkWell(
      //                 child: Icon(
      //                   Icons.remove_circle,
      //                   size: 20,
      //                   color: Colors.red,
      //                 ),
      //                 onTap: () {
      //                   setState(() {
      //                     imagefile.removeAt(index);
      //                     images.replaceRange(index, index + 1, ['Add Image']);
      //                   });
      //                 },
      //               ),
      //             ),
      //           ],
      //         ),
      //       );
      //     } else {
      //       return Card(
      //         elevation: 3,
      //         child: IconButton(
      //           icon: Icon(Icons.add),
      //           onPressed: () {
      //             _onAddImageClick(index);
      //           },
      //         ),
      //       );
      //     }
      //   }),
      // ),
    );
  }

  Future _onAddImageClick1(int index) async {
    image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image != null)
      setState(() {
        files1.add(image);
      });
  }

  Future getFileImage1(int index) async {
//    var dir = await path_provider.getTemporaryDirectory();
    _imageFile.then((file) async {
      setState(() {
        files1.add(file);
      });
    });
  }

  Widget buildGridView3() {
    return li5.items.billImage.length != 0
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.count(
              physics: ScrollPhysics(),
              shrinkWrap: true,
              crossAxisCount: 2,
              childAspectRatio: 1,
              children: List.generate(
                li5.items.billImage.length,
                (index) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Card(
                        elevation: 5,
                        clipBehavior: Clip.antiAlias,
                        child: Stack(children: <Widget>[
                          index < li5.items.billImage.length
                              ? InkWell(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        child: Image.network(li5
                                            .items.billImage[index].imgPath));
                                  },
                                  child: Image.network(
                                    li5.items.billImage[index].imgPath,
                                    width: 300,
                                    height: 300,
                                  ),
                                )
                              : Container(
                                  width: 300,
                                  height: 300,
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.add,
                                    ),
                                    onPressed: () {
                                      _onAddImageClick(index);
                                    },
                                  ),
                                ),
                          index < li5.items.billImage.length
                              ? Positioned(
                                  right: 5,
                                  top: 5,
                                  child: InkWell(
                                      child: Icon(
                                        Icons.remove_circle,
                                        size: 20,
                                        color: Colors.red,
                                      ),
                                      onTap: () {
                                        setState(() {
                                          deleteimage(
                                              li5.items.billImage[index].imgId);
                                          li5.items.billImage.removeAt(index);
                                          print(files);
                                          // images.replaceRange(index, index + 1, ['Add Image']);
                                        });
                                      }))
                              : Container()
                        ])),
                  );
                },
              ),
            ),
            // child: GridView.count(
            //         physics: ScrollPhysics(),
            //   shrinkWrap: true,
            //   crossAxisCount: 3,
            //   childAspectRatio: 1,
            //   children: List.generate(images.length+1, (index) {
            //     if (images[index] is ImageUploadModel)
            //     {
            //       ImageUploadModel uploadModel = images[index];
            //       return Card(
            //         elevation: 20,
            //         clipBehavior: Clip.antiAlias,
            //         child: Stack(
            //           children: <Widget>[
            //             Image.file(
            //               uploadModel.imageFile,
            //               width: 300,
            //               height: 300,
            //             ),
            //             Positioned(
            //               right: 5,
            //               top: 5,
            //               child: InkWell(
            //                 child: Icon(
            //                   Icons.remove_circle,
            //                   size: 20,
            //                   color: Colors.red,
            //                 ),
            //                 onTap: () {
            //                   setState(() {
            //                     imagefile.removeAt(index);
            //                     images.replaceRange(index, index + 1, ['Add Image']);
            //                   });
            //                 },
            //               ),
            //             ),
            //           ],
            //         ),
            //       );
            //     } else {
            //       return Card(
            //         elevation: 3,
            //         child: IconButton(
            //           icon: Icon(Icons.add),
            //           onPressed: () {
            //             _onAddImageClick(index);
            //           },
            //         ),
            //       );
            //     }
            //   }),
            // ),
          )
        : Container();
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
class BackendService1 {
  static GetUserDetails li1;

  static Future<List> getSuggestions(String query) async {
    var url = //'http://35.184.156.126.xip.io/cyberhome/home.php?username=kavin&query=table';
    String_values.base_url +
        'role-user-list?search=${query}&urole_id=' +
        EmployeeEditExpenseTypeState.roleid;

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