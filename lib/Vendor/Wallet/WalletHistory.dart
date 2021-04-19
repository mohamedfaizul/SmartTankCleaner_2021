import 'dart:async';
import 'dart:convert';
import 'package:tankcare/Employee/Dashboard.dart';
import 'dart:io';
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
import 'package:tankcare/VendorModels/WalletHistory.dart';

import '../../string_values.dart';

class WalletHistorylist extends StatefulWidget {
  @override
  WalletHistorylistState createState() => WalletHistorylistState();
}

class WalletHistorylistState extends State<WalletHistorylist> {
  bool loading = false;

  WalletHistoryList li;
  double credittotal = 0;
  double debittotal = 0;

  var page = 1;

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

    var url = String_values.base_url + 'vendor-payout-history';
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
      li = WalletHistoryList.fromJson(json.decode(response.body));
      credittotal = 0;
      debittotal = 0;
      for (int i = 0; i < li.data.credit.length; i++)
        credittotal = credittotal + double.parse(li.data.credit[i].cnoteAmnt);
      for (int i = 0; i < li.data.debit.length; i++)
        debittotal = debittotal + double.parse(li.data.debit[i].cnoteAmnt);
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

  Future<http.Response> searchpostRequest() async {
    setState(() {
      loading = true;
    });

    var url = String_values.base_url +
        'vendor-payout-history?from_date=${sql_dob_from}&to_date=${sql_dob_to}';
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
      li = WalletHistoryList.fromJson(json.decode(response.body));
      credittotal = 0;
      debittotal = 0;
      for (int i = 0; i < li.data.credit.length; i++)
        credittotal = credittotal + double.parse(li.data.credit[i].cnoteAmnt);
      for (int i = 0; i < li.data.debit.length; i++)
        debittotal = debittotal + double.parse(li.data.debit[i].cnoteAmnt);
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

  List<String> items = List<String>.generate(7, (index) {
    return "Item - $index";
  });
  TextEditingController serviceyearcontroller = new TextEditingController();
  TextEditingController totalservicecontroller = new TextEditingController();
  TextEditingController literpricecontroller = new TextEditingController();
  TextEditingController fixedpricecontroller = new TextEditingController();
  TextEditingController searchController = new TextEditingController();
  final dateFormatter = DateFormat('yyyy-MM-dd');
  String sql_dob_from;
  String sql_dob_to;
  TextEditingController datefromcontroller = new TextEditingController();
  TextEditingController datetocontroller = new TextEditingController();

  bool sort;

  String dropdownValue = '-- Service Type --';

  String dropdownValue1 = '-- Property Type --';

  String dropdownValue2 = '-- Select Plan --';

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
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: new Text(
                          "Wallet History",
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
                              datefromcontroller.text = date.day.toString() +
                                  '/' +
                                  date.month.toString() +
                                  '/' +
                                  date.year.toString();
                            },
                            enabled: true,
                            controller: datefromcontroller,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.calendar_today_outlined),
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
                              prefixIcon: Icon(Icons.calendar_today_outlined),
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
                    height: height / 80,
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
                  //   margin: EdgeInsets.only(top: 10.0, bottom: 10),
                  //
                  //   child: new Text(
                  //     "Plan",
                  //     textAlign: TextAlign.left,
                  //     style: TextStyle(
                  //         fontWeight: FontWeight.bold, color: Colors.red),
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: height / 50,
                  // ),

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
                              searchpostRequest();
                            },
                            child: Text(
                              "Search",
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
                              sql_dob_from = "";
                              sql_dob_to = "";
                              datefromcontroller.text = "";
                              datetocontroller.text = "";
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

                  Container(
                      margin: const EdgeInsets.only(top: 10),
                      color: Colors.red.shade50,
                      child: ExpansionTile(
                          backgroundColor: Colors.white,
                          initiallyExpanded: true,
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Credit List",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.red),
                              ),
                              Text(
                                "Credit Total: Rs.${credittotal}",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black),
                              )
                            ],
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
                                        Text("Name",
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
                                        Text("Account Type",
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
                                        Text("Amount",
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
                                rows: li.data.credit
                                    .map(
                                      (list) => DataRow(cells: [
                                        DataCell(
                                          Center(
                                              child: Text(
    DateFormat('dd/MM/yyyy').format(
    DateTime.parse( list.cnoteDate)),
                                            textAlign: TextAlign.center,
                                          )),
                                        ),
                                        DataCell(
                                          Center(
                                              child: Text(list.vendorName,
                                                  textAlign: TextAlign.center)),
                                        ),
                                        DataCell(
                                          Center(
                                              child: Text(list.cnoteAccType,
                                                  textAlign: TextAlign.center)),
                                        ),
                                        DataCell(
                                          Center(
                                              child: Text(list.cnoteAmnt,
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

                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //   children: [
                  //     IconButton(icon: Icon(Icons.arrow_back,color: page>1?Colors.red:Colors.grey,),onPressed: (){if(page>1)setState(() {
                  //       page--;
                  //       postRequest();
                  //     });},),
                  //     int.parse(li.totalCount.toString())==0?Text("0 to 0 of 0"):int.parse(li.totalCount.toString())>(page*10)?Text("${(page*10)-9} to ${(page*10)} of ${li.totalCount}"):Text("${(page*10)-9} to ${li.totalCount} of ${li.totalCount}"),
                  //     IconButton(icon: Icon(Icons.arrow_forward,color: int.parse(li.totalCount.toString())>(page*10)?Colors.red:Colors.grey,),onPressed: (){setState(() {
                  //       if( int.parse(li.totalCount.toString())>(page*10) )
                  //       {page++;
                  //       postRequest();}
                  //     });},)
                  //   ],),
                  SizedBox(
                    height: height / 40,
                  ),
                  Container(
                      margin: const EdgeInsets.only(top: 10),
                      color: Colors.red.shade50,
                      child: ExpansionTile(
                          backgroundColor: Colors.white,
                          initiallyExpanded: true,
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Debit List",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.red),
                              ),
                              Text(
                                "Debit Total: Rs.${debittotal}",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black),
                              )
                            ],
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
                                        Text("Name",
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
                                        Text("Account Type",
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
                                        Text("Amount",
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
                                rows: li.data.debit
                                    .map(
                                      (list) => DataRow(cells: [
                                        DataCell(
                                          Center(
                                              child: Text(
                                              DateFormat('dd/MM/yyyy').format(
    DateTime.parse(list.cnoteDate)),
                                            textAlign: TextAlign.center,
                                          )),
                                        ),
                                        DataCell(
                                          Center(
                                              child: Text(list.vendorName,
                                                  textAlign: TextAlign.center)),
                                        ),
                                        DataCell(
                                          Center(
                                              child: Text(list.cnoteAccType,
                                                  textAlign: TextAlign.center)),
                                        ),
                                        DataCell(
                                          Center(
                                              child: Text(list.cnoteAmnt,
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
}
