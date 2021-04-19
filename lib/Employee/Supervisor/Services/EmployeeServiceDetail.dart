import 'dart:async';
import 'dart:convert';
import 'dart:io';
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
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:tankcare/Customer/register.dart';
import 'package:tankcare/CustomerModels/districtlist.dart';
import 'package:tankcare/Employee/Dashboard.dart';
import 'package:tankcare/VendorModels/APApproval.dart';
import 'package:tankcare/VendorModels/VendorServiceDetailModel.dart';
import 'package:tankcare/string_values.dart';

class EmployeeServiceDetail extends StatefulWidget {
  EmployeeServiceDetail({Key key, this.serviceid});

  String serviceid;

  @override
  EmployeeServiceDetailState createState() => EmployeeServiceDetailState();
}

class EmployeeServiceDetailState extends State<EmployeeServiceDetail> {
  bool loading = false;
  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
  DateTime starttime;
  DateTime endtime;
  VendorServiceDetailModel li;
  List<File> files = [];
  List<File> files1 = [];
  List<String> beforeimages = List<String>();
  List<String> afterimages = List<String>();
  var _kGooglePlex;
  Future<File> _imageFile;

  DistrictListings li3;

  var plusmarkvisible = true;

  var imagedeletevisible = true;

  var plusmarkendvisible = true;

  var imagedeleteendvisible = true;

  int hour;
  String amrpm;

  File image;
  APDetails li2;

