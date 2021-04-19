import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:device_info/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:imei_plugin/imei_plugin.dart';
import 'package:random_color/random_color.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tankcare/Customer/register.dart';
import 'package:tankcare/CustomerModels/profile.dart';
import 'package:tankcare/Employee/Login/Login.dart';
import 'package:tankcare/Employee/Supervisor/Approvals/EmployeeApprovalProcess.dart';
import 'package:tankcare/Employee/Supervisor/Customer/Cutomer360.dart';
import 'package:tankcare/Employee/Supervisor/Customer/EmployeeCustomerList.dart';
import 'package:tankcare/Employee/Supervisor/Expense/EmployeeExpenseList.dart';
import 'package:tankcare/Employee/Supervisor/Incentive/EmployeeIncentiveList.dart';
import 'package:tankcare/Employee/Supervisor/Lead/EmployeeLeadList.dart';
import 'package:tankcare/Employee/Supervisor/Machines/machinelist.dart';
import 'package:tankcare/Employee/Supervisor/My%20Shop/EmployeeMyshopList.dart';
import 'package:tankcare/Employee/Supervisor/My%20Staff/DVStaffList.dart';
import 'package:tankcare/Employee/Supervisor/Property/Property%20Plan/PlanList.dart';
import 'package:tankcare/Employee/Supervisor/Property/Property/PropertyList.dart';
import 'package:tankcare/Employee/Supervisor/Remarks%20List/RemarksList.dart';
import 'package:tankcare/Employee/Supervisor/Services/CustomerPropertyServiceList.dart';
import 'package:tankcare/Employee/Supervisor/Services/FeedBackList.dart';
import 'package:tankcare/Employee/Supervisor/Services/ServiceList.dart';
import 'package:tankcare/Employee/Supervisor/Services/SpecialServiceList.dart';
import 'package:tankcare/Employee/Supervisor/Team/AGMList.dart';
import 'package:tankcare/Employee/Supervisor/Team/DVList.dart';
import 'package:tankcare/Employee/Supervisor/Team/FranchiseList.dart';
import 'package:tankcare/Employee/Supervisor/Team/GMList.dart';
import 'package:tankcare/Employee/Supervisor/Team/RMList.dart';
import 'package:tankcare/Employee/Supervisor/Team/Team360.dart';
import 'package:tankcare/RM%20models/getuser.dart';
import 'package:tankcare/RM%20models/userDesignation.dart';
import 'package:tankcare/Vendor/Approval/ApprovalList.dart';
import 'package:tankcare/Vendor/Machines/Repair%20Request/RepairQuoteList.dart';
import 'package:tankcare/Vendor/Services/ServiceHistory.dart';
import 'package:tankcare/Vendor/Services/ServiceList.dart';
import 'package:tankcare/Vendor/Services/VendorTodayServiceList.dart';
import 'package:tankcare/Vendor/Services/VendorTomorrowServiceList.dart';
import 'package:tankcare/Vendor/Staff/VendorStaffList.dart';
import 'package:tankcare/Vendor/Tarriff/PlanTariffList.dart';
import 'package:tankcare/Vendor/Tarriff/VendorTariffList.dart';
import 'package:tankcare/VendorModels/MenuModel.dart';
import 'package:tankcare/VendorModels/WalletTotal.dart';
import 'package:tankcare/main.dart';
import 'package:tankcare/string_values.dart';

import 'package:tankcare/Employee/Supervisor/Property/Group/GroupList.dart';
import 'package:tankcare/Vendor/Complaint/ComplaintList.dart';
import 'package:tankcare/Vendor/Credit%20Note/CreditNoteList.dart';
import 'package:tankcare/Vendor/Damage/DamageList.dart';
import 'package:tankcare/Vendor/Machines/Repair%20Request/RepairList.dart';
import 'package:tankcare/Vendor/Machines/Spare%20List/SpareList.dart';
import 'package:tankcare/Vendor/Machines/SpareRequestList/SpareRequestList.dart';
import 'package:tankcare/Vendor/Sales/InvoiceList.dart';
import 'package:tankcare/Vendor/Sales/billlist.dart';
import 'package:tankcare/Vendor/ServiceStation/ServiceStationList.dart';
import 'package:tankcare/Vendor/Wallet/WalletList.dart';

