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
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:tankcare/Customer/register.dart';
import 'package:tankcare/CustomerModels/districtlist.dart';
import 'package:tankcare/Employee/Dashboard.dart';
import 'package:tankcare/Vendor/Machines/Repair%20Request/RepairList.dart';
import 'package:tankcare/VendorModels/MachineDetail.dart';
import 'package:tankcare/VendorModels/MachineHistory.dart';
import 'package:tankcare/VendorModels/State.dart';

import '../../../string_values.dart';

class RepairRequest extends StatefulWidget {
  RepairRequest({Key key, this.machineid});

  String machineid;

  @override
  RepairRequestState createState() => RepairRequestState();
}

class RepairRequestState extends State<RepairRequest> {
  bool loading = false;
  MachineView li;
  MachineHistory li2;
  String dropdownValue3 = '-Action-';

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
  String dropdownValue2 = '-- Select District --';
  States li1;

  DistrictListings li3;

  int statetype;

  int districttype;

  Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
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
        'POST', Uri.parse(String_values.base_url + 'machine-repair-request'));
    //property_id plan_id pplan_name pplan_year pplan_service pplan_price pplan_tot_price pplan_start_date
    request.headers.addAll(headers);
    request.fields['machine_id'] = widget.machineid;
    request.fields['machine_uid'] = li.values.machineAssignUid;
    request.fields['machine_utype'] = li.values.machineAssignUtype;
    request.fields['repair_note'] = DescriptionController.text;
    request.fields['district_id'] = districttype.toString();
    request.fields['state_id'] = statetype.toString();
    var response = await request.send();
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
      setState(() {
        loading = false;
      });
      Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => RepairList(),
                ));
      return response.statusCode;

    });
  }

  Future<http.Response> details(planid) async {
    setState(() {
      loading = true;
    });
    var url = String_values.base_url + 'machine-editid/' + planid;
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
      li = MachineView.fromJson(json.decode(response.body));
      setState(() {
        MachineCodeController.text = li.values.machineCode.toString();
        MachineNameController.text = li.values.machineName.toString();
        ManufacturerNameController.text = li.values.manufactureName.toString();
        ManufacturerNumberController.text = li.values.manufactureNumber.toString();
        PurchaseDateController.text =  DateFormat('dd/MM/yyyy').format(
            DateTime.parse( li.values.purchaseDate.toString()));
        MachineTypeController.text = li.values.machineType.toString();
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
      li1 = States.fromJson(json.decode(response.body));

      stringlist.clear();
      stringlist.add('-- Select State --');
      for (int i = 0; i < li1.items.length; i++)
        stringlist.add(li1.items[i].stateName);
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
        li3 = DistrictListings.fromJson(json.decode(response.body));
        stringlist1.clear();

        stringlist1.add('-- Select District --');
        for (int i = 0; i < li3.items.length; i++)
          stringlist1.add(li3.items[i].districtName);
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

  List<String> items = List<String>.generate(7, (index) {
    return "Item - $index";
  });
  Set<Circle> _circles = HashSet<Circle>();
  double radius;
  TextEditingController StatusController = new TextEditingController();
  TextEditingController ServiceStatusController = new TextEditingController();
  TextEditingController ServiceStartDateController =
      new TextEditingController();
  TextEditingController ServiceByController = new TextEditingController();
  TextEditingController DescriptionController = new TextEditingController();
  TextEditingController MachineTypeController = new TextEditingController();
  TextEditingController PlanPaidStatusController = new TextEditingController();
  TextEditingController PlanCurrentStatusController =
      new TextEditingController();
  TextEditingController MachineCodeController = new TextEditingController();
  TextEditingController MachineNameController = new TextEditingController();
  TextEditingController ManufacturerNumberController =
      new TextEditingController();
  TextEditingController valuecontroller = new TextEditingController();
  TextEditingController PlanController = new TextEditingController();
  TextEditingController PlanServiceController = new TextEditingController();

  TextEditingController priceController = new TextEditingController();
  TextEditingController PurchaseDateController = new TextEditingController();
  Completer<GoogleMapController> _controller = Completer();
  TextEditingController GroupContactMobileController =
      new TextEditingController();
  TextEditingController datecontroller = new TextEditingController();
  TextEditingController TotalServicesController = new TextEditingController();
  TextEditingController GroupCodeController = new TextEditingController();
  TextEditingController servicetypeController = new TextEditingController();
  TextEditingController ManufacturerNameController =
      new TextEditingController();
  TextEditingController addressController = new TextEditingController();
  TextEditingController statusController = new TextEditingController();
  TextEditingController PlanYearController = new TextEditingController();

//  TextEditingController SizeRangeControllermax = new TextEditingController();

  bool sort;

  String dropdownValue = '-- Service Type --';

  static List<String> friendsList = [null];

  void initState() {
    details(widget.machineid).then((value) => stateRequest());
    sort = false;

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
              child: new Column(children: <Widget>[
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
                      "Repair Request",
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
              Container(
                  margin: const EdgeInsets.only(top: 10),
                  color: Colors.red.shade50,
                  child: ExpansionTile(
                      backgroundColor: Colors.white,
                      initiallyExpanded: true,
                      title: Text(
                        "Machine Details",
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
                            controller: MachineNameController,
                            decoration: InputDecoration(
                              labelText: 'Machine Name',
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
                            controller: MachineCodeController,
                            decoration: InputDecoration(
                              labelText: 'Machine Code',
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
                            controller: ManufacturerNameController,
                            decoration: InputDecoration(
                              labelText: 'Manufacturer Name',
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
                            controller: ManufacturerNumberController,
                            decoration: InputDecoration(
                              labelText: 'Manufacturer Number',
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
                            controller: PurchaseDateController,
                            decoration: InputDecoration(
                              labelText: 'Purchase Date',
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
                            controller: MachineTypeController,
                            decoration: InputDecoration(
                              labelText: 'Machine Type',
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
                height: height / 80,
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                color: Colors.red.shade50,
                child: ExpansionTile(
                  backgroundColor: Colors.white,
                  initiallyExpanded: true,
                  title: Text(
                    "Repair Details",
                    style: TextStyle(
                        fontWeight: FontWeight.w600, color: Colors.red),
                  ),
                  children: [
                    SizedBox(
                      height: height / 50,
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
                              for (int i = 0; i < li1.items.length; i++)
                                if (li1.items[i].stateName == newValue) {
                                  statetype = int.parse(li1.items[i].stateId);
                                  districtRequest(li1.items[i].stateId);
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
                              for (int i = 0; i < li3.items.length; i++)
                                if (li3.items[i].districtName == newValue) {
                                  districttype =
                                      int.parse(li3.items[i].districtId);
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
                      height: height / 50,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                      child: new TextFormField(
                        enabled: true,
                        maxLines: 25,
                        minLines: 4,
                        controller: DescriptionController,
                        decoration: InputDecoration(
                          labelText: 'Description',
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
                                if (DescriptionController.text.length != 0 &&
                                    dropdownValue1 != '-- Select State --' &&
                                    dropdownValue2 != '-- Select District --')
                                  uploadImage();
                                else {
                                  if (DescriptionController.text.length == 0)
                                    showDialog<void>(
                                      context: context,
                                      barrierDismissible: false,
                                      // user must tap button!
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text(
                                              "Description cannot be empty"),
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
                                  else if (dropdownValue1 ==
                                      '-- Select State --')
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
                  ],
                ),
              ),
            ])),

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
}
