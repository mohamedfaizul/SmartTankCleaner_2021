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
import 'package:tankcare/VendorModels/StationVendorListings.dart';
import 'package:tankcare/VendorModels/StationView.dart';
import 'package:tankcare/VendorModels/SuperVisorListings.dart';

import '../../string_values.dart';

class ViewServiceStation extends StatefulWidget {
  ViewServiceStation({Key key, this.id});

  String id;

  @override
  ViewServiceStationState createState() => ViewServiceStationState();
}

class ViewServiceStationState extends State<ViewServiceStation> {
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
  TextEditingController AssignTypeController = new TextEditingController();
  final TextEditingController _typeAheadController = TextEditingController();
  TextEditingController totalservicecontroller = new TextEditingController();
  TextEditingController DepositAmountController = new TextEditingController();
  TextEditingController literpricecontroller = new TextEditingController();
  TextEditingController fixedpricecontroller = new TextEditingController();
  TextEditingController CoverageRangeController = new TextEditingController();
  TextEditingController StateController = new TextEditingController();
  TextEditingController DistrictController = new TextEditingController();

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
  TextEditingController PincodeController = new TextEditingController();
  TextEditingController SizeControllerTo = new TextEditingController();
  Completer<GoogleMapController> _controller = Completer();
  var loading = false;
  Position position;
  TextEditingController GroupNameController = new TextEditingController();
  TextEditingController GroupNumberController = new TextEditingController();

  TextEditingController addressController = new TextEditingController();

  StationDetail li;

  DistrictListings li1;
  Set<Circle> _circles = HashSet<Circle>();
  int statetype = 1;
  int districttype = 1;
  double radius = 500;
  GroupAdd li2;

  VendorListings li5;

  String vendorid, empid;

  ContractDetail li4;

  void _setCircles(LatLng point) {
    _circles.add(Circle(
        circleId: CircleId(""),
        center: point,
        radius: radius,
        fillColor: Colors.redAccent.withOpacity(0.2),
        strokeWidth: 3,
        strokeColor: Colors.redAccent));
  }

