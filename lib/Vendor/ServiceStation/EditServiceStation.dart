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
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:tankcare/Customer/register.dart';
import 'package:tankcare/CustomerModels/districtlist.dart';
import 'package:tankcare/Employee/Dashboard.dart';
import 'package:tankcare/Employee/EmployeeModels/ErrorResponse.dart';
import 'package:tankcare/VendorModels/MachineListServiceStation.dart';
import 'package:tankcare/VendorModels/State.dart';
import 'package:tankcare/VendorModels/StationVendorListings.dart';
import 'package:tankcare/VendorModels/StationView.dart';
import 'package:tankcare/VendorModels/SuperVisorListings.dart';
import 'package:tankcare/VendorModels/VendorStaffSearch.dart';

import '../../string_values.dart';

class EditServiceStation extends StatefulWidget {
  EditServiceStation({Key key, this.id});

  String id;

  @override
  EditServiceStationState createState() => EditServiceStationState();
}

class EditServiceStationState extends State<EditServiceStation> {
  Set<Marker> markers = Set();
  bool isenable = true;
  bool cameramove = false;
  List<String> selectedIds = new List();
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
  final TextEditingController _typeAheadController2 = TextEditingController();
  TextEditingController totalservicecontroller = new TextEditingController();
  TextEditingController DepositAmountController = new TextEditingController();
  TextEditingController literpricecontroller = new TextEditingController();
  TextEditingController fixedpricecontroller = new TextEditingController();
  TextEditingController CoverageRangeController = new TextEditingController();

  TextEditingController ContractStartDateController =
      new TextEditingController();
  TextEditingController RefundableDepositAmountController =
      new TextEditingController();
  TextEditingController ConsumableandAccessController =
      new TextEditingController();
  TextEditingController TaxController = new TextEditingController();
  TextEditingController TaxAmountController = new TextEditingController();
  TextEditingController RegistrationFeesController =
      new TextEditingController();
  TextEditingController TotalAmountController = new TextEditingController();
  List<PlanServiceYearClass> listplanyear;
  List<PlanListClass> selectedAvengers;
  bool sort;

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
  TextEditingController NameController = new TextEditingController();
  TextEditingController StationNameController = new TextEditingController();
  TextEditingController SizeControllerFrom = new TextEditingController();
  TextEditingController DistrictController = new TextEditingController();
  TextEditingController StateController = new TextEditingController();
  TextEditingController PincodeController = new TextEditingController();
  TextEditingController SizeControllerTo = new TextEditingController();
  Completer<GoogleMapController> _controller = Completer();
  var loading = false;
  Position position;
  TextEditingController GroupNameController = new TextEditingController();
  TextEditingController GroupNumberController = new TextEditingController();

  TextEditingController addressController = new TextEditingController();

  States li2;

  DistrictListings li1;
  Set<Circle> _circles = HashSet<Circle>();
  int statetype = 1;
  int districttype = 1;
  double radius = 500;

  VendorListings li5;

  String vendorid, empid;

  StationDetail li;

  MachineListServiceStation li4;
  ContractDetail li6;

  int item;

  int item1;

  int redudent = 0;

  int redudent1 = 0;

  ErrorResponse ei;

  void _setCircles(LatLng point) {
    _circles.add(Circle(
        circleId: CircleId("circleIdVal"),
        center: point,
        radius: double.parse(CoverageRangeController.text) * 100,
        fillColor: Colors.redAccent.withOpacity(0.2),
        strokeWidth: 3,
        strokeColor: Colors.redAccent));
  }

