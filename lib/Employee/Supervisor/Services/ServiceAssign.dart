import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:io';
import 'dart:ui';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:tankcare/Customer/register.dart';
import 'package:tankcare/CustomerModels/districtlist.dart';
import 'package:tankcare/CustomerModels/servicedetail.dart';
import 'package:tankcare/Employee/Dashboard.dart';
import 'package:tankcare/Employee/EmployeeModels/Services/ServiceAssign.dart';
import 'package:tankcare/Employee/EmployeeModels/Services/ServiceAssignAcheduleDate.dart';
import 'package:tankcare/Employee/Supervisor/Services/ServiceAssignList.dart';
import 'package:tankcare/FRANCHISE/ApprovalList.dart';
import 'package:tankcare/RM%20models/appviewlist.dart';
import 'package:tankcare/Vendor/Login/Login.dart';

import '../../../VendorModels/VendorServiceDetailModel.dart';
import '../../../string_values.dart';

class ServiceAssignView extends StatefulWidget {
  ServiceAssignView({Key key, this.serviceid, this.apid});

  String serviceid;
  String apid;

  @override
  ServiceAssignViewState createState() => ServiceAssignViewState();
}

class ServiceAssignViewState extends State<ServiceAssignView> {
  bool loading = false;
  VendorServiceDetailModel li;
  List<File> files = [];
  var _kGooglePlex = CameraPosition(
    target: LatLng(0, 0),
    zoom: 14,
  );
  Future<File> _imageFile;
  RMApprovalListingsView li2;
  final dateFormatter = DateFormat('yyyy-MM-dd');
  String sql_dob;
  DistrictListings li3;
  String sql_dob_from = "";
  String sql_dob_to = "";
  TextEditingController datefromcontroller = new TextEditingController();
  TextEditingController datetocontroller = new TextEditingController();
  TextEditingController timefromcontroller = new TextEditingController();
  TextEditingController timetocontroller = new TextEditingController();
  String dropdownValue3 = '-Action-';

  num a;

  File image;

  var file;

  int servicerating = 0;
  int servicerrating = 0;
  Set<Marker> markers = Set();
  DateTime damageEndDate;

  bool damageenable = true;

  ServiceAssignModelList li4;

  GoogleMapController controller;

  var visiblemap = false;

  ScheduleDate li5;

  var scedule = false;

  var choosetime = false;

