import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tankcare/Customer/register.dart';
import 'package:tankcare/CustomerModels/profile.dart';
import 'package:tankcare/Employee/Login/Login.dart';
import 'package:tankcare/Vendor/Login/Login.dart';
import 'package:tankcare/Vendor/Staff/VendorStaffList.dart';
import 'package:tankcare/Vendor/Tarriff/PlanTariffList.dart';
import 'package:tankcare/Vendor/Tarriff/VendorTariffList.dart';
import 'package:tankcare/VendorModels/MenuModel.dart';
import 'package:tankcare/VendorModels/WalletTotal.dart';
import 'package:tankcare/string_values.dart';

import 'package:tankcare/Vendor/Approval/ApprovalList.dart';
import 'package:tankcare/Vendor/Complaint/ComplaintList.dart';
import 'package:tankcare/Vendor/Credit%20Note/CreditNoteList.dart';
import 'package:tankcare/Vendor/Damage/DamageList.dart';
import 'package:tankcare/Vendor/Machines/My%20Machines/machinelist.dart';
import 'package:tankcare/Vendor/Machines/Repair%20Request/RepairList.dart';
import 'package:tankcare/Vendor/Machines/Spare%20List/SpareList.dart';
import 'package:tankcare/Vendor/Machines/SpareRequestList/SpareRequestList.dart';
import 'package:tankcare/Vendor/Sales/InvoiceList.dart';
import 'package:tankcare/Vendor/Sales/billlist.dart';
import 'package:tankcare/Vendor/ServiceStation/ServiceStationList.dart';
import 'package:tankcare/Vendor/Services/ServiceList.dart';
import 'package:tankcare/Vendor/Wallet/WalletList.dart';

class VendorDashboard extends StatefulWidget {
  @override
  VendorDashboardState createState() => VendorDashboardState();
}

class VendorDashboardState extends State<VendorDashboard> {
  Profile li;
  static String refcode;
  static String username = "  ";

  bool loading = false;

  WalletTotalAmount li2;
  double amount = 0;

  MenuList li3;

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
      li2 = WalletTotalAmount.fromJson(json.decode(response.body));
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
        VendorLoginPagesState.Userrole = li.data.urole;
        username = li.data.uname;
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

