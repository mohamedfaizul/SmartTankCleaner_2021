import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;
import 'package:tankcare/Customer/register.dart';
import 'package:tankcare/Director/FinanceDamageView.dart';
import 'package:tankcare/FINANCE%20TEAM/View.dart';
import 'package:tankcare/FRANCHISE/Damageview.dart';
import 'package:tankcare/RM%20models/getuser.dart';
import 'package:tankcare/RM%20models/list.dart';
import 'package:tankcare/RM%20models/userDesignation.dart';

import '../string_values.dart';

class DirectorApprovalList extends StatefulWidget {
  @override
  DirectorApprovalListState createState() => DirectorApprovalListState();
}

class DirectorApprovalListState extends State<DirectorApprovalList> {
  bool loading = false;
  List<String> stringlist = ["-- Designation --"];
  final TextEditingController _typeAheadController = TextEditingController();
  RMApprovalListings li;

  var page = 1;

  String usertype;

  GetUserDesignation li3;

  static String roleid;

  String userid;

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
    var url;
    if (dropdownValue == '-- Approval Status --' &&
        dropdownValue2 == '-- Approval Type --')
      url = String_values.base_url + 'approval-functions-list';
    else if (dropdownValue == "Pending" &&
        dropdownValue2 == '-- Approval Type --')
      url = String_values.base_url +
          'approval-functions-list?ap_status=P&page=${page}&limit=10';
    else if (dropdownValue == "Approved" &&
        dropdownValue2 == '-- Approval Type --')
      url = String_values.base_url +
          'approval-functions-list?ap_status=A&page=${page}&limit=10';
    else if (dropdownValue == "Rejected" &&
        dropdownValue2 == '-- Approval Type --')
      url = String_values.base_url +
          'approval-functions-list?ap_status=R&page=${page}&limit=10';
    else if (dropdownValue == '-- Approval Status --' &&
        dropdownValue2 == 'Damage Claim')
      url = String_values.base_url +
          'approval-functions-list?page=${page}&limit=10&ap_type=damage_claim';
    else if (dropdownValue == '-- Approval Status --' &&
        dropdownValue2 == 'Plan')
      url = String_values.base_url +
          'approval-functions-list?page=${page}&limit=10&ap_type=plan';
    else if (dropdownValue == '-- Approval Status --' &&
        dropdownValue2 == 'Service')
      url = String_values.base_url +
          'approval-functions-list?page=${page}&limit=10&ap_type=service';
    else if (dropdownValue == 'Pending' && dropdownValue2 == 'Damage Claim')
      url = String_values.base_url +
          'approval-functions-list?page=${page}&limit=10&ap_type=damage_claim&ap_status=P';
    else if (dropdownValue == 'Pending' && dropdownValue2 == 'Plan')
      url = String_values.base_url +
          'approval-functions-list?page=${page}&limit=10&ap_type=plan&ap_status=P';
    else if (dropdownValue == 'Pending' && dropdownValue2 == 'Service')
      url = String_values.base_url +
          'approval-functions-list?page=${page}&limit=10&ap_type=service&ap_status=P';
    else if (dropdownValue == 'Approved' && dropdownValue2 == 'Damage Claim')
      url = String_values.base_url +
          'approval-functions-list?page=${page}&limit=10&ap_type=damage_claim&ap_status=A';
    else if (dropdownValue == 'Approved' && dropdownValue2 == 'Plan')
      url = String_values.base_url +
          'approval-functions-list?page=${page}&limit=10&ap_type=plan&ap_status=A';
    else if (dropdownValue == 'Approved' && dropdownValue2 == 'Service')
      url = String_values.base_url +
          'approval-functions-list?page=${page}&limit=10&ap_type=service&ap_status=A';
    else if (dropdownValue == 'Rejected' && dropdownValue2 == 'Damage Claim')
      url = String_values.base_url +
          'approval-functions-list?page=${page}&limit=10&ap_type=damage_claim&ap_status=R';
    else if (dropdownValue == 'Rejected' && dropdownValue2 == 'Plan')
      url = String_values.base_url +
          'approval-functions-list?page=${page}&limit=10&ap_type=plan&ap_status=R';
    else if (dropdownValue == 'Rejected' && dropdownValue2 == 'Service')
      url = String_values.base_url +
          'approval-functions-list?page=${page}&limit=10&ap_type=service&ap_status=R';

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
      li = RMApprovalListings.fromJson(json.decode(response.body));
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

