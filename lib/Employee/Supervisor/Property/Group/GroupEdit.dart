import 'dart:io';
import 'package:tankcare/Employee/Dashboard.dart';
import 'dart:io';
import 'dart:ui';
import 'dart:io';
import 'package:tankcare/Employee/Dashboard.dart';
import 'dart:io';
import 'dart:ui';
import 'dart:async';
import 'dart:convert';
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
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:tankcare/Customer/register.dart';
import 'package:tankcare/CustomerModels/districtlist.dart';
import 'package:tankcare/CustomerModels/groupview.dart';
import 'package:tankcare/CustomerModels/statelist.dart';
import 'package:tankcare/Employee/EmployeeModels/ErrorResponse.dart';
import 'package:tankcare/Employee/EmployeeModels/Property/Group/GroupAddSelCus.dart';
import 'package:tankcare/Employee/Supervisor/Property/Group/GroupList.dart';
import 'package:tankcare/Master/PlanList.dart';
import 'package:tankcare/MasterModels/plandetails.dart';
import 'package:tankcare/VendorModels/State.dart';
import 'package:tankcare/string_values.dart';

class GroupEdit extends StatefulWidget {
  GroupEdit({Key key, this.groupid});

  String groupid;

  @override
  GroupEditState createState() => GroupEditState();
}

class GroupEditState extends State<GroupEdit> {
  bool loading = false;
  final TextEditingController _typeAheadController = TextEditingController();
  TextEditingController serviceyearcontroller = new TextEditingController();
  TextEditingController PincodeController = new TextEditingController();
  TextEditingController totalservicecontroller = new TextEditingController();
  TextEditingController literpricecontroller = new TextEditingController();
  TextEditingController fixedpricecontroller = new TextEditingController();
  TextEditingController NameController = new TextEditingController();
  TextEditingController GroupContactNameController =
      new TextEditingController();
  Completer<GoogleMapController> _controller = Completer();
  TextEditingController GroupNumberController = new TextEditingController();
  int statetype = 1;
  int districttype = 1;
  TextEditingController GroupCodeController = new TextEditingController();
  TextEditingController servicetypeController = new TextEditingController();
  TextEditingController PropertyTypeController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();
  bool isenable = true;
  bool cameramove = false;
  double latitudecamera, longitudecamera;
  var addressText;
  var first;
  int proprtytype;
  List<String> stringlist1 = [
    '-- Select District --',
    "Tank",
    "Sump",
    "Sump-Tile",
    "Car",
    "Bike",
    "Floor"
  ];
  GroupView li;
  String dropdownValue1 = '-- Select State --';

  String dropdownValue2 = '-- Select District --';
  var _kGooglePlex;

  StateListings li2;
  DistrictListings li1;

  States li5;

  DistrictListings li6;

  var cusid;

  ErrorResponse ei;

