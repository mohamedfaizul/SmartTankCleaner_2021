import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:tankcare/Customer/register.dart';
import 'package:tankcare/Employee/Dashboard.dart';
import 'package:tankcare/VendorModels/BillList.dart';

import '../../string_values.dart';
import 'billdetail.dart';

class VendorBillList extends StatefulWidget {
  @override
  VendorBillListState createState() => VendorBillListState();
}

class VendorBillListState extends State<VendorBillList> {
  bool loading = false;

  VendorBillListings li;

  var page = 1;

  String stat = "";

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
    if (dropdownValue == '-- Verify Status --')
      stat = "";
    else
      stat = dropdownValue.toString().toUpperCase().substring(0, 1);
    print(stat);
    var url = String_values.base_url +
        'servicer-bill-list?search=${searchController.text}&page=${page}&limit=10&from_date=$sql_dob_from&to_date=$sql_dob_to&verify_status=$stat';
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
      if (response.body.toString().contains("true"))
        li = VendorBillListings.fromJson(json.decode(response.body));
      //  print("plan${li.items[0].mapLocation}");
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
  final dateFormatter = DateFormat('yyyy-MM-dd');
  String sql_dob_from;
  String sql_dob_to;
  TextEditingController datefromcontroller = new TextEditingController();
  TextEditingController datetocontroller = new TextEditingController();

  String dropdownValue = '-- Verify Status --';

