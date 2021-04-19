import 'dart:convert';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:tankcare/Customer/ComplaintDetail.dart';
import 'package:tankcare/Customer/DamageDetail.dart';
import 'package:tankcare/Customer/ReferalList.dart';
import 'package:tankcare/Customer/ServiceDetail.dart';
import 'package:tankcare/Customer/billdetail.dart';
import 'package:tankcare/Customer/register.dart';
import 'package:tankcare/CustomerModels/Property_List_Model.dart';
import 'package:tankcare/CustomerModels/billlist.dart';
import 'package:tankcare/CustomerModels/grouplist.dart';
import 'package:tankcare/CustomerModels/planlist.dart';
import 'package:tankcare/Employee/EmployeeModels/Customers/Customer360.dart';
import 'package:tankcare/Employee/EmployeeModels/Customers/ReferalListings.dart';
import 'package:tankcare/Employee/EmployeeModels/ErrorResponse.dart';
import 'package:tankcare/Employee/EmployeeModels/Property/Group/GroupAddSelCus.dart';
import 'package:tankcare/Employee/EmployeeModels/Property/Property/GroupNameFromCus.dart';
import 'package:tankcare/Employee/Supervisor/Property/Group/GroupDetail.dart';
import 'package:tankcare/Employee/Supervisor/Property/Property%20Plan/PlanDetail.dart';
import 'package:tankcare/Employee/Supervisor/Property/Property/PropertyDetail.dart';
import 'package:tankcare/Employee/Supervisor/Services/FeedBackDetail.dart';
import 'package:tankcare/string_values.dart';

class EmployeeCustomer360 extends StatefulWidget {
  final String title = "AutoComplete Demo";

  @override
  EmployeeCustomer360State createState() => EmployeeCustomer360State();
}

class EmployeeCustomer360State extends State<EmployeeCustomer360> {
  bool valueinfeetshow = true;

  bool heightshow = true;
  bool widthshow = true;
  bool lengthshow = true;
  bool buttonshow = true;
  List<File> files = [];
  String groupid;
  List<String> stringlist = [
    '-- Property Type --',
    "Tank",
    "OverHead Tank",
    "Sump",
    "Sump-Tile",
    "Car",
    "Bike",
    "Floor",
    "OverHead Tank Tile"
  ];

  String propertyunit = "feet";

  File image;

  static String cusid;

  ErrorResponse ei;

  Customer360Model li;

  PropertyListings li2;

  PlanListings li3;

  GroupListings li4;

  ReferalListings li5;

  BillListings li6;

  var enable=false;

  Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  @override
  void initState() {

    super.initState();
  }


  bool loading = false;