import 'EmployeeModels/ErrorResponse.dart';
import 'Supervisor/Services/ServiceAssignList.dart';

class EmployeeDashboard extends StatefulWidget {
  EmployeeDashboard({Key key, this.firsttime});

  bool firsttime;
  @override
  EmployeeDashboardState createState() => EmployeeDashboardState();
}
Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
  print('on background $message');
}
class EmployeeDashboardState extends State<EmployeeDashboard> {
  final TextEditingController _typeAheadController = TextEditingController();
  String usertype;
  String token;
  List<String> stringlist = ["-- Designation --"];
  Position position;
  List multiImei= new List();
  String imei;
  GetUserDesignation li4;
  var dropdownValueuser="-- User Type --";
  var dropdownValuedes="-- Designation --";


  String userid;
 static String roleid;

  ErrorResponse ei;

  String rolename;


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
        li4 = GetUserDesignation.fromJson(json.decode(response.body));

        stringlist.clear();
        stringlist.add("-- Designation --");

        for (int i = 0; i < li4.values.length; i++)
          stringlist.add(li4.values[i].roleName);
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
  Future<void> share() async {
    await Share.share('Join on Tank Care by clicking https://www.minmegam.com, a secure app for tank,sump,car and bike services. Enter my code "${refcode}" to earn rewards! ',

    );
  }
  Future gettoken() async {
    token = await _firebaseMessaging.getToken();
    print("Instance ID: " + token);
    // mob();
  }
  RandomColor _randomColor = RandomColor();
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  double latitudecamera, longitudecamera;
  Profile li;
  static String refcode;
  static String username = "  ";
  bool loading = false;
  WalletTotalAmount li2;
  double amount = 0;
  MenuList li3;
  Color _color;
  Future<http.Response> WalletTotal() async {
    setState(() {
      loading = true;
    });

    var url = String_values.base_url + 'vendor-wallet';
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
      li2 = WalletTotalAmount.fromJson(json.decode(response.body));
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
    var url = String_values.base_url + 'my-profile';
    print(String_values.base_url);
    var response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer ${RegisterPagesState.token}'
      },
    );
    if (response.statusCode == 200) {
      li = Profile.fromJson(json.decode(response.body));
      if (li.status) refcode = li.data.ucode;
      setState(() {
        username = li.data.uname;
        EmployeeLoginPagesState.Userrole = li.data.urole;
        MyApp.role = li.data.urole;
      });
      setState(() {
        loading = false;
      });
    }

    print("response: ${response.statusCode}");
    print("response: ${response.body}");
    return response;
  }

  Future<http.Response> details() async {
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
  Future<void> _currentposition() async {
    position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

  }
  void initState() {
    _getId().then((value) => gettoken().then((value) =>  _currentposition().then((value) {
      latitudecamera = position.latitude;
      longitudecamera = position.longitude;

print(imei);
      print(latitudecamera);
      print(longitudecamera);
      uploadImage("");
      // Fluttertoast.showToast(
      //     msg: imei.toString(),
      //     toastLength: Toast.LENGTH_SHORT,
      //     gravity: ToastGravity.CENTER,
      //     timeInSecForIosWeb: 1,
      //     backgroundColor: Colors.red,
      //     textColor: Colors.white,
      //     fontSize: 16.0
      // );
    })));

    _firebaseMessaging.configure(
        onMessage: (message) async {
          print("Message:start");
          print(message);

        },
        onResume: (message) async {
      print("Message: onresume");
      print(message);

    },
        onLaunch: (message) async {
          print("Message: onlaunch");
          print(message);

        },
        onBackgroundMessage: myBackgroundMessageHandler
    );
     _color = _randomColor.randomColor(
         colorHue: ColorHue.red
    );

    details().then((value) {
      postRequest().then((value) {
        print(MyApp.role);
        if (MyApp.role == "VENDOR")
          WalletTotal().then((value) {
            amount = double.parse(li2.data.currentAmnt);
            widget.firsttime?showDialog<void>(
              context: context,
              barrierDismissible: true,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: Colors.white.withOpacity(0),
                  title: Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(50),
                          bottomRight: Radius.circular(50),
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16.0),
                          child: Image.asset(
                            "logo.png",
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Welcomes You",
                          style: TextStyle(color: Colors.amber, fontSize: 16),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          li.data.uname.toString(),
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),

                  // actions: <Widget>[
                  //   TextButton(
                  //     child: Text('OK'),
                  //     onPressed: () {
                  //       Navigator.of(context).pop();
                  //     },
                  //   ),
                  // ],
                );
              },
            ):Container();
          });
        else
          widget.firsttime?showDialog<void>(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Colors.white.withOpacity(0),
                title: Container(
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(50),
                        bottomRight: Radius.circular(50),
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        child: Image.asset(
                          "logo.png",color: Colors.white,height: MediaQuery.of(context).size.height/3,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Welcomes You",
                        style: TextStyle(color: Colors.amber, fontSize: 16),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        li.data.uname.toString(),
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              );
            },
          ):Container();
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: loading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
            child: Column(
              children: [

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
                        "Dashboard",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                            fontSize: 17),
                      ),
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: Center(
                    child: Container(
                      height: height/1.3,
                      width: width,
                        color: Colors.red.withOpacity(0),
                        padding: EdgeInsets.all(16),
                        child: GridView.count(
                          crossAxisCount: 3,
                          children: <Widget>[
                            for (int i = 0; i < li3.list.length; i++)
                              if (li3.list[i].title != "Home")
                                Card(
                                  elevation: 5.0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20))),
                                  color: RandomHexColor.colorRandom(),
                                  // color: _randomColor.randomColor(
                                  //   colorHue: ColorHue.multiple(colorHues: [ ColorHue.red,ColorHue.green,ColorHue.blue,ColorHue.yellow,ColorHue.orange,]),
                                  //
                                  //   colorBrightness: ColorBrightness.veryLight,
                                  //     colorSaturation: ColorSaturation.highSaturation,
                                  // ),
                                  child: InkWell(
                                    onTap: () {
                                      pageswitch(li3.list[i].title, li3.list[i].children);
                                    },
                                    splashColor: Colors.redAccent,
                                    borderRadius: BorderRadius.circular(20),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Container(

                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.all(Radius.circular(30)),
                                                color: Colors.white.withOpacity(0.5)),
                                            padding: EdgeInsets.all(10),
                                            child: li3.list[i].icon!=null?Image.network(li3.list[i].icon,
                                                height: 35,width: 35,):Container(),
                                          ),
                                          SizedBox(height: height / 80),
                                          Container(
                                            child: Text(
                                              li3.list[i].title,
                                              style: new TextStyle(

                                                  fontSize: 16.0,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                          ],
                        ),
                      ),
                  ),
                ),
              ],
            ),
          ),
      appBar: AppBar(


        title: Image.asset('logotitle.png',height: 40),
        actions: [
          MyApp.role == "VENDOR"
              ? InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WalletRequestList()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("wallet.png",width: 35,height: 35,color: Colors.white,),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Rs. ${amount}"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              :IconButton(icon: Icon(Icons.location_history,color: Colors.white,), onPressed: ()
          {
            showDialog<void>(
              context: context,
              barrierDismissible:
              false, // user must tap button!
              builder: (context) {
                return StatefulBuilder(
                    builder: (context,
                        StateSetter
                        setState) {
                      return AlertDialog(
                          title: Text(
                            "Choose Employee",
                            style: TextStyle(
                                color:
                                Colors.red),
                          ),
                          content: loading
                              ? Center(
                              child:
                              CircularProgressIndicator())
                              : SingleChildScrollView(
                            child: Column(
                              children: [
                                Container(
                                  height:
                                  50,
                                  padding: const EdgeInsets
                                      .only(
                                      left:
                                      20.0,
                                      right:
                                      10.0),
                                  decoration: new BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(
                                          2.0)),
                                      border:
                                      new Border.all(color: Colors.black38)),
                                  child:
                                  DropdownButtonHideUnderline(
                                    child: DropdownButton<
                                        String>(
                                      isExpanded:
                                      true,
                                      value:
                                      dropdownValueuser,
                                      onChanged:
                                          (String newValue) {
                                        if (newValue !=
                                            "-- User Type --")
                                          getdesignation(newValue).then((value) => setState(() {
                                            dropdownValueuser = newValue;
                                            dropdownValuedes = "-- Designation --";
                                          }));
                                      },
                                      items: <
                                          String>[
                                        "-- User Type --",
                                        "Employee",
                                        "Vendor",
                                        "District Vendor",
                                        "Franchise"
                                      ].map<DropdownMenuItem<String>>((String
                                      value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: MediaQuery.of(context)
                                      .size
                                      .height /
                                      50,
                                ),
                                StatefulBuilder(builder:
                                    (context,
                                    setState) {
                                  return Container(
                                    height:
                                    50,
                                    padding: const EdgeInsets.only(
                                        left:
                                        20.0,
                                        right:
                                        20.0),
                                    decoration: new BoxDecoration(
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(2.0)),
                                        border: new Border.all(color: Colors.black38)),
                                    child:
                                    DropdownButtonHideUnderline(
                                      child:
                                      DropdownButton<String>(
                                        isExpanded:
                                        true,
                                        value:
                                        dropdownValuedes,
                                        onChanged:
                                            (String newValue) {
                                          for (int i = 0; i < li4.values.length; i++)
                                            if (li4.values[i].roleName == newValue) {
                                              roleid = li4.values[i].roleId;
                                              rolename=li4.values[i].roleName;
                                              print("roleid: ${roleid}");
                                            }

                                          setState(() {
                                            _typeAheadController.text = "";
                                            dropdownValuedes = newValue;
                                          });
                                        },
                                        items:
                                        stringlist.map<DropdownMenuItem<String>>((String value) {
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
                                    height: MediaQuery.of(context).size.height /
                                        50),
                                TypeAheadFormField(
                                  textFieldConfiguration:
                                  TextFieldConfiguration(
                                    enabled:
                                    true,
                                    controller:
                                    this._typeAheadController,
                                    // onTap: ()
                                    // {
                                    //   Navigator.push(
                                    //       context,
                                    //       MaterialPageRoute(
                                    //           builder: (context) =>
                                    //               Category(userid:HomeState.userid,mapselection: true)));
                                    // },
                                    keyboardType:
                                    TextInputType.text,
                                    decoration:
                                    InputDecoration(
                                      labelText:
                                      'Name',
                                      hintStyle:
                                      TextStyle(
                                        color:
                                        Colors.grey,
                                        fontSize:
                                        16.0,
                                      ),
                                      border:
                                      OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(5.0),
                                      ),
                                    ),
                                  ),
                                  suggestionsCallback:
                                      (pattern) {
                                    return BackendService.getSuggestions(
                                        pattern);
                                  },
                                  itemBuilder:
                                      (context,
                                      suggestion) {
                                    return ListTile(
                                      title:
                                      Text(suggestion),
                                    );
                                  },
                                  transitionBuilder: (context,
                                      suggestionsBox,
                                      controller) {
                                    return suggestionsBox;
                                  },
                                  onSuggestionSelected:
                                      (suggestion) {
                                    for (int i =
                                    0;
                                    i <
                                        BackendService
                                            .li1.items.length;
                                    i++)
                                      if (BackendService.li1.items[i].uname ==
                                          suggestion)
                                        userid =
                                            BackendService.li1.items[i].uid;
                                    print(
                                        userid);
                                    // postRequest(suggestion);
                                    // for(int i=0;i<BackendService.li1.items.length;i++)
                                    // {
                                    //   print(BackendService.li1.items[i].groupName);
                                    //   if (BackendService.li1.items[i].groupName == suggestion) {
                                    //     groupid=BackendService.li1.items[i].groupId.toString();
                                    //     if(BackendService.li1.items[i].serviceType.toString()=="RES")
                                    //       ServiceController.text = "Residential";
                                    //     else
                                    //       ServiceController.text = "Commercial";
                                    //   }
                                    // }
                                    this._typeAheadController.text =
                                        suggestion;

                                    getlocation(userid,rolename);
                                  },
                                  validator:
                                      (value) {
                                    if (value
                                        .isEmpty) {
                                      return 'Please select a city';
                                    } else
                                      return 'nothing';
                                  },
                                  // onSaved: (value) => this._selectedCity = value,
                                ),
                                // Padding(
                                //   padding: const EdgeInsets.all(8.0),
                                //   child: Text('Total Amount : ${totalamount}'),
                                // ),

                                SizedBox(
                                    height: MediaQuery.of(context).size.height /
                                        50),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment
                                      .spaceEvenly,
                                  children: [
                                    Padding(
                                      padding:
                                      const EdgeInsets.all(10.0),
                                      child: Container(
                                          width: MediaQuery.of(context).size.width / 4,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.all(Radius.circular(10))),
                                          child: FlatButton(
                                            onPressed: () {
                                             // payBill("").then((value) =>
                                              //
                                              //     Navigator.push(
                                              //         context,
                                              //         MaterialPageRoute(
                                              //             builder: (context) =>
                                              //                 BillList()))
                                              //
                                              // );
                                            },
                                            child: Text(
                                              "Assign",
                                              style: TextStyle(color: Colors.white),
                                            ),
                                          )),
                                    ),
                                    Padding(
                                      padding:
                                      const EdgeInsets.all(10.0),
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
          })
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: IconButton(
            //       icon: Icon(Icons.share),
            //       onPressed: () {
            //         share();
            //       }),
            // )

        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text("Welcome"),
              accountEmail: Text(username),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.blue.withOpacity(0.5),
                child: Text(
                  username.substring(0, 1),
                  style: TextStyle(fontSize: 40.0,color: Colors.white),
                ),
              ),
            ),
            ListTile(
              title: Text("Logout"),
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setBool('seen', false);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EmployeeLoginPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void pageswitch(String title, List<Children> children) {
    print(title);
    switch (title) {
      case "Incentive":

        if (children.toString() == "null") {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EmployeeIncentiveList()));
        }
        else {
          print("outside");
          showchildren(title, children);
        }
        break;

      case "Expense":
        print(children.toString());
        if (children.toString() == "null") {
          print("inside");
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EmployeeEXPENSEList()));
        } else {
          print("outside");
          showchildren(title, children);
        }
        break;
      case "Services":
        print(children.toString());
        if (children.toString() == "null") {
          print("inside");
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EmployeePropertyServiceList()));
        } else {
          print("outside");
          showchildren(title, children);
        }
        break;

      case "My Shop":
        print(children.toString());
        if (children.toString() == "null") {
          print("inside");
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => EmployeeMyShopList()));
        } else {
          print("outside");
          showchildren(title, children);
        }
        break;
      case "Expense List":
        print(children.toString());
        if (children.toString() == "null") {
          print("inside");
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => EmployeeEXPENSEList()));
        } else {
          showchildren(title, children);
        }
        break;
      case "Lead ":
        print(children.toString());
        if (children.toString() == "null") {
          print("inside");
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => EmployeeLeadList()));
        } else {
          print("outside");
          showchildren(title, children);
        }
        break;
      case "Lead":
        print(children.toString());
        if (children.toString() == "null") {
          print("inside");
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => EmployeeLeadList()));
        } else {
          print("outside");
          showchildren(title, children);
        }
        break;
      case "Remarks List":
        print(children.toString());
        if (children.toString() == "null") {
          print("inside");
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => EmployeeRemarksList()));
        } else {
          print("outside");
          showchildren(title, children);
        }
        break;
      case "Remarks":
        print(children.toString());
        if (children.toString() == "null") {
          print("inside");
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => EmployeeRemarksList()));
        } else {
          print("outside");
          showchildren(title, children);
        }
        break;
      case "Franchise":
        print(children.toString());
        if (children.toString() == "null") {
          print("inside");
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => FranchiseList()));
        } else {
          print("outside");
          showchildren(title, children);
        }
        break;
      case "Customer":
        print(children.toString());
        if (children.toString() == "null") {
          print("inside");
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EmployeePropertyServiceList()));
        } else {
          print("outside");
          showchildren(title, children);
        }
        break;
      case "Approval":
        print(children.toString());
        if (children.toString() == "null") {
          print("inside");
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EmployeePropertyServiceList()));
        } else {
          print("outside");
          showchildren(title, children);
        }
        break;
      case "Team":
        print(children.toString());
        if (children.toString() == "null") {
          print("inside");
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EmployeePropertyServiceList()));
        } else {
          print("outside");
          showchildren(title, children);
        }
        break;
      case "Damage":
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => EmployeeDamageList()));
        break;

      case "Machine":
        if (children.toString() == "null")
          ;
        else
          showchildren(title, children);
        break;
      case "Sales":
        if (children.toString() == "null")
          ;
        else
          showchildren(title, children);
        break;

      case "Tariff":
        if (children.toString() == "null")
          ;
        else
          showchildren(title, children);
        break;
      case "Property":
        if (children.toString() == "null")
          ;
        else
          showchildren(title, children);
        break;

      case "Complaints":
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ComplaintList()));

        break;
      case "Approval List":
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => EmployeeApprovalList()));

        break;
      case "My Staff":
        print(MyApp.role);
        if (MyApp.role == "VENDOR")
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => VendorStaffList()));
        else
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => EmployeeDVStaffList()));
        break;
      case "Credit Note":
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => CreditNoteList()));
        break;
    }
  }

  void childrenwitch(String title) {
    print(title);
    switch (title) {
      case "Incentive List":
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => EmployeeIncentiveList()));

        break;
      case "Service Station":
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ServiceStationList()));
        break;

      case "Approval Process":
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => EmployeeApprovalList()));
        break;
      case "Repair Quote":
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => RepairQUoteList()));
        break;

      case "Remark List":
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => EmployeeRemarksList()));

        break;
      case "Team 360":
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => EmployeeTeam360()));
        break;
      case "Customer 360":
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => EmployeeCustomer360()));
        break;

      case "Expense List":
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => EmployeeEXPENSEList()));
        break;
      case "Special Service":
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => EmployeeSpecialServiceList()));
        break;
      case "Service Quote":
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => VendorBillList()));
        break;
      case "Tomorrow Services":
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => VendorTommorrowServiceList()));
        break;
      case "Services History":
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => ServiceHistoryList()));
        break;
      case "Customer List":
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => EmployeeCustomerList()));
        break;
      case "Group List":
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => EmployeeGroupList()));
        break;
      case "Property List":
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => EmployeePropertyList()));
        break;
      case "Property Plan List":
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => EmployeePlanList()));
        break;
      case "Services List":
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => EmployeeServiceList()));
        break;
      case "Service Assign":
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => ServiceAssignList()));
        break;
      case "All Services":
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => VendorServiceList()));
        break;
      case "Today Services":
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => VendorTodayServiceList()));
        break;
      case "Feedback":
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => EmployeeFeedbackList()));
        break;
      case "Tax Invoice":
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => VendorInvoiceList()));
        break;
      case "Vendor Tariff":
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => VendorTariffList()));
        break;
      case "Plan Tariff":
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => VendorPlanTariffList()));
        break;
      case "My Service Station":
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => ServiceStationList()));
        break;
      case "My Machines":
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => EmployeeMachineList()));
        break;
      case "Repair Request":
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => RepairList()));
        break;
      case "Spare List":
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => SpareList()));
        break;
      case "Franchise":
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => FranchiseList()));
        break;
      case "Franchise List":
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => FranchiseList()));
        break;
      case "General Manager":
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => GMList()));
        break;
      case "Reginal Manager":
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => RMList()));
        break;
      case "Asst General Manager":
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => AGMList()));
        break;
      case "District Vendor":
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => DVList()));
        break;
      case "Spare Request List":
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => SpareRequestList()));
        break;
    }
  }
  Future<int> uploadImage(url) async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer ${RegisterPagesState.token}'
    };

    var request = http.MultipartRequest(
        'POST', Uri.parse(String_values.base_url + 'login-location'));

    request.headers.addAll(headers);
    request.fields['device_id'] = imei;
    request.fields['latitude'] = latitudecamera.toString();
    request.fields['longitude'] = longitudecamera.toString();
    request.fields['firebase_id'] = token;
    request.fields['login_utype']=MyApp.role;
    request.fields['login_uid']=RegisterPagesState.cus_id;
    var response = await request.send();
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);

      setState(() {
        loading = false;
      });
      if(value.toString().contains("true")) {

      }
      else
      {
        ei=ErrorResponse.fromJson(jsonDecode(value));
        Fluttertoast.showToast(
            msg: ei.messages,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.SNACKBAR,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }
    });
  }
  Future<int> getlocation(roleid,userid) async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer ${RegisterPagesState.token}'
    };
    var request = http.MultipartRequest(
        'POST', Uri.parse(String_values.base_url + 'login-history'));
    request.headers.addAll(headers);
    request.fields['rolename']=roleid;
    request.fields['uid']=userid;
    var response = await request.send();
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);

      setState(() {
        loading = false;
      });
      if(value.toString().contains("true")) {

      }
      else
      {
        ei=ErrorResponse.fromJson(jsonDecode(value));
        Fluttertoast.showToast(
            msg: ei.messages,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.SNACKBAR,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }
    });
  }
  void showchildren(title, children) {
    showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
              backgroundColor: Colors.white.withOpacity(0.8),
              title: Container(
                child: Center(
                  child: Text(
                    title,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
              content: Container(
                height: MediaQuery.of(context).size.height / 3,
                width: MediaQuery.of(context).size.width,
                child: GridView.count(crossAxisCount: 3, children: <Widget>[
                  for (int i = 0; i < children.length; i++)
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      color: RandomHexColor.colorRandom(),
                      // color: _randomColor.randomColor(
                      //   colorHue: ColorHue.multiple(colorHues: [ ColorHue.red,ColorHue.green,ColorHue.blue,ColorHue.yellow,ColorHue.orange,]),
                      //   colorBrightness: ColorBrightness.veryLight,
                      //   colorSaturation: ColorSaturation.highSaturation,
                      // ),
                      elevation: 5.0,

                      child: InkWell(
                        splashColor: Colors.redAccent,
                        onTap: () {
                          childrenwitch(children[i].title);
                        },
                        borderRadius: BorderRadius.circular(25),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Container(

                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30)),
                                    color: Colors.white.withOpacity(0.5)),
                                padding: EdgeInsets.all(5),
                                child:children[i].icon!=null? Image.network(
                                  children[i].icon,
                                  height: 25,
                                  width: 25,
                                ):Container(),
                              ),
                              SizedBox(height: 5),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    children[i].title,
                                    style: new TextStyle(
                                        fontSize: 12.0, color: Colors.black),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                ]),
              ));
        });
  }

  Future<String> _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) { // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      imei=androidDeviceInfo.androidId;
      return androidDeviceInfo.androidId; // unique ID on Android
    }
  }
}

class RandomHexColor {
  static const Color one = Color(0xffF4A460);
  static const Color two = Color(0xff78AB46);
  static const Color three = Color(0xff2BCAFF);
  static const Color four = Color(0xff838EDE);
  static const Color five = Color(0xffFFDE2B);
  static List<Color> hexColor = [one, two, three,four,five];

  static final _random = Random();

  static Color colorRandom() {
    return hexColor[_random.nextInt(5)];
  }
}
class BackendService {
  static GetUserDetails li1;

  static Future<List> getSuggestions(String query) async {
    var url = //'http://35.184.156.126.xip.io/cyberhome/home.php?username=kavin&query=table';
    String_values.base_url +
        'role-user-list?search=${query}&urole_id=' +
        EmployeeDashboardState.roleid;
print(url);
print(VendorApprovalListState.roleid);
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
        // return ["No details"];
      } else {
        for (int i = 0; i < li1.items.length; i++)
          s.add(li1.items[i].uname.toString());
        print(s);
        return s;
      }
      // }
      // else {
      //
      //   print("not contains list");
      //   //return "" as List;
      // }

      //["result"];
      // print(json.decode(response.body)["result"]["categoryName"]);
    } else {
      print("Retry");
    }
  }
}