  String dropdownValue3 = '-Action-';

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
          barrierDismissible: false, // user must tap button!
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
      //backgroundColor: Colors.redAccent[100],
      body: loading
          ? Center(child: CircularProgressIndicator())
          : li != null
              ? SingleChildScrollView(
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
                              "Bill List",
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
                        margin: const EdgeInsets.only(left: 24, right: 24),
                        child: new TextField(
                          controller: searchController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.search),
                            labelText: 'Search',
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
                        height: height / 40,
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 24.0, right: 24.0),
                        padding: const EdgeInsets.only(left: 20.0, right: 10.0),
                        decoration: new BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(2.0)),
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
                              '-- Verify Status --',
                              "Pending",
                              "Ongoing",
                              "Completed",
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
                      Padding(
                        padding: const EdgeInsets.only(left: 24, right: 24),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              flex: 5,
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
                                  sql_dob_from = dateFormatter.format(date);
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
                                  labelText: 'From Date',
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
                            Flexible(
                                flex: 1,
                                child: SizedBox(
                                  width: 1,
                                )),
                            Flexible(
                              flex: 5,
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
                                  sql_dob_to = dateFormatter.format(date);
                                  print("date" + sql_dob_to);
                                  datetocontroller.text = date.day.toString() +
                                      '/' +
                                      date.month.toString() +
                                      '/' +
                                      date.year.toString();
                                },
                                enabled: true,
                                controller: datetocontroller,
                                decoration: InputDecoration(
                                  prefixIcon:
                                      Icon(Icons.calendar_today_outlined),
                                  labelText: 'To Date',
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
                          ],
                        ),
                      ),
                      SizedBox(
                        height: height / 50,
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
                                  searchController.text = "";
                                  sql_dob_to = "";
                                  sql_dob_from = "";
                                  datefromcontroller.text = "";
                                  datetocontroller.text = "";
                                  dropdownValue = '-- Verify Status --';
                                  check().then((value) {
                                    if (value)
                                      postRequest();
                                    else
                                      showDialog<void>(
                                        context: context,
                                        barrierDismissible:
                                            false, // user must tap button!
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title:
                                                Text("No Internet Connection"),
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
                                direction: Axis.vertical, //default
                                alignment: WrapAlignment.center,
                                children: [
                                  Text(
                                    "Bill No",
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
                                  Text("Invoice No",
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
                                  Text("Invoice Date",
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
                                  Text("Total Amount",
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
                                  Text("Paid Status",
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
                                  Text("Verify Status",
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
                                  Text("Status",
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
                                  Text("Actions",
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
                          rows: li.items
                              .map(
                                (list) => DataRow(cells: [
                                  DataCell(Center(
                                      child: Center(
                                    child: Wrap(
                                        direction: Axis.vertical, //default
                                        alignment: WrapAlignment.center,
                                        children: [
                                          Text(
                                            list.sbillCode.toString(),
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
                                          Text(list.sbillInvno.toString(),
                                              textAlign: TextAlign.center)
                                        ]),
                                  ))),
                                  DataCell(Center(
                                      child: Center(
                                    child: Wrap(
                                        direction: Axis.vertical, //default
                                        alignment: WrapAlignment.center,
                                        children: [
                                          list.sbillInvDate != null
                                              ? Text(
    DateFormat('dd/MM/yyyy').format(
    DateTime.parse(list.sbillInvDate.toString())),
                                                  textAlign: TextAlign.center)
                                              : Container()
                                        ]),
                                  ))),
                                  DataCell(Center(
                                      child: Center(
                                    child: Wrap(
                                        direction: Axis.vertical, //default
                                        alignment: WrapAlignment.center,
                                        children: [
                                          Text(
                                              "Rs.${list.sbillAmnt.toString()}",
                                              textAlign: TextAlign.center)
                                        ]),
                                  ))),
                                  DataCell(Center(
                                      child: Center(
                                    child: Wrap(
                                        direction: Axis.vertical, //default
                                        alignment: WrapAlignment.center,
                                        children: [
                                          Text(
                                              list.sbillPaymentStatus
                                                  .toString(),
                                              textAlign: TextAlign.center)
                                        ]),
                                  ))),
                                  DataCell(list.sbillApproval.toString() == "A"
                                      ? Center(
                                          child: Center(
                                              child: Wrap(
                                                  direction:
                                                      Axis.vertical, //default
                                                  alignment:
                                                      WrapAlignment.center,
                                                  children: [
                                              Text("Active",
                                                  textAlign: TextAlign.center)
                                            ])))
                                      : list.sbillApproval.toString() == "P"
                                          ? Center(
                                              child: Center(
                                                  child: Wrap(
                                                      direction: Axis
                                                          .vertical, //default
                                                      alignment:
                                                          WrapAlignment.center,
                                                      children: [
                                                  Text("Pending",
                                                      textAlign:
                                                          TextAlign.center)
                                                ])))
                                          : Center(
                                              child: Center(
                                              child: Wrap(
                                                  direction:
                                                      Axis.vertical, //default
                                                  alignment:
                                                      WrapAlignment.center,
                                                  children: [
                                                    Text("Complete",
                                                        textAlign:
                                                            TextAlign.center)
                                                  ]),
                                            ))),
                                  DataCell(
                                    list.sbillStatus.toString() == "A"
                                        ? Center(
                                            child: Center(
                                                child: Wrap(
                                                    direction:
                                                        Axis.vertical, //default
                                                    alignment:
                                                        WrapAlignment.center,
                                                    children: [
                                                Text("Active",
                                                    textAlign: TextAlign.center)
                                              ])))
                                        : list.sbillStatus.toString() == "P"
                                            ? Center(
                                                child: Center(
                                                    child: Wrap(
                                                        direction: Axis
                                                            .vertical, //default
                                                        alignment: WrapAlignment
                                                            .center,
                                                        children: [
                                                    Text("Pending",
                                                        textAlign:
                                                            TextAlign.center)
                                                  ])))
                                            : Center(
                                                child: Center(
                                                    child: Wrap(
                                                        direction: Axis
                                                            .vertical, //default
                                                        alignment: WrapAlignment
                                                            .center,
                                                        children: [
                                                    Text("Complete",
                                                        textAlign:
                                                            TextAlign.center)
                                                  ]))),
                                  ),
                                  DataCell(
                                    DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        isExpanded: true,
                                        value: dropdownValue3,
                                        onChanged: (String newValue) {
                                          setState(() {
                                            if (newValue == "View")
                                              check().then((value) {
                                                if (value)
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              VendorBillDetail(
                                                                  billid: list
                                                                      .sbillId)));
                                                else
                                                  showDialog<void>(
                                                    context: context,
                                                    barrierDismissible:
                                                        false, // user must tap button!
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: Text(
                                                            "No Internet Connection"),
                                                        actions: <Widget>[
                                                          TextButton(
                                                            child: Text('OK'),
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
                                            // else if (newValue == "Edit")
                                            //   check().then((value) {
                                            //     if (value)
                                            //       Navigator.push(
                                            //           context,
                                            //           MaterialPageRoute(
                                            //               builder: (context) =>
                                            //                   GroupEdit(
                                            //                       groupid:
                                            //                           list.cusId)));
                                            //     else
                                            //       showDialog<void>(
                                            //         context: context,
                                            //         barrierDismissible:
                                            //             false, // user must tap button!
                                            //         builder:
                                            //             (BuildContext context) {
                                            //           return AlertDialog(
                                            //             title: Text(
                                            //                 "No Internet Connection"),
                                            //             actions: <Widget>[
                                            //               TextButton(
                                            //                 child: Text('OK'),
                                            //                 onPressed: () {
                                            //                   Navigator.of(context)
                                            //                       .pop();
                                            //                 },
                                            //               ),
                                            //             ],
                                            //           );
                                            //         },
                                            //       );
                                            //   });
                                            // else if (newValue == "Delete") {
                                            //   check().then((value) {
                                            //     if (value)
                                            //       delete(list.cusId);
                                            //     else
                                            //       showDialog<void>(
                                            //         context: context,
                                            //         barrierDismissible:
                                            //             false, // user must tap button!
                                            //         builder:
                                            //             (BuildContext context) {
                                            //           return AlertDialog(
                                            //             title: Text(
                                            //                 "No Internet Connection"),
                                            //             actions: <Widget>[
                                            //               TextButton(
                                            //                 child: Text('OK'),
                                            //                 onPressed: () {
                                            //                   Navigator.of(context)
                                            //                       .pop();
                                            //                 },
                                            //               ),
                                            //             ],
                                            //           );
                                            //         },
                                            //       );
                                            //   });

                                            // li.items.remove(list);
                                          });
                                        },
                                        items: <String>['-Action-', "View"]
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                          return DropdownMenuItem<String>(
                                              value: value,
                                              child: Wrap(
                                                  direction:
                                                      Axis.vertical, //default
                                                  alignment:
                                                      WrapAlignment.center,
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
                                  ),
                                ]),
                              )
                              .toList(),
                        ),
                      ),

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
                      //             initialValue: "2020",
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
                      //             initialValue: "1",
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
                      //             initialValue: "2020",
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
                      //             initialValue: "1",
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
                              : int.parse(li.totalCount.toString()) >
                                      (page * 10)
                                  ? Text(
                                      "${(page * 10) - 9} to ${(page * 10)} of ${li.totalCount}")
                                  : Text(
                                      "${(page * 10) - 9} to ${li.totalCount} of ${li.totalCount}"),
                          IconButton(
                            icon: Icon(
                              Icons.arrow_forward,
                              color: int.parse(li.totalCount.toString()) >
                                      (page * 10)
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

                      // ...listdetails(),
                    ],
                  ),
                )
              : Container(),

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