  final TextEditingController _typeAheadController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    Future<http.Response> postRequest() async {
      setState(() {
        loading = true;
      });

      var url = String_values.base_url + 'cus-360/$cusid';

      print(url);
      var response = await http.get(url,
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer ${RegisterPagesState.token}'
          },);
      if (response.statusCode == 200) {
        setState(() {
          loading = false;
        });
        // li = VendorCustomerListModel.fromJson(json.decode(response.body));
        li=Customer360Model.fromJson(json.decode(response.body));

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
    Future<http.Response> Propertylist() async {
      setState(() {
        loading = true;
      });


      var url = String_values.base_url +
          'property-list?cus_id=$cusid';
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
        li2 = PropertyListings.fromJson(json.decode(response.body));
        // print("plan${li.items[0].propertyName}");
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
    Future<http.Response> Planlist() async {
      setState(() {
        loading = true;
      });


      var url = String_values.base_url +
          'property-cus-plan?cus_id=$cusid';
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
        li3 = PlanListings.fromJson(json.decode(response.body));
        // print("plan${li.items[0].propertyName}");
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
    Future<http.Response> Grouplist() async {
      setState(() {
        loading = true;
      });


      var url = String_values.base_url +
          'group-list?cus_id=$cusid';
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
        li4 = GroupListings.fromJson(json.decode(response.body));
        // print("plan${li.items[0].propertyName}");
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
    Future<http.Response> Referallist() async {
      setState(() {
        loading = true;
      });


      var url = String_values.base_url +
          'ref-discount-list?cus_id=$cusid';
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
        li5 = ReferalListings.fromJson(json.decode(response.body));
        // print("plan${li.items[0].propertyName}");
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
    Future<http.Response> Paymentlist() async {
      setState(() {
        loading = true;
      });


      var url = String_values.base_url +
          'plan-bill-list?cus_id=$cusid';
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
        li6 = BillListings.fromJson(json.decode(response.body));
        // print("plan${li.items[0].propertyName}");
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
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: loading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
          child: new Column(children: <Widget>[
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
                    "Customer 360",
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
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: TypeAheadFormField(
                textFieldConfiguration: TextFieldConfiguration(
                  enabled: true,
                  controller: this._typeAheadController,
                  // onTap: ()
                  // {
                  //   Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //           builder: (context) =>
                  //               Category(userid:HomeState.userid,mapselection: true)));
                  // },
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Select Customer Name',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 16.0,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
                suggestionsCallback: (pattern) {
                  return BackendService.getSuggestions(pattern);
                },
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    title: Text(suggestion),
                  );
                },
                transitionBuilder: (context, suggestionsBox, controller) {
                  return suggestionsBox;
                },
                onSuggestionSelected: (suggestion) {
                  // postRequest(suggestion);
                  for (int i = 0; i < BackendService.li1.data.length; i++) {
                    print(BackendService.li1.data[i].cusName);
                    if (BackendService.li1.data[i].cusName == suggestion) {
                      cusid = BackendService.li1.data[i].cusId;
                      postRequest().then((value) => Propertylist().then((value) => Planlist().then((value) => Grouplist().then((value) => Referallist().then((value) => Paymentlist())))));
                   setState(() {
                     enable=true;
                   });

                    }
                  }
                  this._typeAheadController.text = suggestion;
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please select a city';
                  } else
                    return 'nothing';
                },
                // onSaved: (value) => this._selectedCity = value,
              ),
            ),
            SizedBox(
              height: height / 40,
            ),
            Visibility(
              visible: enable,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: width,
                    color:Colors.red,
                    child: Text("Customer Details",style: TextStyle(color: Colors.white),),padding: EdgeInsets.all(16),
                  ),
                  SizedBox(height: 10),
                  li!=null?Padding(
                    padding: const EdgeInsets.only(left:16.0,right:16.0,top:10),
                    child: Text("Name : ${li.data.cusName.toString()+'-'+li.data.cusCode.toString()}"),
                  ):Container(),
                  li!=null?Padding(
                    padding: const EdgeInsets.only(left:16.0,right:16.0,top:10),
                    child: Text("Mobile : ${li.data.cusPhone.toString()}"),
                  ):Container(),
                  li!=null?Padding(
                    padding: const EdgeInsets.only(left:16.0,right:16.0,top:10),
                    child: Text("Address : ${li.data.cusAddress.toString()}"),
                  ):Container(),
                  // Text(li.data.gm.uphone.toString()),
                  //
                  li!=null?li.data.service!=null  ?Container(
                      margin: const EdgeInsets.only(top: 10),
                      color: Colors.red.shade50,
                      child: ExpansionTile(
                        expandedCrossAxisAlignment: CrossAxisAlignment.start,
                        backgroundColor: Colors.white,
                        initiallyExpanded: false,
                        title: Text(
                          "Service Details",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, color: Colors.red),
                        ),
                        children:[
                          li.data.service.pENDING!=null?Center(
                          child: Container(
                            width:width-32,
                              margin: const EdgeInsets.only(top: 10),
                              color: Colors.red.shade50,
                              child: ExpansionTile(
                                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                                backgroundColor: Colors.white,
                                initiallyExpanded: false,
                                title: Text(
                                  "Pending(${li.data.service.pENDING.length})",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600, color: Colors.red),
                                ),
                                children: [
                                  for(int i=0;i<li.data.service.pENDING.length;i++)
                                    Container(
                                      width: width,
                                      child: InkWell(
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Text((i+1).toString()+". "+li.data.service.pENDING[i].pserviceCode+'-'+li.data.service.pENDING[i].propertyCode,textAlign: TextAlign.start,),
                                        ),
                                        onTap: (){
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ServiceDetail(
                                                          serviceid:
                                                          li.data.service.pENDING[i].pserviceId)));
                                          Fluttertoast.showToast(
                                              msg: li.data.service.pENDING[i].pserviceCode,
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.SNACKBAR,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.red,
                                              textColor: Colors.white,
                                              fontSize: 16.0
                                          );
                                        },
                                      ),
                                    )
                                ],)),
                        ):Center(
                          child: Container(
                              width:width-32,
                              margin: const EdgeInsets.only(top: 10),
                              color: Colors.red.shade50,
                              child: ExpansionTile(
                                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                                backgroundColor: Colors.white,
                                initiallyExpanded: false,
                                title: Text(
                                  "Pending(0)",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600, color: Colors.red),
                                ),)),
                        ),
                          li.data.service.oNGOING!=null?Center(
                            child: Container(
                                width:width-32,
                                margin: const EdgeInsets.only(top: 10),
                                color: Colors.red.shade50,
                                child: ExpansionTile(
                                  expandedCrossAxisAlignment: CrossAxisAlignment.start,
                                  backgroundColor: Colors.white,
                                  initiallyExpanded: false,
                                  title: Text(
                                    "Ongoing(${li.data.service.oNGOING.length})",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600, color: Colors.red),
                                  ),
                                  children: [
                                    for(int i=0;i<li.data.service.oNGOING.length;i++)
                              Container(
                              width: width,
                              child: InkWell(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text((i+1).toString()+". "+li.data.service.oNGOING[i].pserviceCode+'-'+li.data.service.oNGOING[i].propertyCode,textAlign: TextAlign.start,),
                                        ),
                                        onTap: (){
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ServiceDetail(
                                                          serviceid:
                                                          li.data.service.oNGOING[i].pserviceId)));
                                          Fluttertoast.showToast(
                                              msg: li.data.service.oNGOING[i].pserviceCode,
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.SNACKBAR,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.red,
                                              textColor: Colors.white,
                                              fontSize: 16.0
                                          );
                                        },
                                      )
                              )],)),
                          ):Center(
                            child: Container(
                                width:width-32,
                                margin: const EdgeInsets.only(top: 10),
                                color: Colors.red.shade50,
                                child: ExpansionTile(
                                  expandedCrossAxisAlignment: CrossAxisAlignment.start,
                                  backgroundColor: Colors.white,
                                  initiallyExpanded: false,
                                  title: Text(
                                    "Ongoing(0)",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600, color: Colors.red),
                                  ),)),
                          ),
                          li.data.service.cOMPLETED!=null?Center(
                            child: Container(
                                width:width-32,
                                margin: const EdgeInsets.only(top: 10),
                                color: Colors.red.shade50,
                                child: ExpansionTile(
                                  expandedCrossAxisAlignment: CrossAxisAlignment.start,
                                  backgroundColor: Colors.white,
                                  initiallyExpanded: false,
                                  title: Text(
                                    "Completed(${li.data.service.cOMPLETED.length})",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600, color: Colors.red),
                                  ),
                                  children: [
                                    for(int i=0;i<li.data.service.cOMPLETED.length;i++)
                              Container(
                              width: width,
                              child: InkWell(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text((i+1).toString()+". "+li.data.service.cOMPLETED[i].pserviceCode+'-'+li.data.service.cOMPLETED[i].propertyCode,textAlign: TextAlign.start,),
                                        ),
                                        onTap: (){
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ServiceDetail(
                                                          serviceid:
                                                          li.data.service.cOMPLETED[i].pserviceId)));
                                          Fluttertoast.showToast(
                                              msg: li.data.service.cOMPLETED[i].pserviceCode,
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.SNACKBAR,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.red,
                                              textColor: Colors.white,
                                              fontSize: 16.0
                                          );
                                        },
                                      )
                              )],)),
                          ):Center(
                            child: Container(
                                width:width-32,
                                margin: const EdgeInsets.only(top: 10),
                                color: Colors.red.shade50,
                                child: ExpansionTile(
                                  expandedCrossAxisAlignment: CrossAxisAlignment.start,
                                  backgroundColor: Colors.white,
                                  initiallyExpanded: false,
                                  title: Text(
                                    "Completed(0)",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600, color: Colors.red),
                                  ),)),
                          ),
                          SizedBox(height: height/20,)
                        ] )):Container(
                      width:width,
                      margin: const EdgeInsets.only(top: 10),
                      color: Colors.red.shade50,
                      child: ExpansionTile(
                      expandedCrossAxisAlignment: CrossAxisAlignment.start,
                      backgroundColor: Colors.white,
                      initiallyExpanded: false,
                      title: Text(
                        "Service Details(0)",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, color: Colors.red),
                      ))):Container(
                    width:width-32,
                    margin: const EdgeInsets.only(top: 10),
                    color: Colors.red.shade50,
                    child: ExpansionTile(
                      expandedCrossAxisAlignment: CrossAxisAlignment.start,
                      backgroundColor: Colors.white,
                      initiallyExpanded: false,
                      title: Text(
                        "Service Details(0)",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, color: Colors.red),
                      ))),
                  li2!=null?Center(
                    child: Container(
                        margin: const EdgeInsets.only(top: 10),
                        color: Colors.red.shade50,
                        child: ExpansionTile(
                          expandedCrossAxisAlignment: CrossAxisAlignment.start,
                          backgroundColor: Colors.white,
                          initiallyExpanded: false,
                          title: Text(
                            "Property(${li2.items.length})",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, color: Colors.red),
                          ),
                          children: [
                            for(int i=0;i<li2.items.length;i++)
                      Container(
                      width: width,
                      child: InkWell(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text((i+1).toString()+". "+li2.items[i].propertyCode.toString()+'-'+li2.items[i].propertyName.toString(),textAlign: TextAlign.start,),
                                ),
                                onTap: (){
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              EmployeePropertyView(
                                                  propertyid:
                                                  li2.items[i].propertyId)));
                                  Fluttertoast.showToast(
                                      msg: li2.items[i].propertyCode.toString(),
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.SNACKBAR,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0
                                  );
                                },
                              )
                      )],)),
                  ):Container(),
                  li3!=null?Center(
                    child: Container(
                        margin: const EdgeInsets.only(top: 10),
                        color: Colors.red.shade50,
                        child: ExpansionTile(
                          expandedCrossAxisAlignment: CrossAxisAlignment.start,
                          backgroundColor: Colors.white,
                          initiallyExpanded: false,
                          title: Text(
                            "Plan(${li3.items.length})",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, color: Colors.red),
                          ),
                          children: [
                            for(int i=0;i<li3.items.length;i++)
                      Container(
                      width: width,
                      child: InkWell(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text((i+1).toString()+". "+li3.items[i].cusCode.toString()+'-'+li3.items[i].pplanName.toString(),textAlign: TextAlign.start,),
                                ),
                                onTap: (){
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              EmployeePlanDetail(
                                                  planid:
                                                  li3.items[i].pplanId)));
                                  Fluttertoast.showToast(
                                      msg: li3.items[i].pplanName.toString(),
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.SNACKBAR,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0
                                  );
                                },
                              )
                      )],)),
                  ):Container(),
                  li4!=null?Center(
                    child: Container(
                        margin: const EdgeInsets.only(top: 10),
                        color: Colors.red.shade50,
                        child: ExpansionTile(
                          expandedCrossAxisAlignment: CrossAxisAlignment.start,
                          backgroundColor: Colors.white,
                          initiallyExpanded: false,
                          title: Text(
                            "Group(${li4.items.length})",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, color: Colors.red),
                          ),
                          children: [
                            for(int i=0;i<li4.items.length;i++)
                      Container(
                      width: width,
                      child: InkWell(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text((i+1).toString()+". "+li4.items[i].groupCode.toString()+'-'+li4.items[i].groupName.toString(),textAlign: TextAlign.start,),
                                ),
                                onTap: (){
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              EmployeeGroupDetailView(
                                                  groupid:
                                                  li4.items[i].groupId)));
                                  Fluttertoast.showToast(
                                      msg: li4.items[i].groupName.toString(),
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.SNACKBAR,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0
                                  );
                                },
                              )
                      )],)),
                  ):Container(),
                  li!=null?Center(
                    child: Container(
                        width:width,
                        margin: const EdgeInsets.only(top: 10),
                        color: Colors.red.shade50,
                        child: ExpansionTile(
                          expandedCrossAxisAlignment: CrossAxisAlignment.start,
                          backgroundColor: Colors.white,
                          initiallyExpanded: false,
                          title: Text(
                            "Feedback(${li.data.feedback.length})",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, color: Colors.red),
                          ),
                          children: [
                            for(int i=0;i<li.data.feedback.length;i++)
                      Container(
                      width: width,
                      child: InkWell(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text((i+1).toString()+". "+li.data.feedback[i].pserviceCode+'-'+li.data.feedback[i].propertyCode,textAlign: TextAlign.start,),
                                ),
                                onTap: (){
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              EmployeeFeedBackDetail(
                                                  id:
                                                  li.data.feedback[i].feedbackId)));
                                  Fluttertoast.showToast(
                                      msg: li.data.feedback[i].pserviceCode,
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.SNACKBAR,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0
                                  );
                                },
                              )
                      )],)),
                  ):Container(),
                  li!=null?Center(
                    child: Container(
                        width:width,
                        margin: const EdgeInsets.only(top: 10),
                        color: Colors.red.shade50,
                        child: ExpansionTile(
                          expandedCrossAxisAlignment: CrossAxisAlignment.start,
                          backgroundColor: Colors.white,
                          initiallyExpanded: false,
                          title: Text(
                            "Complaint(${li.data.complaint.length})",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, color: Colors.red),
                          ),
                          children: [
                            for(int i=0;i<li.data.complaint.length;i++)
                      Container(
                      width: width,
                      child: InkWell(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text((i+1).toString()+". "+li.data.complaint[i].complaintCode+'-'+li.data.complaint[i].createdAt+'-'+li.data.complaint[i].complaintStatus,textAlign: TextAlign.start,),
                                ),
                                onTap: (){
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ComplaintDetail(
                                                  complaintid:
                                                  li.data.complaint[i].complaintId)));
                                  Fluttertoast.showToast(
                                      msg: li.data.complaint[i].complaintCode,
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.SNACKBAR,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0
                                  );
                                },
                              )
                      ) ],)),
                  ):Container(),
                  li!=null?Center(
                    child: Container(
                        width:width,
                        margin: const EdgeInsets.only(top: 10),
                        color: Colors.red.shade50,
                        child: ExpansionTile(
                          expandedCrossAxisAlignment: CrossAxisAlignment.start,
                          backgroundColor: Colors.white,
                          initiallyExpanded: false,
                          title: Text(
                            "Damage(${li.data.damage.length})",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, color: Colors.red),
                          ),
                          children: [
                            for(int i=0;i<li.data.damage.length;i++)
                      Container(
                      width: width,
                      child: InkWell(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text((i+1).toString()+". "+li.data.damage[i].damageCode+'-'+li.data.damage[i].createdAt+'-'+li.data.damage[i].damageStatus,textAlign: TextAlign.start,),
                                ),
                                onTap: (){
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              DamageDetail(
                                                  damageid:
                                                  li.data.damage[i].damageId)));
                                  Fluttertoast.showToast(
                                      msg: li.data.damage[i].damageCode,
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.SNACKBAR,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0
                                  );
                                },
                              )
                      )],
                        )),
                  ):Container(),
                  li5!=null?Center(
                    child: Container(
                        width:width,
                        margin: const EdgeInsets.only(top: 10),
                        color: Colors.red.shade50,
                        child: ExpansionTile(
                          expandedCrossAxisAlignment: CrossAxisAlignment.start,
                          backgroundColor: Colors.white,
                          initiallyExpanded: false,
                          title: Text(
                            "Referals(${li5.items.length})",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, color: Colors.red),
                          ),
                          children: [
                            for(int i=0;i<li5.items.length;i++)
                      Container(
                      width: width,
                      child: InkWell(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text((i+1).toString()+". "+li5.items[i].discountCode+' Count : '+li5.items[i].rdRefCount,textAlign: TextAlign.start,),
                                ),
                                onTap: (){
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ReferalList()));
                                  Fluttertoast.showToast(
                                      msg: li5.items[i].discountCode,
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.SNACKBAR,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0
                                  );
                                },
                              )
                      )],)),
                  ):Container(),
                  li6!=null?Center(
                    child: li6.items!=null?Container(
                        width:width,
                        margin: const EdgeInsets.only(top: 10),
                        color: Colors.red.shade50,
                        child: ExpansionTile(
                          expandedCrossAxisAlignment: CrossAxisAlignment.start,
                          backgroundColor: Colors.white,
                          initiallyExpanded: false,
                          title: li6.items!=null?Text(
                            "Payments(${li6.items.length})",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, color: Colors.red),
                          ):Container(),
                          children: [
                            for(int i=0;i<li6.items.length;i++)
                      Container(
                      width: width,
                      child: InkWell(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text((i+1).toString()+". "+li6.items[i].billNo+' Amount : '+li6.items[i].billAmount,textAlign: TextAlign.start,),
                                ),
                                onTap: (){
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              BillDetail(
                                                  groupid:
                                                  li6.items[i].billId)));
                                  Fluttertoast.showToast(
                                      msg: li6.items[i].billNo,
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.SNACKBAR,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0
                                  );
                                },
                              )
                      )],)):Container(),
                  ):Container(),
           ],
              ),
            ),
          ])),
      appBar: AppBar(
        title: Image.asset('logotitle.png',height: 40),
      ),
    );
  }


}

