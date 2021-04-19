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
import 'package:tankcare/Employee/EmployeeModels/SpecialServices/List.dart';
import 'package:tankcare/Employee/EmployeeModels/SpecialServices/View.dart';
import 'package:tankcare/VendorModels/MenuModel.dart';
import 'package:tankcare/string_values.dart';

class EmployeeSpecialServiceList extends StatefulWidget {
  @override
  EmployeeSpecialServiceListState createState() =>
      EmployeeSpecialServiceListState();
}

class EmployeeSpecialServiceListState extends State<EmployeeSpecialServiceList> {
  bool loading = false;
  MenuList li3;
  TextEditingController NotesController = new TextEditingController();
  TextEditingController ResponseNotesController = new TextEditingController();
  List<String> stringlist = [
    '-- Property Type --',
    "Tank",
    "OverHead Tank",
    "Sump",
    "Sump-Tile",
    "Car",
    "Bike",
    "Floor",
    "OverHead Tank Tile"
  ];
  String p_Update;
  String p_Delete;
  String p_Create;
  String p_Read;
  SpecialServiceList li;

  var page = 1;

  SpecialServiceDetailsModel li23;
  Future<int> uploadImage() async {
    setState(() {
      loading = true;
    });

    Map<String, String> headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer ${RegisterPagesState.token}'
    };

