import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tankcare/Customer/register.dart';
import 'package:tankcare/CustomerModels/profile.dart';
import 'package:tankcare/FRANCHISE/ApprovalList.dart';
import 'package:tankcare/Vendor/Login/Login.dart';
import 'package:tankcare/string_values.dart';

class FranchaiseDashboard extends StatefulWidget {
  @override
  FranchaiseDashboardState createState() => FranchaiseDashboardState();
}

class FranchaiseDashboardState extends State<FranchaiseDashboard> {
  Profile li;
  static String refcode;
  static String username = "  ";

  bool loading = false;

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
      });
      setState(() {
        loading = false;
      });
    }

    print("response: ${response.statusCode}");
    print("response: ${response.body}");
    return response;
  }

  void initState() {
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
            Card(
              elevation: 5.0,
              // color: Colors.redAccent[100],
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FranchaiseApprovalList()));
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
                        "Approval",
                        style: new TextStyle(fontSize: 10.0),
                      )
                    ],
                  ),
                ),
              ),
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
                  MaterialPageRoute(builder: (context) => VendorLoginPage()),
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
}