class BackendService {
  static EmployeeGroupAddSelectCusModel li1;

  static Future<List> getSuggestions(String query) async {
    var url = //'http://35.184.156.126.xip.io/cyberhome/home.php?username=kavin&query=table';
    String_values.base_url + 'find-customer?search=${query}';

    var response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer ${RegisterPagesState.token}'
      },
    );
    if (response.statusCode == 200) {
      print(response.body);
      li1 = EmployeeGroupAddSelectCusModel.fromJson(json.decode(response.body));
      List<String> s = new List();
      if (li1.data.length == 0) {
        // return ["No details"];
      } else {
        for (int i = 0; i < li1.data.length; i++)
          s.add(li1.data[i].cusName.toString());
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

class BackendService1 {
  static GroupNameFromCusList li2;

  static Future<List> getSuggestions(String query) async {
    var url = //'http://35.184.156.126.xip.io/cyberhome/home.php?username=kavin&query=table';
    String_values.base_url +
        'grouplist-by-cus/' +
        EmployeeCustomer360State.cusid;

    var response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer ${RegisterPagesState.token}'
      },
    );
    if (response.statusCode == 200) {
      print(response.body);
      li2 = GroupNameFromCusList.fromJson(json.decode(response.body));
      List<String> s = new List();
      if (li2.tariff.length == 0) {
        // return ["No details"];
      } else {
        for (int i = 0; i < li2.tariff.length; i++)
          s.add(li2.tariff[i].groupName.toString());
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