  Future<int> uploadImage(apid, aputype, apuid) async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer ${RegisterPagesState.token}'
    };

    var request = http.MultipartRequest(
        'POST', Uri.parse(String_values.base_url + 'approval-functions-save'));

    request.headers.addAll(headers);
    request.fields['ap_id'] = apid;
    request.fields['ap_utype'] = aputype;
    request.fields['ap_uid'] = apuid;
    var response = await request.send();
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => DirectorApprovalList(),
          ));
      return response.statusCode;
    });
  }

  Future<http.Response> delete(planid) async {
    setState(() {
      loading = true;
    });

    var url = String_values.base_url + 'group-delete/' + planid;
    print(String_values.base_url);
    var response = await http.put(
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

  List<String> items = List<String>.generate(7, (index) {
    return "Item - $index";
  });
  TextEditingController serviceyearcontroller = new TextEditingController();
  TextEditingController totalservicecontroller = new TextEditingController();
  TextEditingController literpricecontroller = new TextEditingController();
  TextEditingController fixedpricecontroller = new TextEditingController();
  TextEditingController searchController = new TextEditingController();
  List<PlanListView> listplanyear;
  bool sort;

  String dropdownValue = '-- Approval Status --';

  String dropdownValueuser = "-- User Type --";
  String dropdownValuedes = "-- Designation --";
  String dropdownValue1 = '-- Property Type --';

  String dropdownValue2 = '-- Approval Type --';

  static String dropdownValue3 = '-Action-';

  static List<String> friendsList = [null];

  void initState() {
    sort = false;
    setState(() {
      loading = true;
    });
    check().then((value) {
      if (value)
        postRequest();
      else
        showDialog<void>(
          context: context,
          barrierDismissible: false,
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
    listplanyear = PlanListView.getdata();
    super.initState();
  }

  String searchAddr;

  DateTime _dateTime;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
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
                          offset: Offset(0.0, 1.0),
                          blurRadius: 6.0,
                        ),
                      ],
                    ),
                    margin: EdgeInsets.all(3.0),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: new Text(
                          "Approval List",
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
                        value: dropdownValue2,
                        onChanged: (String newValue) {
                          setState(() {
                            dropdownValue2 = newValue;
                          });
                        },
                        items: <String>[
                          '-- Approval Type --',
                          "Damage Claim",
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
                        value: dropdownValue,
                        onChanged: (String newValue) {
                          page = 1;
                          setState(() {
                            dropdownValue = newValue;
                          });
                        },
                        items: <String>[
                          '-- Approval Status --',
                          "Pending",
                          "Approved",
                          "Rejected",
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
                    height: height / 40,
                  ),
                  SizedBox(
                    height: height / 50,
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
                              postRequest();
                            },
                            child: Text(
                              "Filter",
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
                            onPressed: () {
                              setState(() {
                                dropdownValue = '-- Approval Status --';
                                dropdownValue2 = '-- Approval Type --';
                              });

                              check().then((value) {
                                if (value)
                                  postRequest();
                                else
                                  showDialog<void>(
                                    context: context,
                                    barrierDismissible: false,
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
                              "Clear",
                              style: TextStyle(color: Colors.white),
                            ),
                          )),
                    ],
                  ),
                  SizedBox(
                    height: height / 40,
                  ),
                  if (li.items != null)
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        sortAscending: sort,
                        sortColumnIndex: 0,
                        columnSpacing: width / 20,
                        columns: [
                          DataColumn(
                            label: Center(
                                child: Wrap(
                              direction: Axis.vertical,
                              alignment: WrapAlignment.center,
                              children: [
                                Text(
                                  "Name",
                                  softWrap: true,
                                  style: TextStyle(fontSize: 12),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            )),
                            numeric: false,
                          ),
                          DataColumn(
                            label: Center(
                                child: Wrap(
                              direction: Axis.vertical,
                              alignment: WrapAlignment.center,
                              children: [
                                Text("Order By",
                                    softWrap: true,
                                    style: TextStyle(fontSize: 12),
                                    textAlign: TextAlign.center),
                              ],
                            )),
                            numeric: false,
                          ),
                          DataColumn(
                            label: Center(
                                child: Wrap(
                              direction: Axis.vertical,
                              alignment: WrapAlignment.center,
                              children: [
                                Text("User Type",
                                    softWrap: true,
                                    style: TextStyle(fontSize: 12),
                                    textAlign: TextAlign.center),
                              ],
                            )),
                            numeric: false,
                          ),
                          DataColumn(
                            label: Center(
                                child: Wrap(
                              direction: Axis.vertical,
                              alignment: WrapAlignment.center,
                              children: [
                                Text("Assigned By",
                                    softWrap: true,
                                    style: TextStyle(fontSize: 12),
                                    textAlign: TextAlign.center),
                              ],
                            )),
                            numeric: false,
                          ),
                          DataColumn(
                            label: Center(
                                child: Wrap(
                              direction: Axis.vertical,
                              alignment: WrapAlignment.center,
                              children: [
                                Text("Status",
                                    softWrap: true,
                                    style: TextStyle(fontSize: 12),
                                    textAlign: TextAlign.center),
                              ],
                            )),
                            numeric: false,
                          ),
                          DataColumn(
                            label: Center(
                                child: Wrap(
                              direction: Axis.vertical,
                              alignment: WrapAlignment.center,
                              children: [
                                Text("Actions",
                                    softWrap: true,
                                    style: TextStyle(fontSize: 12),
                                    textAlign: TextAlign.center),
                              ],
                            )),
                            numeric: false,
                          ),
                        ],
                        rows: li.items
                            .map(
                              (list) => DataRow(cells: [
                                DataCell(Center(
                                    child: Center(
                                  child: Wrap(
                                      direction: Axis.vertical,
                                      alignment: WrapAlignment.center,
                                      children: [
                                        Text(
                                          list.apProcessName.toString(),
                                          textAlign: TextAlign.center,
                                        )
                                      ]),
                                ))),
                                DataCell(Center(
                                    child: Center(
                                  child: Wrap(
                                      direction: Axis.vertical,
                                      alignment: WrapAlignment.center,
                                      children: [
                                        Text(list.apDetailsOrderby.toString(),
                                            textAlign: TextAlign.center)
                                      ]),
                                ))),
                                DataCell(
                                  Center(
                                      child: Center(
                                          child: Wrap(
                                              direction: Axis.vertical,
                                              alignment: WrapAlignment.center,
                                              children: [
                                        Text(list.utype.toString(),
                                            textAlign: TextAlign.center)
                                      ]))),
                                ),
                                DataCell(
                                  Center(
                                      child: Center(
                                          child: Wrap(
                                              direction: Axis.vertical,
                                              alignment: WrapAlignment.center,
                                              children: [
                                        Text(list.assignby.toString(),
                                            textAlign: TextAlign.center)
                                      ]))),
                                ),
                                list.apStatus.toString() == "P"
                                    ? DataCell(
                                        Center(
                                            child: Center(
                                                child: Wrap(
                                                    direction: Axis.vertical,
                                                    alignment:
                                                        WrapAlignment.center,
                                                    children: [
                                              Text("Pending",
                                                  textAlign: TextAlign.center)
                                            ]))),
                                      )
                                    : DataCell(
                                        Center(
                                            child: Center(
                                                child: Wrap(
                                                    direction: Axis.vertical,
                                                    alignment:
                                                        WrapAlignment.center,
                                                    children: [
                                              Text("Completed",
                                                  textAlign: TextAlign.center)
                                            ]))),
                                      ),
                                list.apStatus.toString() == "P"
                                    ? DataCell(
                                        DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                            isExpanded: true,
                                            value: dropdownValue3,
                                            onChanged: (String newValue) {
                                              setState(() {
                                                if (newValue == "View")
                                                  check().then((value) {
                                                    if (value) {
                                                      if (list.apProcessName ==
                                                          "Damage Claim Verify")
                                                        Navigator.pushReplacement(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) => DirectorDamageView(
                                                                    propertyid: list
                                                                        .apTblId,
                                                                    apid: list
                                                                        .apId)));
                                                      else if (list
                                                              .apProcessName ==
                                                          "Bill Verify")
                                                        Navigator.pushReplacement(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) => FinanceBillView(
                                                                    propertyid: list
                                                                        .apTblId,
                                                                    apid: list
                                                                        .apId)));
                                                      else if (list
                                                              .apProcessName ==
                                                          "DamageVerify")
                                                        Navigator.pushReplacement(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) => FranchaiseDamageView(
                                                                    propertyid: list
                                                                        .apTblId,
                                                                    apid: list
                                                                        .apId)));
                                                    } else
                                                      showDialog<void>(
                                                        context: context,
                                                        barrierDismissible:
                                                            false,
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                            title: Text(
                                                                "No Internet Connection"),
                                                            actions: <Widget>[
                                                              TextButton(
                                                                child:
                                                                    Text('OK'),
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                  });
                                                else if (newValue == "Edit")
                                                  check().then((value) {
                                                    setState(() {
                                                      dropdownValueuser =
                                                          "-- User Type --";
                                                      dropdownValuedes =
                                                          "-- Designation --";
                                                      _typeAheadController
                                                          .text = "";
                                                    });

                                                    showDialog<void>(
                                                      context: context,
                                                      barrierDismissible: false,
                                                      builder: (context) {
                                                        return StatefulBuilder(
                                                            builder: (context,
                                                                StateSetter
                                                                    setState) {
                                                          return AlertDialog(
                                                              title: Text(
                                                                "Re-Assign Approval",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .red),
                                                              ),
                                                              content: loading
                                                                  ? Center(
                                                                      child:
                                                                          CircularProgressIndicator())
                                                                  : SingleChildScrollView(
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          Container(
                                                                            height:
                                                                                50,
                                                                            padding:
                                                                                const EdgeInsets.only(left: 20.0, right: 10.0),
                                                                            decoration:
                                                                                new BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(2.0)), border: new Border.all(color: Colors.black38)),
                                                                            child:
                                                                                DropdownButtonHideUnderline(
                                                                              child: DropdownButton<String>(
                                                                                isExpanded: true,
                                                                                value: dropdownValueuser,
                                                                                onChanged: (String newValue) {
                                                                                  if (newValue != "-- User Type --")
                                                                                    getdesignation(newValue).then((value) => setState(() {
                                                                                          dropdownValueuser = newValue;
                                                                                          dropdownValuedes = "-- Designation --";
                                                                                        }));
                                                                                },
                                                                                items: <String>[
                                                                                  "-- User Type --",
                                                                                  "Employee",
                                                                                  "Vendor",
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
                                                                            height:
                                                                                MediaQuery.of(context).size.height / 50,
                                                                          ),
                                                                          StatefulBuilder(builder:
                                                                              (context, setState) {
                                                                            return Container(
                                                                              height: 50,
                                                                              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                                                                              decoration: new BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(2.0)), border: new Border.all(color: Colors.black38)),
                                                                              child: DropdownButtonHideUnderline(
                                                                                child: DropdownButton<String>(
                                                                                  isExpanded: true,
                                                                                  value: dropdownValuedes,
                                                                                  onChanged: (String newValue) {
                                                                                    for (int i = 0; i < li3.values.length; i++)
                                                                                      if (li3.values[i].roleName == newValue) {
                                                                                        roleid = li3.values[i].roleId;
                                                                                        print("roleid: ${roleid}");
                                                                                      }

                                                                                    setState(() {
                                                                                      _typeAheadController.text = "";
                                                                                      dropdownValuedes = newValue;
                                                                                    });
                                                                                  },
                                                                                  items: stringlist.map<DropdownMenuItem<String>>((String value) {
                                                                                    return DropdownMenuItem<String>(
                                                                                      value: value,
                                                                                      child: Text(value),
                                                                                    );
                                                                                  }).toList(),
                                                                                ),
                                                                              ),
                                                                            );
                                                                          }),
                                                                          SizedBox(
                                                                              height: MediaQuery.of(context).size.height / 50),
                                                                          TypeAheadFormField(
                                                                            textFieldConfiguration:
                                                                                TextFieldConfiguration(
                                                                              enabled: true,
                                                                              controller: this._typeAheadController,
                                                                              keyboardType: TextInputType.text,
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
                                                                            suggestionsCallback:
                                                                                (pattern) {
                                                                              return BackendService.getSuggestions(pattern);
                                                                            },
                                                                            itemBuilder:
                                                                                (context, suggestion) {
                                                                              return ListTile(
                                                                                title: Text(suggestion),
                                                                              );
                                                                            },
                                                                            transitionBuilder: (context,
                                                                                suggestionsBox,
                                                                                controller) {
                                                                              return suggestionsBox;
                                                                            },
                                                                            onSuggestionSelected:
                                                                                (suggestion) {
                                                                              for (int i = 0; i < BackendService.li1.items.length; i++)
                                                                                if (BackendService.li1.items[i].uname == suggestion) userid = BackendService.li1.items[i].uid;
                                                                              print(userid);

                                                                              this._typeAheadController.text = suggestion;
                                                                            },
                                                                            validator:
                                                                                (value) {
                                                                              if (value.isEmpty) {
                                                                                return 'Please select a city';
                                                                              } else
                                                                                return 'nothing';
                                                                            },
                                                                          ),
                                                                          SizedBox(
                                                                              height: MediaQuery.of(context).size.height / 50),
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceEvenly,
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets.all(10.0),
                                                                                child: Container(
                                                                                    width: MediaQuery.of(context).size.width / 4,
                                                                                    alignment: Alignment.center,
                                                                                    decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.all(Radius.circular(10))),
                                                                                    child: FlatButton(
                                                                                      onPressed: () {
                                                                                        uploadImage(list.apId, usertype, userid).then((value) => Navigator.pop(context));
                                                                                      },
                                                                                      child: Text(
                                                                                        "Assign",
                                                                                        style: TextStyle(color: Colors.white),
                                                                                      ),
                                                                                    )),
                                                                              ),
                                                                              Padding(
                                                                                padding: const EdgeInsets.all(10.0),
                                                                                child: Container(
                                                                                    width: MediaQuery.of(context).size.width / 4,
                                                                                    alignment: Alignment.center,
                                                                                    decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.all(Radius.circular(10))),
                                                                                    child: FlatButton(
                                                                                      onPressed: () {
                                                                                        Navigator.pop(context);
                                                                                      },
                                                                                      child: Text(
                                                                                        "Cancel",
                                                                                        style: TextStyle(color: Colors.white),
                                                                                      ),
                                                                                    )),
                                                                              ),
                                                                            ],
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ));
                                                        });
                                                      },
                                                    );

                                                    if (value)
                                                      ;
                                                    else
                                                      showDialog<void>(
                                                        context: context,
                                                        barrierDismissible:
                                                            false,
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                            title: Text(
                                                                "No Internet Connection"),
                                                            actions: <Widget>[
                                                              TextButton(
                                                                child:
                                                                    Text('OK'),
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                  });
                                              });
                                            },
                                            items: <String>[
                                              '-Action-',
                                              "View",
                                              "Edit"
                                            ].map<DropdownMenuItem<String>>(
                                                (String value) {
                                              return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Wrap(
                                                      direction: Axis.vertical,
                                                      alignment:
                                                          WrapAlignment.center,
                                                      children: [
                                                        Text(
                                                          value,
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              color: Colors.red,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                      ]));
                                            }).toList(),
                                          ),
                                        ),
                                      )
                                    : DataCell(
                                        DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                            isExpanded: true,
                                            value: dropdownValue3,
                                            onChanged: (String newValue) {
                                              setState(() {
                                                if (newValue == "View") {
                                                  check().then((value) {
                                                    if (value) {
                                                      if (list.apProcessName ==
                                                          "Damage Claim Verify")
                                                        Navigator.pushReplacement(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) => DirectorDamageView(
                                                                    propertyid: list
                                                                        .apTblId,
                                                                    apid: list
                                                                        .apId)));
                                                      else if (list
                                                              .apProcessName ==
                                                          "Bill Verify")
                                                        Navigator.pushReplacement(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) => FinanceBillView(
                                                                    propertyid: list
                                                                        .apTblId,
                                                                    apid: list
                                                                        .apId)));
                                                      else if (list
                                                              .apProcessName ==
                                                          "DamageVerify")
                                                        Navigator.pushReplacement(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) => FranchaiseDamageView(
                                                                    propertyid: list
                                                                        .apTblId,
                                                                    apid: list
                                                                        .apId)));
                                                    } else
                                                      showDialog<void>(
                                                        context: context,
                                                        barrierDismissible:
                                                            false,
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                            title: Text(
                                                                "No Internet Connection"),
                                                            actions: <Widget>[
                                                              TextButton(
                                                                child:
                                                                    Text('OK'),
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                  });
                                                } else if (newValue == "Edit")
                                                  check().then((value) {
                                                    setState(() {
                                                      dropdownValueuser =
                                                          "-- User Type --";
                                                      dropdownValuedes =
                                                          "-- Designation --";
                                                      _typeAheadController
                                                          .text = "";
                                                    });

                                                    showDialog<void>(
                                                      context: context,
                                                      barrierDismissible: false,
                                                      builder: (context) {
                                                        return StatefulBuilder(
                                                            builder: (context,
                                                                StateSetter
                                                                    setState) {
                                                          return AlertDialog(
                                                              title: Text(
                                                                "Re-Assign Approval",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .red),
                                                              ),
                                                              content: loading
                                                                  ? Center(
                                                                      child:
                                                                          CircularProgressIndicator())
                                                                  : SingleChildScrollView(
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          Container(
                                                                            height:
                                                                                50,
                                                                            padding:
                                                                                const EdgeInsets.only(left: 20.0, right: 10.0),
                                                                            decoration:
                                                                                new BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(2.0)), border: new Border.all(color: Colors.black38)),
                                                                            child:
                                                                                DropdownButtonHideUnderline(
                                                                              child: DropdownButton<String>(
                                                                                isExpanded: true,
                                                                                value: dropdownValueuser,
                                                                                onChanged: (String newValue) {
                                                                                  if (newValue != "-- User Type --")
                                                                                    getdesignation(newValue).then((value) => setState(() {
                                                                                          dropdownValueuser = newValue;
                                                                                          dropdownValuedes = "-- Designation --";
                                                                                        }));
                                                                                },
                                                                                items: <String>[
                                                                                  "-- User Type --",
                                                                                  "Employee",
                                                                                  "Vendor",
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
                                                                            height:
                                                                                MediaQuery.of(context).size.height / 50,
                                                                          ),
                                                                          StatefulBuilder(builder:
                                                                              (context, setState) {
                                                                            return Container(
                                                                              height: 50,
                                                                              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                                                                              decoration: new BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(2.0)), border: new Border.all(color: Colors.black38)),
                                                                              child: DropdownButtonHideUnderline(
                                                                                child: DropdownButton<String>(
                                                                                  isExpanded: true,
                                                                                  value: dropdownValuedes,
                                                                                  onChanged: (String newValue) {
                                                                                    for (int i = 0; i < li3.values.length; i++)
                                                                                      if (li3.values[i].roleName == newValue) {
                                                                                        roleid = li3.values[i].roleId;
                                                                                        print("roleid: ${roleid}");
                                                                                      }

                                                                                    setState(() {
                                                                                      _typeAheadController.text = "";
                                                                                      dropdownValuedes = newValue;
                                                                                    });
                                                                                  },
                                                                                  items: stringlist.map<DropdownMenuItem<String>>((String value) {
                                                                                    return DropdownMenuItem<String>(
                                                                                      value: value,
                                                                                      child: Text(value),
                                                                                    );
                                                                                  }).toList(),
                                                                                ),
                                                                              ),
                                                                            );
                                                                          }),
                                                                          SizedBox(
                                                                              height: MediaQuery.of(context).size.height / 50),
                                                                          TypeAheadFormField(
                                                                            textFieldConfiguration:
                                                                                TextFieldConfiguration(
                                                                              enabled: true,
                                                                              controller: this._typeAheadController,
                                                                              keyboardType: TextInputType.text,
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
                                                                            suggestionsCallback:
                                                                                (pattern) {
                                                                              return BackendService.getSuggestions(pattern);
                                                                            },
                                                                            itemBuilder:
                                                                                (context, suggestion) {
                                                                              return ListTile(
                                                                                title: Text(suggestion),
                                                                              );
                                                                            },
                                                                            transitionBuilder: (context,
                                                                                suggestionsBox,
                                                                                controller) {
                                                                              return suggestionsBox;
                                                                            },
                                                                            onSuggestionSelected:
                                                                                (suggestion) {
                                                                              for (int i = 0; i < BackendService.li1.items.length; i++)
                                                                                if (BackendService.li1.items[i].uname == suggestion) userid = BackendService.li1.items[i].uid;
                                                                              print(userid);

                                                                              this._typeAheadController.text = suggestion;
                                                                            },
                                                                            validator:
                                                                                (value) {
                                                                              if (value.isEmpty) {
                                                                                return 'Please select a city';
                                                                              } else
                                                                                return 'nothing';
                                                                            },
                                                                          ),
                                                                          SizedBox(
                                                                              height: MediaQuery.of(context).size.height / 50),
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceEvenly,
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets.all(10.0),
                                                                                child: Container(
                                                                                    width: MediaQuery.of(context).size.width / 4,
                                                                                    alignment: Alignment.center,
                                                                                    decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.all(Radius.circular(10))),
                                                                                    child: FlatButton(
                                                                                      onPressed: () {
                                                                                        uploadImage(list.apId, usertype, userid).then((value) => Navigator.pop(context));
                                                                                      },
                                                                                      child: Text(
                                                                                        "Assign",
                                                                                        style: TextStyle(color: Colors.white),
                                                                                      ),
                                                                                    )),
                                                                              ),
                                                                              Padding(
                                                                                padding: const EdgeInsets.all(10.0),
                                                                                child: Container(
                                                                                    width: MediaQuery.of(context).size.width / 4,
                                                                                    alignment: Alignment.center,
                                                                                    decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.all(Radius.circular(10))),
                                                                                    child: FlatButton(
                                                                                      onPressed: () {
                                                                                        Navigator.pop(context);
                                                                                      },
                                                                                      child: Text(
                                                                                        "Cancel",
                                                                                        style: TextStyle(color: Colors.white),
                                                                                      ),
                                                                                    )),
                                                                              ),
                                                                            ],
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ));
                                                        });
                                                      },
                                                    );

                                                    if (value)
                                                      ;
                                                    else
                                                      showDialog<void>(
                                                        context: context,
                                                        barrierDismissible:
                                                            false,
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                            title: Text(
                                                                "No Internet Connection"),
                                                            actions: <Widget>[
                                                              TextButton(
                                                                child:
                                                                    Text('OK'),
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                  });
                                              });
                                            },
                                            items: <String>[
                                              '-Action-',
                                              "View",
                                            ].map<DropdownMenuItem<String>>(
                                                (String value) {
                                              return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Wrap(
                                                      direction: Axis.vertical,
                                                      alignment:
                                                          WrapAlignment.center,
                                                      children: [
                                                        Text(
                                                          value,
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              color: Colors.red,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                      ]));
                                            }).toList(),
                                          ),
                                        ),
                                      ),
                              ]),
                            )
                            .toList(),
                      ),
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: page > 1 ? Colors.red : Colors.grey,
                        ),
                        onPressed: () {
                          if (page > 1)
                            setState(() {
                              page--;
                              postRequest();
                            });
                        },
                      ),
                      int.parse(li.totalCount.toString()) == 0
                          ? Text("0 to 0 of 0")
                          : int.parse(li.totalCount.toString()) > (page * 10)
                              ? Text(
                                  "${(page * 10) - 9} to ${(page * 10)} of ${li.totalCount}")
                              : Text(
                                  "${(page * 10) - 9} to ${li.totalCount} of ${li.totalCount}"),
                      IconButton(
                        icon: Icon(
                          Icons.arrow_forward,
                          color:
                              int.parse(li.totalCount.toString()) > (page * 10)
                                  ? Colors.red
                                  : Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            if (int.parse(li.totalCount.toString()) >
                                (page * 10)) {
                              page++;
                              postRequest();
                            }
                          });
                        },
                      )
                    ],
                  ),
                  SizedBox(
                    height: height / 40,
                  ),
                  SizedBox(
                    height: height / 40,
                  ),
                ],
              ),
            ),
        appBar: AppBar(
        title: Image.asset('logotitle.png',height: 40),
      ),
    );
  }
}

