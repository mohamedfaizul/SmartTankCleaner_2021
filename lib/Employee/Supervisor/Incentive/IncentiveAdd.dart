import 'dart:async';
import 'dart:collection';
import 'dart:convert';
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
import 'package:intl/intl.dart';
import 'package:tankcare/Customer/register.dart';
import 'package:tankcare/CustomerModels/districtlist.dart';
import 'package:tankcare/CustomerModels/groupadd.dart';
import 'package:tankcare/Employee/Dashboard.dart';
import 'package:tankcare/Employee/EmployeeModels/ErrorResponse.dart';
import 'package:tankcare/Employee/EmployeeModels/Incentive/AddModel.dart';
import 'package:tankcare/Employee/EmployeeModels/Incentive/IncentiveAddModel2.dart';
import 'package:tankcare/Employee/Supervisor/Customer/EmployeeCustomerList.dart';
import 'package:tankcare/Employee/Supervisor/My%20Staff/DVStaffView.dart';
import 'package:tankcare/RM%20models/getuser.dart';
import 'package:tankcare/VendorModels/State.dart';
import 'package:tankcare/VendorModels/StationVendorListings.dart';
import 'package:tankcare/string_values.dart';

import 'EmployeeIncentiveList.dart';

class EmployeeIncentiveAdd extends StatefulWidget {
  @override
  EmployeeIncentiveAddState createState() => EmployeeIncentiveAddState();
}

class EmployeeIncentiveAddState extends State<EmployeeIncentiveAdd> {
  Set<Marker> markers = Set();
  bool isenable = true;
  bool cameramove = false;
  PlanServiceYearClass li34;
  final dateFormatter = DateFormat('yyyy-MM-dd');
  static String sql_dob_from;
  String sql_dob_to;
  List<String> stringlist = [
    '-- Property Type --',
    "Tank",
    "OverHead Tank",
    "Sump",
    "Sump-Tile",
    "Car",
    "Bike",
    "Floor",
    "OverHead Tank Tile"
  ];
  TextEditingController datefromcontroller = new TextEditingController();
  TextEditingController datetocontroller = new TextEditingController();
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

  static String dropdownValueuser = "-- User Type --";
  static String dropdownValuedes = "-- Designation --";
  TextEditingController serviceyearcontroller = new TextEditingController();
  final TextEditingController _typeAheadController = TextEditingController();
  final TextEditingController _typeAheadController1 = TextEditingController();
  TextEditingController totalservicecontroller = new TextEditingController();
  TextEditingController DepositAmountController = new TextEditingController();
  TextEditingController literpricecontroller = new TextEditingController();
  TextEditingController fixedpricecontroller = new TextEditingController();
  TextEditingController CoverageRangeController = new TextEditingController();
  TextEditingController PasswordController = new TextEditingController();
  TextEditingController ConfirmPasswordController = new TextEditingController();
  List<PlanServiceYearClass> listplanyear;
  List<PlanListClass> selectedAvengers;
  bool sort;

  UserListModel li58;

  var enable = false;

  String usertype;

