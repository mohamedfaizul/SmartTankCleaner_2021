import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:ui';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:tankcare/Customer/register.dart';
import 'package:tankcare/CustomerModels/districtlist.dart';
import 'package:tankcare/CustomerModels/groupadd.dart';
import 'package:tankcare/Employee/Dashboard.dart';
import 'package:tankcare/Employee/EmployeeModels/DVStaff/DVShopListUserRoleModel.dart';
import 'package:tankcare/Employee/Login/Login.dart';
import 'package:tankcare/Employee/MyShop/DVShopDetailModel.dart';
import 'package:tankcare/Employee/Supervisor/My%20Shop/EmployeeMyshopList.dart';
import 'package:tankcare/VendorModels/State.dart';
import 'package:tankcare/VendorModels/SuperVisorListings.dart';
import 'package:tankcare/string_values.dart';

class EmployeeViewRentalShop extends StatefulWidget {
  EmployeeViewRentalShop({Key key, this.id});

  String id;

  @override
  EmployeeViewRentalShopState createState() => EmployeeViewRentalShopState();
}

class EmployeeViewRentalShopState extends State<EmployeeViewRentalShop> {
  Set<Marker> markers = Set();
  bool isenable = true;
  bool cameramove = false;
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
  TextEditingController totalservicecontroller = new TextEditingController();
  TextEditingController DepositAmountController = new TextEditingController();
  TextEditingController literpricecontroller = new TextEditingController();
  TextEditingController fixedpricecontroller = new TextEditingController();
  TextEditingController CoverageRangeController = new TextEditingController();
  TextEditingController OwnerNameController = new TextEditingController();
  TextEditingController OwnerPhoneController = new TextEditingController();
  TextEditingController ContractYearsController = new TextEditingController();
  TextEditingController StateController = new TextEditingController();
  TextEditingController DistrictController = new TextEditingController();
  List<PlanServiceYearClass> listplanyear;
  List<PlanListClass> selectedAvengers;
  bool sort;