class PlanListView {
  String planname;
  String property;
  String servicetype;
  String size;

  PlanListView({this.planname, this.property, this.servicetype, this.size});

  static List<PlanListView> getdata() {
    return <PlanListView>[
      PlanListView(
          planname: "Below 1000L",
          property: "Tank",
          servicetype: "Residential",
          size: "500"),
      PlanListView(
          planname: "1000L - 2000L",
          property: "Tank-sump",
          servicetype: "Commercial",
          size: "29966"),
      PlanListView(
          planname: "Above 1000L",
          property: "Car",
          servicetype: "Residential",
          size: "299"),
    ];
  }
}

class BackendService {
  static GetUserDetails li1;

  static Future<List> getSuggestions(String query) async {
    var url = String_values.base_url +
        'role-user-list?search=${query}&urole_id=' +
        DirectorApprovalListState.roleid;

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
      } else {
        for (int i = 0; i < li1.items.length; i++)
          s.add(li1.items[i].uname.toString());
        print(s);
        return s;
      }
    } else {
      print("Retry");
    }
  }
}

class _Row {
  _Row(
    this.valueA,
    this.valueB,
    this.valueC,
    this.valueD,
    this.valueE,
  );

  final String valueA;
  final String valueB;
  final String valueC;
  final String valueD;
  final int valueE;

  bool selected = false;
}
