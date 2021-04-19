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
import 'package:tankcare/CustomerModels/groupadd.dart';
import 'package:tankcare/Employee/Dashboard.dart';
import 'package:tankcare/Employee/EmployeeModels/DVStaff/DVStaffDetail.dart';
import 'package:tankcare/Vendor/Staff/VendorStaffList.dart';
import 'package:tankcare/VendorModels/AddStaffDropdownModel.dart';
import 'package:tankcare/VendorModels/StationVendorListings.dart';
import 'package:tankcare/string_values.dart';

class EmployeeStaffView extends StatefulWidget {
  EmployeeStaffView({Key key, this.id});

  String id;

  @override
  EmployeeStaffViewState createState() => EmployeeStaffViewState();
}

class EmployeeStaffViewState extends State<EmployeeStaffView> {
  Set<Marker> markers = Set();
  bool isenable = true;
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
  TextEditingController totalservicecontroller = new TextEditingController();
  TextEditingController DepositAmountController = new TextEditingController();
  TextEditingController literpricecontroller = new TextEditingController();
  TextEditingController fixedpricecontroller = new TextEditingController();
  TextEditingController CoverageRangeController = new TextEditingController();
  TextEditingController DistrictController = new TextEditingController();
  TextEditingController AddressController = new TextEditingController();

  TextEditingController MobileController = new TextEditingController();
  TextEditingController AlertMobileController = new TextEditingController();
  TextEditingController EmailController = new TextEditingController();
  TextEditingController AccountNameController = new TextEditingController();
  TextEditingController AccountNoController = new TextEditingController();
  TextEditingController IFSCController = new TextEditingController();
  TextEditingController BankNameController = new TextEditingController();
  TextEditingController BranchNameController = new TextEditingController();
  TextEditingController GenderController = new TextEditingController();
  TextEditingController StateController = new TextEditingController();

  List<PlanServiceYearClass> listplanyear;
  List<PlanListClass> selectedAvengers;
  bool sort;

  static String dropdownValue = '-- Select Gender --';
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
  final dateFormatter = DateFormat('yyyy-MM-dd');
  String sql_dob_from;
  String sql_dob_to;
  TextEditingController datefromcontroller = new TextEditingController();
  TextEditingController datetocontroller = new TextEditingController();
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

  DVStaffDetailModel li;

  DAccDetails li1;
  Set<Circle> _circles = HashSet<Circle>();
  int statetype = 1;
  int districttype = 1;
  double radius = 500;
  GroupAdd li2;

  VendorListings li5;

  String stationid, empid;

  File image;

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
    sort = false;
    CoverageRangeController.text = "10";
    selectedAvengers = [];
    listplan = PlanListClass.getdata();