  Future<http.Response> approval(planid) async {
    setState(() {
      loading = true;
    });
    var url =
        String_values.base_url + 'ap-verify-details/' + planid + '/property';
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
      li2 = APDetails.fromJson(json.decode(response.body));
      setState(() {
        // ServiceByController.text=li.planServices.se
        //
        // DamageCodeController.text=li4.items.damageCode;
        // DamageStatusController.text=li4.items.damageStatus;
        // DamageNoteController.text=li4.items.damageNote;
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

  Future<http.Response> startupload() async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer ${RegisterPagesState.token}'
    };

    var request = http.MultipartRequest(
        'POST', Uri.parse(String_values.base_url + 'service-process'));

    for (int i = 0; i < beforeimages.length; i++) {
      print(beforeimages[i]);
      print(beforeimages.length);
      request.files.add(
          await http.MultipartFile.fromPath('start_upimgs[]', beforeimages[i]));
    }
    request.headers.addAll(headers);
    request.fields['process_type'] = "start";
    request.fields['service_id'] = widget.serviceid.toString();
    request.fields['otp'] = StartOTPController.text;
    var res = await request.send();
    print("Result: ${res.statusCode} ");
    files.clear();
  }

  Future<http.Response> endupload() async {
    print(afterimages);
    Map<String, String> headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer ${RegisterPagesState.token}'
    };

    var request = http.MultipartRequest(
        'POST', Uri.parse(String_values.base_url + 'service-process'));
    for (int i = 0; i < afterimages.length; i++) {
      print(afterimages);
      request.files.add(
          await http.MultipartFile.fromPath('end_upimgs[]', afterimages[i]));
    }
    request.headers.addAll(headers);
    request.fields['process_type'] = "end";
    request.fields['service_id'] = widget.serviceid.toString();
    request.fields['otp'] = EndOTPController.text;
    var res = await request.send();
    print("Result: ${res.statusCode} ");
    files1.clear();
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

  Future<http.Response> details(planid) async {
    setState(() {
      loading = true;
    });
    var url = String_values.base_url +
        'property-plan-services-view/?serviceid=' +
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

      // ServiceByController.text=li.planServices.se
      ServiceStartDateController.text = DateFormat.yMd().format(DateTime.parse(li.planServices.pserviceDate.toString()));

      ServiceStatusController.text =
          li.planServices.pserviceServiceStatus.toString();

      if (li.planServices.pserviceStatus.toString() == "A")
        StatusController.text = "Active";
      else if (li.planServices.pserviceStatus.toString() == "P")
        StatusController.text = "Pending";

      PropertyNameController.text = li.property.propertyName.toString();
      GroupNameController.text = li.property.groupName.toString();
      if (li.property.serviceType.toString() == "RES")
        ServiceController.text = "Residential";
      else
        ServiceController.text = "Commercial";
      PropertyCodeController.text = li.property.propertyCode.toString();
      PropertyTypeController.text = li.property.propertyTypeName.toString();
      valuecontroller.text = li.property.propertyValue.toString();

      PlanController.text = li.plan.pplanName.toString();
      PlanYearController.text = li.plan.pplanYear.toString();
      PlanServiceController.text = li.plan.pplanService.toString();
      priceController.text = li.plan.pplanPrice.toString();
      datecontroller.text = li.plan.pplanStartDate.toString();
      PlanCurrentStatusController.text = li.plan.pplanCurrentStatus.toString();

      if (li.planServices.pserviceServiceStatus.toString() == "COMPLETED") {
        setState(() {
          starttime = dateFormat.parse(li.planServices.pserviceStartAt);
          var month = starttime.month.toString();
          if (starttime.month == 1)
            month = 'January';
          else if (starttime.month == 2)
            month = 'February';
          else if (starttime.month == 3)
            month = 'March';
          else if (starttime.month == 4)
            month = 'April';
          else if (starttime.month == 5)
            month = 'May';
          else if (starttime.month == 6)
            month = 'June';
          else if (starttime.month == 7)
            month = 'July';
          else if (starttime.month == 8)
            month = 'August';
          else if (starttime.month == 9)
            month = 'September';
          else if (starttime.month == 10)
            month = 'October';
          else if (starttime.month == 11)
            month = 'November';
          else if (starttime.month == 12) month = 'December';
          convert(starttime);

          if (starttime.day == 1 ||
              starttime.day == 21 ||
              starttime.day == 31) {
            starttimecontroller.text = starttime.day.toString() +
                'st ' +
                month +
                ', ' +
                starttime.year.toString() +
                ' , ' +
                hour.toString() +
                ":" +
                starttime.minute.toString() +
                " " +
                amrpm;
          } else if (starttime.day == 2 || starttime.day == 22) {
            starttimecontroller.text = starttime.day.toString() +
                'nd ' +
                month +
                ', ' +
                starttime.year.toString() +
                ' , ' +
                hour.toString() +
                ":" +
                starttime.minute.toString() +
                " " +
                amrpm;
          } else if (starttime.day == 3 || starttime.day == 23) {
            starttimecontroller.text = starttime.day.toString() +
                'rd ' +
                month +
                ', ' +
                starttime.year.toString() +
                ' , ' +
                hour.toString() +
                ":" +
                starttime.minute.toString() +
                " " +
                amrpm;
          } else {
            starttimecontroller.text = starttime.day.toString() +
                'th ' +
                month +
                ', ' +
                starttime.year.toString() +
                ' , ' +
                hour.toString() +
                ":" +
                starttime.minute.toString() +
                " " +
                amrpm;
          }

          endtime = dateFormat.parse(li.planServices.pserviceEndAt);
          month = endtime.month.toString();
          if (endtime.month == 1)
            month = 'January';
          else if (endtime.month == 2)
            month = 'February';
          else if (endtime.month == 3)
            month = 'March';
          else if (endtime.month == 4)
            month = 'April';
          else if (endtime.month == 5)
            month = 'May';
          else if (endtime.month == 6)
            month = 'June';
          else if (endtime.month == 7)
            month = 'July';
          else if (endtime.month == 8)
            month = 'August';
          else if (endtime.month == 9)
            month = 'September';
          else if (endtime.month == 10)
            month = 'October';
          else if (endtime.month == 11)
            month = 'November';
          else if (endtime.month == 12) month = 'December';
          convert(endtime);

          if (endtime.day == 1 || endtime.day == 21 || endtime.day == 31) {
            endtimecontroller.text = endtime.day.toString() +
                'st ' +
                month +
                ', ' +
                endtime.year.toString() +
                ' , ' +
                hour.toString() +
                ":" +
                endtime.minute.toString() +
                " " +
                amrpm;
          } else if (endtime.day == 2 || endtime.day == 22) {
            endtimecontroller.text = endtime.day.toString() +
                'nd ' +
                month +
                ', ' +
                endtime.year.toString() +
                ' , ' +
                hour.toString() +
                ":" +
                endtime.minute.toString() +
                " " +
                amrpm;
          } else if (endtime.day == 3 || endtime.day == 23) {
            endtimecontroller.text = endtime.day.toString() +
                'rd ' +
                month +
                ', ' +
                endtime.year.toString() +
                ' , ' +
                hour.toString() +
                ":" +
                endtime.minute.toString() +
                " " +
                amrpm;
          } else {
            endtimecontroller.text = endtime.day.toString() +
                'th ' +
                month +
                ', ' +
                endtime.year.toString() +
                ' , ' +
                hour.toString() +
                ":" +
                endtime.minute.toString() +
                " " +
                amrpm;
          }

          plusmarkvisible = false;
          imagedeletevisible = false;
          plusmarkendvisible = false;
          imagedeleteendvisible = false;
        });
        // for(int i=0;i<json.decode(li.planServices.pserviceBeforeImg).length;i++)
        //   beforeimages.add(json.decode(li.planServices.pserviceBeforeImg)[i].toString());
        //
        // for (var url in beforeimages) {
        //   try {
        //
        //     var imageId = await ImageDownloader.downloadImage(url);
        //     var path = await ImageDownloader.findPath(imageId);
        //     setState(() {
        //       files.add(File(path));
        //     });
        //
        //   } catch (error) {
        //     print(error);
        //   }
        // }
        // for(int i=0;i<json.decode(li.planServices.pserviceAfterImg).length;i++)
        //   afterimages.add(json.decode(li.planServices.pserviceAfterImg)[i].toString());
        //
        // for (var url in afterimages) {
        //   try {
        //
        //     var imageId = await ImageDownloader.downloadImage(url);
        //     var path = await ImageDownloader.findPath(imageId);
        //     setState(() {
        //       files1.add(File(path));
        //     });
        //
        //   } catch (error) {
        //     print(error);
        //   }
        // }
      } else if (li.planServices.pserviceServiceStatus.toString() ==
          "ONGOING") {
        setState(() {
          starttime = dateFormat.parse(li.planServices.pserviceStartAt);
          var month = starttime.month.toString();
          if (starttime.month == 1)
            month = 'January';
          else if (starttime.month == 2)
            month = 'February';
          else if (starttime.month == 3)
            month = 'March';
          else if (starttime.month == 4)
            month = 'April';
          else if (starttime.month == 5)
            month = 'May';
          else if (starttime.month == 6)
            month = 'June';
          else if (starttime.month == 7)
            month = 'July';
          else if (starttime.month == 8)
            month = 'August';
          else if (starttime.month == 9)
            month = 'September';
          else if (starttime.month == 10)
            month = 'October';
          else if (starttime.month == 11)
            month = 'November';
          else if (starttime.month == 12) month = 'December';
          convert(starttime);

          if (starttime.day == 1 ||
              starttime.day == 21 ||
              starttime.day == 31) {
            starttimecontroller.text = starttime.day.toString() +
                'st ' +
                month +
                ', ' +
                starttime.year.toString() +
                ' , ' +
                hour.toString() +
                ":" +
                starttime.minute.toString() +
                " " +
                amrpm;
          } else if (starttime.day == 2 || starttime.day == 22) {
            starttimecontroller.text = starttime.day.toString() +
                'nd ' +
                month +
                ', ' +
                starttime.year.toString() +
                ' , ' +
                hour.toString() +
                ":" +
                starttime.minute.toString() +
                " " +
                amrpm;
          } else if (starttime.day == 3 || starttime.day == 23) {
            starttimecontroller.text = starttime.day.toString() +
                'rd ' +
                month +
                ', ' +
                starttime.year.toString() +
                ' , ' +
                hour.toString() +
                ":" +
                starttime.minute.toString() +
                " " +
                amrpm;
          } else {
            starttimecontroller.text = starttime.day.toString() +
                'th ' +
                month +
                ', ' +
                starttime.year.toString() +
                ' , ' +
                hour.toString() +
                ":" +
                starttime.minute.toString() +
                " " +
                amrpm;
          }
          plusmarkvisible = false;
          imagedeletevisible = false;
          plusmarkendvisible = true;
          imagedeleteendvisible = true;
        });
        // for(int i=0;i<json.decode(li.planServices.pserviceBeforeImg).length;i++)
        //   beforeimages.add(json.decode(li.planServices.pserviceBeforeImg)[i].toString());
        //
        // for (var url in beforeimages) {
        //   try {
        //
        //     var imageId = await ImageDownloader.downloadImage(url);
        //     var path = await ImageDownloader.findPath(imageId);
        //     setState(() {
        //       files.add(File(path));
        //     });
        //
        //   } catch (error) {
        //     print(error);
        //   }
        // }
      } else {
        setState(() {
          plusmarkvisible = true;
          imagedeletevisible = true;
          plusmarkendvisible = true;
          imagedeleteendvisible = true;
        });
      }
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

  Future<http.Response> startprocess() async {
    setState(() {
      loading = true;
    });
    var url = String_values.base_url +
        'service-process-otp?process=start&id=' +
        widget.serviceid;
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
      // setState(() {
      //   plusmarkvisible = false;
      //   imagedeletevisible = false;
      // });
      showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Enter Start OTP",
              style: TextStyle(color: Colors.red),
            ),
            content: TextField(
              enabled: true,
              controller: StartOTPController,
              decoration: InputDecoration(
                labelText: 'Start OTP',
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 16.0,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  check().then((value) {
                    if (value) {
                      if (StartOTPController.text.length > 0)
                        startupload()
                            .then((value) => details(widget.serviceid));
                      else
                        showDialog<void>(
                          context: context,
                          barrierDismissible: false, // user must tap button!
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Start Otp cannot be Empty"),
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
                    } else
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
                  Navigator.of(context).pop();
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
        },
      );
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

  Future<http.Response> endprocess() async {
    setState(() {
      loading = true;
    });
    var url = String_values.base_url +
        'service-process-otp?process=end&id=' +
        widget.serviceid;
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
      // setState(() {
      //   plusmarkendvisible = false;
      //   imagedeleteendvisible = false;
      // });
      showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Enter End OTP",
              style: TextStyle(color: Colors.red),
            ),
            content: TextField(
              enabled: true,
              controller: EndOTPController,
              decoration: InputDecoration(
                labelText: 'End OTP',
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 16.0,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  check().then((value) {
                    if (value) {
                      if (EndOTPController.text.length > 0)
                        endupload().then((value) => details(widget.serviceid));
                      else
                        showDialog<void>(
                          context: context,
                          barrierDismissible: false, // user must tap button!
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("End Otp cannot be Empty"),
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
                    } else
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
                  Navigator.of(context).pop();
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
        },
      );
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
  TextEditingController EndOTPController = new TextEditingController();
  TextEditingController StatusController = new TextEditingController();
  TextEditingController ServiceStatusController = new TextEditingController();
  TextEditingController starttimecontroller = new TextEditingController();
  TextEditingController endtimecontroller = new TextEditingController();
  TextEditingController ServiceStartDateController =
      new TextEditingController();
  TextEditingController ServiceByController = new TextEditingController();
  TextEditingController StartOTPController = new TextEditingController();
  TextEditingController ServiceController = new TextEditingController();
  TextEditingController PlanPaidStatusController = new TextEditingController();
  TextEditingController PlanCurrentStatusController =
      new TextEditingController();
  TextEditingController PropertyCodeController = new TextEditingController();
  TextEditingController PropertyNameController = new TextEditingController();
  TextEditingController valuecontroller = new TextEditingController();
  TextEditingController PlanController = new TextEditingController();
  TextEditingController PlanServiceController = new TextEditingController();
  List<PlanServiceYearClass> listplanyear;
  TextEditingController priceController = new TextEditingController();
  TextEditingController GroupNameController = new TextEditingController();
  Completer<GoogleMapController> _controller = Completer();
  TextEditingController GroupContactMobileController =
      new TextEditingController();
  TextEditingController datecontroller = new TextEditingController();
  TextEditingController TotalServicesController = new TextEditingController();
  TextEditingController GroupCodeController = new TextEditingController();
  TextEditingController servicetypeController = new TextEditingController();
  TextEditingController PropertyTypeController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();
  TextEditingController statusController = new TextEditingController();
  TextEditingController PlanYearController = new TextEditingController();

//  TextEditingController SizeRangeControllermax = new TextEditingController();
  List<PlanListClass> selectedAvengers;
  bool sort;

  String dropdownValue = '-- Service Type --';

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
                          "Service Details",
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
                      "Service Details",
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
                    child: new TextField(
                      enabled: false,
                      controller: ServiceByController,
                      decoration: InputDecoration(
                        labelText: 'Service By',
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
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
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
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
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
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: new TextField(
                      enabled: false,
                      controller: StatusController,
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
                      "Property Details",
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
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
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
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: new TextField(
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
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
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
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
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
                      "Service Start Process",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                  ),
                  //
                  (li.planServices.pserviceServiceStatus.toString() ==
                              "COMPLETED") ||
                          (li.planServices.pserviceServiceStatus.toString() ==
                              "ONGOING")
                      ? Container(
                          child: Column(
                            children: [
                              li.planServices.pserviceBeforeImg.toString() ==
                                      "null"
                                  ? GridView.count(
                                      physics: ScrollPhysics(),
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      crossAxisCount: 2,
                                      childAspectRatio: 1,
                                      children: List.generate(
                                        li.planServices.pserviceBeforeImg
                                            .length,
                                        (index) {
                                          return Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Card(
                                                  elevation: 5,
                                                  clipBehavior: Clip.antiAlias,
                                                  child: InkWell(
                                                    onTap: () {
                                                      showDialog(
                                                          context: context,
                                                          child: Image.network(li
                                                              .planServices
                                                              .pserviceBeforeImg[
                                                                  index]
                                                              .imgPath));
                                                    },
                                                    child: Image.network(
                                                      li
                                                          .planServices
                                                          .pserviceBeforeImg[
                                                              index]
                                                          .imgPath,
                                                      height: 300,
                                                      width: 300,
                                                    ),
                                                  )));
                                        },
                                      ),
                                    )
                                  : Container(),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  starttimecontroller.text,
                                  style: TextStyle(color: Colors.black),
                                ),
                              )
                            ],
                          ),
                        )
                      : GridView.count(
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          crossAxisCount: 2,
                          childAspectRatio: 1,
                          children: List.generate(
                            files.length + 1,
                            (index) {
                              return Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Card(
                                    elevation: 5,
                                    clipBehavior: Clip.antiAlias,
                                    child: Stack(children: <Widget>[
                                      index < files.length
                                          ? InkWell(
                                              onTap: () {
                                                showDialog(
                                                    context: context,
                                                    child: Image.file(
                                                        files[index]));
                                              },
                                              child: Image.file(
                                                files[index],
                                                width: 300,
                                                height: 300,
                                              ),
                                            )
                                          : Visibility(
                                              visible: plusmarkvisible,
                                              child: Container(
                                                width: 300,
                                                height: 300,
                                                child: IconButton(
                                                  icon: Icon(
                                                    Icons.add,
                                                  ),
                                                  onPressed: () {
                                                    _onAddImageClick(index);
                                                  },
                                                ),
                                              ),
                                            ),
                                      index < files.length
                                          ? Positioned(
                                              right: 5,
                                              top: 5,
                                              child: Visibility(
                                                visible: imagedeletevisible,
                                                child: InkWell(
                                                    child: Icon(
                                                      Icons.remove_circle,
                                                      size: 20,
                                                      color: Colors.red,
                                                    ),
                                                    onTap: () {
                                                      setState(() {
                                                        files.removeAt(index);
                                                        beforeimages
                                                            .removeAt(index);
                                                        print(files);
                                                        // images.replaceRange(index, index + 1, ['Add Image']);
                                                      });
                                                    }),
                                              ))
                                          : Container()
                                    ])),
                              );
                            },
                          ),
                        ),

                  Visibility(
                      child: Container(
                          width: width / 2,
                          margin: EdgeInsets.all(12),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50))),
                          child: FlatButton(
                            onPressed: () {
                              check().then((value) {
                                if (value) {
                                  startprocess();
                                } else
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
                              "Start Process",
                              style: TextStyle(color: Colors.white),
                            ),
                          )),
                      visible: files.length != 0 ? true : false),
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  //   child: new TextField(
                  //     enabled: false,
                  //     controller: valuecontroller,
                  //     decoration: InputDecoration(
                  //       labelText: 'Property Value',
                  //       hintStyle: TextStyle(
                  //         color: Colors.grey,
                  //         fontSize: 16.0,
                  //       ),
                  //       border: OutlineInputBorder(
                  //         borderRadius: BorderRadius.circular(5.0),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  SizedBox(
                    height: height / 50,
                  ),
                  (li.planServices.pserviceServiceStatus.toString() ==
                              "COMPLETED") ||
                          (li.planServices.pserviceServiceStatus.toString() ==
                              "ONGOING")
                      ? Container(
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
                            "Service End Process",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: Colors.red),
                          ),
                        )
                      : Container(),
                  (li.planServices.pserviceServiceStatus.toString() ==
                          "COMPLETED")
                      ? Container(
                          child: Column(
                            children: [
                              li.planServices.pserviceAfterImg.toString() ==
                                      "null"
                                  ? GridView.count(
                                      physics: ScrollPhysics(),
                                      shrinkWrap: true,
                                      crossAxisCount: 2,
                                      childAspectRatio: 1,
                                      children: List.generate(
                                        li.planServices.pserviceAfterImg.length,
                                        (index) {
                                          return Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Card(
                                                  elevation: 5,
                                                  clipBehavior: Clip.antiAlias,
                                                  child: InkWell(
                                                    onTap: () {
                                                      showDialog(
                                                          context: context,
                                                          child: Image.network(li
                                                              .planServices
                                                              .pserviceAfterImg[
                                                                  index]
                                                              .imgPath));
                                                    },
                                                    child: Image.network(
                                                      li
                                                          .planServices
                                                          .pserviceAfterImg[
                                                              index]
                                                          .imgPath,
                                                      height: 300,
                                                      width: 300,
                                                    ),
                                                  )));
                                        },
                                      ),
                                    )
                                  : Container(),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  endtimecontroller.text,
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        )
                      : (li.planServices.pserviceServiceStatus.toString() ==
                              "ONGOING")
                          ? GridView.count(
                              physics: ScrollPhysics(),
                              shrinkWrap: true,
                              crossAxisCount: 2,
                              childAspectRatio: 1,
                              children: List.generate(
                                files1.length + 1,
                                (index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Card(
                                        elevation: 5,
                                        clipBehavior: Clip.antiAlias,
                                        child: Stack(children: <Widget>[
                                          index < files1.length
                                              ? InkWell(
                                                  onTap: () {
                                                    showDialog(
                                                        context: context,
                                                        child: Image.file(
                                                            files1[index]));
                                                  },
                                                  child: Image.file(
                                                    files1[index],
                                                    width: 300,
                                                    height: 300,
                                                  ),
                                                )
                                              : Visibility(
                                                  visible: plusmarkendvisible,
                                                  child: Container(
                                                    width: 300,
                                                    height: 300,
                                                    child: IconButton(
                                                      icon: Icon(
                                                        Icons.add,
                                                      ),
                                                      onPressed: () {
                                                        _onAddImageClickend(
                                                            index);
                                                      },
                                                    ),
                                                  ),
                                                ),
                                          index < files1.length
                                              ? Positioned(
                                                  right: 5,
                                                  top: 5,
                                                  child: Visibility(
                                                    visible:
                                                        imagedeleteendvisible,
                                                    child: InkWell(
                                                        child: Icon(
                                                          Icons.remove_circle,
                                                          size: 20,
                                                          color: Colors.red,
                                                        ),
                                                        onTap: () {
                                                          setState(() {
                                                            files1.removeAt(
                                                                index);
                                                            afterimages
                                                                .removeAt(
                                                                    index);
                                                            print(files1);
                                                            // images.replaceRange(index, index + 1, ['Add Image']);
                                                          });
                                                        }),
                                                  ))
                                              : Container()
                                        ])),
                                  );
                                },
                              ),
                            )
                          : Container(),

                  Visibility(
                      child: Container(
                          width: width / 2,
                          margin: EdgeInsets.all(12),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50))),
                          child: FlatButton(
                            onPressed: () {
                              check().then((value) {
                                if (value) {
                                  endprocess();
                                } else
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
                              "End Process",
                              style: TextStyle(color: Colors.white),
                            ),
                          )),
                      visible: files1.length != 0 ? true : false),
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

  Future _onAddImageClick(int index) async {
    final picker = ImagePicker();
    image = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (image != null)
      setState(() {
        files.add(image);
        beforeimages.add(image.path);
      });
  }

  Future getFileImage(int index) async {
//    var dir = await path_provider.getTemporaryDirectory();
    _imageFile.then((file) async {});
  }

  void convert(DateTime date) {
    if (date.hour >= 12) {
      hour = date.hour - 12;
      amrpm = 'PM';
      if (date.hour == 12) {
        hour = date.hour;
      }
    } else {
      if (date.hour != 0) {
        hour = date.hour;
        amrpm = 'AM';
      } else {
        hour = 12;
        amrpm = 'AM';
      }
    }
  }

  Future _onAddImageClickend(int index) async {
    final picker = ImagePicker();
    image = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (image != null)
      setState(() {
        files1.add(image);
        afterimages.add(image.path);
      });
  }

  Future getFileImageend(int index) async {
//    var dir = await path_provider.getTemporaryDirectory();
    _imageFile.then((file) async {
      setState(() {
        // ImageUploadModel imageUpload = new ImageUploadModel();
        // imageUpload.isUploaded = false;
        // imageUpload.uploading = false;
        // imageUpload.imageFile = file;
        // imageUpload.imageUrl = '';
        // // images.replaceRange(index, index + 1, [imageUpload]);
        // print("images Image: $file");

        files1.add(file);
        afterimages.add(file.path);
      });
    });
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
