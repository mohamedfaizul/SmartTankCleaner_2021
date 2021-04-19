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
import 'package:tankcare/Employee/Dashboard.dart';
import 'package:tankcare/VendorModels/MachineDetail.dart';
import 'package:tankcare/VendorModels/MachineHistory.dart';

import 'package:tankcare/Vendor/Machines/Repair%20Request/MachineRepairRequest.dart';

import '../../../string_values.dart';

class MachineDetail extends StatefulWidget {
  MachineDetail({Key key, this.machineid});

  String machineid;

  @override
  MachineDetailState createState() => MachineDetailState();
}

class MachineDetailState extends State<MachineDetail> {
  bool loading = false;
  MachineView li;
  MachineHistory li2;
  String dropdownValue3 = '-Action-';

  Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
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
        ;
        ManufacturerNameController.text = li.values.manufactureName.toString();
        ;
        ManufacturerNumberController.text =
            li.values.manufactureNumber.toString();
        ;
        PurchaseDateController.text =  DateFormat('dd/MM/yyyy').format(
            DateTime.parse( li.values.purchaseDate.toString()));
        ;
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

  Future<http.Response> historydetails(planid) async {
    setState(() {
      loading = true;
    });
    var url = String_values.base_url + 'machine-history/' + planid;
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
      li2 = MachineHistory.fromJson(json.decode(response.body));

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

  String dropdownValue1 = '-- Property Type --';

  String dropdownValue2 = '-- Select Plan --';

  static List<String> friendsList = [null];

  void initState() {
    details(widget.machineid).then((value) => historydetails(widget.machineid));
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: new Text(
                              "View Machine Detail",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                  fontSize: 17),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              top: 10, bottom: 10, right: 10),
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child: FlatButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RepairRequest(
                                            machineid: widget.machineid,
                                          )));
                            },
                            child: Text(
                              "Request For Repair",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        )
                      ],
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
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
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
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
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
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
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
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
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
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
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
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
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
                  Container(
                      margin: const EdgeInsets.only(top: 10),
                      color: Colors.red.shade50,
                      child: ExpansionTile(
                          backgroundColor: Colors.white,
                          initiallyExpanded: false,
                          title: Text(
                            "Repair Details",
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
                                        Text("Repair Code",
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
                                        Text("Repair Charge",
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
                                        Text("Repair Note",
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
                                        Text("Status",
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
                                rows: li.values.repairHistory
                                    .map(
                                      (list) => DataRow(cells: [
                                        DataCell(
                                          Center(
                                              child: Text(
                                            list.repairCode.toString(),
                                            textAlign: TextAlign.center,
                                          )),
                                        ),
                                        DataCell(
                                          Center(
                                              child: Text(
                                                  list.repairCharge.toString(),
                                                  textAlign: TextAlign.center)),
                                        ),
                                        DataCell(
                                          Center(
                                              child: Text(
                                                  list.repairNote.toString(),
                                                  textAlign: TextAlign.center)),
                                        ),
                                        DataCell(
                                          Center(
                                              child: Text(
                                                  list.repairStatus.toString(),
                                                  textAlign: TextAlign.center)),
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
                          initiallyExpanded: false,
                          title: Text(
                            "History",
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
                                        Text("Machine",
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
                                        Text("Date",
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
                                        Text("History Type",
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
                                        Text("From",
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
                                        Text("To",
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
                                rows: li2.values
                                    .map(
                                      (list) => DataRow(cells: [
                                        DataCell(
                                          Center(
                                              child: Text(
                                            list.machineName,
                                            textAlign: TextAlign.center,
                                          )),
                                        ),
                                        DataCell(
                                          Center(
                                              child: Text(list.historyDate,
                                                  textAlign: TextAlign.center)),
                                        ),
                                        DataCell(
                                          Center(
                                              child: Text(list.historyType,
                                                  textAlign: TextAlign.center)),
                                        ),
                                        DataCell(
                                          Center(
                                              child: Text(list.fromBy,
                                                  textAlign: TextAlign.center)),
                                        ),
                                        DataCell(
                                          Center(
                                              child: Text(list.toBy,
                                                  textAlign: TextAlign.center)),
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
}