  Future<http.Response> details(planid) async {
    setState(() {
      loading = true;
    });
    var url = String_values.base_url + 'group-view/' + planid;
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
      li = GroupView.fromJson(json.decode(response.body));
      setState(() {
        NameController.text = li.groupName.toString();
        cusid = li.cusId.toString();
        GroupCodeController.text = li.groupCode.toString();
        _typeAheadController.text = li.cusName.toString();
        GroupContactNameController.text = li.groupContactName.toString();
        GroupNumberController.text = li.groupContactPhone.toString();
        PincodeController.text = li.groupPincode.toString();
        addressController.text = li.groupAddress.toString();
        if (li.serviceType.toString() == "COM")
          servicetypeController.text = "Commercial";
        else
          servicetypeController.text = "Residential";
        if (li.serviceType.toString() == "RES")
          dropdownValue = 'Residential';
        else
          dropdownValue = 'Commercial';
        stateRequest().then((value) => districtRequest(li.stateId));
        li.latitude.toString() != null
            ? _kGooglePlex = CameraPosition(
                // bearing: 192.8334901395799,
                target: LatLng(
                    double.parse(li.latitude), double.parse(li.longitude)),
                zoom: 14)
            : _kGooglePlex = CameraPosition(
                // bearing: 192.8334901395799,
                target: LatLng(0, 0),
                zoom: 14);
        latitudecamera = double.parse(li.latitude.toString());
        longitudecamera = double.parse(li.longitude.toString());
      });

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

  List<String> items = List<String>.generate(7, (index) {
    return "Item - $index";
  });

  List<String> stringlist = [
    '-- Select State --',
    "Tank",
    "Sump",
    "Sump-Tile",
    "Car",
    "Bike",
    "Floor"
  ];
  bool sort;
  TextEditingController PlanNameController = new TextEditingController();
  TextEditingController ServiceTypeController = new TextEditingController();
  TextEditingController SizeRangeControllermin = new TextEditingController();
  TextEditingController SizeRangeControllermax = new TextEditingController();
  TextEditingController stateController = new TextEditingController();
  TextEditingController districtController = new TextEditingController();

  String dropdownValue = 'Commercial';

  static List<String> friendsList = [null];

  void initState() {
    _kGooglePlex = CameraPosition(
        // bearing: 192.8334901395799,
        target: LatLng(0, 0),
        zoom: 17);
    sort = false;
    details(widget.groupid);
    super.initState();
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
      li5 = States.fromJson(json.decode(response.body));

      setState(() {
        stringlist.clear();
        stringlist.add('-- Select State --');
        for (int i = 0; i < li5.items.length; i++)
          stringlist.add(li5.items[i].stateName);
        dropdownValue1 = stringlist[int.parse(li.stateId)];
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
        li6 = DistrictListings.fromJson(json.decode(response.body));

        stringlist1.clear();
        stringlist1.add('-- Select District --');
        for (int i = 0; i < li6.items.length; i++) {
          stringlist1.add(li6.items[i].districtName);
          if (li.districtId == li6.items[i].districtId)
            dropdownValue2 = li6.items[i].districtName;
        }
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

  String searchAddr;

  DateTime _dateTime;

  @override
  Widget build(BuildContext context) {
    Future<bool> check() async {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile) {
        return true;
      } else if (connectivityResult == ConnectivityResult.wifi) {
        return true;
      }
      return false;
    }

    Future<http.Response> postRequest() async {
      setState(() {
        loading = true;
      });
      String servicetype;
      if (dropdownValue == "Residential")
        servicetype = "RES";
      else
        servicetype = "COM";
      var url = String_values.base_url + 'group-add';
      Map data = {
        "cus_id": cusid,
        "group_id": widget.groupid,
        "group_name": GroupContactNameController.text,
        "group_address": addressController.text,
        "service_type": servicetype,
        "group_contact_name": GroupContactNameController.text,
        "group_contact_phone": GroupNumberController.text,
        "map_location": addressController.text,
        "district_id": districttype,
        "state_id": statetype,
        "latitude": latitudecamera.toString(),
        "longitude": longitudecamera.toString(),
      };
      print("data: ${data}");
      print(String_values.base_url);
      //encode Map to JSON
      var body = json.encode(data);
      print("response: ${body}");
      var response = await http.post(url,
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer ${RegisterPagesState.token}'
          },
          body: body);
      if (response.statusCode == 200) {
        setState(() {
          loading = false;
        });
        if (response.body.toString().contains("true")) {
          Fluttertoast.showToast(
              msg: "Group Edited Successfully",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.SNACKBAR,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => EmployeeGroupList()),
          );
        } else {
          ei = ErrorResponse.fromJson(jsonDecode(response.body));
          Fluttertoast.showToast(
              msg: ei.messages,
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.SNACKBAR,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
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
                          "Group Edit",
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
                    height: height / 50,
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
                  //     TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                  //   ),
                  // ),
                  SizedBox(
                    height: height / 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Container(
                      child: new TextFormField(
                        controller: NameController,
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
                  ),
                  SizedBox(
                    height: height / 80,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Container(
                      child: new TextFormField(
                        enabled: false,
                        controller: GroupCodeController,
                        decoration: InputDecoration(
                          labelText: 'Group Code',
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
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Container(
                      child: new TextFormField(
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
                  ),
                  SizedBox(
                    height: height / 80,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Container(
                      child: new TextFormField(
                        controller: GroupNumberController,
                        decoration: InputDecoration(
                          labelText: 'Group Contact Mobile',
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
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
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
                          labelText: 'Select Customer Name',
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
                        for (int i = 0;
                            i < BackendService.li1.data.length;
                            i++) {
                          print(BackendService.li1.data[i].cusName);
                          if (BackendService.li1.data[i].cusName ==
                              suggestion) {
                            cusid = BackendService.li1.data[i].cusId;
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
                    height: height / 80,
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
                        value: dropdownValue,
                        onChanged: (String newValue) {
                          setState(() {
                            dropdownValue = newValue;
                          });
                        },
                        items: <String>[
                          '-- Service Type --',
                          "Residential",
                          "Commercial"
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
                    height: height / 80,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Container(
                      child: new TextFormField(
                        minLines: 3,
                        maxLines: 10,
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
                  Container(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      height: height / 2,
                      child: Stack(children: <Widget>[
                        GoogleMap(
                          gestureRecognizers: {
                            Factory<OneSequenceGestureRecognizer>(
                              () => EagerGestureRecognizer(),
                            ),
                          },
                          zoomControlsEnabled: true,
                          mapType: MapType.normal,
                          initialCameraPosition: _kGooglePlex,
                          onMapCreated: (GoogleMapController controller) {
                            _controller.complete(controller);
                          },

                          onCameraIdle: () async {
                            if (cameramove == true) {
                              // placemark = await Geolocator()
                              //     .placemarkFromCoordinates(
                              //         latitudecamera, longitudecamera);
                              final coordinates = new Coordinates(
                                  latitudecamera, longitudecamera);
                              addressText = await Geocoder.local
                                  .findAddressesFromCoordinates(coordinates);
                              this.first = addressText.first;
                              //  print("moved" + value.target.latitude.toString());
                              setState(() {
                                cameramove = true;
                                addressController.text = "";
                                if (this.first != "")
                                  addressController.text =
                                      '${this.first.addressLine}';

                                cameramove = false;
                              });

                              // print(value.longitude);
                            }
                          },
                          onCameraMove: ((value) async {
                            latitudecamera = value.target.latitude;
                            longitudecamera = value.target.longitude;
                            //  print("moved" + value.target.latitude.toString());
                            setState(() {
                              cameramove = true;
                            });
                            // print(value.longitude);
                          }),
                          // markers: markers,
                        ),
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
                  SizedBox(
                    height: height / 80,
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
                        value: dropdownValue1,
                        onChanged: (String newValue) {
                          setState(() {
                            dropdownValue1 = newValue;
                            dropdownValue2 = '-- Select District --';
                            statetype = stringlist.indexOf(newValue);
                            for (int i = 0; i < li5.items.length; i++)
                              if (li5.items[i].stateName == newValue) {
                                statetype = int.parse(li5.items[i].stateId);

                                districtRequest(li5.items[i].stateId);
                              }
                          });
                        },
                        items: stringlist
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height / 80,
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
                        value: dropdownValue2,
                        onChanged: (String newValue) {
                          setState(() {
                            dropdownValue2 = newValue;
                            for (int i = 0; i < li6.items.length; i++)
                              if (li6.items[i].districtName == newValue) {
                                districttype =
                                    int.parse(li6.items[i].districtId);
                              }
                          });
                        },
                        items: stringlist1
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height / 80,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Container(
                      child: new TextField(
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
                              check().then((value) {
                                if (value) {
                                  if (NameController.text.length != 0 &&
                                      GroupNumberController.text.length != 0 &&
                                      NameController.text.length != 0 &&
                                      addressController.text.length != 0 &&
                                      _typeAheadController.text.length != 0)
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
                                                      postRequest();
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
                                    if (NameController.text.length == 0)
                                      showDialog<void>(
                                        context: context,
                                        barrierDismissible: false,
                                        // user must tap button!
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text(
                                                "Group name cannot be empty"),
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
                                    else if (GroupNumberController
                                            .text.length ==
                                        0)
                                      showDialog<void>(
                                        context: context,
                                        barrierDismissible: false,
                                        // user must tap button!
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text(
                                                "Group number cannot be empty"),
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
                                    else if (GroupNumberController
                                            .text.length ==
                                        0)
                                      showDialog<void>(
                                        context: context,
                                        barrierDismissible: false,
                                        // user must tap button!
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text(
                                                "Group Contact Name cannot be empty"),
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
                                    else if (_typeAheadController.text.length ==
                                        0)
                                      showDialog<void>(
                                        context: context,
                                        barrierDismissible: false,
                                        // user must tap button!
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text(
                                                "Customer name cannot be empty"),
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
                                } else
                                  showDialog<void>(
                                    context: context,
                                    barrierDismissible: false,
                                    // user must tap button!
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
                  // DataTable(
                  //   showBottomBorder: true,
                  //   showCheckboxColumn: true,
                  //   columns: [
                  //     DataColumn(label: Text("Name")),
                  //     DataColumn(label: Text("Year")),
                  //     DataColumn(label: Text("Plan")),
                  //     DataColumn(label: Text("Action")),
                  //   ],
                  //   rows: [
                  //     DataRow(cells: [
                  //       DataCell(Text("BalaKumar")),
                  //       DataCell(Text("2020")),
                  //       DataCell(Text("to get above 80k")),
                  //       DataCell(IconButton(
                  //         icon: Icon(Icons.add),
                  //         onPressed: () {},
                  //       ))
                  //     ]),
                  //     DataRow(cells: [
                  //       DataCell(Text("BalaKumar")),
                  //       DataCell(Text("2021")),
                  //       DataCell(Text("to get above 120k")),
                  //       DataCell(IconButton(
                  //         icon: Icon(Icons.add),
                  //         onPressed: () {},
                  //       ))
                  //     ]),
                  //   ],
                  // ),
                  // DataTable(
                  //   sortAscending: sort,
                  //   sortColumnIndex: 0,
                  //   columns: [
                  //     DataColumn(
                  //         label: Text("Plan Name", style: TextStyle(fontSize: 14)),
                  //         numeric: false,
                  //
                  //         // onSort: (columnIndex, ascending) {
                  //         //   onSortColum(columnIndex, ascending);
                  //         //   setState(() {
                  //         //     sort = !sort;
                  //         //   });
                  //         // }
                  //         ),
                  //     DataColumn(
                  //
                  //       label: Text("Total Services", style: TextStyle(fontSize: 14)),
                  //       numeric: false,
                  //     ),
                  //     DataColumn(
                  //
                  //       label: Text("Actions", style: TextStyle(fontSize: 14)),
                  //       numeric: false,
                  //     ),
                  //   ],
                  //   rows: listplan
                  //       .map(
                  //         (list) => DataRow(
                  //             selected: selectedAvengers.contains(list),
                  //             cells: [
                  //               DataCell(
                  //                 Text(list.name),
                  //                 onTap: () {
                  //                   print('Selected ${list.name}');
                  //                 },
                  //               ),
                  //               DataCell(
                  //                 Text(list.totalservices),
                  //               ),
                  //               DataCell(
                  //                 IconButton(icon:Icon(Icons.remove_circle_outline),onPressed: (){
                  //                   setState(() {
                  //                     listplan.remove(list);
                  //                   });
                  //                 }),
                  //               ),
                  //             ]),
                  //       )
                  //       .toList(),
                  // ),

                  // ...listdetails(),
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
}

class BackendService {
  static EmployeeGroupAddSelectCusModel li1;

  static Future<List> getSuggestions(String query) async {
    var url = //'http://35.184.156.126.xip.io/cyberhome/home.php?username=kavin&query=table';
        String_values.base_url + 'find-customer?search=${query}';

    var response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer ${RegisterPagesState.token}'
      },
    );
    if (response.statusCode == 200) {
      print(response.body);
      li1 = EmployeeGroupAddSelectCusModel.fromJson(json.decode(response.body));
      List<String> s = new List();
      if (li1.data.length == 0) {
        // return ["No details"];
      } else {
        for (int i = 0; i < li1.data.length; i++)
          s.add(li1.data[i].cusName.toString());
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