  Future<http.Response> details(planid) async {
    setState(() {
      loading = true;
    });
    var url = String_values.base_url + 'service-station-view/' + planid;
    print(url);
    var response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer ${RegisterPagesState.token}'
      },
    );
    if (response.statusCode == 200) {
      li = StationDetail.fromJson(json.decode(response.body));
      setState(() {
        li6 = ContractDetail.fromJson(json.decode(li.data.vendorContract));
        ContractStartDateController.text = DateFormat('dd/MM/yyyy').format(
            DateTime.parse(li6.cStardate.toString()));
        RefundableDepositAmountController.text = li6.refundAmnt.toString();
        ConsumableandAccessController.text = li6.accsAmnt.toString();
        TaxController.text = li6.accsTax.toString();
        TaxAmountController.text = li6.accsTaxAmnt.toString();
        RegistrationFeesController.text = li6.regFee.toString();
        TotalAmountController.text = li6.totalDeposit.toString();
        for (int i = 0; i < li.data.machineDetails.length; i++)
          selectedIds.add(li.data.machineDetails[i].machineId);
        print(selectedIds);
        // ServiceByController.text=li.planServices.se
        StationNameController.text = li.data.stationName;
        if (li.data.stationAssignUtype == "VENDOR")
          dropdownValue = "Vendor";
        else
          dropdownValue = "Supervisor";
        _typeAheadController.text = li.data.assignby;
        station_assign_uid = li.data.stationAssignUid;
        CoverageRangeController.text = li.data.locationCoverage;
        addressController.text = li.data.mapLocation;
        districttype = int.parse(li.data.districtId);
        statetype = int.parse(li.data.stateId);
        longitudecamera = double.parse(li.data.longitude);
        latitudecamera = double.parse(li.data.latitude);
        _kGooglePlex = CameraPosition(
            // bearing: 192.8334901395799,
            target: LatLng(double.parse(li.data.latitude),
                double.parse(li.data.longitude)),
            zoom: 14);
        StateController.text = li.data.stateName;
        DistrictController.text = li.data.districtName;
        districtRequest(li.data.stateId).then((value) {
          dropdownValue2 = li.data.districtName;
        });
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

  void initState() {
    stateRequest()
        .then((value) => details(widget.id).then((value) {
              radius = double.parse(li.data.locationCoverage) * 100;

              print(radius);

              print(double.parse(li.data.latitude));
              print(double.parse(li.data.longitude));

              setState(() {
                loading = true;
              });
              setState(() {
                _setCircles(LatLng(double.parse(li.data.latitude),
                    double.parse(li.data.longitude)));
                loading = false;
                print(_circles);
              });
              //
              // _setCircles(LatLng(latitudecamera,longitudecamera));
            }))
        .then((value) => machinelist());

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

  Future<int> savestaff() async {
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
        'POST', Uri.parse(String_values.base_url + 'station-staff-save'));
    //property_id plan_id pplan_name pplan_year pplan_service pplan_price pplan_tot_price pplan_start_date
    request.headers.addAll(headers);
    request.fields['staff_id'] = BackendService2.li24.items[item1].staffId;
    request.fields['station_id'] = widget.id;
    var response = await request.send();
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
      setState(() {
        loading = false;
      });
      return response.statusCode;
    });
  }

  Future<int> machineAdd() async {
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

    var request = http.MultipartRequest('POST',
        Uri.parse(String_values.base_url + 'station-machine-assign-save'));
    //property_id plan_id pplan_name pplan_year pplan_service pplan_price pplan_tot_price pplan_start_date
    request.headers.addAll(headers);
    request.fields['machine_ids'] = json.encode(li.data.machineDetails);
    request.fields['station_id'] = widget.id;
    print(json.encode(selectedIds));
    var response = await request.send();
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
      setState(() {
        loading = false;
      });
      return response.statusCode;
    });
  }

  Future<http.Response> deletestaff(id) async {
    setState(() {
      loading = true;
    });

    var url = String_values.base_url + 'station-staff-delete/' + id;
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
      li2 = States.fromJson(json.decode(response.body));

      stringlist.clear();
      stringlist.add('-- Select State --');
      for (int i = 0; i < li2.items.length; i++)
        stringlist.add(li2.items[i].stateName);
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

  Future<http.Response> machinelist() async {
    setState(() {
      loading = true;
    });

    var url = String_values.base_url + 'my-machine-list';
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
      li4 = MachineListServiceStation.fromJson(json.decode(response.body));
      print("response: ${response.body}");
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
                zoom: 14);
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
        zoom: 17);
    print(position.latitude);
    print(position.longitude);
    controller.moveCamera(CameraUpdate.newCameraPosition(_kGooglePlex));
  }

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
        'POST', Uri.parse(String_values.base_url + 'service-station-save'));
    //property_id plan_id pplan_name pplan_year pplan_service pplan_price pplan_tot_price pplan_start_date
    request.headers.addAll(headers);
    request.fields['station_name'] = StationNameController.text;
    request.fields['station_id'] = widget.id;
    request.fields['station_assign_utype'] = servicetype;
    request.fields['station_assign_uid'] = station_assign_uid;
    request.fields['vendor_deposite_amount'] = DepositAmountController.text;
    request.fields['location_coverage'] = CoverageRangeController.text;
    request.fields['map_location'] = addressController.text;
    request.fields['latitude'] = latitudecamera.toString();
    request.fields['longitude'] = longitudecamera.toString();
    request.fields['district_id'] = districttype.toString();
    request.fields['state_id'] = statetype.toString();
    var response = await request.send();
    response.stream.transform(utf8.decoder).listen((value) {
      if(value.toString().contains("true")) {
        Fluttertoast.showToast(
            msg: "Edited Successfully",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.SNACKBAR,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );

      }
      else
      {
        ei=ErrorResponse.fromJson(jsonDecode(value));
        Fluttertoast.showToast(
            msg: ei.messages,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.SNACKBAR,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }
      print(value);
      setState(() {
        loading = false;
      });
      return response.statusCode;
    });
  }

  String searchAddr;
  String station_assign_uid;
  DateTime _dateTime;

  @override
  Widget build(BuildContext context) {
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
                          "Edit Service Station",
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
                            "Service Station Details",
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
                                enabled: true,
                                controller: StationNameController,
                                decoration: InputDecoration(
                                  labelText: 'Station Name',
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
                              margin: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
                              padding: const EdgeInsets.only(
                                  left: 20.0, right: 10.0),
                              decoration: new BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(2.0)),
                                  border:
                                      new Border.all(color: Colors.black38)),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  value: dropdownValue,
                                  onChanged: (String newValue) {
                                    setState(() {
                                      dropdownValue = newValue;
                                    });
                                  },
                                  items: <String>[
                                    '-- Assign Type --',
                                    "Vendor",
                                    "Supervisor",
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
                                    labelText: dropdownValue == "Vendor"
                                        ? 'Select Vendor'
                                        : dropdownValue == "Supervisor"
                                            ? 'Select Supervisor'
                                            : 'Select Vendor',
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
                                  // postRequest(suggestion);
                                  if (dropdownValue == "Vendor")
                                    for (int i = 0;
                                        i < BackendService.li1.values.length;
                                        i++) {
                                      print(BackendService
                                          .li1.values[i].vendorName);
                                      if (BackendService
                                              .li1.values[i].vendorName ==
                                          suggestion) {
                                        vendorid = BackendService
                                            .li1.values[i].vendorId
                                            .toString();
                                        station_assign_uid = BackendService
                                            .li1.values[i].vendorId
                                            .toString();
                                      }
                                    }
                                  else if (dropdownValue == "Supervisor")
                                    for (int i = 0;
                                        i < BackendService.li2.values.length;
                                        i++) {
                                      print(
                                          BackendService.li2.values[i].empName);
                                      if (BackendService
                                              .li2.values[i].empName ==
                                          suggestion) {
                                        empid = BackendService
                                            .li2.values[i].empId
                                            .toString();
                                        station_assign_uid = BackendService
                                            .li2.values[i].empId
                                            .toString();
                                      }
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
                            dropdownValue == "Vendor"
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10.0, right: 10.0),
                                    child: new TextField(
                                      enabled: true,
                                      controller: DepositAmountController,
                                      decoration: InputDecoration(
                                        labelText: 'Deposit Amount',
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
                                  )
                                : Container(),
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
                          initiallyExpanded: false,
                          title: Text(
                            "Operation Coverage",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, color: Colors.red),
                          ),
                          children: [
                            SizedBox(
                              height: height / 50,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  flex: 5,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10.0, right: 10.0),
                                    child: new TextField(
                                      onChanged: (string) {
                                        setState(() {});
                                      },
                                      enabled: false,
                                      keyboardType: TextInputType.number,
                                      controller: CoverageRangeController,
                                      decoration: InputDecoration(
                                        labelText: 'Coverage Range in KM',
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
                              ],
                            ),
                            SizedBox(
                              height: height / 50,
                            ),

                            SizedBox(
                              height: height / 50,
                            ),
                            Container(
                                padding:
                                    const EdgeInsets.only(left: 16, right: 16),
                                height: height / 2,
                                child: Stack(children: <Widget>[
                                  GoogleMap(
                                    zoomControlsEnabled: true,
                                    circles: _circles,
                                    mapType: MapType.normal,
                                    initialCameraPosition: _kGooglePlex,
                                    onMapCreated:
                                        (GoogleMapController controller) {
                                      _controller.complete(controller);
                                    },
                                  ),
                                  // markers: markers,

                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 50),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: new Icon(
                                        Icons.location_on,
                                        size: 50.0,
                                        color: Colors.red,
                                      ),
                                    ),
                                  )
                                ])),
                            //
                            SizedBox(
                              height: height / 80,
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

                  Container(
                      margin: const EdgeInsets.only(top: 10),
                      color: Colors.red.shade50,
                      child: ExpansionTile(
                          backgroundColor: Colors.white,
                          initiallyExpanded: true,
                          title: Text(
                            "Machine Add Details",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, color: Colors.red),
                          ),
                          children: [
                            SizedBox(
                              height: height / 50,
                            ),
                            Row(
                              children: [
                                Flexible(
                                  flex: 5,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10.0, right: 10.0),
                                    child: TypeAheadFormField(
                                      textFieldConfiguration:
                                          TextFieldConfiguration(
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
                                          labelText: 'Select Machine',
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
                                        return BackendService1.getSuggestions(
                                            pattern);
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
                                        // postRequest(suggestion);

                                        for (int i = 0;
                                            i <
                                                BackendService1
                                                    .li23.items.length;
                                            i++) {
                                          print(BackendService1
                                              .li23.items[i].machineName);
                                          if (BackendService1
                                                  .li23.items[i].machineName ==
                                              suggestion) {
                                            item = i;
                                          }
                                        }

                                        this._typeAheadController1.text =
                                            suggestion;
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
                                Flexible(
                                    flex: 1,
                                    child: IconButton(
                                        icon: Icon(
                                          Icons.add_circle_outline,
                                          color: Colors.red,
                                        ),
                                        onPressed: () {
                                          // for(int i=0;i<BackendService1.li23.items.length;i++)
                                          setState(() {
                                            redudent = 0;
                                            selectedIds.add(BackendService1
                                                .li23.items[item].machineId);
                                            print(selectedIds);
                                            for (int i = 0;
                                                i <
                                                    li.data.machineDetails
                                                        .length;
                                                i++)
                                              if (li.data.machineDetails[i]
                                                      .machineId ==
                                                  BackendService1
                                                      .li23
                                                      .items[item]
                                                      .machineId) redudent++;

                                            if (redudent == 0)
                                              li.data.machineDetails.add(
                                                  MachineDetails(
                                                      machineId:
                                                          BackendService1
                                                              .li23
                                                              .items[item]
                                                              .machineId,
                                                      machineCode:
                                                          BackendService1
                                                              .li23
                                                              .items[item]
                                                              .machineCode,
                                                      machineName:
                                                          BackendService1
                                                              .li23
                                                              .items[item]
                                                              .machineName,
                                                      machineType:
                                                          BackendService1
                                                              .li23
                                                              .items[item]
                                                              .machineType));
                                            else
                                              Fluttertoast.showToast(
                                                  msg: "Machine Already Exists",
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity:
                                                      ToastGravity.SNACKBAR,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor: Colors.red,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0);
                                          });
                                        }))
                              ],
                            ),
                            SizedBox(
                              height: height / 50,
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                sortColumnIndex: 0,
                                columnSpacing: width / 25,
                                columns: [
                                  DataColumn(
                                    label: Center(
                                        child: Wrap(
                                      direction: Axis.vertical, //default
                                      alignment: WrapAlignment.center,
                                      children: [
                                        Text("Machine Code",
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
                                        Text("Machine Name",
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
                                        Text("Machine Type",
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
                                rows: li.data.machineDetails
                                    .map(
                                      (list) => DataRow(cells: [
                                        DataCell(
                                          Center(
                                              child: Text(
                                            list.machineCode.toString(),
                                            textAlign: TextAlign.center,
                                          )),
                                        ),
                                        DataCell(
                                          Center(
                                              child: Text(
                                                  list.machineName.toString(),
                                                  textAlign: TextAlign.center)),
                                        ),
                                        DataCell(
                                          Center(
                                              child: Text(
                                                  list.machineType.toString(),
                                                  textAlign: TextAlign.center)),
                                        ),
                                        DataCell(
                                          Center(
                                            child: IconButton(
                                                icon: Icon(
                                                  Icons.remove_circle_outline,
                                                  color: Colors.red,
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    setState(() {
                                                      li.data.machineDetails
                                                          .remove(list);
                                                      selectedIds.remove(list);
                                                      print(selectedIds);
                                                    });
                                                  });
                                                }),
                                          ),
                                        ),
                                      ]),
                                    )
                                    .toList(),
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
                                                          machineAdd().then((value) =>
                                                              Navigator.pushReplacement(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          EditServiceStation(
                                                                              id: widget.id))));
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
                  Container(
                      margin: const EdgeInsets.only(top: 10),
                      color: Colors.red.shade50,
                      child: ExpansionTile(
                          backgroundColor: Colors.white,
                          initiallyExpanded: true,
                          title: Text(
                            "Staff Add Details",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, color: Colors.red),
                          ),
                          children: [
                            SizedBox(
                              height: height / 50,
                            ),
                            Row(
                              children: [
                                Flexible(
                                  flex: 5,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10.0, right: 10.0),
                                    child: TypeAheadFormField(
                                      textFieldConfiguration:
                                          TextFieldConfiguration(
                                        enabled: true,
                                        controller: this._typeAheadController2,
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
                                          labelText: 'Select Staff',
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
                                        return BackendService2.getSuggestions(
                                            pattern);
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
                                        // postRequest(suggestion);

                                        for (int i = 0;
                                            i <
                                                BackendService2
                                                    .li24.items.length;
                                            i++) {
                                          print(BackendService2
                                              .li24.items[i].staffName);
                                          if (BackendService2
                                                  .li24.items[i].staffName ==
                                              suggestion) {
                                            item1 = i;
                                          }
                                        }

                                        this._typeAheadController2.text =
                                            suggestion;
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
                                Flexible(
                                    flex: 1,
                                    child: IconButton(
                                        icon: Icon(
                                          Icons.add_circle_outline,
                                          color: Colors.red,
                                        ),
                                        onPressed: () {
                                          // for(int i=0;i<BackendService1.li23.items.length;i++)
                                          setState(() {
                                            redudent1 = 0;
                                            for (int i = 0;
                                                i < li.data.staff.length;
                                                i++)
                                              if (li.data.staff[i].staffId ==
                                                  BackendService2
                                                      .li24
                                                      .items[item1]
                                                      .staffId) redudent1++;
                                            if (redudent1 == 0) {
                                              savestaff().then((value) =>
                                                  li.data.staff.add(Staff(
                                                      staffId: BackendService2
                                                          .li24
                                                          .items[item1]
                                                          .staffId,
                                                      staffCode: BackendService2
                                                          .li24
                                                          .items[item1]
                                                          .staffCode,
                                                      staffName: BackendService2
                                                          .li24
                                                          .items[item1]
                                                          .staffName)));
                                            } else
                                              Fluttertoast.showToast(
                                                  msg: "Staff Already Exists",
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity:
                                                      ToastGravity.SNACKBAR,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor: Colors.red,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0);
                                          });
                                        }))
                              ],
                            ),
                            SizedBox(
                              height: height / 50,
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                sortColumnIndex: 0,
                                columnSpacing: width / 25,
                                columns: [
                                  DataColumn(
                                    label: Center(
                                        child: Wrap(
                                      direction: Axis.vertical, //default
                                      alignment: WrapAlignment.center,
                                      children: [
                                        Text("Staff Code",
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
                                        Text("Staff Name",
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
                                rows: li.data.staff
                                    .map(
                                      (list) => DataRow(cells: [
                                        DataCell(
                                          Center(
                                              child: Text(
                                            list.staffCode,
                                            textAlign: TextAlign.center,
                                          )),
                                        ),
                                        DataCell(
                                          Center(
                                              child: Text(list.staffName,
                                                  textAlign: TextAlign.center)),
                                        ),
                                        DataCell(
                                          Center(
                                            child: IconButton(
                                                icon: Icon(
                                                  Icons.remove_circle_outline,
                                                  color: Colors.red,
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    setState(() {
                                                      deletestaff(list.staffId)
                                                          .then((value) => li
                                                              .data.staff
                                                              .remove(list));
                                                    });
                                                  });
                                                }),
                                          ),
                                        ),
                                      ]),
                                    )
                                    .toList(),
                              ),
                            ),
                            SizedBox(
                              height: height / 80,
                            ),
                          ])),
                  Container(
                      margin: const EdgeInsets.only(top: 10),
                      color: Colors.red.shade50,
                      child: ExpansionTile(
                          backgroundColor: Colors.white,
                          initiallyExpanded: true,
                          title: Text(
                            "Contract Details",
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
                                controller: ContractStartDateController,
                                decoration: InputDecoration(
                                  labelText: 'Contract Start Date',
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
                                controller: RefundableDepositAmountController,
                                decoration: InputDecoration(
                                  labelText: 'Refundable Deposit Amount',
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
                                controller: ConsumableandAccessController,
                                decoration: InputDecoration(
                                  labelText: 'Consumable and Accessories',
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
                                controller: TaxController,
                                decoration: InputDecoration(
                                  labelText: 'Tax',
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
                                controller: TaxAmountController,
                                decoration: InputDecoration(
                                  labelText: 'Tax Amount',
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
                                controller: RegistrationFeesController,
                                decoration: InputDecoration(
                                  labelText: 'Registration Fees',
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
                                controller: TotalAmountController,
                                decoration: InputDecoration(
                                  labelText: 'Total Amount',
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
  static VendorListings li1;

  static SupervisorListings li2;

  static Future<List> getSuggestions(String query) async {
    var url;
    if (EditServiceStationState.dropdownValue == "Vendor") {
      url =
          //'http://35.184.156.126.xip.io/cyberhome/home.php?username=kavin&query=table';
          String_values.base_url + 'vendor-list?approval=a';
      var response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer ${RegisterPagesState.token}'
        },
      );
      if (response.statusCode == 200) {
        print(response.body);

        li1 = VendorListings.fromJson(json.decode(response.body));
        List<String> s = new List();
        if (li1.values.length == 0) {
          // return ["No details"];
        } else {
          for (int i = 0; i < li1.values.length; i++)
            s.add(li1.values[i].vendorName.toString());
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
    } else if (EditServiceStationState.dropdownValue == "Supervisor") {
      url =
          //'http://35.184.156.126.xip.io/cyberhome/home.php?username=kavin&query=table';
          String_values.base_url + 'superviser-list';
      var response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer ${RegisterPagesState.token}'
        },
      );
      if (response.statusCode == 200) {
        print(response.body);

        li2 = SupervisorListings.fromJson(json.decode(response.body));
        List<String> s = new List();
        if (li2.values.length == 0) {
          // return ["No details"];
        } else {
          for (int i = 0; i < li2.values.length; i++)
            if (li2.values[i].empName
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase()))
              s.add(li2.values[i].empName.toString());
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
}

class BackendService1 {
  static MachineListServiceStation li23;

  static Future<List> getSuggestions(String query) async {
    var url;

    url =
        //'http://35.184.156.126.xip.io/cyberhome/home.php?username=kavin&query=table';
        String_values.base_url + 'my-machine-list';
    var response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer ${RegisterPagesState.token}'
      },
    );
    if (response.statusCode == 200) {
      print(response.body);

      li23 = MachineListServiceStation.fromJson(json.decode(response.body));
      List<String> s = new List();
      if (li23.items.length == 0) {
        // return ["No details"];
      } else {
        for (int i = 0; i < li23.items.length; i++)
          s.add(li23.items[i].machineName.toString());
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

class BackendService2 {
  static VendorStaffSearch li24;

  static Future<List> getSuggestions(String query) async {
    var url;

    url =
        //'http://35.184.156.126.xip.io/cyberhome/home.php?username=kavin&query=table';
        String_values.base_url + 'vendor-staff-search?dhandapani=n';
    var response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer ${RegisterPagesState.token}'
      },
    );
    if (response.statusCode == 200) {
      print(response.body);

      li24 = VendorStaffSearch.fromJson(json.decode(response.body));
      List<String> s = new List();
      if (li24.items.length == 0) {
        // return ["No details"];
      } else {
        for (int i = 0; i < li24.items.length; i++)
          s.add(li24.items[i].staffName.toString());
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
