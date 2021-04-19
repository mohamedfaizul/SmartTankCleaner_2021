import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tankcare/Customer/forgotpass.dart';
import 'package:tankcare/Customer/register.dart';
import 'package:tankcare/DISTRICT%20VENDOR/Dashboard.dart';
import 'package:tankcare/Director/Dashboard.dart';
import 'package:tankcare/FINANCE%20TEAM/Dashboard.dart';
import 'package:tankcare/FRANCHISE/Dashboard.dart';
import 'package:tankcare/RM/Dashboard.dart';
import 'package:tankcare/Vendor/Dashboard.dart';
import 'package:tankcare/VendorModels/Login.dart';
import 'package:tankcare/string_values.dart';

class VendorLoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: VendorLoginPages(),
    );
  }
}

class VendorLoginPages extends StatefulWidget {
  @override
  VendorLoginPagesState createState() => VendorLoginPagesState();
}

class VendorLoginPagesState extends State<VendorLoginPages> {
  bool _isHidden = true;
  static String Userrole;
  bool loading = false;

  LoginRes li;

  String errortextemail;
  String errortextpass;

  bool validateE = false;

  bool validateP = false;

  var character = "Employee";

  Future<bool> setRegistered(userid, token, email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userid', userid);
    await prefs.setString('token', token);
    await prefs.setString('email', email);
    await prefs.setBool('seen', true);
    return true;
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

  Future<int> uploadImage(url) async {
    setState(() {
      loading = true;
    });
    Map<String, String> headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer ${RegisterPagesState.token}'
    };

    var request = http.MultipartRequest(
        'POST', Uri.parse(String_values.base_url + 'user-login'));
    request.headers.addAll(headers);
    request.fields['uname'] = emailController.text;
    request.fields['password'] = passwordController.text;

    var response = await request.send();
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);

      li = LoginRes.fromJson(json.decode(value));
      setState(() {
        loading = false;
      });