  void initState() {
    details(widget.id).then((value) {
      radius = double.parse(li.data.locationCoverage) * 100;

      print(radius);

      print(double.parse(li.data.latitude));
      print(double.parse(li.data.longitude));

      setState(() {
        loading = true;
      });
      setState(() {
        _setCircles(LatLng(
            double.parse(li.data.latitude), double.parse(li.data.longitude)));
        loading = false;
        print(_circles);
      });
      //
      // _setCircles(LatLng(latitudecamera,longitudecamera));
    });

    super.initState();
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
        // ServiceByController.text=li.planServices.se
        StationNameController.text = li.data.stationName;
        AssignTypeController.text = li.data.stationAssignUtype;
        _typeAheadController.text = li.data.assignby;
        CoverageRangeController.text = li.data.locationCoverage;
        addressController.text = li.data.mapLocation;
        StateController.text = li.data.stateName;
        DistrictController.text = li.data.districtName;
        li4 = ContractDetail.fromJson(json.decode(li.data.vendorContract));
        ContractStartDateController.text = DateFormat('dd/MM/yyyy').format(
            DateTime.parse(li4.cStardate.toString()));
        RefundableDepositAmountController.text = li4.refundAmnt.toString();
        ConsumableandAccessController.text = li4.accsAmnt.toString();
        TaxController.text = li4.accsTax.toString();
        TaxAmountController.text = li4.accsTaxAmnt.toString();
        RegistrationFeesController.text = li4.regFee.toString();
        TotalAmountController.text = li4.totalDeposit.toString();
        longitudecamera = double.parse(li.data.longitude);
        latitudecamera = double.parse(li.data.latitude);
        _kGooglePlex = CameraPosition(
            // bearing: 192.8334901395799,
            target: LatLng(double.parse(li.data.latitude),
                double.parse(li.data.longitude)),
            zoom: 14);
      });
      setState(() {
        loading = false;
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

  Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  // Future<http.Response> stateRequest() async {
  //   setState(() {
  //     loading=true;
  //   });
  //
  //   var url =
  //       String_values.base_url+'state';
  //   var response = await http.get(url,
  //     headers: {"Content-Type": "application/json",'Authorization': 'Bearer ${RegisterPagesState.token}'},
  //   );
  //   if (response.statusCode == 200)
  //   {
  //     setState(() {
  //       loading=false;
  //     });
  //     li= States.fromJson(json.decode(response.body));
  //
  //     stringlist.clear();
  //     stringlist.add('-- Select State --');
  //     for(int i=0;i<li.items.length;i++)
  //       stringlist.add(li.items[i].stateName);
  //     //dropdownValue1=stringlist[0];
  //
  //   }
  //
  //   else {
  //     setState(() {
  //       loading=false;
  //     });
  //     print("Retry");
  //   }
  //   print("response: ${response.statusCode}");
  //   print("response: ${response.body}");
  //   return response;
  // }
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

  String searchAddr;
  String station_assign_uid;
  DateTime _dateTime;

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
          'POST', Uri.parse(String_values.base_url + 'service-station-save'));
      //property_id plan_id pplan_name pplan_year pplan_service pplan_price pplan_tot_price pplan_start_date
      request.headers.addAll(headers);
      request.fields['station_name'] = StationNameController.text;
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
        print(value);
        setState(() {
          loading = false;
        });
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
                        "View Service Station",
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
                            padding:
                                const EdgeInsets.only(left: 10.0, right: 10.0),
                            child: new TextField(
                              enabled: false,
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
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 10.0, right: 10.0),
                            child: new TextField(
                              enabled: false,
                              controller: AssignTypeController,
                              decoration: InputDecoration(
                                labelText: 'Assign Type',
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
                            padding:
                                const EdgeInsets.only(left: 10.0, right: 10.0),
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
                                    print(BackendService.li2.values[i].empName);
                                    if (BackendService.li2.values[i].empName ==
                                        suggestion) {
                                      empid = BackendService.li2.values[i].empId
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
                                    enabled: false,
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
                            padding:
                                const EdgeInsets.only(left: 10.0, right: 10.0),
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
                            padding:
                                const EdgeInsets.only(left: 10.0, right: 10.0),
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
                            padding:
                                const EdgeInsets.only(left: 10.0, right: 10.0),
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
                            padding:
                                const EdgeInsets.only(left: 10.0, right: 10.0),
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
                            ],
                            rows: li.data.machineDetails
                                .map(
                                  (list) => DataRow(cells: [
                                    DataCell(
                                      Center(
                                          child: Text(
                                        list.machineCode,
                                        textAlign: TextAlign.center,
                                      )),
                                    ),
                                    DataCell(
                                      Center(
                                          child: Text(list.machineName,
                                              textAlign: TextAlign.center)),
                                    ),
                                    DataCell(
                                      Center(
                                          child: Text(list.machineType,
                                              textAlign: TextAlign.center)),
                                    ),
                                  ]),
                                )
                                .toList(),
                          ),
                        )
                      ],
                    )),
                Container(
                    margin: const EdgeInsets.only(top: 10),
                    color: Colors.red.shade50,
                    child: ExpansionTile(
                      backgroundColor: Colors.white,
                      initiallyExpanded: false,
                      title: Text(
                        "Staff Details",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, color: Colors.red),
                      ),
                      children: [
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
                                  ]),
                                )
                                .toList(),
                          ),
                        )
                      ],
                    )),
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
                            padding:
                                const EdgeInsets.only(left: 10.0, right: 10.0),
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
                            padding:
                                const EdgeInsets.only(left: 10.0, right: 10.0),
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
                            padding:
                                const EdgeInsets.only(left: 10.0, right: 10.0),
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
                            padding:
                                const EdgeInsets.only(left: 10.0, right: 10.0),
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
                            padding:
                                const EdgeInsets.only(left: 10.0, right: 10.0),
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
                            padding:
                                const EdgeInsets.only(left: 10.0, right: 10.0),
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
                            padding:
                                const EdgeInsets.only(left: 10.0, right: 10.0),
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
              ],
            )),

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
    if (ViewServiceStationState.dropdownValue == "Vendor") {
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
    } else if (ViewServiceStationState.dropdownValue == "Supervisor") {
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