    listplanyear = PlanServiceYearClass.getdata();
    List<PlanServiceYearClass> tags = PlanServiceYearClass.getdata();
    String jsonTags = jsonEncode(tags);
    // print("res:${jsonTags}");
//    print("response: ${PlanServiceYearClass.toJson()}");
    super.initState();
  }

  Future<http.Response> details(planid) async {
    setState(() {
      loading = true;
    });
    var url = String_values.base_url + 'dvendor-staff-details/' + planid;
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
      li = DVStaffDetailModel.fromJson(json.decode(response.body));
      setState(() {
        this._typeAheadController.text = li.items.shopName.toString();
        NameController.text = li.items.dstaffName.toString();
        MobileController.text = li.items.dstaffPhone.toString();
        AlertMobileController.text = li.items.dstaffPhoneAlter.toString();
        EmailController.text = li.items.dstaffEmail.toString();
        datefromcontroller.text =   DateFormat('dd/MM/yyyy').format(
            DateTime.parse(li.items.dstaffDob.toString()));
        datetocontroller.text =   DateFormat('dd/MM/yyyy').format(
            DateTime.parse(li.items.dstaffDoj.toString()));
        GenderController.text = li.items.dstaffGender.toString();
        StateController.text = li.items.stateName.toString();
        DistrictController.text = li.items.districtName.toString();
        PincodeController.text = li.items.dstaffPincode.toString();
        AddressController.text = li.items.dstaffAddress.toString();
        li1 = DAccDetails.fromJson(json.decode(li.items.dstaffBankDetails));
        AccountNameController.text = li1.dstaffAccName.toString();
        AccountNoController.text = li1.dstaffAccNo.toString();
        IFSCController.text = li1.dstaffAccIfsc.toString();
        BranchNameController.text = li1.dstaffAccBranch.toString();
        BankNameController.text = li1.dstaffAccBank.toString();

        // ServiceController.text=li.res.planDatas.planServicetype.toString();
        // PropertyTypeController.text=li.res.planDatas.planPropertytypeId.toString();
        // valuecontroller.text=li.res.planDatas.planUnit.toString();
        // LiterFromController.text=li.res.planDatas.planSizeFrom.toString();
        // LiterToController.text=li.res.planDatas.planSizeTo.toString();
        // statusController.text=li.property.propertyStatus.toString();
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
          'POST', Uri.parse(String_values.base_url + 'vendor-staff-add'));
      //property_id plan_id pplan_name pplan_year pplan_service pplan_price pplan_tot_price pplan_start_date
      request.headers.addAll(headers);
      for (int i = 0; i < files.length; i++) {
        request.files.add(
            await http.MultipartFile.fromPath('staff_photos', files[i].path));
        print(files[i].path);
      }
      for (int i = 0; i < files1.length; i++) {
        request.files.add(
            await http.MultipartFile.fromPath('staff_proofs', files1[i].path));
        print(files1[i].path);
      }
      request.fields['staff_name'] = _typeAheadController.text;
      request.fields['staff_phone'] = MobileController.text;
      request.fields['staff_phone_alter'] = AlertMobileController.text;
      request.fields['staff_email'] = EmailController.text;
      request.fields['staff_gender'] = dropdownValue.toUpperCase();
      request.fields['staff_dob'] = sql_dob_from;

      request.fields['staff_doj'] = sql_dob_to;
      request.fields['staff_address'] = addressController.text.toString();
      request.fields['staff_pincode'] = PincodeController.text.toString();
      request.fields['staff_district'] = districttype.toString();
      request.fields['staff_state'] = statetype.toString();

      request.fields['staff_acc_name'] = AccountNameController.text;
      request.fields['staff_acc_no'] = AccountNoController.text.toString();
      request.fields['staff_acc_branch'] = BranchNameController.text.toString();
      request.fields['staff_acc_bank'] = BankNameController.text.toString();
      request.fields['staff_acc_ifsc'] = IFSCController.text.toString();
      request.fields['service_station_id'] = stationid;
      var response = await request.send();
      response.stream.transform(utf8.decoder).listen((value) {
        print(value);

        if (value.contains("true")) {
          setState(() {
            loading = false;
          });
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => VendorStaffList()));
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
                          "View Staff",
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
                         initiallyExpanded: false,
                          title: Text(
                            "Personal Details",
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
                                    labelText: 'Select Service Station',
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
                                      i < BackendService.li1.values.length;
                                      i++) {
                                    print(BackendService
                                        .li1.values[i].stationName);
                                    stationid = BackendService
                                        .li1.values[i].stationId
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
                                controller: NameController,
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
                            ),
                            SizedBox(
                              height: height / 50,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
                              child: new TextField(
                                enabled: false,
                                controller: MobileController,
                                decoration: InputDecoration(
                                  labelText: 'Mobile Number',
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
                                controller: AlertMobileController,
                                decoration: InputDecoration(
                                  labelText: 'Alert Mobile Number',
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
                                controller: EmailController,
                                decoration: InputDecoration(
                                  labelText: 'Email',
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
                                  const EdgeInsets.only(left: 24, right: 24),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    flex: 5,
                                    child: TextField(
                                      enabled: false,
                                      onTap: () async {
                                        DateTime date = DateTime(1900);
                                        FocusScope.of(context)
                                            .requestFocus(new FocusNode());

                                        date = await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now().subtract(
                                                new Duration(days: 23725)),
                                            lastDate: DateTime.now()
                                                .add(new Duration(days: 365)));
                                        /*    var time =await showTimePicker(
                              initialTime: TimeOfDay.now(),
                              context: context,
                            );*/
                                        sql_dob_from =
                                            dateFormatter.format(date);
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
                                        labelText: 'Date of Birth',
                                        hintStyle: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 16.0,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(25.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                      flex: 1,
                                      child: SizedBox(
                                        width: 1,
                                      )),
                                  Flexible(
                                    flex: 5,
                                    child: TextField(
                                      enabled: false,
                                      onTap: () async {
                                        DateTime date = DateTime(1900);
                                        FocusScope.of(context)
                                            .requestFocus(new FocusNode());

                                        date = await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now().subtract(
                                                new Duration(days: 23725)),
                                            lastDate: DateTime.now()
                                                .add(new Duration(days: 365)));
                                        /*    var time =await showTimePicker(
                          initialTime: TimeOfDay.now(),
                          context: context,
                        );*/
                                        sql_dob_to = dateFormatter.format(date);
                                        print("date" + sql_dob_to);
                                        datetocontroller.text =
                                            date.day.toString() +
                                                '/' +
                                                date.month.toString() +
                                                '/' +
                                                date.year.toString();
                                      },
                                      controller: datetocontroller,
                                      decoration: InputDecoration(
                                        prefixIcon:
                                            Icon(Icons.calendar_today_outlined),
                                        labelText: 'Date of Joining',
                                        hintStyle: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 16.0,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(25.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: height / 80,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
                              child: new TextField(
                                enabled: false,
                                controller: GenderController,
                                decoration: InputDecoration(
                                  labelText: 'Gender',
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
                         initiallyExpanded: false,
                          title: Text(
                            "Home Address",
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
                            SizedBox(
                              height: height / 80,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
                              child: Container(
                                child: new TextFormField(
                                  enabled: false,
                                  controller: AddressController,
                                  minLines: 6,
                                  maxLines: 20,
                                  keyboardType: TextInputType.number,
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

                  Container(
                      margin: const EdgeInsets.only(top: 10),
                      color: Colors.red.shade50,
                      child: ExpansionTile(
                          backgroundColor: Colors.white,
                         initiallyExpanded: false,
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
                                    "Employee Passport Size Photo",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 15),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              child: Column(
                                children: [
                                  GridView.count(
                                    physics: ScrollPhysics(),
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    crossAxisCount: 2,
                                    childAspectRatio: 1,
                                    children: List.generate(
                                      li.items.dstaffPhotos.length,
                                      (index) {
                                        return Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Card(
                                                elevation: 5,
                                                clipBehavior: Clip.antiAlias,
                                                child: InkWell(
                                                  onTap: () {
                                                    showDialog(
                                                        context: context,
                                                        child: Image.network(li
                                                            .items
                                                            .dstaffPhotos[index]
                                                            .imgPath));
                                                  },
                                                  child: Image.network(
                                                    li.items.dstaffPhotos[index]
                                                        .imgPath,
                                                    height: 300,
                                                    width: 300,
                                                  ),
                                                )));
                                      },
                                    ),
                                  ),
                                ],
                              ),
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
                                    "Employee Address Proof",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 15),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              child: Column(
                                children: [
                                  GridView.count(
                                    physics: ScrollPhysics(),
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    crossAxisCount: 2,
                                    childAspectRatio: 1,
                                    children: List.generate(
                                      li.items.dstaffProofs.length,
                                      (index) {
                                        return Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Card(
                                                elevation: 5,
                                                clipBehavior: Clip.antiAlias,
                                                child: InkWell(
                                                  onTap: () {
                                                    showDialog(
                                                        context: context,
                                                        child: Image.network(li
                                                            .items
                                                            .dstaffProofs[index]
                                                            .imgPath));
                                                  },
                                                  child: Image.network(
                                                    li.items.dstaffProofs[index]
                                                        .imgPath,
                                                    height: 300,
                                                    width: 300,
                                                  ),
                                                )));
                                      },
                                    ),
                                  ),
                                ],
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
                            "Account Details",
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
                                  controller: AccountNameController,
                                  decoration: InputDecoration(
                                    labelText: 'Account Name',
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
                              height: height / 50,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
                              child: Container(
                                child: new TextField(
                                  enabled: false,
                                  controller: AccountNoController,
                                  decoration: InputDecoration(
                                    labelText: 'Account No',
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
                              height: height / 50,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
                              child: Container(
                                child: new TextField(
                                  enabled: false,
                                  controller: IFSCController,
                                  decoration: InputDecoration(
                                    labelText: 'IFSC code',
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
                              height: height / 50,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
                              child: Container(
                                child: new TextField(
                                  enabled: false,
                                  controller: BankNameController,
                                  decoration: InputDecoration(
                                    labelText: 'Bank Name',
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
                              height: height / 50,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
                              child: Container(
                                child: new TextField(
                                  enabled: false,
                                  controller: BranchNameController,
                                  decoration: InputDecoration(
                                    labelText: 'Branch Name',
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
                              height: height / 50,
                            ),
                          ])),

                  SizedBox(
                    height: height / 40,
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
}

class BackendService {
  static AddStaffDropdown li1;

  static Future<List> getSuggestions(String query) async {
    var url;

    url =
        //'http://35.184.156.126.xip.io/cyberhome/home.php?username=kavin&query=table';
        String_values.base_url + 'service-station-list';
    var response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer ${RegisterPagesState.token}'
      },
    );
    if (response.statusCode == 200) {
      print(response.body);

      li1 = AddStaffDropdown.fromJson(json.decode(response.body));
      List<String> s = new List();
      if (li1.values.length == 0) {
        // return ["No details"];
      } else {
        for (int i = 0; i < li1.values.length; i++)
          s.add(li1.values[i].stationName.toString());
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