      if (li.status) {
        Userrole = li.uroleName;
        setRegistered(li.uid, li.token, emailController.text);
        RegisterPagesState.cus_id = li.uid;
        RegisterPagesState.token = li.token;
        if (li.uroleName == "VENDOR")
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => VendorDashboard()));
        else if (li.uroleName == "RM")
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => RMDashboard()));
        else if (li.uroleName == "FRANCHISE")
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => FranchaiseDashboard()));
        else if (li.uroleName == "DVENDOR")
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => DistrictVendorDashboard()));
        else if (li.uroleName == "FINANCE TEAM")
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => FinanceDashboard()));
        else if (li.uroleName == "DIRECTOR")
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      DirectorDashboard())); // if(li.accVerify=="N")
        //   Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) =>OTPPage()),
        //   );
        // else
        // {
        //   setRegistered(li.uid, li.token,emailController.text);
        //   RegisterPagesState.cus_id=li.uid;
        //   RegisterPagesState.token=li.token;
        //   Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => Home()),
        //   );
        // }

      } else
        showDialog<void>(
            context: context,
            barrierDismissible: false, // user must tap button!
            builder: (BuildContext context) {
              return AlertDialog(
                content: li.messages.length != 0
                    ? Text(li.messages[0])
                    : Text(li.alert),
                actions: <Widget>[
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            });

      // showDialog(
      //     context: context,
      //     builder:(_) =>AlertDialog(
      //       title: Text(
      //         li.alert,
      //         style: TextStyle(color: Colors.red),
      //
      //       ),
      //       content:Text(
      //           li.alert,
      //           style: TextStyle(color: Colors.red),)
      //     ));
      setState(() {
        loading = false;
      });
    });
  }

  Future<http.Response> postRequest() async {
    setState(() {
      loading = true;
    });
    var url;

    url = String_values.base_url + 'user-login';
    Map data = {
      "uname": emailController.text,
      "password": passwordController.text
    };
    print("data: ${data}");
    print(url);
    //encode Map to JSON
    var body = json.encode(data);
    print("response: ${body}");
    var response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          //   'Authorization':
          //       'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1aWQiOiIxIiwidXR5cGUiOiJFTVAifQ.AhfTPvo5C_rCMIexbUd1u6SEoHkQCjt3I7DVDLwrzUs'
          //
        },
        body: body);
    if (response.statusCode == 200) {
      li = LoginRes.fromJson(json.decode(response.body));
      setState(() {
        loading = false;
      });

      if (li.status) {
        setRegistered(li.uid, li.token, emailController.text);
        RegisterPagesState.cus_id = li.uid;
        RegisterPagesState.token = li.token;
        if (li.uroleName == "VENDOR")
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => VendorDashboard()));
        if (li.uroleName == "DVENDOR")
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => DistrictVendorDashboard()));
        if (li.uroleName == "FRANCHISE")
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => FranchaiseDashboard()));
        if (li.uroleName == "RM")
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => RMDashboard()));

        // if(li.accVerify=="N")
        //   Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) =>OTPPage()),
        //   );
        // else
        // {
        //   setRegistered(li.uid, li.token,emailController.text);
        //   RegisterPagesState.cus_id=li.uid;
        //   RegisterPagesState.token=li.token;
        //   Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => Home()),
        //   );
        // }

      } else
        showDialog<void>(
            context: context,
            barrierDismissible: false, // user must tap button!
            builder: (BuildContext context) {
              return AlertDialog(
                content: li.messages.length != 0
                    ? Text(li.messages[0])
                    : Text(li.alert),
                actions: <Widget>[
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            });

      // showDialog(
      //     context: context,
      //     builder:(_) =>AlertDialog(
      //       title: Text(
      //         li.alert,
      //         style: TextStyle(color: Colors.red),
      //
      //       ),
      //       content:Text(
      //           li.alert,
      //           style: TextStyle(color: Colors.red),)
      //     ));

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

  void _toggleVisibility() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  static TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: loading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: height / 6,
                  ),
                  new Container(
                    child: Image.asset('logo.png'),
                    width: 180,
                    height: 180,
                  ),

                  SizedBox(
                    height: height / 50,
                  ),
                  /*

            Text(
              "TANK CARE SOLUTIONS",
              style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),*/
                  // Container(
                  //
                  //   decoration: BoxDecoration(
                  //     color: Colors.red.shade100,
                  //     borderRadius: BorderRadius.circular(10.0),
                  //   ),
                  //   child: Column(
                  //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //     children: [
                  //
                  //       Row(
                  //         mainAxisAlignment: MainAxisAlignment.start,
                  //         children: [
                  //           Padding(
                  //             padding: const EdgeInsets.only(left:16.0,right: 16.0,top: 16.0,bottom: 10),
                  //             child: Text("Select Role",style: TextStyle(fontSize: 20,color: Colors.black,fontWeight: FontWeight.w600),),
                  //           ),
                  //         ],
                  //       ),
                  //       Row(
                  //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //         children: [
                  //           Row(
                  //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //             children: [    Radio(
                  //                 value: "Employee",
                  //                 groupValue: character,
                  //                 onChanged: (value) {
                  //                   setState(() {
                  //                     character = value;
                  //                     print(character);
                  //                   });
                  //                 }), Text('Employee',style: TextStyle(fontSize: 16,color: Colors.black),),],),
                  //
                  //           Row(
                  //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //             children: [    Radio(
                  //                 value: "Vendor",
                  //                 groupValue: character,
                  //                 onChanged: (value) {
                  //                   setState(() {
                  //                     character = value;
                  //                     print(character);
                  //                   });
                  //                 }), Text('Vendor',style: TextStyle(fontSize: 16,color: Colors.black),),],)
                  //
                  //         ],
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  SizedBox(
                    height: height / 40,
                  ),
                  buildTextField("Email or Mobile Number"),
                  SizedBox(
                    height: height / 30,
                  ),
                  TextField(
                    obscureText: true,
                    controller: passwordController,
                    onTap: () {
                      setState(() {
                        errortextpass = null;
                      });
                    },
                    decoration: InputDecoration(
                      errorText: validateP ? errortextpass : null,
                      labelText: 'Password',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 16.0,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height / 30,
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {},
                          child: Padding(
                            padding: const EdgeInsets.only(right: 24.0),
                            child: InkWell(
                              child: Container(
                                padding: const EdgeInsets.all(16.0),
                                child: Text("Forgot Password?"),
                              ),
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ForgotPasswordPage()),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: height / 30,
                  ),

                  ButtonContainer(),
                  // buildButtonContainer(),

                  SizedBox(
                    height: height / 30,
                  ),
                  //
                  // Container(
                  //   child: Center(
                  //     child: InkWell(
                  //       onTap: (){
                  //         Navigator.pushReplacement(
                  //           context,
                  //           MaterialPageRoute(
                  //               builder: (context) =>RegisterPage()),
                  //         );
                  //       },
                  //       child: Container(
                  //         padding:const EdgeInsets.all(16.0),
                  //         child: Text("Create an Account",style: TextStyle(color: Colors.red,fontWeight: FontWeight.w600),),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
    );
  }

  Widget buildTextField(String hintText) {
    return TextField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      onTap: () {
        setState(() {
          errortextemail = null;
        });
      },
      decoration: InputDecoration(
        errorText: validateE ? errortextemail : null,
        labelText: hintText,
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: 16.0,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        suffixIcon: hintText == "Password"
            ? IconButton(
                onPressed: _toggleVisibility,
                icon: _isHidden
                    ? Icon(Icons.visibility_off)
                    : Icon(Icons.visibility),
              )
            : null,
      ),
      obscureText: hintText == "Password" ? _isHidden : false,
    );
  }

  Widget ButtonContainer() {
    return Container(
        width: MediaQuery.of(context).size.width / 1.5,
        height: 40,
        child: FlatButton(
          child: Text('Login'),
          color: Colors.redAccent,
          textColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          onPressed: () {
            setState(() {
              if (emailController.text.trim().isNotEmpty) {
                validateE = false;
              } else {
                validateE = true;
                errortextemail = "Email cannot be empty";
              }
              if (passwordController.text.isEmpty ||
                  passwordController.text.trim().length < 6) {
                if (passwordController.text.isEmpty)
                  errortextpass = "Password cannot be empty";
                else
                  errortextpass = "Password should be minimum of 6 characters";
                validateP = true;
              } else
                validateP = false;

              if (validateE == false && validateP == false)
                check().then((value) {
                  if (value)
                    uploadImage("");
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
            });

            //  Navigator.push(context, MaterialPageRoute(builder: (context) => SecondRoute extends StatelessWidget());
          },
        ));
  }
}