  final dateFormatter = DateFormat('yyyy-MM-dd');
  String sql_dob_from;
  String sql_dob_to;
  TextEditingController datefromcontroller = new TextEditingController();
  static String dropdownValue = '-- Assign Type --';
  List<String> stringlist = [
    '-- Select State --',
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

  static List<String> friendsList = [null];
  static LatLng _initialPosition;
  TextEditingController ShopDepositController = new TextEditingController();
  TextEditingController ShopNameController = new TextEditingController();
  TextEditingController ShopRentController = new TextEditingController();
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

  DVShopDetailModel li5;

  String vendorid, empid;

  String shopid;

  Future<http.Response> details(planid) async {
    setState(() {
      loading = true;
    });
    var url = String_values.base_url + 'shop-details/' + planid;
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
      li5 = DVShopDetailModel.fromJson(json.decode(response.body));
      setState(() {
        ShopNameController.text = li5.values.shopName.toString();
        _typeAheadController.text = li5.values.assignby.toString();
        ShopRentController.text = li5.values.shopRent.toString();
        ShopDepositController.text = li5.values.shopDeposit.toString();
        addressController.text = li5.values.shopAddress.toString();
        StateController.text = li5.values.stateName.toString();
        DistrictController.text = li5.values.districtName.toString();
        OwnerNameController.text = li5.values.shopOwnerName.toString();
        OwnerPhoneController.text = li5.values.shopOwnerPhone.toString();
        datefromcontroller.text = DateFormat.yMd().format(DateTime.parse(li5.values.shopCStartDate.toString()));
        ContractYearsController.text = li5.values.shopCYears.toString();
        PincodeController.text = li5.values.shopPincode.toString();
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
    sort = false;
    CoverageRangeController.text = "10";
    selectedAvengers = [];
    listplan = PlanListClass.getdata();
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
          'POST', Uri.parse(String_values.base_url + 'shop-save'));
      //property_id plan_id pplan_name pplan_year pplan_service pplan_price pplan_tot_price pplan_start_date
      request.headers.addAll(headers);
      request.fields['shop_name'] = ShopNameController.text;
      request.fields['shop_uid'] = shopid;
      request.fields['shop_utype'] = EmployeeLoginPagesState.Userrole;
      request.fields['shop_rent'] = ShopRentController.text;
      request.fields['shop_deposit'] = ShopDepositController.text;
      request.fields['shop_owner_name'] = OwnerNameController.text;
      request.fields['shop_owner_phone'] = OwnerPhoneController.text;
      request.fields['shop_address'] = addressController.text;
      request.fields['shop_pincode'] = PincodeController.text;
      request.fields['shop_state'] = statetype.toString();
      request.fields['shop_district'] = districttype.toString();
      request.fields['shop_c_start_date'] = sql_dob_from;
      request.fields['shop_c_years'] = ContractYearsController.text.toString();
      var response = await request.send();
      response.stream.transform(utf8.decoder).listen((value) {
        print(value);

        setState(() {
          loading = false;
        });
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => EmployeeMyShopList()));
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
                          "View Rental Shop",
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
                            "Shop Details",
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
                                controller: ShopNameController,
                                decoration: InputDecoration(
                                  labelText: 'Shop Name',
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
                                  enabled: false,
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
                                    labelText: 'Shop For',
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
                                    if (BackendService.li1.items[i].uname ==
                                        suggestion)
                                      shopid = BackendService.li1.items[i].uid
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
                                enabled: false,
                                controller: ShopRentController,
                                decoration: InputDecoration(
                                  labelText: 'Shop Rent',
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
                                controller: ShopDepositController,
                                decoration: InputDecoration(
                                  labelText: 'Shop Deposit',
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
                                controller: OwnerNameController,
                                decoration: InputDecoration(
                                  labelText: 'Owner Name',
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
                                controller: OwnerPhoneController,
                                decoration: InputDecoration(
                                  labelText: 'Owner Phone',
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
                            Container(
                              margin:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: TextField(
                                enabled: false,
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
                                controller: datefromcontroller,
                                decoration: InputDecoration(
                                  prefixIcon:
                                      Icon(Icons.calendar_today_outlined),
                                  labelText: 'Contract Date',
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
                                enabled: false,
                                controller: ContractYearsController,
                                decoration: InputDecoration(
                                  labelText: 'Contract Years',
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
                            "Address Details",
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
                              child: Container(
                                child: new TextField(
                                  enabled: false,
                                  minLines: 3,
                                  maxLines: 15,
                                  controller: addressController,
                                  decoration: InputDecoration(
                                    labelText: 'Address',
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
                            ),

                            SizedBox(
                              height: height / 80,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
                              child: Container(
                                child: new TextField(
                                  enabled: false,
                                  controller: StateController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: 'State',
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
                            ),
                            SizedBox(
                              height: height / 80,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
                              child: Container(
                                child: new TextField(
                                  enabled: false,
                                  controller: DistrictController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: 'District',
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
                            ),
                            // Container(
                            //   margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                            //   padding: const EdgeInsets.only(left: 20.0, right: 10.0),
                            //   decoration: new BoxDecoration(
                            //       borderRadius: BorderRadius.all(Radius.circular(2.0)),
                            //       border: new Border.all(color: Colors.black38)),
                            //   child: DropdownButtonHideUnderline(
                            //     child: DropdownButton<String>(
                            //       isExpanded: true,
                            //       value: dropdownValue1,
                            //       onChanged: (String newValue) {
                            //         setState(() {
                            //           dropdownValue1 = newValue;
                            //           dropdownValue2='-- Select District --';
                            //           statetype = stringlist.indexOf(newValue);
                            //           for(int i=0;i<li.items.length;i++)
                            //             if(li.items[i].stateName==newValue) {
                            //               statetype=int.parse(li.items[i].stateId);
                            //               districtRequest(li.items[i].stateId);
                            //             }
                            //         });
                            //       },
                            //       items: stringlist
                            //           .map<DropdownMenuItem<String>>((String value) {
                            //         return DropdownMenuItem<String>(
                            //           value: value,
                            //           child: Text(value),
                            //         );
                            //       }).toList(),
                            //     ),
                            //   ),
                            // ),
                            // SizedBox(
                            //   height: height / 80,
                            // ),
                            // Container(
                            //   margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                            //   padding: const EdgeInsets.only(left: 20.0, right: 10.0),
                            //   decoration: new BoxDecoration(
                            //       borderRadius: BorderRadius.all(Radius.circular(2.0)),
                            //       border: new Border.all(color: Colors.black38)),
                            //   child: DropdownButtonHideUnderline(
                            //     child: DropdownButton<String>(
                            //       isExpanded: true,
                            //       value: dropdownValue2,
                            //       onChanged: (String newValue) {
                            //         setState(() {
                            //           dropdownValue2 = newValue;
                            //           for(int i=0;i<li1.items.length;i++)
                            //             if(li1.items[i].districtName==newValue) {
                            //               districttype = int.parse(li1.items[i].districtId);
                            //             }
                            //         });
                            //       },
                            //       items: stringlist1
                            //           .map<DropdownMenuItem<String>>((String value) {
                            //         return DropdownMenuItem<String>(
                            //           value: value,
                            //           child: Text(value),
                            //         );
                            //       }).toList(),
                            //     ),
                            //   ),
                            // ),
                            SizedBox(
                              height: height / 80,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
                              child: Container(
                                child: new TextField(
                                  enabled: false,
                                  controller: PincodeController,
                                  maxLength: 6,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: 'Pincode',
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

                  SizedBox(
                    height: height / 40,
                  ),
                  //
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //   children: [
                  //     Container(
                  //         alignment: Alignment.center,
                  //         decoration: BoxDecoration(
                  //             color: Colors.red,
                  //             borderRadius: BorderRadius.all(Radius.circular(50))),
                  //         child: FlatButton(
                  //           onPressed: () {
                  //             if(PincodeController.text.length==6&&ShopNameController.text.length!=0&&ShopRentController.text.length!=0&&ShopDepositController.text.length!=0&&OwnerNameController.text.length!=0&&OwnerPhoneController.text.length>9&&dropdownValue1!='-- Select State --'&&dropdownValue2!= '-- Select District --'&&addressController.text.length!=0)
                  //               uploadImage();
                  //             else
                  //             {
                  //               if(ShopNameController.text.length==0)
                  //                 showDialog<void>(
                  //                   context: context,
                  //                   barrierDismissible: false, // user must tap button!
                  //                   builder: (BuildContext context) {
                  //                     return AlertDialog(
                  //                       title: Text("Name cannot be empty"),
                  //
                  //                       actions: <Widget>[
                  //                         TextButton(
                  //                           child: Text('OK'),
                  //                           onPressed: () {
                  //                             Navigator.of(context).pop();
                  //                           },
                  //                         ),
                  //                       ],
                  //                     );
                  //                   },
                  //                 );
                  //
                  //               else if(PincodeController.text.length!=6)
                  //                 showDialog<void>(
                  //                   context: context,
                  //                   barrierDismissible: false, // user must tap button!
                  //                   builder: (BuildContext context) {
                  //                     return AlertDialog(
                  //                       title: Text("Pincode Should be 6 digits"),
                  //                       actions: <Widget>[
                  //                         TextButton(
                  //                           child: Text('OK'),
                  //                           onPressed: () {
                  //                             Navigator.of(context).pop();
                  //                           },
                  //                         ),
                  //                       ],
                  //                     );
                  //                   },
                  //                 );
                  //
                  //               else if(ShopRentController.text.length==0)
                  //                 showDialog<void>(
                  //                   context: context,
                  //                   barrierDismissible: false, // user must tap button!
                  //                   builder: (BuildContext context) {
                  //                     return AlertDialog(
                  //                       title: Text("Shop Rent Cannot be Empty"),
                  //                       actions: <Widget>[
                  //                         TextButton(
                  //                           child: Text('OK'),
                  //                           onPressed: () {
                  //                             Navigator.of(context).pop();
                  //                           },
                  //                         ),
                  //                       ],
                  //                     );
                  //                   },
                  //                 );
                  //               else if(OwnerNameController.text.length==0)
                  //                 showDialog<void>(
                  //                   context: context,
                  //                   barrierDismissible: false, // user must tap button!
                  //                   builder: (BuildContext context) {
                  //                     return AlertDialog(
                  //                       title: Text("Owner Name Cannot Be Empty"),
                  //                       actions: <Widget>[
                  //                         TextButton(
                  //                           child: Text('OK'),
                  //                           onPressed: () {
                  //                             Navigator.of(context).pop();
                  //                           },
                  //                         ),
                  //                       ],
                  //                     );
                  //                   },
                  //                 );
                  //               else if(OwnerPhoneController.text.length<10)
                  //                 showDialog<void>(
                  //                   context: context,
                  //                   barrierDismissible: false, // user must tap button!
                  //                   builder: (BuildContext context) {
                  //                     return AlertDialog(
                  //                       title: Text("Phone Number should be 10 characters"),
                  //                       actions: <Widget>[
                  //                         TextButton(
                  //                           child: Text('OK'),
                  //                           onPressed: () {
                  //                             Navigator.of(context).pop();
                  //                           },
                  //                         ),
                  //                       ],
                  //                     );
                  //                   },
                  //                 );
                  //               else if(OwnerPhoneController.text!=OwnerNameController.text)
                  //                 showDialog<void>(
                  //                   context: context,
                  //                   barrierDismissible: false, // user must tap button!
                  //                   builder: (BuildContext context) {
                  //                     return AlertDialog(
                  //                       title: Text("Password and Confirm Password should be same"),
                  //                       actions: <Widget>[
                  //                         TextButton(
                  //                           child: Text('OK'),
                  //                           onPressed: () {
                  //                             Navigator.of(context).pop();
                  //                           },
                  //                         ),
                  //                       ],
                  //                     );
                  //                   },
                  //                 );
                  //
                  //               else if(addressController.text.length==0)
                  //                 showDialog<void>(
                  //                   context: context,
                  //                   barrierDismissible: false, // user must tap button!
                  //                   builder: (BuildContext context) {
                  //                     return AlertDialog(
                  //                       title: Text("Address cannot be empty"),
                  //                       actions: <Widget>[
                  //                         TextButton(
                  //                           child: Text('OK'),
                  //                           onPressed: () {
                  //                             Navigator.of(context).pop();
                  //                           },
                  //                         ),
                  //                       ],
                  //                     );
                  //                   },
                  //                 );
                  //               else if(ShopDepositController.text.length==0)
                  //                 showDialog<void>(
                  //                   context: context,
                  //                   barrierDismissible: false, // user must tap button!
                  //                   builder: (BuildContext context) {
                  //                     return AlertDialog(
                  //                       title: Text("Email cannot be empty"),
                  //                       actions: <Widget>[
                  //                         TextButton(
                  //                           child: Text('OK'),
                  //                           onPressed: () {
                  //                             Navigator.of(context).pop();
                  //                           },
                  //                         ),
                  //                       ],
                  //                     );
                  //                   },
                  //                 );
                  //               else if(dropdownValue1=='-- Select State --')
                  //                 showDialog<void>(
                  //                   context: context,
                  //                   barrierDismissible: false, // user must tap button!
                  //                   builder: (BuildContext context) {
                  //                     return AlertDialog(
                  //                       title: Text("Please Choose State"),
                  //                       actions: <Widget>[
                  //                         TextButton(
                  //                           child: Text('OK'),
                  //                           onPressed: () {
                  //                             Navigator.of(context).pop();
                  //                           },
                  //                         ),
                  //                       ],
                  //                     );
                  //                   },
                  //                 );
                  //               else if(dropdownValue2=='-- Select District --')
                  //                 showDialog<void>(
                  //                   context: context,
                  //                   barrierDismissible: false, // user must tap button!
                  //                   builder: (BuildContext context) {
                  //                     return AlertDialog(
                  //                       title: Text("Please Choose District"),
                  //                       actions: <Widget>[
                  //                         TextButton(
                  //                           child: Text('OK'),
                  //                           onPressed: () {
                  //                             Navigator.of(context).pop();
                  //                           },
                  //                         ),
                  //                       ],
                  //                     );
                  //                   },
                  //                 );
                  //             }
                  //           },
                  //           child: Text(
                  //             "Save",
                  //             style: TextStyle(color: Colors.white),
                  //           ),
                  //         )),
                  //     Container(
                  //         alignment: Alignment.center,
                  //         decoration: BoxDecoration(
                  //             color: Colors.grey,
                  //             borderRadius: BorderRadius.all(Radius.circular(50))),
                  //         child: FlatButton(
                  //           onPressed: () {},
                  //           child: Text(
                  //             "Cancel",
                  //             style: TextStyle(color: Colors.white),
                  //           ),
                  //         )),
                  //   ],
                  // ),
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
}

class BackendService {
  static DVShopListUserRoleModel li1;

  static SupervisorListings li2;

  static Future<List> getSuggestions(String query) async {
    var url;
    url =
        //'http://35.184.156.126.xip.io/cyberhome/home.php?username=kavin&query=table';
        String_values.base_url + 'role-user-list?urole_id=17';
    var response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer ${RegisterPagesState.token}'
      },
    );
    if (response.statusCode == 200) {
      print(response.body);

      li1 = DVShopListUserRoleModel.fromJson(json.decode(response.body));
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
