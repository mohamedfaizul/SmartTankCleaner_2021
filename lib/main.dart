import 'dart:convert';

import 'package:documents_picker/documents_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tankcare/Customer/CustomerGroupList.dart';
import 'package:tankcare/Customer/GroupList.dart';
import 'package:tankcare/Customer/PlanList.dart';
import 'package:tankcare/Customer/PropertyList.dart';
import 'package:tankcare/Customer/ReferalList.dart';
import 'package:tankcare/Customer/ServiceList.dart';
import 'package:tankcare/Customer/billlist.dart';
import 'package:tankcare/Customer/checkoutlist.dart';
import 'package:tankcare/Customer/login.dart';
import 'package:tankcare/Customer/register.dart';
import 'package:tankcare/CustomerModels/profile.dart';
import 'package:tankcare/Employee/Login/Login.dart';
import 'package:tankcare/string_values.dart';

import 'package:tankcare/Employee/Dashboard.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static bool _seen = false;
  Map<int, Color> color =
  {
    50:Color.fromRGBO(229,115,115, .1),
    100:Color.fromRGBO(229,115,115, .2),
    200:Color.fromRGBO(229,115,115, .3),
    300:Color.fromRGBO(229,115,115, .4),
    400:Color.fromRGBO(229,115,115, .5),
    500:Color.fromRGBO(229,115,115, .6),
    600:Color.fromRGBO(229,115,115, .7),
    700:Color.fromRGBO(229,115,115, .8),
    800:Color.fromRGBO(229,115,115, .9),
    900:Color.fromRGBO(229,115,115, 1),
  };

  static String role;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    MaterialColor colorCustom = MaterialColor(0xFFFF7373, color);
    Future<bool> checkFirstSeen() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _seen = (prefs.getBool('seen') ?? false);
      if (_seen) {
        RegisterPagesState.cus_id = prefs.getString("userid");
        RegisterPagesState.token = prefs.getString("token");
        LoginPagesState.emailController.text = prefs.getString("email");
        role = prefs.getString("role");
        print('Open sequence: Not First Time');
        print(RegisterPagesState.cus_id);
        print(RegisterPagesState.token);
      } else {
        // Set the flag to true at the end of onboarding screen if everything is successfull and so I am commenting it out
        // await prefs.setBool('seen', true);
        print('Open sequence: First Time');
      }
      return _seen;
    }

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.red,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FutureBuilder(
        future: checkFirstSeen(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data);
            print(role);
            //  return PlanService();
            return snapshot.data ? EmployeeDashboard(firsttime: true,) : EmployeeLoginPage();
            //   return snapshot.data? VendorDashboard():VendorLoginPage();
             return snapshot.data ? Home() : LoginPage();
            //    return MyHomePage();
          }
          return Container(); // noop, this builder is called again when the future completes
        },
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
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
    Future<void> share() async {
      await Share.share('Join on Tank Care by clicking https://www.minmegam.com, a secure app for tank,sump,car and bike services. Enter my code "${refcode}" to earn rewards! ',

      );
    }

    // Future<void> shareFile() async {
    //   List<dynamic> docs = await DocumentsPicker.pickDocuments;
    //   if (docs == null || docs.isEmpty) return null;
    //
    //   await FlutterShare.shareFile(
    //     title: 'Example share',
    //     text: 'Example share text',
    //     filePath: docs[0] as String,
    //   );
    // }

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      //backgroundColor: Colors.redAccent[100],
      body: loading
          ? Center(child: CircularProgressIndicator())
          : Container(
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
                                builder: (context) => CustomerGroupList()));
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
                              "Group",
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PropertyList()));
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
                              "Property",
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
                                builder: (context) => PlanList()));
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
                              "Plan",
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
                                builder: (context) => ServiceList()));
                      },
                      splashColor: Colors.redAccent,
                      borderRadius: BorderRadius.circular(15),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(
                              Icons.attach_money,
                              size: 25.0,
                            ),
                            SizedBox(height: 15),
                            Text(
                              "Service",
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
                                builder: (context) => BillList()));
                      },
                      splashColor: Colors.redAccent,
                      borderRadius: BorderRadius.circular(15),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(
                              Icons.feedback,
                              size: 25.0,
                            ),
                            SizedBox(height: 15),
                            Text(
                              "Bill List",
                              style: new TextStyle(fontSize: 11.0),
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
                                builder: (context) => CheckOutList()));
                      },
                      splashColor: Colors.redAccent,
                      borderRadius: BorderRadius.circular(15),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(
                              Icons.mode_comment,
                              size: 25.0,
                            ),
                            SizedBox(height: 15),
                            Text(
                              "Checkout",
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
                                builder: (context) => ReferalList()));
                      },
                      //  splashColor: Colors.redAccent[100],
                      borderRadius: BorderRadius.circular(15),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(
                              Icons.share,
                              size: 25.0,
                            ),
                            SizedBox(height: 15),
                            Text(
                              "Referrals",
                              style: new TextStyle(fontSize: 12.0),
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
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
                icon: Icon(Icons.share),
                onPressed: () {
                  share();
                }),
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
                  MaterialPageRoute(builder: (context) => LoginPages()),
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
