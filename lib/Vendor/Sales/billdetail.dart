import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:tankcare/Customer/register.dart';
import 'package:tankcare/CustomerModels/districtlist.dart';
import 'package:tankcare/CustomerModels/statelist.dart';
import 'package:tankcare/Employee/Dashboard.dart';
import 'package:tankcare/VendorModels/Billview.dart';

import '../../string_values.dart';

class VendorBillDetail extends StatefulWidget {
  VendorBillDetail({Key key, this.billid});

  String billid;

  @override
  VendorBillDetailState createState() => VendorBillDetailState();
}

class VendorBillDetailState extends State<VendorBillDetail> {
  bool loading = false;
  VendorBillView li;

  var _kGooglePlex;

  StateListings li2;

  DistrictListings li3;

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
    print("response: ${planid}");
    var url = String_values.base_url + 'servicer-bill-view?sbill_id=' + planid;
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
      li = VendorBillView.fromJson(json.decode(response.body));
      vendorNameController.text = li.data.vendorName.toString();
      vendorEmailController.text = li.data.vendorEmail.toString();
      vendorPhoneController.text = li.data.vendorPhone.toString();
      vendorCityController.text = li.data.vendorDistrict.toString();
      vendorAddressController.text = li.data.vendorAddress.toString();
      vendorStateController.text = li.data.vendorState.toString();

      BillNoController.text = li.data.sbillInvno.toString();
      BillDateController.text =DateFormat('dd/MM/yyyy').format(
          DateTime.parse( li.data.sbillDate.toString()));
      BillNoteController.text = li.data.sbillPaymentStatus.toString();
      if (li.data.sbillStatus.toString() == "A")
        BillStatusController.text = "Active";
      else
        BillStatusController.text = "Pending";

      // PriceDiscountController.text="0";//+li.data.discount.toString();
      // PriceSubtotalController.text=li.data.billAmount.toString();
      // PriceTotalAmountController.text=li.data.billAmount.toString();
      // PriceTotalItemsController.text=li.data.totalItems.toString();
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
  List<PlanListClass> listplan;
  TextEditingController serviceyearcontroller = new TextEditingController();
  TextEditingController totalservicecontroller = new TextEditingController();
  TextEditingController literpricecontroller = new TextEditingController();
  TextEditingController fixedpricecontroller = new TextEditingController();
  List<PlanServiceYearClass> listplanyear;
  TextEditingController vendorNameController = new TextEditingController();
  TextEditingController vendorPhoneController = new TextEditingController();
  TextEditingController vendorCityController = new TextEditingController();
  TextEditingController stateController = new TextEditingController();
  TextEditingController districtController = new TextEditingController();
  TextEditingController vendorEmailController = new TextEditingController();
  TextEditingController vendorStateController = new TextEditingController();
  TextEditingController PropertyTypeController = new TextEditingController();
  TextEditingController vendorAddressController = new TextEditingController();

  TextEditingController BillNoController = new TextEditingController();
  TextEditingController BillNoteController = new TextEditingController();
  TextEditingController BillDateController = new TextEditingController();
  TextEditingController BillStatusController = new TextEditingController();

  TextEditingController PriceTotalAmountController =
      new TextEditingController();
  TextEditingController PriceTotalItemsController = new TextEditingController();
  TextEditingController PriceSubtotalController = new TextEditingController();
  TextEditingController PriceDiscountController = new TextEditingController();

//  TextEditingController SizeRangeControllermax = new TextEditingController();
  List<PlanListClass> selectedAvengers;
  bool sort;

  String dropdownValue = '-- Service Type --';

  String dropdownValue1 = '-- Property Type --';

  String dropdownValue2 = '-- Select Plan --';

  static List<String> friendsList = [null];

