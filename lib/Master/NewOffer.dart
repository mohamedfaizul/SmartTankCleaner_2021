import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:tankcare/Employee/Dashboard.dart';

class NewOffer extends StatefulWidget {
  @override
  NewOfferState createState() => NewOfferState();
}

class NewOfferState extends State<NewOffer> {
  List<String> items = List<String>.generate(7, (index) {
    return "Item - $index";
  });
  List<PlanListClass> listplan;
  TextEditingController serviceyearcontroller = new TextEditingController();
  TextEditingController totalservicecontroller = new TextEditingController();
  TextEditingController literpricecontroller = new TextEditingController();
  TextEditingController fixedpricecontroller = new TextEditingController();
  List<PlanServiceYearClass> listplanyear;
  List<PlanListClass> selectedAvengers;
  bool sort;

  String dropdownValue = '-- Service Type --';

  String dropdownValue1 = '-- Property Type --';

  String dropdownValue2 = '-- Select Plan --';

  static List<String> friendsList = [null];

  void initState() {
    sort = false;
    selectedAvengers = [];
    listplan = PlanListClass.getdata();
    listplanyear = PlanServiceYearClass.getdata();
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
      body: SingleChildScrollView(
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
                    "New Offer",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: height / 40,
            ),
            Container(
              padding: EdgeInsets.all(16),
              width: width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, 1.0), //(x,y)
                    blurRadius: 1.0,
                  ),
                ],
              ),
              // color: Colors.white,
              margin: EdgeInsets.all(10.0),

              child: new Text(
                "Offer",
                textAlign: TextAlign.left,
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
              ),
            ),
            SizedBox(
              height: height / 50,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: Container(
                child: new TextField(
                  decoration: InputDecoration(
                    hintText: 'Offer Name: Free Bike Service',
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
                    "Residentioal",
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
                child: new TextField(
                  decoration: InputDecoration(
                    hintText: 'Free Service: 1 ',
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

            Container(
              padding: EdgeInsets.all(16),
              width: width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, 1.0), //(x,y)
                    blurRadius: 1.0,
                  ),
                ],
              ),
              // color: Colors.white,
              margin: EdgeInsets.all(10.0),

              child: new Text(
                "Offer Conditions",
                textAlign: TextAlign.left,
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
              ),
            ),
            SizedBox(
              height: height / 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                  padding: const EdgeInsets.only(left: 20.0, right: 10.0),
                  decoration: new BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(2.0)),
                      border: new Border.all(color: Colors.black38)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: dropdownValue2,
                      onChanged: (String newValue) {
                        setState(() {
                          dropdownValue2 = newValue;
                        });
                      },
                      items: <String>[
                        '-- Select Plan --',
                        "Below 1000L",
                        "1000L to 2000L",
                        "Above 1000L",
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.all(Radius.circular(50))),
                    child: FlatButton(
                      onPressed: () {
                        setState(() {
                          listplan.add(PlanListClass(
                              name: dropdownValue2, totalservices: "1"));
                        });
                      },
                      child: Text(
                        "Add",
                        style: TextStyle(color: Colors.white),
                      ),
                    )),
              ],
            ),
            SizedBox(
              height: height / 40,
            ),
            SizedBox(
              height: height / 80,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                sortAscending: sort,
                sortColumnIndex: 0,
                columns: [
                  DataColumn(
                    label: Center(
                        child: Wrap(
                      direction: Axis.vertical, //default
                      alignment: WrapAlignment.center,
                      children: [
                        Text("Plan Name",
                            softWrap: true, style: TextStyle(fontSize: 12)),
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
                        Text("Total Services",
                            softWrap: true, style: TextStyle(fontSize: 12)),
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
                            softWrap: true, style: TextStyle(fontSize: 12)),
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
                rows: listplan
                    .map(
                      (list) => DataRow(
                          selected: selectedAvengers.contains(list),
                          cells: [
                            DataCell(
                              Center(child: Text(list.name)),
                              onTap: () {
                                print('Selected ${list.name}');
                              },
                            ),
                            DataCell(
                              Center(child: Text(list.totalservices)),
                            ),
                            DataCell(
                              Center(
                                child: IconButton(
                                    icon: Icon(Icons.remove_circle_outline),
                                    onPressed: () {
                                      setState(() {
                                        listplan.remove(list);
                                      });
                                    }),
                              ),
                            ),
                          ]),
                    )
                    .toList(),
              ),
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
                        borderRadius: BorderRadius.all(Radius.circular(50))),
                    child: FlatButton(
                      onPressed: () {},
                      child: Text(
                        "Save",
                        style: TextStyle(color: Colors.white),
                      ),
                    )),
                Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.all(Radius.circular(50))),
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

  static List<PlanListClass> getdata() {
    return <PlanListClass>[
      PlanListClass(name: "Below 1000L", totalservices: "1 "),
      PlanListClass(name: "1000L - 2000L", totalservices: "5"),
      PlanListClass(name: "Above 2000L", totalservices: "2"),
      PlanListClass(name: "2000L -  4000L ", totalservices: "6"),
    ];
  }
}

class PlanServiceYearClass {
  String serviceyear;
  String totalservices;
  String literprice;
  String fixedprice;

  PlanServiceYearClass(
      {this.serviceyear, this.totalservices, this.literprice, this.fixedprice});

  static List<PlanServiceYearClass> getdata() {
    return <PlanServiceYearClass>[
      PlanServiceYearClass(
          serviceyear: "1999"
              "",
          totalservices: "1 ",
          literprice: "10",
          fixedprice: "299"),
      PlanServiceYearClass(
          serviceyear: "2003",
          totalservices: "5",
          literprice: "10",
          fixedprice: "299"),
      PlanServiceYearClass(
          serviceyear: "2019",
          totalservices: "2",
          literprice: "10",
          fixedprice: "299"),
      PlanServiceYearClass(
          serviceyear: "2020",
          totalservices: "6",
          literprice: "10",
          fixedprice: "299"),
    ];
  }
}