  String servicer_uid;
  String service_id;
  String station_id;

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
    var url = String_values.base_url +
        'property-plan-services-view?serviceid=' +
        planid;
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
      li = VendorServiceDetailModel.fromJson(json.decode(response.body));
      setState(() {
        // ServiceByController.text=li.planServices.se

        PropertyNameController.text = li.property.propertyName.toString();
        GroupNameController.text = li.property.groupName.toString();
        if (li.planServices.pserviceType.toString() == "RES")
          ServiceController.text = "Residential";
        else
          ServiceController.text = "Commercial";

        PropertyCodeController.text = li.property.propertyCode.toString();
        PropertyTypeController.text = li.property.propertyTypeName.toString();
        valuecontroller.text = li.property.propertyValue.toString();

        CusNameController.text = li.property.cusName.toString();
        CusCodeController.text = li.property.cusCode.toString();
        PhoneController.text = li.property.cusPhone.toString();
        GroupContactNameController.text =
            li.property.groupContactName.toString();
        GroupContactMobilController.text =
            li.property.groupContactPhone.toString();

        PlanNameController.text = li.plan.pplanName.toString();
        PlanPriceController.text = li.plan.pplanPrice.toString();
        PlanServiceController.text = li.plan.pplanService.toString();
        StartDateController.text = DateFormat('dd/MM/yyyy')
            .format(DateTime.parse(li.plan.pplanStartDate.toString()));
        TotalYearController.text = li.plan.pplanYear.toString();
        CurrStatusController.text = li.plan.pplanCurrentStatus.toString();
        ServiceStartDateController.text = DateFormat('dd/MM/yyyy')
            .format(DateTime.parse(li.planServices.pserviceDate.toString()));
        ServiceStatusController.text =
            li.planServices.pserviceServiceStatus.toString();
        if (li.planServices.pserviceStatus.toString() == "A")
          ServiceByController.text = "Active";
        else if (li.planServices.pserviceStatus.toString() == "P")
          ServiceByController.text = "Pending";
        ServiceStartAtController.text =
            li.planServices.pserviceStartAt.toString();
        ServiceEndAtController.text = li.planServices.pserviceEndAt.toString();
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

  void OnlyBottomSheet(BuildContext context, String title, String body,
      String button, String button2) {
    showModalBottomSheet(
        backgroundColor: Color.fromRGBO(0, 0, 0, 0),
        context: context,
        builder: (ctx) {
          return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                // color: ((HomeState.role == "2") ||
                //     ((HomeState.role == "3") && HomeState.userRole))
                //     ? Color.fromRGBO(251, 201, 17, 1)
                //     : Color.fromRGBO(91, 155, 213, 1),
              ),
              margin: const EdgeInsets.only(right: 10, left: 10, bottom: 60),
              height: MediaQuery.of(context).size.height * 0.15,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  (button != "" || button2 != "")
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: (button != "" && button2 != "")
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 10.0),
                                      child: FlatButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          button,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: FlatButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          button2,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        color: Colors.blueAccent,
                                      ),
                                    ),
                                  ],
                                )
                              : Center(
                                  child: FlatButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      button,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    color: Colors.grey,
                                  ),
                                ),
                        )
                      : Container()
                ],
              ));
        });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var token;
  PersistentBottomSheetController Bottomcontroller;

  void displayBottomSheet(BuildContext context, String title, String body,
      String uid, String button, String button2) {
    Bottomcontroller =
        _scaffoldKey.currentState.showBottomSheet<Null>((BuildContext context) {
      return Container(
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), color: Colors.red
              // color: ((HomeState.role == "2") ||
              //     ((HomeState.role == "3") && HomeState.userRole))
              //     ? Color.fromRGBO(251, 201, 17, 1)
              //     : Color.fromRGBO(91, 155, 213, 1),
              ),
          height: MediaQuery.of(context).size.height / 3,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                      color: Colors.white
                      // color: ((HomeState.role == "2") ||
                      //     ((HomeState.role == "3") && HomeState.userRole))
                      //     ? Color.fromRGBO(251, 201, 17, 1)
                      //     : Color.fromRGBO(91, 155, 213, 1),
                      ),
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Service Assign",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.red,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    title,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                (button != "" || button2 != "")
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: (button != "" && button2 != "")
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: FlatButton(
                                      onPressed: () {
                                        uploadImage1(uid).then((value) {
                                          final width =
                                              MediaQuery.of(context).size.width;
                                          final height = MediaQuery.of(context)
                                              .size
                                              .height;
                                          if (Bottomcontroller != null) {
                                            Bottomcontroller.close();
                                            Bottomcontroller = null;
                                          }

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
                                                      "Schedule Date",
                                                      style: TextStyle(
                                                          color: Colors.red),
                                                    ),
                                                    content:
                                                        SingleChildScrollView(
                                                      child: Column(
                                                        children: [
                                                          li5 != null
                                                              ? li5.items !=
                                                                      null
                                                                  ? SingleChildScrollView(
                                                                      scrollDirection:
                                                                          Axis.horizontal,
                                                                      child:
                                                                          DataTable(
                                                                        sortAscending:
                                                                            sort,
                                                                        sortColumnIndex:
                                                                            0,
                                                                        columnSpacing:
                                                                            width /
                                                                                20,
                                                                        columns: [
                                                                          DataColumn(
                                                                            label: Center(
                                                                                child: Wrap(
                                                                              direction: Axis.vertical, //default
                                                                              alignment: WrapAlignment.center,
                                                                              children: [
                                                                                Text(
                                                                                  "Service Code",
                                                                                  softWrap: true,
                                                                                  style: TextStyle(fontSize: 12),
                                                                                  textAlign: TextAlign.center,
                                                                                ),
                                                                              ],
                                                                            )),
                                                                            numeric:
                                                                                false,

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
                                                                                  "Schedule Start & End",
                                                                                  softWrap: true,
                                                                                  style: TextStyle(fontSize: 12),
                                                                                  textAlign: TextAlign.center,
                                                                                ),
                                                                              ],
                                                                            )),
                                                                            numeric:
                                                                                false,

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
                                                                                  "Status",
                                                                                  softWrap: true,
                                                                                  style: TextStyle(fontSize: 12),
                                                                                  textAlign: TextAlign.center,
                                                                                ),
                                                                              ],
                                                                            )),
                                                                            numeric:
                                                                                false,

                                                                            // onSort: (columnIndex, ascending) {
                                                                            //   onSortColum(columnIndex, ascending);
                                                                            //   setState(() {
                                                                            //     sort = !sort;
                                                                            //   });
                                                                            // }
                                                                          ),
                                                                        ],
                                                                        rows: li5
                                                                            .items
                                                                            .map(
                                                                              (list) => DataRow(cells: [
                                                                                DataCell(Center(
                                                                                    child: Center(
                                                                                  child: Wrap(
                                                                                      direction: Axis.vertical, //default
                                                                                      alignment: WrapAlignment.center,
                                                                                      children: [
                                                                                        Text(
                                                                                          list.pserviceCode.toString(),
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
                                                                                        Text(list.pserviceAsignStartAt != null ? "${list.pserviceAsignStartAt} & ${list.pserviceAsignEndAt}" : "-", textAlign: TextAlign.center)
                                                                                      ]),
                                                                                ))),
                                                                                DataCell(
                                                                                  Center(
                                                                                      child:
                                                                                          Center(
                                                                                              child:
                                                                                                  Wrap(
                                                                                                      direction: Axis.vertical, //default
                                                                                                      alignment: WrapAlignment.center,
                                                                                                      children: [
                                                                                        Text(list.pserviceServiceStatus.toString(), textAlign: TextAlign.center)
                                                                                      ]))),
                                                                                ),
                                                                              ]),
                                                                            )
                                                                            .toList(),
                                                                      ),
                                                                    )
                                                                  : Container()
                                                              : Container(),
                                                          Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    16),
                                                            color: Colors.red,
                                                            width:
                                                                double.infinity,
                                                            child: Text(
                                                              "Sheduled Date:${datefromcontroller.text}",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ),
                                                          Row(
                                                            children: [
                                                              Checkbox(
                                                                  value:
                                                                      scedule,
                                                                  onChanged:
                                                                      (value) {
                                                                    setState(
                                                                        () {
                                                                      scedule =
                                                                          value;
                                                                    });
                                                                  }),
                                                              Text(
                                                                  "Special Service")
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              Checkbox(
                                                                  value:
                                                                      choosetime,
                                                                  onChanged:
                                                                      (value) {
                                                                    setState(
                                                                        () {
                                                                      choosetime =
                                                                          value;
                                                                    });
                                                                  }),
                                                              Text(
                                                                  "Need to add Time"),
                                                            ],
                                                          ),
                                                          Visibility(
                                                            child: Column(
                                                              children: [
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left: 24,
                                                                      right:
                                                                          24),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Flexible(
                                                                        flex: 5,
                                                                        child:
                                                                            TextField(
                                                                          onTap:
                                                                              () async {
                                                                            FocusScope.of(context).requestFocus(new FocusNode());

                                                                            TimeOfDay
                                                                                time =
                                                                                await showTimePicker(
                                                                              initialTime: TimeOfDay.now(),
                                                                              context: context,
                                                                            );

                                                                            timefromcontroller.text = DateFormat('hh:mm a').format(DateTime(
                                                                                2019,
                                                                                08,
                                                                                1,
                                                                                time.hour,
                                                                                time.minute));
                                                                          },
                                                                          enabled:
                                                                              true,
                                                                          controller:
                                                                              timefromcontroller,
                                                                          decoration:
                                                                              InputDecoration(
                                                                            prefixIcon:
                                                                                Icon(Icons.calendar_today_outlined),
                                                                            labelText:
                                                                                'From Time',
                                                                            hintStyle:
                                                                                TextStyle(
                                                                              color: Colors.grey,
                                                                              fontSize: 16.0,
                                                                            ),
                                                                            border:
                                                                                OutlineInputBorder(
                                                                              borderRadius: BorderRadius.circular(25.0),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left: 24,
                                                                      top: 10,
                                                                      right:
                                                                          24),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Flexible(
                                                                        flex: 5,
                                                                        child:
                                                                            TextField(
                                                                                enabled:true,
                                                                          onTap:
                                                                              () async {
                                                                                FocusScope.of(context).requestFocus(new FocusNode());
                                                                                TimeOfDay
                                                                                time =
                                                                                await showTimePicker(
                                                                              initialTime: TimeOfDay.now(),
                                                                              context: context,
                                                                            );

                                                                            timetocontroller.text = DateFormat('hh:mm a').format(DateTime(
                                                                                2019,
                                                                                08,
                                                                                1,
                                                                                time.hour,
                                                                                time.minute));
                                                                          },

                                                                          controller:
                                                                              timetocontroller,
                                                                          decoration:
                                                                              InputDecoration(
                                                                            prefixIcon:
                                                                                Icon(Icons.calendar_today_outlined),
                                                                            labelText:
                                                                                'To Time',
                                                                            hintStyle:
                                                                                TextStyle(
                                                                              color: Colors.grey,
                                                                              fontSize: 16.0,
                                                                            ),
                                                                            border:
                                                                                OutlineInputBorder(
                                                                              borderRadius: BorderRadius.circular(25.0),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            visible: choosetime,
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        child: Text('OK'),
                                                        onPressed: () {
                                                          check().then((value) {
                                                            if (value) {
                                                              upload();
                                                            }
                                                          });
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
                                        });
                                      },
                                      child: Text(
                                        button,
                                        style: TextStyle(color: Colors.red),
                                      ),
                                      color: Colors.white,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: FlatButton(
                                      onPressed: () {
                                        if (Bottomcontroller != null) {
                                          Bottomcontroller.close();
                                          Bottomcontroller = null;
                                        }
                                      },
                                      child: Text(
                                        button2,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              )
                            : Center(
                                child: FlatButton(
                                  onPressed: () {
                                    if (Bottomcontroller != null) {
                                      Bottomcontroller.close();
                                      Bottomcontroller = null;
                                    }
                                  },
                                  child: Text(
                                    button,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  color: Colors.grey,
                                ),
                              ),
                      )
                    : Container()
              ],
            ),
          ));
    });
  }

  Future<int> uploadImage() async {
    setState(() {
      loading = true;
    });
    visiblemap = true;
    Map<String, String> headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer ${RegisterPagesState.token}'
    };

    var request = http.MultipartRequest(
        'POST', Uri.parse(String_values.base_url + 'get-servicer'));
    //property_id plan_id pplan_name pplan_year pplan_service pplan_price pplan_tot_price pplan_start_date
    request.headers.addAll(headers);
    request.fields['servicer_utype'] = dropdownValue.toUpperCase();
    request.fields['service_date'] = sql_dob_from;
    var response = await request.send();
    response.stream.transform(utf8.decoder).listen((value) async {
      setState(() {
        loading = false;
      });
      li4 = ServiceAssignModelList.fromJson(json.decode(value));
      controller = await _controller.future;
      _kGooglePlex = CameraPosition(
          // bearing: 192.8334901395799,
          target: LatLng(double.parse(li4.tariff[0].latitude),
              double.parse(li4.tariff[0].longitude)),
          zoom: 6);
      controller.moveCamera(CameraUpdate.newCameraPosition(_kGooglePlex));

      setState(() {
        markers.clear();

        markers.addAll([
          for (int i = 0; i < li4.tariff.length; i++)
            Marker(
                markerId: MarkerId(li4.tariff[i].stationName),
                onTap: () {
                  servicer_uid = li4.tariff[i].assignUid;
                  service_id = widget.serviceid;

                  station_id = li4.tariff[i].stationId;
                  displayBottomSheet(
                      context,
                      "Station Name: ${li4.tariff[i].stationName}\nVendor Name: ${li4.tariff[i].assignby}\nMobile: ${li4.tariff[i].phone}\nAddress: \n${li4.tariff[i].mapLocation}\n",
                      "body",
                      li4.tariff[i].assignUid,
                      "Assign",
                      "Cancel");
                },
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueRed),
                position: LatLng(double.parse(li4.tariff[i].latitude),
                    double.parse(li4.tariff[i].longitude))),
        ]);

        print(value);
      });
    });
  }

  Future<int> uploadImage1(uid) async {
    setState(() {
      loading = true;
    });
    visiblemap = true;
    Map<String, String> headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer ${RegisterPagesState.token}'
    };

    var request = http.MultipartRequest(
        'POST', Uri.parse(String_values.base_url + 'get-servicer-schedule'));
    //property_id plan_id pplan_name pplan_year pplan_service pplan_price pplan_tot_price pplan_start_date
    request.headers.addAll(headers);
    request.fields['servicer_utype'] = dropdownValue.toUpperCase();
    request.fields['service_date'] = sql_dob_from;
    request.fields['servicer_uid'] = uid;
    var response = await request.send();
    response.stream.transform(utf8.decoder).listen((value) async {
      li5 = ScheduleDate.fromJson(json.decode(value));
      setState(() {
        loading = false;
      });
    });
  }

  Future<int> upload() async {
    setState(() {
      loading = true;
    });
    visiblemap = true;
    Map<String, String> headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer ${RegisterPagesState.token}'
    };

    var request = http.MultipartRequest(
        'POST', Uri.parse(String_values.base_url + 'service-assign'));
    //property_id plan_id pplan_name pplan_year pplan_service pplan_price pplan_tot_price pplan_start_date
    request.headers.addAll(headers);
    request.fields['servicer_utype'] = dropdownValue.toUpperCase();
    request.fields['service_date'] = sql_dob_from;
    request.fields['servicer_uid'] = servicer_uid;
    request.fields['service_id'] = service_id;
    if (choosetime) {
      request.fields['asign_start_at'] = timefromcontroller.text;
      request.fields['asign_end_at'] = timetocontroller.text;
    }
    request.fields['station_id'] = station_id;
    if (scedule) request.fields['special_service'] = "Y";
    var response = await request.send();
    response.stream.transform(utf8.decoder).listen((value) async {
      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => ServiceAssignList()));
      print(value);
      setState(() {
        loading = false;
      });
    });
  }

  Future<http.Response> apprdetails(planid) async {
    setState(() {
      loading = true;
    });
    var url = String_values.base_url + 'ap-verify-list/' + planid;
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
      li2 = RMApprovalListingsView.fromJson(json.decode(response.body));

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

    var url = String_values.base_url + 'state-list?page=1&limit=50';
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
        li2 = RMApprovalListingsView.fromJson(json.decode(response.body));
        // stateController.text=li2.items[int.parse(li.stateId)-1].stateName;
      });
      // for(int i=0;i<li.items.length;i++)
      //   stringlist.add(li.items[i].stateName);
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

  Future<http.Response> districtRequest() async {
    setState(() {
      loading = true;
    });

    var url = String_values.base_url + 'district-list';
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
        li3 = DistrictListings.fromJson(json.decode(response.body));
        // districtController.text=li3.items[int.parse(li.districtId)-1].districtName;
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
  List<PlanListClass> listplan;
  TextEditingController StatusController = new TextEditingController();
  TextEditingController ServiceStatusController = new TextEditingController();
  TextEditingController ServiceStartDateController =
      new TextEditingController();
  TextEditingController datecontroller = new TextEditingController();
  TextEditingController ServiceByController = new TextEditingController();
  TextEditingController ComplaintController = new TextEditingController();
  TextEditingController DamageController = new TextEditingController();
  TextEditingController ServiceController = new TextEditingController();
  TextEditingController PlanPaidStatusController = new TextEditingController();
  TextEditingController PlanCurrentStatusController =
      new TextEditingController();

  TextEditingController PlanNameController = new TextEditingController();
  TextEditingController PlanPriceController = new TextEditingController();
  TextEditingController PlanServiceController = new TextEditingController();
  TextEditingController StartDateController = new TextEditingController();
  TextEditingController TotalYearController = new TextEditingController();
  TextEditingController CurrStatusController = new TextEditingController();

  TextEditingController PropertyCodeController = new TextEditingController();
  TextEditingController FeedBackController = new TextEditingController();
  TextEditingController PropertyNameController = new TextEditingController();
  TextEditingController valuecontroller = new TextEditingController();
  TextEditingController CusNameController = new TextEditingController();
  TextEditingController PhoneController = new TextEditingController();
  List<PlanServiceYearClass> listplanyear;
  TextEditingController GroupContactNameController =
      new TextEditingController();
  TextEditingController GroupNameController = new TextEditingController();
  Completer<GoogleMapController> _controller = Completer();
  TextEditingController GroupContactMobileController =
      new TextEditingController();
  TextEditingController GroupContactMobilController =
      new TextEditingController();
  TextEditingController TotalServicesController = new TextEditingController();
  TextEditingController GroupCodeController = new TextEditingController();
  TextEditingController servicetypeController = new TextEditingController();
  TextEditingController PropertyTypeController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();
  TextEditingController statusController = new TextEditingController();
  TextEditingController CusCodeController = new TextEditingController();
  TextEditingController ServiceStartAtController = new TextEditingController();
  TextEditingController ServiceEndAtController = new TextEditingController();

//  TextEditingController SizeRangeControllermax = new TextEditingController();
  List<PlanListClass> selectedAvengers;
  bool sort;

  String dropdownValue = '- Service Type -';

  String dropdownValue1 = '-- Property Type --';

  String dropdownValue2 = '-- Select Plan --';

  static List<String> friendsList = [null];

  void initState() {
    details(widget.serviceid);
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
      key: _scaffoldKey,
      //backgroundColor: Colors.redAccent[100],
      body: loading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: new Column(
                children: <Widget>[
                  Container(
                      margin: const EdgeInsets.only(top: 10),
                      color: Colors.red.shade50,
                      child: ExpansionTile(
                          backgroundColor: Colors.white,
                          title: Text(
                            "Service details",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, color: Colors.red),
                          ),
                          initiallyExpanded: false,
                          children: [
                            SizedBox(
                              height: height / 50,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
                              child: new TextField(
                                enabled: false,
                                controller: ServiceStartDateController,
                                decoration: InputDecoration(
                                  labelText: 'Service Start Date',
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
                                controller: ServiceStatusController,
                                decoration: InputDecoration(
                                  labelText: 'Service Status',
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
                                controller: ServiceByController,
                                decoration: InputDecoration(
                                  labelText: 'Status',
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
                          ])),

                  Container(
                      margin: const EdgeInsets.only(top: 10),
                      color: Colors.red.shade50,
                      child: ExpansionTile(
                          backgroundColor: Colors.white,
                          title: Text(
                            "Property details",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, color: Colors.red),
                          ),
                          initiallyExpanded: false,
                          children: [
                            SizedBox(
                              height: height / 50,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
                              child: new TextField(
                                enabled: false,
                                controller: PropertyNameController,
                                decoration: InputDecoration(
                                  labelText: 'Property Name',
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
                                controller: GroupNameController,
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
                            SizedBox(
                              height: height / 50,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
                              child: new TextField(
                                enabled: false,
                                controller: PropertyCodeController,
                                decoration: InputDecoration(
                                  labelText: 'Property Code',
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
                                controller: PropertyTypeController,
                                decoration: InputDecoration(
                                  labelText: 'Property Type',
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
                              child: new TextFormField(
                                enabled: false,
                                controller: valuecontroller,
                                decoration: InputDecoration(
                                  labelText: 'Property Value',
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
                              child: new TextFormField(
                                enabled: false,
                                controller: ServiceController,
                                decoration: InputDecoration(
                                  labelText: 'Service Type',
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
                          ])),
                  // Container(
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(5.0),
                  //     color: Colors.white,
                  //     boxShadow: [
                  //       BoxShadow(
                  //         color: Colors.grey,
                  //         offset: Offset(0.0, 1.0), //(x,y)
                  //         blurRadius: 2.0,
                  //       ),
                  //     ],
                  //   ),
                  //   // color: Colors.white,
                  //   margin: EdgeInsets.all(3.0),
                  //   child: Center(
                  //     child: Padding(
                  //       padding: const EdgeInsets.all(16.0),
                  //       child: Row(
                  //         mainAxisAlignment: MainAxisAlignment.start,
                  //         children: [
                  //           new Text(
                  //             "Photos",
                  //             textAlign: TextAlign.left,
                  //             style: TextStyle(
                  //                 fontWeight: FontWeight.bold,
                  //                 color: Colors.red,
                  //                 fontSize: 14),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // for(int i=0;i<json.decode(li.propertyImages).length;i++)
                  //   Padding(
                  //     padding: const EdgeInsets.all(18.0),
                  //     child: Container(
                  //         width:width/2,
                  //         child: Image.network(json.decode(li.propertyImages)[i])),
                  //   ),
                  Container(
                      margin: const EdgeInsets.only(top: 10),
                      color: Colors.red.shade50,
                      child: ExpansionTile(
                          backgroundColor: Colors.white,
                          title: Text(
                            "Customer details",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, color: Colors.red),
                          ),
                          initiallyExpanded: false,
                          children: [
                            SizedBox(
                              height: height / 50,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
                              child: new TextField(
                                enabled: false,
                                controller: CusNameController,
                                decoration: InputDecoration(
                                  labelText: 'Customer Name',
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
                                controller: CusCodeController,
                                decoration: InputDecoration(
                                  labelText: 'Customer Code',
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
                                controller: PhoneController,
                                decoration: InputDecoration(
                                  labelText: 'Contact Mobile',
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
                            SizedBox(
                              height: height / 50,
                            ),
                          ])),
                  Container(
                      margin: const EdgeInsets.only(top: 10),
                      color: Colors.red.shade50,
                      child: ExpansionTile(
                          backgroundColor: Colors.white,
                          title: Text(
                            "Plan details",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, color: Colors.red),
                          ),
                          initiallyExpanded: false,
                          children: [
                            SizedBox(
                              height: height / 50,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
                              child: new TextField(
                                enabled: false,
                                controller: PlanNameController,
                                decoration: InputDecoration(
                                  labelText: 'Plan Name',
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
                                controller: PlanPriceController,
                                decoration: InputDecoration(
                                  labelText: 'Plan Price',
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
                                controller: PlanServiceController,
                                decoration: InputDecoration(
                                  labelText: 'Plan Service',
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
                                controller: StartDateController,
                                decoration: InputDecoration(
                                  labelText: 'Start Date',
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
                                controller: TotalYearController,
                                decoration: InputDecoration(
                                  labelText: 'Total Year',
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
                                controller: CurrStatusController,
                                decoration: InputDecoration(
                                  labelText: 'Current Status',
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
                          ])),
                  Container(
                      margin: const EdgeInsets.only(top: 10),
                      color: Colors.red.shade50,
                      child: ExpansionTile(
                          backgroundColor: Colors.white,
                          title: Text(
                            "Assign details",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, color: Colors.red),
                          ),
                          initiallyExpanded: true,
                          children: [
                            SizedBox(
                              height: height / 50,
                            ),
                            Container(
                              margin:
                                  const EdgeInsets.only(left: 24, right: 24),
                              padding: const EdgeInsets.only(
                                  left: 20.0, right: 10.0),
                              decoration: new BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(2.0)),
                                  border:
                                      new Border.all(color: Colors.black38)),
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
                                    '- Service Type -',
                                    "Vendor",
                                    "Supervisor"
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
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
                              padding:
                                  const EdgeInsets.only(left: 24, right: 24),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                            firstDate: DateTime.now().subtract(
                                                new Duration(days: 23725)),
                                            lastDate: DateTime.now()
                                                .add(new Duration(days: 365)));
                                        /*    var time =await showTimePicker(
                              initialTime: TimeOfDay.now(),
                              context: context,
                            );*/
                                        sql_dob_from =
                                            dateFormatter.format(date);
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
                                        labelText: 'Assign Date',
                                        hintStyle: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 16.0,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(25.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                                margin: EdgeInsets.only(
                                    left: 24, right: 24, top: 24),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50))),
                                child: FlatButton(
                                  onPressed: () {
                                    if (dropdownValue != '- Service Type -' &&
                                        datefromcontroller.text.length != 0) {
                                      uploadImage();
                                      setState(() {
                                        visiblemap = true;
                                      });
                                    } else {
                                      if (dropdownValue == '- Service Type -')
                                        showDialog<void>(
                                          context: context,
                                          barrierDismissible: false,
                                          // user must tap button!
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text(
                                                  "Please Choose Service Type"),
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
                                      else
                                        showDialog<void>(
                                          context: context,
                                          barrierDismissible: false,
                                          // user must tap button!
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text("Please Choose Date"),
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
                                  child: Container(
                                    child: Text(
                                      "Search",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                )),
                            SizedBox(
                              height: height / 50,
                            ),
                            Visibility(
                              visible: visiblemap,
                              child: Container(
                                padding:
                                    const EdgeInsets.only(left: 16, right: 16),
                                height: height / 2,
                                child: GoogleMap(
                                  gestureRecognizers: {
                                    Factory<OneSequenceGestureRecognizer>(
                                      () => EagerGestureRecognizer(),
                                    ),
                                  },
                                  zoomControlsEnabled: true,
                                  mapType: MapType.normal,
                                  markers: markers,
                                  initialCameraPosition: _kGooglePlex,
                                  onMapCreated:
                                      (GoogleMapController controller) {
                                    _controller.complete(controller);
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              height: height / 50,
                            ),
                            Visibility(
                              visible: visiblemap,
                              child: li4 != null
                                  ? SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: DataTable(
                                        sortAscending: sort,
                                        sortColumnIndex: 0,
                                        columnSpacing: width / 20,
                                        columns: [
                                          DataColumn(
                                            label: Center(
                                                child: Wrap(
                                              direction:
                                                  Axis.vertical, //default
                                              alignment: WrapAlignment.center,
                                              children: [
                                                Text(
                                                  "Assign By",
                                                  softWrap: true,
                                                  style:
                                                      TextStyle(fontSize: 12),
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
                                              direction:
                                                  Axis.vertical, //default
                                              alignment: WrapAlignment.center,
                                              children: [
                                                Text(
                                                  "Station Name",
                                                  softWrap: true,
                                                  style:
                                                      TextStyle(fontSize: 12),
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
                                              direction:
                                                  Axis.vertical, //default
                                              alignment: WrapAlignment.center,
                                              children: [
                                                Text(
                                                  "Phone Number",
                                                  softWrap: true,
                                                  style:
                                                      TextStyle(fontSize: 12),
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
                                              direction:
                                                  Axis.vertical, //default
                                              alignment: WrapAlignment.center,
                                              children: [
                                                Text("Service Count",
                                                    softWrap: true,
                                                    style:
                                                        TextStyle(fontSize: 12),
                                                    textAlign:
                                                        TextAlign.center),
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
                                              direction:
                                                  Axis.vertical, //default
                                              alignment: WrapAlignment.center,
                                              children: [
                                                Text("Action",
                                                    softWrap: true,
                                                    style:
                                                        TextStyle(fontSize: 12),
                                                    textAlign:
                                                        TextAlign.center),
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
                                        rows: li4.tariff
                                            .map(
                                              (list) => DataRow(cells: [
                                                DataCell(Center(
                                                    child: Center(
                                                  child: Wrap(
                                                      direction: Axis
                                                          .vertical, //default
                                                      alignment:
                                                          WrapAlignment.center,
                                                      children: [
                                                        Text(
                                                          list.assignby,
                                                          textAlign:
                                                              TextAlign.center,
                                                        )
                                                      ]),
                                                ))),
                                                DataCell(Center(
                                                    child: Center(
                                                  child: Wrap(
                                                      direction: Axis
                                                          .vertical, //default
                                                      alignment:
                                                          WrapAlignment.center,
                                                      children: [
                                                        Text(list.stationName,
                                                            textAlign: TextAlign
                                                                .center)
                                                      ]),
                                                ))),
                                                DataCell(
                                                  Center(
                                                      child: Center(
                                                          child: Wrap(
                                                              direction: Axis
                                                                  .vertical, //default
                                                              alignment: WrapAlignment.center,
                                                              children: [
                                                        Text(list.phone,
                                                            textAlign: TextAlign
                                                                .center)
                                                      ]))),
                                                ),
                                                DataCell(
                                                  Container(
                                                    margin: EdgeInsets.all(5),
                                                    color:list
                                                        .serviceCount <=
                                                        5
                                                        ? Colors
                                                        .green
                                                        : (list.serviceCount >
                                                        5) &&
                                                        (list.serviceCount <=
                                                            10)
                                                        ? Colors
                                                        .yellow.shade700
                                                        : Colors
                                                        .red,
                                                    child: Center(
                                                        child: Wrap(
                                                            direction: Axis
                                                                .vertical, //default
                                                            alignment:
                                                                WrapAlignment
                                                                    .center,
                                                            children: [
                                                      Text(
                                                          list.serviceCount
                                                              .toString(),
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800,
                                                              color: Colors
                                                                  .white,
                                                              ),
                                                          textAlign: TextAlign
                                                              .center)
                                                    ])),
                                                  ),
                                                ),
                                                DataCell(
                                                  Center(
                                                    child: FlatButton(
                                                      child: Text("Assign"),
                                                      color: Colors.red,
                                                      onPressed: () {
                                                        servicer_uid =
                                                            list.assignUid;
                                                        service_id =
                                                            widget.serviceid;

                                                        station_id =
                                                            list.stationId;
                                                        uploadImage1(
                                                                list.assignUid)
                                                            .then((value) {
                                                          final width =
                                                              MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width;
                                                          final height =
                                                              MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height;

                                                          showDialog<void>(
                                                              context: context,
                                                              barrierDismissible:
                                                                  false, // user must tap button!
                                                              builder:
                                                                  (context) {
                                                                return StatefulBuilder(
                                                                    builder: (context,
                                                                        StateSetter
                                                                            setState) {
                                                                  return AlertDialog(
                                                                    title: Text(
                                                                      "Schedule Date",
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.red),
                                                                    ),
                                                                    content:
                                                                        SingleChildScrollView(
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          li5 != null
                                                                              ? li5.items != null
                                                                                  ? SingleChildScrollView(
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
                                                                                                  "Service Code",
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
                                                                                                  "Schedule Start & End",
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
                                                                                                  "Status",
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
                                                                                        ],
                                                                                        rows: li5.items
                                                                                            .map(
                                                                                              (list) => DataRow(cells: [
                                                                                                DataCell(Center(
                                                                                                    child: Center(
                                                                                                  child: Wrap(
                                                                                                      direction: Axis.vertical, //default
                                                                                                      alignment: WrapAlignment.center,
                                                                                                      children: [
                                                                                                        Text(
                                                                                                          list.pserviceCode.toString(),
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
                                                                                                        Text(list.pserviceAsignStartAt != null ? "${list.pserviceAsignStartAt} & ${list.pserviceAsignEndAt}" : "-", textAlign: TextAlign.center)
                                                                                                      ]),
                                                                                                ))),
                                                                                                DataCell(
                                                                                                  Center(
                                                                                                      child: Center(
                                                                                                          child: Wrap(
                                                                                                              direction: Axis.vertical, //default
                                                                                                              alignment: WrapAlignment.center,
                                                                                                              children: [Text(list.pserviceServiceStatus.toString(), textAlign: TextAlign.center)]))),
                                                                                                ),
                                                                                              ]),
                                                                                            )
                                                                                            .toList(),
                                                                                      ),
                                                                                    )
                                                                                  : Container()
                                                                              : Container(),
                                                                          Container(
                                                                            padding:
                                                                                EdgeInsets.all(16),
                                                                            color:
                                                                                Colors.red,
                                                                            width:
                                                                                double.infinity,
                                                                            child:
                                                                                Text(
                                                                              "Sheduled Date:${datefromcontroller.text}",
                                                                              style: TextStyle(color: Colors.white),
                                                                            ),
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              Checkbox(
                                                                                  value: scedule,
                                                                                  onChanged: (value) {
                                                                                    setState(() {
                                                                                      scedule = value;
                                                                                    });
                                                                                  }),
                                                                              Text("Special Service")
                                                                            ],
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              Checkbox(
                                                                                  value: choosetime,
                                                                                  onChanged: (value) {
                                                                                    setState(() {
                                                                                      choosetime = value;
                                                                                    });
                                                                                  }),
                                                                              Text("Need to add Time"),
                                                                            ],
                                                                          ),
                                                                          Visibility(
                                                                            child:
                                                                                Column(
                                                                              children: [
                                                                                Padding(
                                                                                  padding: const EdgeInsets.only(left: 24, right: 24),
                                                                                  child: Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                    children: [
                                                                                      Flexible(
                                                                                        flex: 5,
                                                                                        child: TextField(
                                                                                          onTap: () async {
                                                                                            FocusScope.of(context).requestFocus(new FocusNode());

                                                                                            TimeOfDay time = await showTimePicker(
                                                                                              initialTime: TimeOfDay.now(),
                                                                                              context: context,
                                                                                            );

                                                                                            timefromcontroller.text = DateFormat('hh:mm a').format(DateTime(2019, 08, 1, time.hour, time.minute));
                                                                                          },
                                                                                          enabled: true,
                                                                                          controller: timefromcontroller,
                                                                                          decoration: InputDecoration(
                                                                                            prefixIcon: Icon(Icons.calendar_today_outlined),
                                                                                            labelText: 'From Time',
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
                                                                                Padding(
                                                                                  padding: const EdgeInsets.only(left: 24, top: 10, right: 24),
                                                                                  child: Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                    children: [
                                                                                      Flexible(
                                                                                        flex: 5,
                                                                                        child: TextField(
                                                                                          onTap: () async {
                                                                                            FocusScope.of(context).requestFocus(new FocusNode());
                                                                                            TimeOfDay time = await showTimePicker(
                                                                                              initialTime: TimeOfDay.now(),
                                                                                              context: context,
                                                                                            );

                                                                                            timetocontroller.text = DateFormat('hh:mm a').format(DateTime(2019, 08, 1, time.hour, time.minute));
                                                                                          },
                                                                                          enabled: true,
                                                                                          controller: timetocontroller,
                                                                                          decoration: InputDecoration(
                                                                                            prefixIcon: Icon(Icons.calendar_today_outlined),
                                                                                            labelText: 'To Time',
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
                                                                              ],
                                                                            ),
                                                                            visible:
                                                                                choosetime,
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    actions: [
                                                                      TextButton(
                                                                        child: Text(
                                                                            'OK'),
                                                                        onPressed:
                                                                            () {
                                                                          check()
                                                                              .then((value) {
                                                                            if (value) {
                                                                              upload();
                                                                            }
                                                                          });
                                                                        },
                                                                      ),
                                                                      TextButton(
                                                                        child: Text(
                                                                            'Cancel'),
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        },
                                                                      ),
                                                                    ],
                                                                  );
                                                                });
                                                              });
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                )
                                              ]),
                                            )
                                            .toList(),
                                      ),
                                    )
                                  : Container(),
                            ),
                          ])),
                ],
              ),
            ),

      appBar: AppBar(
        title: Image.asset('logotitle.png', height: 40),
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () {
      //     Navigator.pushAndRemoveUntil(
      //       context,
      //       MaterialPageRoute(
      //           builder: (context) => EmployeeDashboard(firsttime: false)),
      //       (Route<dynamic> route) => false,
      //     );
      //   },
      //   icon: Icon(Icons.dashboard_outlined),
      //   label: Text('Dashboard'),
      //   backgroundColor: Colors.red,
      // ),
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

  _onAddImageClick() async {
    image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) return image;

    // print("Uploaded Image: $_imageFile");
    // _imageFile.then((file) async {
    //   return file;
    // setState(() {
    //   files.add(file);
    //
    // });
    // });
  }

  getFileImage(file) {}
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
