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
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:tankcare/Customer/register.dart';
import 'package:tankcare/CustomerModels/districtlist.dart';
import 'package:tankcare/CustomerModels/statelist.dart';
import 'package:tankcare/Employee/Dashboard.dart';
import 'package:tankcare/Employee/EmployeeModels/FeedBack/FeedBackDetail.dart';
import 'package:tankcare/string_values.dart';

class EmployeeFeedBackDetail extends StatefulWidget {
  EmployeeFeedBackDetail({Key key, this.id});

  String id;

  @override
  EmployeeFeedBackDetailState createState() => EmployeeFeedBackDetailState();
}

class EmployeeFeedBackDetailState extends State<EmployeeFeedBackDetail> {
  bool loading = false;
  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
  DateTime starttime;
  DateTime endtime;
  EmployeeFeedBackDetailModel li;
  List<File> files = [];
  List<File> files1 = [];
  List<String> beforeimages = List<String>();
  List<String> afterimages = List<String>();
  var _kGooglePlex;
  Future<File> _imageFile;
  StateListings li2;

  DistrictListings li3;

  var plusmarkvisible = true;

  var imagedeletevisible = true;

  var plusmarkendvisible = true;

  var imagedeleteendvisible = true;

  int hour;
  String amrpm;

  File image;

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
      request.files
          .add(await http.MultipartFile.fromPath('upimgs[]', beforeimages[i]));
    }
    request.headers.addAll(headers);
    request.fields['process_type'] = "start";
    request.fields['service_id'] = widget.id.toString();
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
      request.files
          .add(await http.MultipartFile.fromPath('upimgs[]', afterimages[i]));
    }
    request.headers.addAll(headers);
    request.fields['process_type'] = "end";
    request.fields['service_id'] = widget.id.toString();
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
    var url =
        String_values.base_url + 'service-feedback-view?feedback_id=' + planid;
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
      li = EmployeeFeedBackDetailModel.fromJson(json.decode(response.body));

      // ServiceByController.text=li.planServices.se
      // ServiceStartDateController.text = li.planServices.pserviceDate.toString();
      // ServiceStatusController.text =
      //     li.planServices.pserviceServiceStatus.toString();
      //
      // if (li.planServices.pserviceStatus.toString() == "A")
      //   StatusController.text = "Active";
      // else if (li.planServices.pserviceStatus.toString() == "P")
      //   StatusController.text = "Pending";
      //
      PropertyNameController.text = li.items.propertyName.toString();
      GroupNameController.text = li.items.groupName.toString();
      if (li.items.serviceType.toString() == "RES")
        ServiceController.text = "Residential";
      else
        ServiceController.text = "Commercial";
      PropertyCodeController.text = li.items.propertyCode.toString();
      FeedBackSummaryController.text = li.items.feedbackNote.toString();
      PropertyTypeController.text = li.items.ptypeName.toString();
      valuecontroller.text = li.items.propertyValue.toString();
      //
      // PlanController.text = li.plan.pplanName.toString();
      CustomerName.text = li.items.cusName.toString();
      // PlanServiceController.text = li.plan.pplanService.toString();
      // priceController.text = li.plan.pplanPrice.toString();
      // datecontroller.text = li.plan.pplanStartDate.toString();
      // PlanCurrentStatusController.text = li.plan.pplanCurrentStatus.toString();

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
        widget.id;
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
                        startupload().then((value) => details(widget.id));
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
        widget.id;
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
                        endupload().then((value) => details(widget.id));
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
        li2 = StateListings.fromJson(json.decode(response.body));
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
  TextEditingController CustomerName = new TextEditingController();
  TextEditingController EndOTPController = new TextEditingController();
  TextEditingController StatusController = new TextEditingController();
  TextEditingController FeedBackSummaryController = new TextEditingController();
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
    details(widget.id);
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
                          "FeedBack Details",
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
                            "Property Details",
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
                              child: new TextField(
                                enabled: false,
                                controller: valuecontroller,
                                decoration: InputDecoration(
                                  labelText: 'Property Capacity',
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
                                controller: CustomerName,
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
                          ])),
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
                            "Servicer Ratings",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, color: Colors.red),
                          ),
                          children: [
                            RatingBar.builder(
                              initialRating:
                                  double.parse(li.items.servicerRating),
                              direction: Axis.horizontal,
                              allowHalfRating: false,
                              itemCount: 5,
                              minRating: 1,
                              itemSize: 35.0,
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.amber,
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
                          initiallyExpanded: true,
                          title: Text(
                            "Service Ratings",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, color: Colors.red),
                          ),
                          children: [
                            RatingBar.builder(
                              initialRating: double.parse(li.items.cleanRating),
                              direction: Axis.horizontal,
                              allowHalfRating: false,
                              itemCount: 5,
                              minRating: 1,
                              itemSize: 35.0,
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                            ),
                            SizedBox(
                              height: height / 50,
                            ),
                          ]))

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
                  ,
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
                            "FeedBack Summary",
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
                                minLines: 6,
                                maxLines: 20,
                                enabled: false,
                                controller: FeedBackSummaryController,
                                decoration: InputDecoration(
                                  labelText: 'FeedBack Summary',
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