  String roleid;
  Future<http.Response> details() async {
    setState(() {
      loading = true;
    });
    var url = String_values.base_url + 'com-role-list';
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
      li58 = UserListModel.fromJson(json.decode(response.body));

      setState(() {
        stringlist3.clear();
        stringlist3.add("-- User Type --");
        for (int i = 0; i < li58.items.length; i++)
          stringlist3.add(li58.items[i].roleName);
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

  static String dropdownValue = '-- Assign Type --';
  List<String> stringlist3 = [
    "-- User Type --",
    "Tank",
    "OverHead Tank",
    "Sump",
    "Sump-Tile",
    "Car",
    "Bike",
    "Floor",
    "OverHead Tank Tile"
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

  static List<String> friendsList = [null];
  static LatLng _initialPosition;
  TextEditingController EmailController = new TextEditingController();
  TextEditingController NameController = new TextEditingController();
  TextEditingController MobileController = new TextEditingController();
  TextEditingController SizeControllerFrom = new TextEditingController();
  TextEditingController PincodeController = new TextEditingController();
  TextEditingController SizeControllerTo = new TextEditingController();
  Completer<GoogleMapController> _controller = Completer();
  var loading = false;
  Position position;
  TextEditingController GroupNameController = new TextEditingController();
  TextEditingController GroupNumberController = new TextEditingController();

  TextEditingController addressController = new TextEditingController();

  States li;

  DistrictListings li1;
  Set<Circle> _circles = HashSet<Circle>();
  int statetype = 1;
  int districttype = 1;
  double radius = 500;
  GroupAdd li2;

  VendorListings li5;

  String vendorid, empid;

  ErrorResponse ei;

  static String userid;

  bool visibletable;

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
    sort = false;
    literpricecontroller.text = "0";
    CoverageRangeController.text = "10";
    selectedAvengers = [];
    listplan = PlanListClass.getdata();
    details();
    stateRequest();

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

  Future<http.Response> stateRequest() async {
    setState(() {
      loading = true;
    });

    var url = String_values.base_url + 'state';
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
      li = States.fromJson(json.decode(response.body));

      stringlist.clear();
      stringlist.add('-- Select State --');
      for (int i = 0; i < li.items.length; i++)
        stringlist.add(li.items[i].stateName);
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
            // if (this.first != "")
            //   addressController.text = '${this.first.addressLine}';
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

  @override
  Widget build(BuildContext context) {
    Future<int> uploadImage() async {
      setState(() {
        loading = true;
      });

      Map<String, String> headers = {
        "Content-Type": "application/json",
        'Authorization': 'Bearer ${RegisterPagesState.token}'
      };

      var request = http.MultipartRequest(
          'POST', Uri.parse(String_values.base_url + 'com-save'));
      //property_id plan_id pplan_name pplan_year pplan_service pplan_price pplan_tot_price pplan_start_date
      request.headers.addAll(headers);
      request.fields['com_uid'] = EmployeeIncentiveAddState.userid;
      request.fields['com_urole_id'] = roleid;
      request.fields['com_utype'] = usertype;
      request.fields['com_amount'] = "0";
      request.fields['com_month'] = sql_dob_from;
      request.fields['device'] = "mobile";
      request.fields['com_details'] = json.encode(listplanyear);
      var response = await request.send();
      response.stream.transform(utf8.decoder).listen((value) {
        print(value);

        setState(() {
          loading = false;
        });
        if (value.toString().contains("true")) {
          listplanyear.clear();
          Fluttertoast.showToast(
              msg: "Incentive Added Successfully",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.SNACKBAR,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => EmployeeIncentiveList()),
          );
        } else {
          ei = ErrorResponse.fromJson(jsonDecode(value));
          Fluttertoast.showToast(
              msg: ei.messages,
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.SNACKBAR,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }
        return response.statusCode;
      });
    }

    Future<http.Response> vendorListings() async {
      setState(() {
        loading = true;
      });

      var url = String_values.base_url + 'vendor-list?approval=a';
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
          loading = false;
        });
        li5 = VendorListings.fromJson(json.decode(response.body));
        // print("plan${li.items[0].mapLocation}");
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
                          "Add Incentive",
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
                            "Details",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, color: Colors.red),
                          ),
                          children: [
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
                                      setState(() {
                                        dropdownValueuser = newValue;
                                        for (int i = 0;
                                            i < li58.items.length;
                                            i++)
                                          if (li58.items[i].roleName ==
                                              newValue) {
                                            BackendService1.usertype =
                                                li58.items[i].roleId;
                                            usertype = li58.items[i].roleType;
                                            roleid = li58.items[i].roleId;
                                          }
                                        _typeAheadController.text = "";
                                      });
                                  },
                                  items: stringlist3
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
                                    labelText: 'Name *',
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
                                  datefromcontroller.text = "";
                                  sql_dob_from = "";
                                  for (int i = 0;
                                      i < BackendService.li1.items.length;
                                      i++)
                                    if (BackendService.li1.items[i].uname ==
                                        suggestion)
                                      userid = BackendService.li1.items[i].uid;
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
                            // Padding(
                            //   padding: const EdgeInsets.all(8.0),
                            //   child: Text('Total Amount : ${totalamount}'),
                            // ),
                            Container(
                              margin:
                                  const EdgeInsets.only(left: 10, right: 10),
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
                                  enable = true;
                                  sql_dob_from = dateFormatter.format(date);
                                  visibletable = true;
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
                                  labelText: 'Select Date *',
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
                                height:
                                    MediaQuery.of(context).size.height / 50),
                            Visibility(
                              visible: enable,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                  sortAscending: sort,
                                  sortColumnIndex: 0,
                                  columnSpacing: width / 25,
                                  columns: [
                                    DataColumn(
                                      label: Center(
                                          child: Wrap(
                                        direction: Axis.vertical, //default
                                        alignment: WrapAlignment.center,
                                        children: [
                                          Text("Incentive Type",
                                              softWrap: true,
                                              style: TextStyle(fontSize: 12)),
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
                                          Text("Incentive Count",
                                              softWrap: true,
                                              style: TextStyle(fontSize: 12)),
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
                                          Text("Incentive Amount",
                                              softWrap: true,
                                              style: TextStyle(fontSize: 12)),
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
                                          Text("Action",
                                              softWrap: true,
                                              style: TextStyle(fontSize: 12)),
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
                                  rows: listplanyear
                                      .map(
                                        (list) => DataRow(
                                            selected:
                                                selectedAvengers.contains(list),
                                            cells: [
                                              DataCell(
                                                Center(
                                                    child: Text(
                                                  list.incentivetype,
                                                  textAlign: TextAlign.center,
                                                )),
                                              ),
                                              DataCell(
                                                Center(
                                                    child: Text(list.count,
                                                        textAlign:
                                                            TextAlign.center)),
                                              ),
                                              DataCell(
                                                Center(
                                                    child: Text(
                                                        list.incentiveamt,
                                                        textAlign:
                                                            TextAlign.center)),
                                              ),
                                              DataCell(
                                                Center(
                                                  child: IconButton(
                                                      icon: Icon(Icons
                                                          .remove_circle_outline),
                                                      onPressed: () {
                                                        setState(() {
                                                          listplanyear
                                                              .remove(list);
                                                        });
                                                      }),
                                                ),
                                              ),
                                            ]),
                                      )
                                      .toList(),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: enable,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    new Flexible(
                                      flex: 6,
                                      child: Container(
                                        height: height / 15,
                                        padding: EdgeInsets.all(5),
                                        margin: EdgeInsets.only(left: 16),
                                        child: TypeAheadFormField(
                                          textFieldConfiguration:
                                              TextFieldConfiguration(
                                            enabled: true,
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
                                            keyboardType: TextInputType.text,
                                            decoration: InputDecoration(
                                              labelText: 'Type *',
                                              hintStyle: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 16.0,
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                              ),
                                            ),
                                          ),
                                          suggestionsCallback: (pattern) {
                                            return BackendService1
                                                .getSuggestions(pattern);
                                          },
                                          itemBuilder: (context, suggestion) {
                                            return ListTile(
                                              title: Text(suggestion),
                                            );
                                          },
                                          transitionBuilder: (context,
                                              suggestionsBox, controller) {
                                            return suggestionsBox;
                                          },
                                          onSuggestionSelected: (suggestion) {
                                            int cnt = 0;

                                            for (int i = 0;
                                                i < listplanyear.length;
                                                i++)
                                              if (suggestion ==
                                                  listplanyear[i]
                                                      .incentivetype) {
                                                cnt++;
                                              }
                                            if (cnt == 0) {
                                              this._typeAheadController1.text =
                                                  suggestion;
                                              for (int i = 0;
                                                  i <
                                                      BackendService1
                                                          .li1.data.length;
                                                  i++)
                                                if (suggestion ==
                                                    BackendService1
                                                        .li1.data[i].ctype) {
                                                  literpricecontroller.text =
                                                      BackendService1
                                                          .li1.data[i].commCnt;
                                                }
                                            } else
                                              Fluttertoast.showToast(
                                                  msg: "Type Already Exists",
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity:
                                                      ToastGravity.SNACKBAR,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor: Colors.red,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0);
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
                                    ),
                                    new Flexible(
                                      flex: 2,
                                      child: Container(
                                        height: height / 15,
                                        padding: EdgeInsets.all(5),
                                        child: new TextFormField(
                                          enabled: false,
                                          controller: literpricecontroller,
                                          keyboardType: TextInputType.number,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 12),
                                          decoration: InputDecoration(
                                            ///  hintText: "List Price",
                                            hintStyle: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 16.0,
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    new Flexible(
                                      flex: 4,
                                      child: Container(
                                        height: height / 15,
                                        padding: EdgeInsets.all(5),
                                        child: new TextField(
                                          controller: fixedpricecontroller,
                                          keyboardType: TextInputType.number,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 12),
                                          decoration: InputDecoration(
                                            // hintText: "Fixed Price",
                                            hintStyle: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 16.0,
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    new Flexible(
                                      flex: 3,
                                      child: Container(
                                          margin: EdgeInsets.only(right: 16),
                                          child: IconButton(
                                            icon: Icon(
                                              Icons.add_circle_outline,
                                              color: Colors.red,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                listplanyear.add(
                                                    PlanServiceYearClass(
                                                        incentivetype:
                                                            _typeAheadController1
                                                                .text,
                                                        count: "0",
                                                        incentiveamt:
                                                            fixedpricecontroller
                                                                .text));
                                                _typeAheadController1.text = "";
                                                totalservicecontroller.text =
                                                    "";
                                                fixedpricecontroller.text = "";
                                              });
                                            },
                                          )),
                                    ),
                                    SizedBox(
                                      height: height / 80,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: height / 80,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(50))),
                                    child: FlatButton(
                                      onPressed: () {
                                        if (dropdownValueuser !=
                                                "-- User Type --" &&
                                            datefromcontroller.text.length !=
                                                0 &&
                                            _typeAheadController.text.length !=
                                                0)
                                          showDialog(context: context,
                                              child: AlertDialog(title: Column(
                                                children: [
                                                  Image.asset("tenor.gif",height: 100,),
                                                  Text("Are you sure?"),
                                                ],
                                              ),content: SingleChildScrollView(
                                                child: Column(
                                                  children: [
                                                    Text("Do you want to Add!"),
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
                                                            "Add",
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
                                          if (_typeAheadController
                                                  .text.length ==
                                              0)
                                            showDialog<void>(
                                              context: context,
                                              barrierDismissible: false,
                                              // user must tap button!
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text(
                                                      "Name cannot be empty"),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      child: Text('OK'),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          else if (PincodeController
                                                  .text.length !=
                                              6)
                                            showDialog<void>(
                                              context: context,
                                              barrierDismissible: false,
                                              // user must tap button!
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text(
                                                      "Pincode Should be 6 digits"),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      child: Text('OK'),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          else if (MobileController
                                                  .text.length !=
                                              10)
                                            showDialog<void>(
                                              context: context,
                                              barrierDismissible: false,
                                              // user must tap button!
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text(
                                                      "Mobile Number should be 10 digits"),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      child: Text('OK'),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          else if (PasswordController
                                                  .text.length <
                                              6)
                                            showDialog<void>(
                                              context: context,
                                              barrierDismissible: false,
                                              // user must tap button!
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text(
                                                      "Password should be 6 characters"),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      child: Text('OK'),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          else if (ConfirmPasswordController
                                                  .text.length <
                                              6)
                                            showDialog<void>(
                                              context: context,
                                              barrierDismissible: false,
                                              // user must tap button!
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text(
                                                      "Confirm Password should be 6 characters"),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      child: Text('OK'),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          else if (ConfirmPasswordController
                                                  .text !=
                                              PasswordController.text)
                                            showDialog<void>(
                                              context: context,
                                              barrierDismissible: false,
                                              // user must tap button!
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text(
                                                      "Password and Confirm Password should be same"),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      child: Text('OK'),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          else if (datefromcontroller
                                                  .text.length ==
                                              0)
                                            showDialog<void>(
                                              context: context,
                                              barrierDismissible: false,
                                              // user must tap button!
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text(
                                                      "Date cannot be empty"),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      child: Text('OK'),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          else if (EmailController
                                                  .text.length ==
                                              0)
                                            showDialog<void>(
                                              context: context,
                                              barrierDismissible: false,
                                              // user must tap button!
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text(
                                                      "Email cannot be empty"),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      child: Text('OK'),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          else if (dropdownValueuser ==
                                              '-- User Type --')
                                            showDialog<void>(
                                              context: context,
                                              barrierDismissible: false,
                                              // user must tap button!
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text(
                                                      "Please Choose UserType"),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      child: Text('OK'),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
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
                                                  title: Text(
                                                      "Please Choose District"),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      child: Text('OK'),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(50))),
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
                          ])),

                  // Container(
                  //   margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                  //   padding: const EdgeInsets.only(left: 20.0, right: 10.0),
                  //   decoration: new BoxDecoration(
                  //       borderRadius: BorderRadius.all(Radius.circular(2.0)),
                  //       border: new Border.all(color: Colors.black38)),
                  //   child: DropdownButtonHideUnderline(
                  //     child: DropdownButton<String>(
                  //       isExpanded: true,
                  //       value: dropdownValue,
                  //       onChanged: (String newValue) {
                  //         setState(() {
                  //           dropdownValue = newValue;
                  //         });
                  //       },
                  //       items: <String>[
                  //         '-- Service Type --',
                  //         "Residential",
                  //         "Commercial"
                  //       ].map<DropdownMenuItem<String>>((String value) {
                  //         return DropdownMenuItem<String>(
                  //           value: value,
                  //           child: Text(value),
                  //         );
                  //       }).toList(),
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: height / 50,
                  // ),

                  // Container(
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(5.0),
                  //     color: Colors.white,
                  //     boxShadow: [
                  //       BoxShadow(
                  //         color: Colors.grey,
                  //         offset: Offset(0.0, 1.0), //(x,y)
                  //         blurRadius: 0.2,
                  //       ),
                  //     ],
                  //   ),
                  //   // decoration: new BoxDecoration(
                  //   //     borderRadius:BorderRadius.all(Radius.circular(2.0)),
                  //   //     border: new Border.all(color: Colors.red)
                  //   // ),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //     children: [
                  //       new Flexible(
                  //         flex: 3,
                  //         child: Padding(
                  //           padding: const EdgeInsets.only(left: 10.0),
                  //           child: new TextFormField(
                  //             initialValue: "Service Year",
                  //             maxLines: 2,
                  //             minLines: 2,
                  //             textAlign: TextAlign.center,
                  //             enabled: false,
                  //             style: TextStyle(
                  //                 fontSize: 12,
                  //                 color: Colors.black,
                  //                 fontWeight: FontWeight.w800),
                  //             decoration: InputDecoration(
                  //               border: InputBorder.none,
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //       new Flexible(
                  //         flex: 3,
                  //         child: Padding(
                  //           padding: const EdgeInsets.only(
                  //             left: 10.0,
                  //           ),
                  //           child: new TextFormField(
                  //             initialValue: "Total Services",
                  //             maxLines: 2,
                  //             minLines: 2,
                  //             textAlign: TextAlign.center,
                  //             enabled: false,
                  //             style: TextStyle(
                  //                 fontSize: 12,
                  //                 color: Colors.black,
                  //                 fontWeight: FontWeight.w800),
                  //             decoration: InputDecoration(
                  //               border: InputBorder.none,
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //       new Flexible(
                  //         flex: 3,
                  //         child: Padding(
                  //           padding: const EdgeInsets.only(left: 10.0),
                  //           child: new TextFormField(
                  //             initialValue: "Liter Price",
                  //             maxLines: 2,
                  //             minLines: 2,
                  //             textAlign: TextAlign.center,
                  //             enabled: false,
                  //             style: TextStyle(
                  //                 fontSize: 12,
                  //                 color: Colors.black,
                  //                 fontWeight: FontWeight.w800),
                  //             decoration: InputDecoration(
                  //               border: InputBorder.none,
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //       new Flexible(
                  //         flex: 3,
                  //         child: Padding(
                  //           padding: const EdgeInsets.only(left: 10.0),
                  //           child: new TextFormField(
                  //             initialValue: "Fixed Price",
                  //             maxLines: 2,
                  //             minLines: 2,
                  //             textAlign: TextAlign.center,
                  //             enabled: false,
                  //             style: TextStyle(
                  //                 fontSize: 12,
                  //                 color: Colors.black,
                  //                 fontWeight: FontWeight.w800),
                  //             decoration: InputDecoration(
                  //               border: InputBorder.none,
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //       new Flexible(
                  //           flex: 2,
                  //           child: Padding(
                  //             padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  //             child: new TextFormField(
                  //               initialValue: "Action",
                  //               maxLines: 2,
                  //               minLines: 2,
                  //               textAlign: TextAlign.center,
                  //               enabled: false,
                  //               style: TextStyle(
                  //                   fontSize: 12,
                  //                   color: Colors.black,
                  //                   fontWeight: FontWeight.w800),
                  //               decoration: InputDecoration(
                  //                 border: InputBorder.none,
                  //               ),
                  //             ),
                  //           ))
                  //     ],
                  //   ),
                  // ),

                  // Container(
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(5.0),
                  //     color: Colors.white,
                  //     boxShadow: [
                  //       BoxShadow(
                  //         color: Colors.grey,
                  //         offset: Offset(0.0, 1.0), //(x,y)
                  //         blurRadius: 0.2,
                  //       ),
                  //     ],
                  //   ),
                  //   // decoration: new BoxDecoration(
                  //   //     borderRadius:BorderRadius.all(Radius.circular(2.0)),
                  //   //     border: new Border.all(color: Colors.red)
                  //   // ),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //     children: [
                  //       new Flexible(
                  //         flex: 3,
                  //         child: Padding(
                  //           padding: const EdgeInsets.only(left: 10.0),
                  //           child: new TextFormField(
                  //             initialValue: "Plan Name",
                  //             maxLines: 2,
                  //             minLines: 2,
                  //             textAlign: TextAlign.center,
                  //             enabled: false,
                  //             style: TextStyle(
                  //                 fontSize: 12,
                  //                 color: Colors.black,
                  //                 fontWeight: FontWeight.w800),
                  //             decoration: InputDecoration(
                  //               border: InputBorder.none,
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //       new Flexible(
                  //         flex: 3,
                  //         child: Padding(
                  //           padding: const EdgeInsets.only(left: 10.0),
                  //           child: new TextFormField(
                  //             initialValue: "Total Services",
                  //             maxLines: 2,
                  //             minLines: 2,
                  //             textAlign: TextAlign.center,
                  //             enabled: false,
                  //             style: TextStyle(
                  //                 fontSize: 12,
                  //                 color: Colors.black,
                  //                 fontWeight: FontWeight.w800),
                  //             decoration: InputDecoration(
                  //               border: InputBorder.none,
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //       new Flexible(
                  //           flex: 2,
                  //           child: Padding(
                  //             padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  //             child: new TextFormField(
                  //               initialValue: "Action",
                  //               maxLines: 2,
                  //               minLines: 2,
                  //               textAlign: TextAlign.center,
                  //               enabled: false,
                  //               style: TextStyle(
                  //                   fontSize: 12,
                  //                   color: Colors.black,
                  //                   fontWeight: FontWeight.w800),
                  //               decoration: InputDecoration(
                  //                 border: InputBorder.none,
                  //               ),
                  //             ),
                  //           )),
                  //     ],
                  //   ),
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 8.0),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //     children: [
                  //       new Flexible(
                  //         flex: 3,
                  //         child: Container(
                  //           height: height / 20,
                  //           padding: EdgeInsets.all(5),
                  //           child: new TextFormField(
                  //             initialValue: "0.3",
                  //             enabled: false,
                  //             textAlign: TextAlign.center,
                  //             style: TextStyle(fontSize: 12),
                  //             decoration: InputDecoration(
                  //               hintStyle: TextStyle(
                  //                 color: Colors.grey,
                  //                 fontSize: 16.0,
                  //               ),
                  //               border: OutlineInputBorder(
                  //                 borderRadius: BorderRadius.circular(5.0),
                  //               ),
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //       new Flexible(
                  //         flex: 3,
                  //         child: Container(
                  //           height: height / 20,
                  //           padding: EdgeInsets.all(5),
                  //           child: new TextFormField(
                  //             initialValue: "299",
                  //             enabled: false,
                  //             textAlign: TextAlign.center,
                  //             style: TextStyle(fontSize: 12),
                  //             decoration: InputDecoration(
                  //               hintStyle: TextStyle(
                  //                 color: Colors.grey,
                  //                 fontSize: 16.0,
                  //               ),
                  //               border: OutlineInputBorder(
                  //                 borderRadius: BorderRadius.circular(5.0),
                  //               ),
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //       new Flexible(
                  //         flex: 2,
                  //         child: Container(
                  //             height: height / 20,
                  //             child: IconButton(
                  //               icon: Icon(Icons.remove_circle_outline),
                  //               onPressed: () {},
                  //             )),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),

      appBar: AppBar(
        title: Image.asset('logotitle.png', height: 40),
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () {
      //     Navigator.pushAndRemoveUntil(
      //       context,
      //       MaterialPageRoute(
      //           builder: (context) => EmployeeDashboard(firsttime: false)),
      //       (Route<dynamic> route) => false,
      //     );
      //   },
      //   icon: Icon(Icons.dashboard_outlined),
      //   label: Text('Dashboard'),
      //   backgroundColor: Colors.red,
      // ),
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

class BackendService {
  static GetUserDetails li1;

  static String usertype;

  static Future<List> getSuggestions(String query) async {
    if (EmployeeIncentiveAddState.dropdownValueuser == "RM")
      usertype = "5";
    else if (EmployeeIncentiveAddState.dropdownValueuser == "SALES-EXECUTIVE")
      usertype = "21";
    else if (EmployeeIncentiveAddState.dropdownValueuser == "DVENDOR")
      usertype = "17";
    else if (EmployeeIncentiveAddState.dropdownValueuser == "FRANCHISE")
      usertype = "18";
    var url = //'http://35.184.156.126.xip.io/cyberhome/home.php?username=kavin&query=table';
        String_values.base_url +
            'role-user-list?search=${query}&urole_id=' +
            usertype;
    print(url);
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

class BackendService1 {
  static IncentiveAddModel li1;

  static String type;
  static String usertype;
  static Future<List> getSuggestions(String query) async {
    if (EmployeeIncentiveAddState.dropdownValueuser == "RM") {
      type = "EMP";
    } else if (EmployeeIncentiveAddState.dropdownValueuser == "SALES-EXECUTIVE")
      type = "EMP";
    else if (EmployeeIncentiveAddState.dropdownValueuser == "DVENDOR")
      type = "DVENDOR";
    else if (EmployeeIncentiveAddState.dropdownValueuser == "FRANCHISE")
      type = "FRANCHISE";
    var url = //'http://35.184.156.126.xip.io/cyberhome/home.php?username=kavin&query=table';
        String_values.base_url +
            'com-users?utype=$type&urole_id=$usertype&uid=${EmployeeIncentiveAddState.userid}&cmonth=${EmployeeIncentiveAddState.sql_dob_from}';
    print(url);
    var response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer ${RegisterPagesState.token}'
      },
    );
    if (response.statusCode == 200) {
      print(response.body);
      li1 = IncentiveAddModel.fromJson(json.decode(response.body));

      List<String> s = new List();
      if (li1.data.length == 0) {
        // return ["No details"];
      } else {
        for (int i = 0; i < li1.data.length; i++)
          s.add(li1.data[i].ctype.toString());
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
  String incentivetype;
  String count;
  String incentiveamt;

  PlanServiceYearClass({this.incentivetype, this.count, this.incentiveamt});

  Map<String, dynamic> toJson() {
    return {
      'com_type': incentivetype,
      'com_count': count,
      'com_amount': incentiveamt,
    };
  }

  static List<PlanServiceYearClass> getdata() {
    return <PlanServiceYearClass>[];
  }
}