  void initState() {
    details().then((value) => WalletTotal().then((value) {
          amount = double.parse(li2.data.currentAmnt);
          postRequest().then((value) => showDialog<void>(
                context: context,
                barrierDismissible: false, // user must tap button!
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: Colors.white,
                    title: Text(
                      "Welcome",
                      style: TextStyle(color: Colors.red),
                    ),
                    content: Text(li.data.uname.toString()),
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
              ));
        }));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      //backgroundColor: Colors.redAccent[100],
      body: Container(
        padding: EdgeInsets.all(18),
        child: GridView.count(
          crossAxisCount: 3,
          children: <Widget>[
            for (int i = 0; i < li3.list.length; i++)
              if (li3.list[i].title != "Home")
                Card(
                  elevation: 5.0,
                  // color: Colors.redAccent[100],
                  child: InkWell(
                    onTap: () {
                      pageswitch(li3.list[i].title, li3.list[i].children);
                      // Navigator.push(context,
                      //     MaterialPageRoute(builder: (context) => VendorServiceList()));
                    },
                    splashColor: Colors.redAccent,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Image.network(li3.list[i].icon),
                          SizedBox(height: 15),
                          Text(
                            li3.list[i].title,
                            style: new TextStyle(fontSize: 10.0),
                          )
                        ],
                      ),
                    ),
                  ),
                ),

            Card(
              elevation: 5.0,
              // color: Colors.redAccent[100],
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => VendorServiceList()));
                },
                splashColor: Colors.redAccent,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        Icons.border_color,
                        size: 25.0,
                      ),
                      SizedBox(height: 15),
                      Text(
                        "Services",
                        style: new TextStyle(fontSize: 10.0),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Card(
              elevation: 5.0,
              child: InkWell(
                splashColor: Colors.redAccent,
                onTap: () {
                  showDialog<void>(
                    context: context,
                    barrierDismissible: true, // user must tap button!
                    builder: (BuildContext context) {
                      return AlertDialog(
                          backgroundColor: Colors.white.withOpacity(0.98),
                          title: Center(
                            child: Text(
                              "Sales",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                          content: Container(
                            height: height / 3,
                            width: width,
                            child: GridView
                                .count(crossAxisCount: 3, children: <Widget>[
                              Card(
                                elevation: 5.0,
                                child: InkWell(
                                  splashColor: Colors.redAccent,
                                  onTap: () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                VendorBillList()));
                                  },
                                  //  splashColor: Colors.redAccent[100],
                                  borderRadius: BorderRadius.circular(15),
                                  child: Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Icon(
                                          Icons.build,
                                          size: 25.0,
                                        ),
                                        SizedBox(height: 15),
                                        Text(
                                          "Service Bill",
                                          style: new TextStyle(fontSize: 12.0),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Card(
                                elevation: 5.0,
                                child: InkWell(
                                  splashColor: Colors.redAccent,
                                  onTap: () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                VendorInvoiceList()));
                                  },
                                  //  splashColor: Colors.redAccent[100],
                                  borderRadius: BorderRadius.circular(15),
                                  child: Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Icon(
                                          Icons.assignment,
                                          size: 25.0,
                                        ),
                                        SizedBox(height: 15),
                                        Text(
                                          "Tax Invoice",
                                          style: new TextStyle(fontSize: 12.0),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                          ));
                    },
                  );
                },
                //  splashColor: Colors.redAccent[100],
                borderRadius: BorderRadius.circular(15),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        Icons.assignment,
                        size: 25.0,
                      ),
                      SizedBox(height: 15),
                      Text(
                        "Sales",
                        style: new TextStyle(fontSize: 12.0),
                      )
                    ],
                  ),
                ),
              ),
            ),

            Card(
              elevation: 5.0,
              child: InkWell(
                splashColor: Colors.redAccent,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EmployeeDamageList()));
                },
                //  splashColor: Colors.redAccent[100],
                borderRadius: BorderRadius.circular(15),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        Icons.broken_image,
                        size: 25.0,
                      ),
                      SizedBox(height: 15),
                      Text(
                        "Damage",
                        style: new TextStyle(fontSize: 12.0),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Card(
              elevation: 5.0,
              child: InkWell(
                splashColor: Colors.redAccent,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreditNoteList()));
                },
                //  splashColor: Colors.redAccent[100],
                borderRadius: BorderRadius.circular(15),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        Icons.note,
                        size: 25.0,
                      ),
                      SizedBox(height: 15),
                      Text(
                        "Credit Note",
                        style: new TextStyle(fontSize: 12.0),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Card(
              elevation: 5.0,
              child: InkWell(
                splashColor: Colors.redAccent,
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ComplaintList()));
                },
                //  splashColor: Colors.redAccent[100],
                borderRadius: BorderRadius.circular(15),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        Icons.warning_amber_sharp,
                        size: 25.0,
                      ),
                      SizedBox(height: 15),
                      Text(
                        "Complaints",
                        style: new TextStyle(fontSize: 12.0),
                      )
                    ],
                  ),
                ),
              ),
            ),

            Card(
              elevation: 5.0,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => VendorApprovalList()));
                },
                splashColor: Colors.redAccent,
                borderRadius: BorderRadius.circular(15),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        Icons.margin,
                        size: 25.0,
                      ),
                      SizedBox(height: 15),
                      Text(
                        "Approval",
                        style: new TextStyle(fontSize: 12.0),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Card(
              elevation: 5.0,
              child: InkWell(
                onTap: () {
                  showDialog<void>(
                    context: context,
                    barrierDismissible: true, // user must tap button!
                    builder: (BuildContext context) {
                      return AlertDialog(
                          backgroundColor: Colors.white.withOpacity(0.98),
                          title: Center(
                            child: Text(
                              "Tariff",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                          content: Container(
                            height: height / 3,
                            width: width,
                            child: GridView.count(
                                crossAxisCount: 3,
                                children: <Widget>[
                                  Card(
                                    elevation: 5.0,
                                    child: InkWell(
                                      splashColor: Colors.redAccent,
                                      onTap: () {
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    VendorTariffList()));
                                      },
                                      //  splashColor: Colors.redAccent[100],
                                      borderRadius: BorderRadius.circular(15),
                                      child: Center(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Icon(
                                              Icons.baby_changing_station,
                                              size: 25.0,
                                            ),
                                            SizedBox(height: 15),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Vendor Tariff",
                                                  style: new TextStyle(
                                                    fontSize: 12.0,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Card(
                                    elevation: 5.0,
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    VendorPlanTariffList()));
                                      },
                                      splashColor: Colors.redAccent,
                                      borderRadius: BorderRadius.circular(15),
                                      child: Center(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Icon(
                                              Icons.margin,
                                              size: 25.0,
                                            ),
                                            SizedBox(height: 15),
                                            Text(
                                              "Plan Tariff",
                                              style:
                                                  new TextStyle(fontSize: 12.0),
                                              textAlign: TextAlign.center,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ]),
                          ));
                    },
                  );
                },
                splashColor: Colors.redAccent,
                borderRadius: BorderRadius.circular(15),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        Icons.assignment_turned_in_outlined,
                        size: 25.0,
                      ),
                      SizedBox(height: 15),
                      Text(
                        "Tariff",
                        style: new TextStyle(fontSize: 12.0),
                      )
                    ],
                  ),
                ),
              ),
            ),
            // Card(
            //   elevation: 5.0,
            //   child: InkWell(
            //     onTap: () {
            //       Navigator.push(context,
            //           MaterialPageRoute(builder: (context) => VendorCustomerList()));
            //
            //     },
            //     splashColor: Colors.redAccent,
            //     borderRadius: BorderRadius.circular(15),
            //     child: Center(
            //       child: Column(
            //         mainAxisSize: MainAxisSize.min,
            //         children: <Widget>[
            //           Icon(
            //             Icons.margin,
            //             size: 25.0,
            //           ),
            //           SizedBox(height: 15),
            //           Text(
            //             "Customer",
            //             style: new TextStyle(fontSize: 12.0),
            //           )
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
            Card(
              elevation: 5.0,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => VendorStaffList()));
                },
                splashColor: Colors.redAccent,
                borderRadius: BorderRadius.circular(15),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        Icons.contacts,
                        size: 25.0,
                      ),
                      SizedBox(height: 15),
                      Text(
                        "Staff",
                        style: new TextStyle(fontSize: 12.0),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Card(
              elevation: 5.0,
              child: InkWell(
                splashColor: Colors.redAccent,
                onTap: () {
                  showDialog<void>(
                    context: context,
                    barrierDismissible: true, // user must tap button!
                    builder: (BuildContext context) {
                      return AlertDialog(
                          backgroundColor: Colors.white.withOpacity(0.98),
                          title: Center(
                            child: Text(
                              "Machines",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                          content: Container(
                            height: height / 3,
                            width: width,
                            child: GridView
                                .count(crossAxisCount: 3, children: <Widget>[
                              Card(
                                elevation: 5.0,
                                child: InkWell(
                                  splashColor: Colors.redAccent,
                                  onTap: () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ServiceStationList()));
                                  },
                                  //  splashColor: Colors.redAccent[100],
                                  borderRadius: BorderRadius.circular(15),
                                  child: Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Icon(
                                          Icons.baby_changing_station,
                                          size: 25.0,
                                        ),
                                        SizedBox(height: 15),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "My Service Stations",
                                              style: new TextStyle(
                                                fontSize: 12.0,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Card(
                                elevation: 5.0,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MachineList()));
                                  },
                                  splashColor: Colors.redAccent,
                                  borderRadius: BorderRadius.circular(15),
                                  child: Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Icon(
                                          Icons.margin,
                                          size: 25.0,
                                        ),
                                        SizedBox(height: 15),
                                        Text(
                                          "My Machines",
                                          style: new TextStyle(fontSize: 12.0),
                                          textAlign: TextAlign.center,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Card(
                                elevation: 5.0,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                RepairList()));
                                  },
                                  splashColor: Colors.redAccent,
                                  borderRadius: BorderRadius.circular(15),
                                  child: Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Icon(
                                          Icons.home_repair_service_outlined,
                                          size: 25.0,
                                        ),
                                        SizedBox(height: 15),
                                        Text(
                                          "Repair Request",
                                          style: new TextStyle(fontSize: 12.0),
                                          textAlign: TextAlign.center,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Card(
                                elevation: 5.0,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => SpareList()));
                                  },
                                  splashColor: Colors.redAccent,
                                  borderRadius: BorderRadius.circular(15),
                                  child: Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Icon(
                                          Icons.margin,
                                          size: 25.0,
                                        ),
                                        SizedBox(height: 15),
                                        Text(
                                          "Spare List",
                                          style: new TextStyle(fontSize: 12.0),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Card(
                                elevation: 5.0,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SpareRequestList()));
                                  },
                                  splashColor: Colors.redAccent,
                                  borderRadius: BorderRadius.circular(15),
                                  child: Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Icon(
                                          Icons.assessment,
                                          size: 25.0,
                                        ),
                                        SizedBox(height: 15),
                                        Text(
                                          "Spare Request List",
                                          style: new TextStyle(fontSize: 12.0),
                                          textAlign: TextAlign.center,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                          ));
                    },
                  );
                },
                //  splashColor: Colors.redAccent[100],
                borderRadius: BorderRadius.circular(15),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        Icons.donut_small_outlined,
                        size: 25.0,
                      ),
                      SizedBox(height: 15),
                      Text(
                        "Machine",
                        style: new TextStyle(fontSize: 12.0),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      appBar: AppBar(
        title: Image.asset('logotitle.png',height: 100,width:200),
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => WalletRequestList()));
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("wallet.png"),
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
        ],
      ),

      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text("Welcome"),
              accountEmail: Text(username),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.orange,
                child: Text(
                  username.substring(0, 1),
                  style: TextStyle(fontSize: 40.0),
                ),
              ),
            ),
            // ListTile(
            //   title: Text("Group"),
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //           builder: (context) => GroupList()),
            //     );
            //   },
            // ),
            // ListTile(
            //   title: Text("Bill List"),
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //           builder: (context) => BillList()),
            //     );
            //   },
            // ),
            // ListTile(
            //   title: Text("Checkout"),
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //           builder: (context) => CheckOutList()),
            //     );
            //   },
            // ),
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
            // ListTile(
            //   title: Text("Plan"),
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //           builder: (context) => PlanList()),
            //     );
            //   },
            // ),
            // ListTile(
            //   title: Text("Property"),
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //           builder: (context) => PropertyList()),
            //     );
            //   },
            // ),
            // ListTile(
            //   title: Text("Offer"),
            //   onTap: () {
            //     Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //             builder: (context) => OfferList())
            //     );
            //   },
            // ),
          ],
        ),
      ),
    );
  }

  void pageswitch(String title, List<Children> children) {
    switch (title) {
      case "Services":
        if (children.length == 0)
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => VendorServiceList()));
        else
          showDialog<void>(
              context: context,
              barrierDismissible: true, // user must tap button!
              builder: (BuildContext context) {
                return AlertDialog(
                    backgroundColor: Colors.white.withOpacity(0.98),
                    title: Center(
                      child: Text(
                        title,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    content: Container(
                      height: MediaQuery.of(context).size.height / 3,
                      width: MediaQuery.of(context).size.width,
                      child:
                          GridView.count(crossAxisCount: 3, children: <Widget>[
                        for (int i = 0; i < children.length; i++)
                          Card(
                            elevation: 5.0,
                            child: InkWell(
                              splashColor: Colors.redAccent,
                              onTap: () {},
                              //  splashColor: Colors.redAccent[100],
                              borderRadius: BorderRadius.circular(15),
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Image.network(children[i].icon),
                                    SizedBox(height: 15),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          children[i].title,
                                          style: new TextStyle(
                                            fontSize: 12.0,
                                          ),
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
        break;
      case "Damage":
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => EmployeeDamageList()));
        break;

      case "Machine":
        if (children.length == 0)
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => VendorServiceList()));
        else
          showDialog<void>(
              context: context,
              barrierDismissible: true, // user must tap button!
              builder: (BuildContext context) {
                return AlertDialog(
                    backgroundColor: Colors.white.withOpacity(0.98),
                    title: Center(
                      child: Text(
                        title,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    content: Container(
                      height: MediaQuery.of(context).size.height / 3,
                      width: MediaQuery.of(context).size.width,
                      child:
                          GridView.count(crossAxisCount: 3, children: <Widget>[
                        for (int i = 0; i < children.length; i++)
                          Card(
                            elevation: 5.0,
                            child: InkWell(
                              splashColor: Colors.redAccent,
                              onTap: () {
                                childrenwitch(children[i].title);
                              },
                              //  splashColor: Colors.redAccent[100],
                              borderRadius: BorderRadius.circular(15),
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Image.network(children[i].icon),
                                    SizedBox(height: 15),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          children[i].title,
                                          style: new TextStyle(
                                            fontSize: 12.0,
                                          ),
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
        break;
      case "Sales":
        if (children.length == 0)
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => VendorServiceList()));
        else
          showDialog<void>(
              context: context,
              barrierDismissible: true, // user must tap button!
              builder: (BuildContext context) {
                return AlertDialog(
                    backgroundColor: Colors.white.withOpacity(0.98),
                    title: Center(
                      child: Text(
                        title,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    content: Container(
                      height: MediaQuery.of(context).size.height / 3,
                      width: MediaQuery.of(context).size.width,
                      child:
                          GridView.count(crossAxisCount: 3, children: <Widget>[
                        for (int i = 0; i < children.length; i++)
                          Card(
                            elevation: 5.0,
                            child: InkWell(
                              splashColor: Colors.redAccent,
                              onTap: () {
                                childrenwitch(children[i].title);
                              },
                              //  splashColor: Colors.redAccent[100],
                              borderRadius: BorderRadius.circular(15),
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Image.network(children[i].icon),
                                    SizedBox(height: 15),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          children[i].title,
                                          style: new TextStyle(
                                            fontSize: 12.0,
                                          ),
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
        break;

      case "Tariff":
        if (children.length == 0)
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => VendorServiceList()));
        else
          showDialog<void>(
              context: context,
              barrierDismissible: true, // user must tap button!
              builder: (BuildContext context) {
                return AlertDialog(
                    backgroundColor: Colors.white.withOpacity(0.98),
                    title: Center(
                      child: Text(
                        title,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    content: Container(
                      height: MediaQuery.of(context).size.height / 3,
                      width: MediaQuery.of(context).size.width,
                      child:
                          GridView.count(crossAxisCount: 3, children: <Widget>[
                        for (int i = 0; i < children.length; i++)
                          Card(
                            elevation: 5.0,
                            child: InkWell(
                              splashColor: Colors.redAccent,
                              onTap: () {
                                childrenwitch(children[i].title);
                              },
                              //  splashColor: Colors.redAccent[100],
                              borderRadius: BorderRadius.circular(15),
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Image.network(children[i].icon),
                                    SizedBox(height: 15),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          children[i].title,
                                          style: new TextStyle(
                                            fontSize: 12.0,
                                          ),
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
        break;

      case "Complaints":
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ComplaintList()));

        break;
      case "Approval List":
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => VendorApprovalList()));

        break;
      case "My Staff":
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => VendorStaffList()));
        break;
      case "Credit Note":
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => CreditNoteList()));
        break;
    }
  }

  void childrenwitch(String title) {
    switch (title) {
      case "Service Bill":
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => VendorBillList()));
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
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MachineList()));
        break;
      case "Repair Request":
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => RepairList()));
        break;
      case "Spare List":
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => SpareList()));
        break;
      case "Spare Request List":
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => SpareRequestList()));
        break;
    }
  }
}