  void initState() {
    details(widget.billid);
    sort = false;
    //stateRequest();
    //  districtRequest();
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
                          "Bill Details",
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
                    padding: EdgeInsets.all(16),
                    width: width,
                    decoration: BoxDecoration(
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
                    margin: EdgeInsets.only(top: 10.0, bottom: 10),

                    child: new Text(
                      "Vendor Details",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                  ),
                  SizedBox(
                    height: height / 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Container(
                      child: new TextFormField(
                        controller: vendorNameController,
                        enabled: false,
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
                  ),
                  SizedBox(
                    height: height / 80,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Container(
                      child: new TextFormField(
                        controller: vendorEmailController,
                        enabled: false,
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
                  ),
                  SizedBox(
                    height: height / 80,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Container(
                      child: new TextFormField(
                        controller: vendorPhoneController,
                        enabled: false,
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
                  ),
                  SizedBox(
                    height: height / 80,
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  //   child: Container(
                  //     child: new TextFormField(
                  //       controller: vendorCityController,
                  //       enabled: false,
                  //       decoration: InputDecoration(
                  //         labelText: 'City',
                  //         hintStyle: TextStyle(
                  //           color: Colors.grey,
                  //           fontSize: 16.0,
                  //         ),
                  //         border: OutlineInputBorder(
                  //           borderRadius: BorderRadius.circular(5.0),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: height / 80,
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  //   child: Container(
                  //     child: new TextFormField(
                  //       controller: vendorStateController,
                  //       enabled: false,
                  //       decoration: InputDecoration(
                  //         labelText: 'State',
                  //         hintStyle: TextStyle(
                  //           color: Colors.grey,
                  //           fontSize: 16.0,
                  //         ),
                  //         border: OutlineInputBorder(
                  //           borderRadius: BorderRadius.circular(5.0),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: height / 80,
                  // ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Container(
                      child: new TextFormField(
                        minLines: 3,
                        maxLines: 10,
                        controller: vendorAddressController,
                        enabled: false,
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
                  SizedBox(
                    height: height / 40,
                  ),
                  Container(
                    padding: EdgeInsets.all(16),
                    width: width,
                    decoration: BoxDecoration(
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
                    margin: EdgeInsets.only(top: 10.0, bottom: 10),

                    child: new Text(
                      "Bill Details",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                  ),
                  SizedBox(
                    height: height / 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Container(
                      child: new TextFormField(
                        controller: BillNoController,
                        enabled: false,
                        decoration: InputDecoration(
                          labelText: 'Bill No',
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
                        controller: BillDateController,
                        enabled: false,
                        decoration: InputDecoration(
                          labelText: 'Bill Date',
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
                        controller: BillNoteController,
                        enabled: false,
                        decoration: InputDecoration(
                          labelText: 'Bill Payment Status',
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
                        controller: BillStatusController,
                        enabled: false,
                        decoration: InputDecoration(
                          labelText: 'Bill Status',
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
                  //   margin: EdgeInsets.only(top:10.0,bottom: 10),
                  //
                  //   child: new Text(
                  //     "Item Details",
                  //     textAlign: TextAlign.left,
                  //     style:
                  //     TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                  //   ),
                  // ),
                  // SingleChildScrollView(
                  //   scrollDirection: Axis.horizontal,
                  //   child: DataTable(
                  //     sortAscending: sort,
                  //     sortColumnIndex: 0,
                  //     columnSpacing: width / 20,
                  //     columns: [
                  //       DataColumn(
                  //         label: Center(
                  //             child: Wrap(
                  //               direction: Axis.vertical, //default
                  //               alignment: WrapAlignment.center,
                  //               children: [
                  //                 Text(
                  //                   "Plan Name",
                  //                   softWrap: true,
                  //                   style: TextStyle(fontSize: 12),
                  //                   textAlign: TextAlign.center,
                  //                 ),
                  //               ],
                  //             )),
                  //         numeric: false,
                  //
                  //         // onSort: (columnIndex, ascending) {
                  //         //   onSortColum(columnIndex, ascending);
                  //         //   setState(() {
                  //         //     sort = !sort;
                  //         //   });
                  //         // }
                  //       ),
                  //       DataColumn(
                  //         label: Center(
                  //             child: Wrap(
                  //               direction: Axis.vertical, //default
                  //               alignment: WrapAlignment.center,
                  //               children: [
                  //                 Text("Total Year",
                  //                     softWrap: true,
                  //                     style: TextStyle(fontSize: 12),
                  //                     textAlign: TextAlign.center),
                  //               ],
                  //             )),
                  //         numeric: false,
                  //
                  //         // onSort: (columnIndex, ascending) {
                  //         //   onSortColum(columnIndex, ascending);
                  //         //   setState(() {
                  //         //     sort = !sort;
                  //         //   });
                  //         // }
                  //       ),
                  //       DataColumn(
                  //         label: Center(
                  //             child: Wrap(
                  //               direction: Axis.vertical, //default
                  //               alignment: WrapAlignment.center,
                  //               children: [
                  //                 Text("Total Service",
                  //                     softWrap: true,
                  //                     style: TextStyle(fontSize: 12),
                  //                     textAlign: TextAlign.center),
                  //               ],
                  //             )),
                  //         numeric: false,
                  //
                  //         // onSort: (columnIndex, ascending) {
                  //         //   onSortColum(columnIndex, ascending);
                  //         //   setState(() {
                  //         //     sort = !sort;
                  //         //   });
                  //         // }
                  //       ),
                  //       DataColumn(
                  //         label: Center(
                  //             child: Wrap(
                  //               direction: Axis.vertical, //default
                  //               alignment: WrapAlignment.center,
                  //               children: [
                  //                 Text("Status",
                  //                     softWrap: true,
                  //                     style: TextStyle(fontSize: 12),
                  //                     textAlign: TextAlign.center),
                  //               ],
                  //             )),
                  //         numeric: false,
                  //
                  //         // onSort: (columnIndex, ascending) {
                  //         //   onSortColum(columnIndex, ascending);
                  //         //   setState(() {
                  //         //     sort = !sort;
                  //         //   });
                  //         // }
                  //       ),
                  //       DataColumn(
                  //         label: Center(
                  //             child: Wrap(
                  //               direction: Axis.vertical, //default
                  //               alignment: WrapAlignment.center,
                  //               children: [
                  //                 Text("Plan Price",
                  //                     softWrap: true,
                  //                     style: TextStyle(fontSize: 12),
                  //                     textAlign: TextAlign.center),
                  //               ],
                  //             )),
                  //         numeric: false,
                  //
                  //         // onSort: (columnIndex, ascending) {
                  //         //   onSortColum(columnIndex, ascending);
                  //         //   setState(() {
                  //         //     sort = !sort;
                  //         //   });
                  //         // }
                  //       ),
                  //     ],
                  //     rows: li.map(
                  //           (list) => DataRow(cells: [
                  //         DataCell(Center(
                  //             child: Center(
                  //               child: Wrap(
                  //                   direction: Axis.vertical, //default
                  //                   alignment: WrapAlignment.center,
                  //                   children: [
                  //                     Text(
                  //                       list.pplanName,
                  //                       textAlign: TextAlign.center,
                  //                     )
                  //                   ]),
                  //             ))),
                  //         DataCell(Center(
                  //             child: Center(
                  //               child: Wrap(
                  //                   direction: Axis.vertical, //default
                  //                   alignment: WrapAlignment.center,
                  //                   children: [
                  //                     Text(list.pplanYear,
                  //                         textAlign: TextAlign.center)
                  //                   ]),
                  //             ))),
                  //         DataCell(
                  //           Center(
                  //               child: Center(
                  //                   child: Wrap(
                  //                       direction: Axis.vertical, //default
                  //                       alignment: WrapAlignment.center,
                  //                       children: [
                  //                         Text(list.pplanService,
                  //                             textAlign: TextAlign.center)
                  //                       ]))),
                  //         ),
                  //         DataCell(
                  //           list.billDetailsStatus == "A"
                  //               ? Center(
                  //               child: Center(
                  //                   child: Wrap(
                  //                       direction:
                  //                       Axis.vertical, //default
                  //                       alignment: WrapAlignment.center,
                  //                       children: [
                  //                         Text("Active",
                  //                             textAlign: TextAlign.center)
                  //                       ])))
                  //               : list.billDetailsStatus == "P"
                  //               ? Center(
                  //               child: Center(
                  //                   child: Wrap(
                  //                       direction:
                  //                       Axis.vertical, //default
                  //                       alignment:
                  //                       WrapAlignment.center,
                  //                       children: [
                  //                         Text("Pending",
                  //                             textAlign: TextAlign.center)
                  //                       ])))
                  //               : Center(
                  //               child: Center(
                  //                   child: Wrap(
                  //                       direction:
                  //                       Axis.vertical, //default
                  //                       alignment:
                  //                       WrapAlignment.center,
                  //                       children: [
                  //                         Text("Complete",
                  //                             textAlign: TextAlign.center)
                  //                       ]))),
                  //         ),
                  //             DataCell(
                  //               Center(
                  //                   child: Center(
                  //                       child: Wrap(
                  //                           direction: Axis.vertical, //default
                  //                           alignment: WrapAlignment.center,
                  //                           children: [
                  //                             Text(list.pplanPrice,
                  //                                 textAlign: TextAlign.center)
                  //                           ]))),
                  //             ),
                  //       ]),
                  //     )
                  //         .toList(),
                  //   ),
                  // ),
                  SizedBox(
                    height: height / 80,
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(right:28.0),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.end,
                  //     children: [
                  //       Padding(
                  //         padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  //         child: Container(
                  //           child: new Text("Total: ${li.data.vendorGst.toString()}",style: TextStyle(color: Colors.red),
                  //
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: height / 80,
                  // ),
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
                  //     "Price Details",
                  //     textAlign: TextAlign.left,
                  //     style:
                  //     TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: height / 50,
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  //   child: Container(
                  //     child: new TextFormField(
                  //       controller: PriceTotalItemsController,
                  //       enabled: false,
                  //       decoration: InputDecoration(
                  //         labelText: 'Total items',
                  //         hintStyle: TextStyle(
                  //           color: Colors.grey,
                  //           fontSize: 16.0,
                  //         ),
                  //         border: OutlineInputBorder(
                  //           borderRadius: BorderRadius.circular(5.0),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: height / 80,
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  //   child: Container(
                  //     child: new TextFormField(
                  //       controller: PriceSubtotalController,
                  //       enabled: false,
                  //       decoration: InputDecoration(
                  //         labelText: 'Sub total',
                  //         hintStyle: TextStyle(
                  //           color: Colors.grey,
                  //           fontSize: 16.0,
                  //         ),
                  //         border: OutlineInputBorder(
                  //           borderRadius: BorderRadius.circular(5.0),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: height / 80,
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  //   child: Container(
                  //     child: new TextFormField(
                  //       controller: PriceDiscountController,
                  //       enabled: false,
                  //       decoration: InputDecoration(
                  //         labelText: 'Discount',
                  //         hintStyle: TextStyle(
                  //           color: Colors.grey,
                  //           fontSize: 16.0,
                  //         ),
                  //         border: OutlineInputBorder(
                  //           borderRadius: BorderRadius.circular(5.0),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: height / 80,
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  //   child: Container(
                  //     child: new TextFormField(
                  //       controller: PriceTotalAmountController,
                  //       enabled: false,
                  //       decoration: InputDecoration(
                  //         labelText: 'Total Amount',
                  //         hintStyle: TextStyle(
                  //           color: Colors.grey,
                  //           fontSize: 16.0,
                  //         ),
                  //         border: OutlineInputBorder(
                  //           borderRadius: BorderRadius.circular(5.0),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: height / 80,
                  // ),
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
