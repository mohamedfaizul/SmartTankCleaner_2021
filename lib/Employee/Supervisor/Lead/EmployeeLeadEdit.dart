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
import 'package:tankcare/CustomerModels/CustomerSelectPhoneModel.dart';
import 'package:tankcare/CustomerModels/districtlist.dart';
import 'package:tankcare/CustomerModels/groupadd.dart';
import 'package:tankcare/Employee/Dashboard.dart';
import 'package:tankcare/Employee/EmployeeModels/ErrorResponse.dart';
import 'package:tankcare/Employee/EmployeeModels/Lead/LeadDetail.dart';
import 'package:tankcare/Employee/EmployeeModels/Lead/LeadFollowerApi.dart';
import 'package:tankcare/Employee/Supervisor/Lead/EmployeeLeadList.dart';
import 'package:tankcare/VendorModels/State.dart';
import 'package:tankcare/string_values.dart';

class EmployeeLeadEdit extends StatefulWidget {
  EmployeeLeadEdit({Key key, this.id});

  String id;

  @override
  EmployeeLeadEditState createState() => EmployeeLeadEditState();
}

class EmployeeLeadEditState extends State<EmployeeLeadEdit> {
  Set<Marker> markers = Set();
  bool isenable = true;
  bool cameramove = false;
  double latitudecamera, longitudecamera;
  List<String> items = List<String>.generate(7, (index) {
    return "Item - $index";
  });

  final dateFormatter = DateFormat('yyyy-MM-dd');
  String sql_dob_from;
  String sql_dob_to;
  TextEditingController datefromcontroller = new TextEditingController();
  TextEditingController FollowupNotesController = new TextEditingController();
  TextEditingController datetocontroller = new TextEditingController();
  EmployeeLeadDetailModel li5;
  String dropdownValue3 = '-Action-';
  String dropdownValue5 = '-- Follower Type --';
  States li;

  DistrictListings li1;

  LeadFollowerModel li6;

  ErrorResponse ei;