    var request = http.MultipartRequest(
        'POST', Uri.parse(String_values.base_url + 'special-service-save'));
    //property_id plan_id pplan_name pplan_year pplan_service pplan_price pplan_tot_price pplan_start_date
    request.headers.addAll(headers);
    request.fields['ss_date'] = sql_dob_from;
    request.fields['ss_request_note'] = NotesController.text;
    var response = await request.send();
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);

      setState(() {
        loading = false;
      });
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => EmployeeSpecialServiceList()));
      return response.statusCode;
    });
  }
  Future<int> editImage(ssid) async {
    setState(() {
      loading = true;
    });

    Map<String, String> headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer ${RegisterPagesState.token}'
    };

    var request = http.MultipartRequest(
        'POST', Uri.parse(String_values.base_url + 'special-service-save'));
    //property_id plan_id pplan_name pplan_year pplan_service pplan_price pplan_tot_price pplan_start_date
    request.headers.addAll(headers);
    request.fields['ss_date'] = sql_dob_from;
    request.fields['ss_id'] = ssid;
    request.fields['ss_request_note'] = NotesController.text;
    request.fields['ss_response_note'] = ResponseNotesController.text;
    var response = await request.send();
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);

      setState(() {
        loading = false;
      });
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => EmployeeSpecialServiceList()));
      return response.statusCode;
    });
  }
  Future<http.Response> details(planid) async {
    setState(() {
      loading = true;
    });
    var url =
        String_values.base_url + 'special-service-details/' + planid;
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
      li23 = SpecialServiceDetailsModel.fromJson(json.decode(response.body));
      datefromcontroller.text=  DateFormat('dd/MM/yyyy').format(
          DateTime.parse(li23.items.ssDate));
      ResponseNotesController.text=li23.items.ssResponseNote;
      NotesController.text=li23.items.ssRequestNote;
      sql_dob_from=li23.items.ssDate;

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
  Future<http.Response> menulist() async {
    setState(() {
      loading = true;
    });
    var url = String_values.base_url + 'menu-list';
    print(url);
    var response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer ${RegisterPagesState.token}'
      },
    );
    if (response.statusCode == 200) {
      li3 = MenuList.fromJson(jsonDecode(response.body));
      setState(() {
        stringlist.clear();
        stringlist.add("-Action-");
        for (int i = 0; i < li3.list.length; i++)
          if (li3.list[i].title == "Services") {
            if (li3.list[i].children.toString() == "null") {
              p_Update = li3.list[i].rrUpdate;
              p_Create = li3.list[i].rrCreate;
              p_Delete = li3.list[i].rrDelete;
              p_Read = li3.list[i].rrRead;
              if (p_Read == "1") stringlist.add("View");

              if (p_Update == '1') stringlist.add("Edit");
              if (p_Delete == "1") stringlist.add("Delete");
              print(stringlist);
            } else {
              for (int j = 0; j < li3.list[i].children.length; j++)
                if (li3.list[i].children[j].title == "Special Service") {
                  p_Update = li3.list[i].children[j].rrUpdate;
                  p_Create = li3.list[i].children[j].rrCreate;
                  p_Delete = li3.list[i].children[j].rrDelete;
                  p_Read = li3.list[i].children[j].rrRead;
                  if (p_Read == "1") stringlist.add("View");

                  if (p_Update == '1') stringlist.add("Response");
                  if (p_Delete == "1") stringlist.add("Delete");
                  print(stringlist);
                }
            }
          }
      });

      print(p_Create);
      print(p_Update);
      print(p_Delete);
      print(p_Read);
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
  Future<http.Response> postRequest() async {
    setState(() {
      loading = true;
    });

    var url = String_values.base_url +
        'special-service-list?assign=n&page=${page}&limit=10&search=${searchController.text}';
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
      li = SpecialServiceList.fromJson(json.decode(response.body));
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

  Future<http.Response> delete(planid) async {
    setState(() {
      loading = true;
    });

    var url = String_values.base_url + 'special-service-delete/' + planid;
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
  final dateFormatter = DateFormat('yyyy-MM-dd');
  String sql_dob_from;
  String sql_dob_to;
  TextEditingController datefromcontroller = new TextEditingController();
  TextEditingController datetocontroller = new TextEditingController();

  TextEditingController serviceyearcontroller = new TextEditingController();
  TextEditingController totalservicecontroller = new TextEditingController();
  TextEditingController literpricecontroller = new TextEditingController();
  TextEditingController fixedpricecontroller = new TextEditingController();
  TextEditingController searchController = new TextEditingController();
  List<PlanListView> listplanyear;
  bool sort;

  String dropdownValue = '-- Assign Status --';

  String dropdownValue1 = '-- Property Type --';

  String dropdownValue2 = '-- Service Status --';

  String dropdownValue3 = '-Action-';

  static List<String> friendsList = [null];

  void initState() {
    sort = false;
    setState(() {
      loading = true;
    });
    check().then((value) {
      if (value)
        postRequest().then((value) => menulist());
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
                        "Special Service List",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                            fontSize: 17),
                      ),
                    ),
                  ),
                  p_Create == "1"
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
                                    "Service Request",
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
                                              NotesController,
                                              decoration:
                                              InputDecoration(
                                                labelText: 'Request Notes',
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
                                            uploadImage().then(
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
                        "Add Special Request",
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
                        datefromcontroller.text = "";
                        sql_dob_from = "";
                        dropdownValue = '-- Assign Status --';
                        dropdownValue2 = '-- Service Status --';
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
                              "SS Code",
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
                            Text(
                              "Request Note",
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
                            Text("Response Note",
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
                            Text("Date",
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
                            Text("Requested By",
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
                  // DataColumn(
                  //   label: Center(
                  //       child: Wrap(
                  //         direction: Axis.vertical, //default
                  //         alignment: WrapAlignment.center,
                  //         children: [
                  //           Text("Assign Status",
                  //               softWrap: true,
                  //               style: TextStyle(fontSize: 12),
                  //               textAlign: TextAlign.center),
                  //         ],
                  //       )),
                  //   numeric: false,
                  //
                  //   // onSort: (columnIndex, ascending) {
                  //   //   onSortColum(columnIndex, ascending);
                  //   //   setState(() {
                  //   //     sort = !sort;
                  //   //   });
                  //   // }
                  // ),
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
                                  list.ssCode.toString(),
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
                                Text(
                                  list.ssRequestNote.toString(),
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
                                Text(list.ssResponseNote.toString(),
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
                                    Text(  DateFormat('dd/MM/yyyy').format(
                                  DateTime.parse(list.ssDate.toString())),
                                        textAlign: TextAlign.center)
                                  ]))),
                    ),
                    DataCell(
                      Center(
                          child: Center(
                              child: Wrap(
                                  direction: Axis.vertical, //default
                                  alignment: WrapAlignment.center,
                                  children: [
                                    Text(list.requestBy.toString(),
                                        textAlign: TextAlign.center)
                                  ]))),
                    ),

                    // list.assignUid==null?
                    // DataCell(
                    //   Center(
                    //       child: Center(
                    //           child: Wrap(
                    //               direction: Axis.vertical, //default
                    //               alignment: WrapAlignment.center,
                    //               children: [
                    //                 Text("Not Assigned",
                    //                     textAlign: TextAlign.center)
                    //               ]))),
                    // ):    DataCell(
                    //   Center(
                    //       child: Center(
                    //           child: Wrap(
                    //               direction: Axis.vertical, //default
                    //               alignment: WrapAlignment.center,
                    //               children: [
                    //                 Text("Assigned",
                    //                     textAlign: TextAlign.center)
                    //               ]))),
                    // ),
                    DataCell(
                      DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: dropdownValue3,
                          onChanged: (String newValue) {
                            setState(() {
                              if (newValue == "View")
                                details(list.ssId).then((value) =>
                                showDialog<void>(
                                    context: context,
                                    barrierDismissible:
                                    false, // user must tap button!
                                    builder: (context) {
                                      return StatefulBuilder(builder:
                                          (context, StateSetter setState) {
                                        return AlertDialog(
                                          title: Text(
                                            "Service Request",
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
                                                    enabled: false,
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
                                                Padding(
                                                  padding:
                                                  const EdgeInsets.only(
                                                      left: 10.0,
                                                      right: 10.0),
                                                  child: Container(
                                                    child: new TextField(
                                                      enabled: false,
                                                      maxLines: 25,
                                                      minLines: 3,
                                                      controller:
                                                      NotesController,
                                                      decoration:
                                                      InputDecoration(
                                                        labelText: 'Request Notes',
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
                                                      enabled: false,
                                                      maxLines: 25,
                                                      minLines: 3,
                                                      controller:
                                                      ResponseNotesController,
                                                      decoration:
                                                      InputDecoration(
                                                        labelText: 'Response Notes',
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
                                              child: Text('Ok'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      });
                                    }));
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) =>
                              //             ServiceDetail(
                              //                 serviceid:
                              //                 list.ssId)));
                              else if (newValue == "Response")
                                details(list.ssId).then((value) =>
                                    showDialog<void>(
                                        context: context,
                                        barrierDismissible:
                                        false, // user must tap button!
                                        builder: (context) {
                                          return StatefulBuilder(builder:
                                              (context, StateSetter setState) {
                                            return AlertDialog(
                                              title: Text(
                                                "Service Request",
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
                                                          NotesController,
                                                          decoration:
                                                          InputDecoration(
                                                            labelText: 'Request Notes',
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
                                                          ResponseNotesController,
                                                          decoration:
                                                          InputDecoration(
                                                            labelText: 'Response Notes',
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
                                                        editImage(list.ssId).then(
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
                                        }));
//                                    else if (newValue == "Edit")
//                                      Navigator.push(
//                                          context,
//                                          MaterialPageRoute(
//                                              builder: (context) =>
//                                                  PropertyEdit(
//                                                      propertyid:
//                                                          list.propertyId)));
                                   else if (newValue == "Delete") {
                                showDialog(context: context,
                                    child: AlertDialog(title: Column(
                                      children: [
                                        Image.asset("ingo.jpeg",height: 100,),
                                        Text("Are you sure?"),
                                      ],
                                    ),content: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          Text("Do you want to delete!"),
                                          SizedBox(height: height/20,),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              RaisedButton(
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(25))),
                                                color: Colors.red,
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  delete(list.ssId);
                                                  li.items.remove(list);
                                                },
                                                child: Text(
                                                  "Delete",
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
                                   }
                            });
                          },
                          items: stringlist.map<DropdownMenuItem<String>>(
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