  Future<http.Response> delete(planid) async {
    setState(() {
      loading = true;
    });

    var url = String_values.base_url + 'lead-followup-delete/' + planid;
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
        details(widget.id).then((value) => loading = false);
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
    var url = String_values.base_url + 'lead-details/' + planid;
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
      li5 = EmployeeLeadDetailModel.fromJson(json.decode(response.body));
      setState(() {
        NameController.text = li5.items.cusName.toString();
        EmailController.text = li5.items.cusEmail.toString();
        ;
        _typeAheadController.text = li5.items.cusPhone.toString();
        ;
        CusCodeController.text = li5.items.cusCode.toString();
        ;
        addressController.text = li5.items.cusAddress.toString();
        ;
        StateController.text = li5.items.stateName.toString();
        ;
        DistrictController.text = li5.items.districtName.toString();
        ;
        NotesController.text = li5.items.leadNotes.toString();
        ;
        PincodeController.text = li5.items.cusPincode.toString();

        FollowerNameController.text = li5.items.followerBy.toString();
        ;
        FollowerTypeController.text = li5.items.leadFollowUtype.toString();
        ;
        FollowupStatusController.text = li5.items.leadFollowupStatus.toString();
        ;
       if(li5.items.leadFollowUtype.toString()=="FRANCHISE")
        dropdownValue5="Franchise";
       else
         dropdownValue5="District Vendor";
        dropdownValue=li5.items.leadFollowupStatus.substring(0,1)+li5.items.leadFollowupStatus.toLowerCase().substring(1,li5.items.leadFollowupStatus.length);
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

  List<PlanListClass> listplan;
  var addressText;
  var first;
  static CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(11.127123, 78.656891),
    zoom: 14,
  );
  TextEditingController serviceyearcontroller = new TextEditingController();
  static final TextEditingController _typeAheadController = TextEditingController();
  TextEditingController totalservicecontroller = new TextEditingController();
  TextEditingController DepositAmountController = new TextEditingController();
  TextEditingController literpricecontroller = new TextEditingController();
  TextEditingController fixedpricecontroller = new TextEditingController();
  TextEditingController CoverageRangeController = new TextEditingController();
  static  TextEditingController CusCodeController = new TextEditingController();
  static TextEditingController StateController = new TextEditingController();
  static TextEditingController DistrictController = new TextEditingController();
  TextEditingController ConfirmPasswordController = new TextEditingController();
  TextEditingController NotesController = new TextEditingController();
  TextEditingController FollowerTypeController = new TextEditingController();
  TextEditingController FollowerNameController = new TextEditingController();
  TextEditingController FollowupStatusController = new TextEditingController();
  TextEditingController FollowupStatController = new TextEditingController();
  List<PlanServiceYearClass> listplanyear;
  List<PlanListClass> selectedAvengers;
  bool sort;

  static String dropdownValue = 'Followup';
  List<String> stringlist = ['-Action-', 'View', "Delete"];
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
  static TextEditingController EmailController = new TextEditingController();
  static TextEditingController NameController = new TextEditingController();
  static TextEditingController MobileController = new TextEditingController();
  static TextEditingController SizeControllerFrom = new TextEditingController();
  static TextEditingController PincodeController = new TextEditingController();
  TextEditingController SizeControllerTo = new TextEditingController();
  Completer<GoogleMapController> _controller = Completer();
  var loading = false;
  Position position;
  TextEditingController GroupNameController = new TextEditingController();
  TextEditingController GroupNumberController = new TextEditingController();

  static TextEditingController addressController = new TextEditingController();

  Set<Circle> _circles = HashSet<Circle>();
  int statetype = 1;
  int districttype = 1;
  double radius = 500;
  GroupAdd li2;

  String vendorid, empid;

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
    selectedAvengers = [];
    listplan = PlanListClass.getdata();

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
  Future<int> uploadImage1() async {
    setState(() {
      loading = true;
    });

    Map<String, String> headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer ${RegisterPagesState.token}'
    };

    var request = http.MultipartRequest(
        'POST', Uri.parse(String_values.base_url + 'lead-followup-save'));
    //property_id plan_id pplan_name pplan_year pplan_service pplan_price pplan_tot_price pplan_start_date
    request.headers.addAll(headers);
    request.fields['lead_id'] = widget.id;
    request.fields['followup_date'] = sql_dob_from;
    request.fields['followup_notes'] = FollowupNotesController.text;
    request.fields['followup_status'] = dropdownValue.toUpperCase();

    var response = await request.send();
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);

      setState(() {
        loading = false;
      });
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => EmployeeLeadList()));
      return response.statusCode;
    });
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

  Future<int> followername(name) async {
    setState(() {
      loading = true;
    });

    Map<String, String> headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer ${RegisterPagesState.token}'
    };

    var request = http.MultipartRequest(
        'POST', Uri.parse(String_values.base_url + 'find-lead-follower'));
    //property_id plan_id pplan_name pplan_year pplan_service pplan_price pplan_tot_price pplan_start_date
    request.headers.addAll(headers);
    request.fields['follow_utype'] = name;
    request.fields['cus_state'] = BackendService.li1.data.stateId;
    request.fields['cus_district'] = BackendService.li1.data.districtId;
    request.fields['cus_pincode'] = BackendService.li1.data.cusPincode;;

    var response = await request.send();
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);

      li6=LeadFollowerModel.fromJson(json.decode(value));
      FollowerNameController.text=li6.data.followUname;
      setState(() {
        loading = false;
      });

      return response.statusCode;
    });
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
          'POST', Uri.parse(String_values.base_url + 'lead-save'));
      //property_id plan_id pplan_name pplan_year pplan_service pplan_price pplan_tot_price pplan_start_date
      request.headers.addAll(headers);
      request.fields['cus_phone']=_typeAheadController.text;
      request.fields['cus_id']= li5.items.cusId;
      request.fields['cus_name']= li5.items.cusName;
      request.fields['cus_email']= li5.items.cusEmail;
      request.fields['cus_address']= li5.items.cusAddress;
      request.fields['cus_state']= li5.items.stateId;
      request.fields['cus_district']= li5.items.districtId;
      request.fields['cus_pincode']= li5.items.cusPincode;
      request.fields['lead_notes']= NotesController.text;
      request.fields['lead_followup_status'] = dropdownValue.toUpperCase();
      request.fields['cus_pincode']= li5.items.cusPincode;
      request.fields['lead_id']= widget.id;
      // lead_id
      if(dropdownValue5=="District Vendor")
        request.fields['lead_follow_utype']= "DVENDOR";
      else
        request.fields['lead_follow_utype']= "FRANCHISE";
      request.fields['lead_follow_uid']= li5.items.leadFollowUid;


      var response = await request.send();
      response.stream.transform(utf8.decoder).listen((value) {
        print(value);
        if (value.toString().contains("true")) {

          Fluttertoast.showToast(
              msg: "Edited Successfully",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.SNACKBAR,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => EmployeeLeadList()));
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
        setState(() {
          loading = false;
        });
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => EmployeeLeadList()));
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
                    "Lead Edit",
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
                      "Customer Details",
                      style: TextStyle(
                          fontWeight: FontWeight.w600, color: Colors.red),
                    ),
                    children: [
                      SizedBox(
                        height: height / 50,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        child: TypeAheadFormField(
                          textFieldConfiguration: TextFieldConfiguration(
                            enabled: false,
                            controller: _typeAheadController,
                            // onTap: ()
                            // {
                            //   Navigator.push(
                            //       context,
                            //       MaterialPageRoute(
                            //           builder: (context) =>
                            //               Category(userid:HomeState.userid,mapselection: true)));
                            // },
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Enter Mobile Number',
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
                          transitionBuilder: (context, suggestionsBox, controller) {
                            return suggestionsBox;
                          },
                          onSuggestionSelected: (suggestion) {
                            // postRequest(suggestion);
                            // for (int i = 0;
                            // i < BackendService.li1.data.length;
                            // i++) {
                            //   print(BackendService.li1.data[i].cusName);
                            //   if (BackendService.li1.data[i].cusName ==
                            //       suggestion) {
                            //     cusid = BackendService.li1.data[i].cusId;
                            //   }
                            // }
                            _typeAheadController.text = suggestion;
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
                        height: height / 50,
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
                        height: height / 50,
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
                      "Product Details",
                      style: TextStyle(
                          fontWeight: FontWeight.w600, color: Colors.red),
                    ),
                    children: [
                      SizedBox(
                        height: height / 40,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10.0, right: 10.0),
                        child: Container(
                          child: new TextField(
                            maxLines: 25,
                            minLines: 3,
                            controller: NotesController,
                            decoration: InputDecoration(
                              labelText: 'Notes',
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
            Container(
                margin: const EdgeInsets.only(top: 10),
                color: Colors.red.shade50,
                child: ExpansionTile(
                    backgroundColor: Colors.white,
                    initiallyExpanded: true,
                    title: Text(
                      "Follower Details",
                      style: TextStyle(
                          fontWeight: FontWeight.w600, color: Colors.red),
                    ),
                    children: [
                      SizedBox(
                        height: height / 40,
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                        padding: const EdgeInsets.only(left: 20.0, right: 10.0),
                        decoration: new BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(2.0)),
                            border: new Border.all(color: Colors.black38)),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: dropdownValue5,
                            onChanged: (String newValue) {
                              setState(() {
                                dropdownValue5 = newValue;
                                if(newValue=="District Vendor")
                                  followername("DVENDOR");
                                else if(newValue=="Franchise")
                                  followername("FRANCHISE");

                              });
                            },
                            items: <String>[
                              '-- Follower Type --',
                              "District Vendor",
                              "Franchise"
                            ].map<DropdownMenuItem<String>>((String value) {
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
                        child: Container(
                          child: new TextField(
                            enabled: false,
                            controller: FollowerNameController,
                            decoration: InputDecoration(
                              labelText: 'Follower Name',
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
                      Container(
                          margin:
                          const EdgeInsets.only(
                              left: 10.0,
                              right: 10.0),
                          padding:
                          const EdgeInsets.only(
                              left: 20.0,
                              right: 10.0),
                          decoration: new BoxDecoration(
                              borderRadius:
                              BorderRadius.all(
                                  Radius.circular(
                                      2.0)),
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
                                value: dropdownValue,
                                onChanged: (String
                                newValue) {
                                  setState(() {
                                    dropdownValue =
                                        newValue;
                                  });
                                },
                                items: <String>[
                                  "Followup",
                                  "Done",
                                  "Close"
                                ].map<
                                    DropdownMenuItem<
                                        String>>((String
                                value) {
                                  return DropdownMenuItem<
                                      String>(
                                      value: value,
                                      child: Wrap(
                                          direction: Axis
                                              .vertical,
                                          //default
                                          alignment:
                                          WrapAlignment
                                              .center,
                                          children: [
                                            Text(
                                              value,
                                              style: TextStyle(
                                                  fontSize:
                                                  12,
                                                  color:
                                                  Colors.red,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ]));
                                }).toList(),
                              ))),
                      SizedBox(
                        height: height / 50,
                      ),
                    ])),
            SizedBox(
              height: height / 50,
            ),
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: new Text(
                        "Follow Up History",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                            fontSize: 15),
                      ),
                    ),
                  ),
                  li5.items.leadFollowupStatus.toString() == "FOLLOWUP"
                      ? Container(
                    margin: const EdgeInsets.only(
                        top: 10, bottom: 10, right: 10),
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius:
                        BorderRadius.all(Radius.circular(20))),
                    child: FlatButton(
                      onPressed: () {
                        showDialog<void>(
                            context: context,
                            barrierDismissible:
                            false, // user must tap button!
                            builder: (context) {
                              return StatefulBuilder(builder:
                                  (context, StateSetter setState) {
                                return AlertDialog(
                                  title: Text(
                                    "Lead Follow Up",
                                    style: TextStyle(
                                        color: Colors.red),
                                  ),
                                  content: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: height / 50,
                                        ),
                                        Container(
                                          margin:
                                          const EdgeInsets.only(
                                              left: 10,
                                              right: 10),
                                          child: TextField(
                                            onTap: () async {
                                              DateTime date =
                                              DateTime(1900);
                                              FocusScope.of(context)
                                                  .requestFocus(
                                                  new FocusNode());

                                              date = await showDatePicker(
                                                  context: context,
                                                  initialDate:
                                                  DateTime
                                                      .now(),
                                                  firstDate: DateTime
                                                      .now()
                                                      .subtract(
                                                      new Duration(
                                                          days:
                                                          23725)),
                                                  lastDate: DateTime
                                                      .now()
                                                      .add(new Duration(
                                                      days:
                                                      365)));
                                              /*    var time =await showTimePicker(
                              initialTime: TimeOfDay.now(),
                              context: context,
                            );*/
                                              sql_dob_from =
                                                  dateFormatter
                                                      .format(date);
                                              print("date" +
                                                  sql_dob_from);
                                              datefromcontroller
                                                  .text = date.day
                                                  .toString() +
                                                  '/' +
                                                  date.month
                                                      .toString() +
                                                  '/' +
                                                  date.year
                                                      .toString();
                                            },
                                            enabled: true,
                                            controller:
                                            datefromcontroller,
                                            decoration:
                                            InputDecoration(
                                              prefixIcon: Icon(Icons
                                                  .calendar_today_outlined),
                                              labelText:
                                              'Select Date',
                                              hintStyle: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 16.0,
                                              ),
                                              border:
                                              OutlineInputBorder(
                                                borderRadius:
                                                BorderRadius
                                                    .circular(
                                                    25.0),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: height / 50,
                                        ),
                                        Container(
                                            margin:
                                            const EdgeInsets.only(
                                                left: 10.0,
                                                right: 10.0),
                                            padding:
                                            const EdgeInsets.only(
                                                left: 20.0,
                                                right: 10.0),
                                            decoration: new BoxDecoration(
                                                borderRadius:
                                                BorderRadius.all(
                                                    Radius.circular(
                                                        2.0)),
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
                                                  value: dropdownValue,
                                                  onChanged: (String
                                                  newValue) {
                                                    setState(() {
                                                      dropdownValue =
                                                          newValue;
                                                    });
                                                  },
                                                  items: <String>[
                                                    "Followup",
                                                    "Done",
                                                    "Close"
                                                  ].map<
                                                      DropdownMenuItem<
                                                          String>>((String
                                                  value) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                        value: value,
                                                        child: Wrap(
                                                            direction: Axis
                                                                .vertical,
                                                            //default
                                                            alignment:
                                                            WrapAlignment
                                                                .center,
                                                            children: [
                                                              Text(
                                                                value,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                    12,
                                                                    color:
                                                                    Colors.red,
                                                                    fontWeight: FontWeight.w500),
                                                              ),
                                                            ]));
                                                  }).toList(),
                                                ))),
                                        SizedBox(
                                          height: height / 50,
                                        ),
                                        Padding(
                                          padding:
                                          const EdgeInsets.only(
                                              left: 10.0,
                                              right: 10.0),
                                          child: Container(
                                            child: new TextField(
                                              enabled: true,
                                              maxLines: 25,
                                              minLines: 3,
                                              controller:
                                              FollowupNotesController,
                                              decoration:
                                              InputDecoration(
                                                labelText: 'Notes',
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
                                                      5.0),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      child: Text('OK'),
                                      onPressed: () {
                                        check().then((value) {
                                          if (value) {
                                            uploadImage1().then(
                                                    (value) =>
                                                    Navigator.of(
                                                        context)
                                                        .pop());
                                          }
                                        });
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
                              });
                            });
                      },
                      child: Text(
                        "Follow Up",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                      : Container()
                ],
              ),
            ),
            SizedBox(
              height: height / 40,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                sortColumnIndex: 0,
                columnSpacing: width / 20,
                columns: [
                  DataColumn(
                    label: Center(
                        child: Wrap(
                          direction: Axis.vertical, //default
                          alignment: WrapAlignment.center,
                          children: [
                            Text(
                              "Follow up Date",
                              softWrap: true,
                              style: TextStyle(fontSize: 12),
                              textAlign: TextAlign.center,
                            ),
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
                            Text("Follow Up Note",
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
                            Text("Follow Up Status",
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
                            Text("Action",
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
                rows: li5.items.followupDetails
                    .map(
                      (list) => DataRow(cells: [
                    DataCell(Center(
                        child: Center(
                          child: Wrap(
                              direction: Axis.vertical, //default
                              alignment: WrapAlignment.center,
                              children: [
                                Text(
                              DateFormat('dd/MM/yyyy').format(
                              DateTime.parse( list.followupDate.toString())),
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
                                Text(list.followupNotes.toString(),
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
                                    Text(list.followupStatus.toString(),
                                        textAlign: TextAlign.center)
                                  ]))),
                    ),
                    DataCell(
                      DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: dropdownValue3,
                          onChanged: (String newValue) {
                            setState(() {
                              if (newValue == "View") {
                                datefromcontroller.text =
                                    dateFormatter.format(
                                        DateTime.parse(list
                                            .followupDate
                                            .toString()));
                                FollowupStatController.text =
                                    list.followupStatus.toString();
                                FollowupNotesController.text =
                                    list.followupNotes.toString();
                                showDialog<void>(
                                    context: context,
                                    barrierDismissible:
                                    false, // user must tap button!
                                    builder: (context) {
                                      return StatefulBuilder(builder:
                                          (context,
                                          StateSetter setState) {
                                        return AlertDialog(
                                          title: Text(
                                            "Lead Follow Up",
                                            style: TextStyle(
                                                color: Colors.red),
                                          ),
                                          content:
                                          SingleChildScrollView(
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                  const EdgeInsets
                                                      .only(
                                                      left: 10.0,
                                                      right: 10),
                                                  child: TextField(
                                                    onTap: () async {
                                                      DateTime date =
                                                      DateTime(
                                                          1900);
                                                      FocusScope.of(
                                                          context)
                                                          .requestFocus(
                                                          new FocusNode());

                                                      date = await showDatePicker(
                                                          context:
                                                          context,
                                                          initialDate:
                                                          DateTime
                                                              .now(),
                                                          firstDate: DateTime
                                                              .now()
                                                              .subtract(new Duration(
                                                              days:
                                                              23725)),
                                                          lastDate: DateTime
                                                              .now()
                                                              .add(new Duration(
                                                              days:
                                                              365)));
                                                      /*    var time =await showTimePicker(
                              initialTime: TimeOfDay.now(),
                              context: context,
                            );*/
                                                      sql_dob_from =
                                                          dateFormatter
                                                              .format(
                                                              date);
                                                      print("date" +
                                                          sql_dob_from);
                                                      datefromcontroller
                                                          .text = date
                                                          .day
                                                          .toString() +
                                                          '/' +
                                                          date.month
                                                              .toString() +
                                                          '/' +
                                                          date.year
                                                              .toString();
                                                    },
                                                    enabled: false,
                                                    controller:
                                                    datefromcontroller,
                                                    decoration:
                                                    InputDecoration(
                                                      prefixIcon:
                                                      Icon(Icons
                                                          .calendar_today_outlined),
                                                      labelText:
                                                      'Select Date',
                                                      hintStyle:
                                                      TextStyle(
                                                        color: Colors
                                                            .grey,
                                                        fontSize:
                                                        16.0,
                                                      ),
                                                      border:
                                                      OutlineInputBorder(
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(
                                                            25.0),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: height / 50,
                                                ),
                                                Padding(
                                                  padding:
                                                  const EdgeInsets
                                                      .only(
                                                      left: 10.0,
                                                      right:
                                                      10.0),
                                                  child: Container(
                                                    child:
                                                    new TextField(
                                                      enabled: false,
                                                      controller:
                                                      FollowupStatController,
                                                      decoration:
                                                      InputDecoration(
                                                        labelText:
                                                        'Follow Up Status',
                                                        hintStyle:
                                                        TextStyle(
                                                          color: Colors
                                                              .grey,
                                                          fontSize:
                                                          16.0,
                                                        ),
                                                        border:
                                                        OutlineInputBorder(
                                                          borderRadius:
                                                          BorderRadius.circular(
                                                              5.0),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: height / 50,
                                                ),
                                                Padding(
                                                  padding:
                                                  const EdgeInsets
                                                      .only(
                                                      left: 10.0,
                                                      right:
                                                      10.0),
                                                  child: Container(
                                                    child:
                                                    new TextField(
                                                      enabled: false,
                                                      maxLines: 25,
                                                      minLines: 3,
                                                      controller:
                                                      FollowupNotesController,
                                                      decoration:
                                                      InputDecoration(
                                                        labelText:
                                                        'Notes',
                                                        hintStyle:
                                                        TextStyle(
                                                          color: Colors
                                                              .grey,
                                                          fontSize:
                                                          16.0,
                                                        ),
                                                        border:
                                                        OutlineInputBorder(
                                                          borderRadius:
                                                          BorderRadius.circular(
                                                              5.0),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              child: Text('OK'),
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop();
                                              },
                                            ),
                                            TextButton(
                                              child: Text('Cancel'),
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop();
                                              },
                                            ),
                                          ],
                                        );
                                      });
                                    });
                              }

                              // else if (newValue == "Edit")
                              //   Navigator.pushReplacement(
                              //       context,
                              //       MaterialPageRoute(
                              //           builder: (context) =>
                              //               EmployeeCustomerEdit(id: list.cusId)));
                              else if (newValue == "Delete") {
                                delete(list.followupId);
                                // li.values.remove(list);
                              }
                            });

                            //   Navigator.pushReplacement(
                            //       context,
                            //       MaterialPageRoute(
                            //           builder: (context) =>
                            //               MachineDetail(machineid: list.machineId)));
                            // else if (newValue == "Delete") {
                            //   delete(list.machineId);
                            //   li.values.remove(list);
                            //   }
                            // else if (newValue == "Edit")
                            //   Navigator.push(
                            //       context,
                            //       MaterialPageRoute(
                            //           builder: (context) =>
                            //               PlanEdit(planid: list.pplanId)));
//                                    else if (newValue == "Edit")
//                                      Navigator.push(
//                                          context,
//                                          MaterialPageRoute(
//                                              builder: (context) =>
//                                                  PropertyEdit(
//                                                      propertyid:
//                                                          list.propertyId)));
//                                    else if (newValue == "Delete") {
//                                      delete(list.id);
//                                      li.items.remove(list);
//                                    }
                          },
                          items: stringlist
                              .map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                    value: value,
                                    child: Wrap(
                                        direction:
                                        Axis.vertical, //default
                                        alignment: WrapAlignment.center,
                                        children: [
                                          Text(
                                            value,
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.red,
                                                fontWeight:
                                                FontWeight.w500),
                                          ),
                                        ]));
                              }).toList(),
                        ),
                      ),
                    )
                  ]),
                )
                    .toList(),
              ),
            ),

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
                        if (_typeAheadController.text.length == 10 &&NotesController.text.length!=0&&
                            dropdownValue5 != '-- Follower Type --' )
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
                          if (_typeAheadController.text.length != 10)
                            showDialog<void>(
                              context: context,
                              barrierDismissible: false,
                              // user must tap button!
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title:
                                  Text("Mobile Number should be 10 digits"),
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
                          if (NotesController.text.length == 0)
                            showDialog<void>(
                              context: context,
                              barrierDismissible: false,
                              // user must tap button!
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title:
                                  Text("Please Add Notes"),
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

                          else if (dropdownValue5 == '-- Follower Type --')
                            showDialog<void>(
                              context: context,
                              barrierDismissible: false,
                              // user must tap button!
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Please Choose Follower Type"),
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
class BackendService {
  static CustomerSelectPhoneModel li1;

  static Future<List> getSuggestions(String query) async {
    if (query.length == 10) {
      var url = //'http://35.184.156.126.xip.io/cyberhome/home.php?username=kavin&query=table';
      String_values.base_url +
          'find-lead-cus?search=${query}';

      var response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer ${RegisterPagesState.token}'
        },
      );
      if (response.statusCode == 200) {
        print(response.body);
        li1 = CustomerSelectPhoneModel.fromJson(json.decode(response.body));
        EmployeeLeadEditState.EmailController.text = li1.data.cusEmail.toString();
        EmployeeLeadEditState.CusCodeController.text = li1.data.cusCode.toString();
        ;
        EmployeeLeadEditState.addressController.text = li1.data.cusAddress.toString();
        ;
        EmployeeLeadEditState.NameController.text = li1.data.cusName.toString();
        ;
        EmployeeLeadEditState.StateController.text = li1.data.stateName.toString();
        ;
        EmployeeLeadEditState.DistrictController.text = li1.data.districtName.toString();
        ;

        EmployeeLeadEditState.PincodeController.text = li1.data.cusPincode.toString();


        // List<String> s = new List();
        // if (li1.data. == 0) {
        //   // return ["No details"];
        // } else {
        //   for (int i = 0; i < li1.items.length; i++)
        //     s.add(li1.items[i].groupName.toString());
        //   print(s);
        //   return s;
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
