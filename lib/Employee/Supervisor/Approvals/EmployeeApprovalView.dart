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
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:tankcare/Customer/register.dart';
import 'package:tankcare/CustomerModels/billdetail.dart';
import 'package:tankcare/CustomerModels/districtlist.dart';
import 'package:tankcare/CustomerModels/servicedetail.dart';
import 'package:tankcare/Employee/Dashboard.dart';
import 'package:tankcare/Employee/EmployeeModels/DVStaff/DVStaffDetail.dart';
import 'package:tankcare/Employee/EmployeeModels/ErrorResponse.dart';
import 'package:tankcare/Employee/Login/Login.dart';
import 'package:tankcare/Employee/Supervisor/Approvals/EmployeeApprovalProcess.dart';
import 'package:tankcare/RM%20models/DamageView.dart';
import 'package:tankcare/RM%20models/propertyview.dart';
import 'package:tankcare/Vendor/Login/Login.dart';
import 'package:tankcare/VendorModels/APApproval.dart';
import 'package:tankcare/VendorModels/MachineRepairDetails.dart';
import 'package:tankcare/VendorModels/SpareRequestView.dart';
import 'package:tankcare/VendorModels/StationView.dart';
import 'package:tankcare/VendorModels/VendorServiceDetailModel.dart';
import 'package:tankcare/VendorModels/VendorStaffDetailsModel.dart';
import 'package:tankcare/string_values.dart';

class EmployeeApprovalView extends StatefulWidget {
  EmployeeApprovalView({Key key, this.verify, this.propertyid, this.apid});

  String verify;
  String propertyid;
  String apid;

  @override
  EmployeeApprovalViewState createState() => EmployeeApprovalViewState();
}

class EmployeeApprovalViewState extends State<EmployeeApprovalView> {
  bool loading = false;

  PropertyDetails li;
  BillView li34;
  List<File> files = [];
  var _kGooglePlex;
  Future<File> _imageFile;
  APDetails li2;
  final dateFormatter = DateFormat('yyyy-MM-dd');
  String sql_dob;
  DistrictListings li3;
  String tblid;
  String dropdownValue3 = '-Action-';

  VendorStaffDetails li45;

  StationDetail li47;

  SpareRequestView li48;
  Future<String> DamageOTPSave(damageid) async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer ${RegisterPagesState.token}'
    };

    var request = http.MultipartRequest('POST',
        Uri.parse(String_values.base_url + 'service-damage-amount-save'));
    //property_id plan_id pplan_name pplan_year pplan_service pplan_price pplan_tot_price pplan_start_date
    request.headers.addAll(headers);
    request.fields['damage_id'] = damageid;
    request.fields['damage_otp'] = OTPController.text;
    request.fields['damage_amount'] = ClaimAmountController.text;
    var response = await request.send();
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);

      return value;
    });
  }

  Future<int> DamageClaim(damageid) async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer ${RegisterPagesState.token}'
    };

    var request = http.MultipartRequest(
        'POST', Uri.parse(String_values.base_url + 'service-damage-otp'));
    //property_id plan_id pplan_name pplan_year pplan_service pplan_price pplan_tot_price pplan_start_date
    request.headers.addAll(headers);
    request.fields['damage_id'] = damageid;
    var response = await request.send();
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
      if (value.contains("true"))
        showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                "Claim Amount",
                style: TextStyle(color: Colors.red),
              ),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      enabled: true,
                      controller: ClaimAmountController,
                      decoration: InputDecoration(
                        labelText: 'Claim Amount',
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
                      height: MediaQuery.of(context).size.height / 40,
                    ),
                    TextField(
                      enabled: true,
                      controller: OTPController,
                      decoration: InputDecoration(
                        labelText: 'Enter OTP',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 16.0,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: Text('Save & Approve'),
                  onPressed: () {
                    check().then((value) {
                      if (value) {
                        if ((OTPController.text.length > 0) &&
                            (ClaimAmountController.text.length > 0))
                          DamageOTPSave(li4.items.damageId).then((value) {
                            uploadImage(widget.apid, tblid, "a");
                          });
                        else
                          Fluttertoast.showToast(
                              msg: "OTP or Claim Amount Cannot be Empty",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.SNACKBAR,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
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

      return response.statusCode;
    });
  }

  num a;

  File image;

  var file;

  int servicerating = 0;
  int servicerrating = 0;

  DateTime damageEndDate;

  bool damageenable = true;

  FranchaiseDamage li4;
  DVStaffDetailModel li46;
  MachineRepairDetails li5;

  VendorServiceDetailModel li6;

  ErrorResponse ei;

  Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  Future<http.Response> damage(planid) async {
    setState(() {
      loading = true;
    });
    var url =
        String_values.base_url + 'service-damage-view?damage_id=' + planid;
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
      li4 = FranchaiseDamage.fromJson(json.decode(response.body));
      setState(() {
        // ServiceByController.text=li.planServices.se

        DamageCodeController.text = li4.items.damageCode;
        DamageStatusController.text = li4.items.damageStatus;
        DamageNoteController.text = li4.items.damageNote;
        DamageAmountController.text = li4.items.damageAmount;
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

  Future<int> reservicecall() async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer ${RegisterPagesState.token}'
    };

    var request = http.MultipartRequest(
        'POST', Uri.parse(String_values.base_url + 'reservice-submit'));
    //property_id plan_id pplan_name pplan_year pplan_service pplan_price pplan_tot_price pplan_start_date
    request.headers.addAll(headers);
    request.fields['service_id'] = widget.propertyid;
    request.fields['service_date'] = datecontroller.text;
    var response = await request.send();
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => EmployeeApprovalList(),
          ));
      return response.statusCode;
    });
  }

  Future<http.Response> details(planid) async {
    setState(() {
      loading = true;
    });

    var url;
    print(widget.verify);
    print("inside");
    switch (widget.verify) {
      case "Property Verify":
        {
          url = String_values.base_url + 'property-view/' + planid;
          var response = await http.get(
            url,
            headers: {
              "Content-Type": "application/json",
              'Authorization': 'Bearer ${RegisterPagesState.token}'
            },
          );
          if (response.statusCode == 200) {
            print(response.body);
            setState(() {
              loading = false;
            });
            li = PropertyDetails.fromJson(json.decode(response.body));
            setState(() {
              // ServiceByController.text=li.planServices.se

              PropertyNameController.text = li.propertyName.toString();
              GroupNameController.text = li.groupName.toString();
              // if (li.serviceType.toString() == "RES")
              //   ServiceController.text = "Residential";
              // else
              //   ServiceController.text = "Commercial";

              PropertyCodeController.text = li.propertyCode.toString();
              PropertyTypeController.text = li.propertyTypeName.toString();
              valuecontroller.text = li.mapLocation.toString();

              CusNameController.text = li.cusName.toString();
              CusCodeController.text = li.cusCode.toString();
              PhoneController.text = li.cusPhone.toString();
              GroupContactNameController.text = li.groupContactName.toString();
              GroupContactMobilController.text =
                  li.groupContactPhone.toString();
            });
          }
          break;
        }
      case "Repair Quote":
        {
          url = String_values.base_url + 'machine-repair-details/' + planid;
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
            li5 = MachineRepairDetails.fromJson(json.decode(response.body));
            setState(() {
              RepairCodeController.text = li5.data.repairCode.toString();
              RepairNoteController.text = li5.data.repairNote.toString();
              RepairStatusController.text = li5.data.repairStatus.toString();
              MachineNameController.text = li5.data.machineName.toString();
              MachineCodeController.text = li5.data.machineCode.toString();
              MachineTypeController.text = li5.data.machineType.toString();
              ManufacturerNameController.text =
                  li5.data.manufactureName.toString();
              ManufacturerNoController.text =
                  li5.data.manufactureNumber.toString();
              PurchaseDateController.text =   DateFormat('dd/MM/yyyy').format(
                  DateTime.parse(li5.data.purchaseDate.toString()));
              StateController.text = li5.data.stateName.toString();
              DistrictController.text = li5.data.districtName.toString();
              AssignbyController.text = li5.data.assignby.toString();
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
          break;
        }
      case "Service Verify":
        {
          url = String_values.base_url +
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
            li6 = VendorServiceDetailModel.fromJson(json.decode(response.body));
            setState(() {
              // ServiceByController.text=li.planServices.se

              PropertyNameController.text =
                  li6.property.propertyName.toString();
              GroupNameController.text = li6.property.groupName.toString();
              // if (li.serviceType.toString() == "RES")
              //   ServiceController.text = "Residential";
              // else
              //   ServiceController.text = "Commercial";

              PropertyCodeController.text =
                  li6.property.propertyCode.toString();
              PropertyTypeController.text =
                  li6.property.propertyTypeName.toString();
              valuecontroller.text = li6.property.mapLocation.toString();

              CusNameController.text = li6.property.cusName.toString();
              CusCodeController.text = li6.property.cusCode.toString();
              PhoneController.text = li6.property.cusPhone.toString();
              GroupContactNameController.text =
                  li6.property.groupContactName.toString();
              GroupContactMobilController.text =
                  li6.property.groupContactPhone.toString();

              ServiceStartDateController.text =
                  DateFormat('dd/MM/yyyy').format(
                      DateTime.parse(li6.planServices.pserviceDate.toString()));
              ServiceStatusController.text =
                  li6.planServices.pserviceServiceStatus.toString();
              if (li6.planServices.pserviceStatus.toString() == "A")
                StatusController.text = "Active";
              else if (li6.planServices.pserviceStatus.toString() == "P")
                StatusController.text = "Pending";
              ServiceStartAtController.text =
                  li6.planServices.pserviceStartAt.toString();
              ServiceEndAtController.text =
                  li6.planServices.pserviceEndAt.toString();
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
      case "DamageVerify":
        {
          setState(() {
            loading = true;
          });
          var url = String_values.base_url +
              'service-damage-view?damage_id=' +
              widget.propertyid;
          print(url);
          var response1 = await http.get(
            url,
            headers: {
              "Content-Type": "application/json",
              'Authorization': 'Bearer ${RegisterPagesState.token}'
            },
          );
          if (response1.statusCode == 200) {
            setState(() {
              loading = false;
            });
            li4 = FranchaiseDamage.fromJson(json.decode(response1.body));
            setState(() {
              // ServiceByController.text=li.planServices.se

              DamageCodeController.text = li4.items.damageCode;
              DamageStatusController.text = li4.items.damageStatus;
              DamageNoteController.text = li4.items.damageNote;
            });
          } else {
            setState(() {
              loading = false;
            });
            print("Retry");
          }
          print("response: ${response1.statusCode}");
          print("response: ${response1.body}");

          setState(() {
            loading = true;
          });
          url = String_values.base_url +
              'property-plan-services-view?serviceid=' +
              li4.items.serviceId;
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
            li6 = VendorServiceDetailModel.fromJson(json.decode(response.body));
            setState(() {
              // ServiceByController.text=li.planServices.se

              PropertyNameController.text =
                  li6.property.propertyName.toString();
              GroupNameController.text = li6.property.groupName.toString();
              // if (li.serviceType.toString() == "RES")
              //   ServiceController.text = "Residential";
              // else
              //   ServiceController.text = "Commercial";

              PropertyCodeController.text =
                  li6.property.propertyCode.toString();
              PropertyTypeController.text =
                  li6.property.propertyTypeName.toString();
              valuecontroller.text = li6.property.mapLocation.toString();

              CusNameController.text = li6.property.cusName.toString();
              CusCodeController.text = li6.property.cusCode.toString();
              PhoneController.text = li6.property.cusPhone.toString();
              GroupContactNameController.text =
                  li6.property.groupContactName.toString();
              GroupContactMobilController.text =
                  li6.property.groupContactPhone.toString();

              ServiceStartDateController.text =
                  DateFormat('dd/MM/yyyy').format(
                      DateTime.parse( li6.planServices.pserviceDate.toString()));
              ServiceStatusController.text =
                  li6.planServices.pserviceServiceStatus.toString();
              if (li6.planServices.pserviceStatus.toString() == "A")
                StatusController.text = "Active";
              else if (li6.planServices.pserviceStatus.toString() == "P")
                StatusController.text = "Pending";
              ServiceStartAtController.text =
                  li6.planServices.pserviceStartAt.toString();
              ServiceEndAtController.text =
                  li6.planServices.pserviceEndAt.toString();
            });
          }
          print("response: ${response.statusCode}");
          print("response: ${response.body}");
          break;
        }
      case "Bill Verify":
        {
          setState(() {
            loading = true;
          });
          var url = String_values.base_url + 'plan-bill-view?bill_id=' + planid;
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
            li34 = BillView.fromJson(json.decode(response.body));
            setState(() {
              // ServiceByController.text=li34.planServices.se

              BillNoController.text = li34.data.billNo.toString();
              InvoiceNoController.text = li34.data.invNo.toString();
              PaidReferrenceNo.text = li34.data.paidRefNo.toString();
              if (li34.data.totalItems.toString() == "1")
                PaidStatusController.text = "Paid";
              else
                PaidStatusController.text = "UnPaid";
              // if (li34.serviceType.toString() == "RES")
              //   ServiceController.text = "Residential";
              // else
              //   ServiceController.text = "Commercial";

              InvoicedateController.text =   DateFormat('dd/MM/yyyy').format(
                  DateTime.parse(li34.data.invDatetime.toString()));
              BillNotesController.text = li34.data.billNotes.toString();
              TotalItemscontroller.text = li34.data.totalItems.toString();

              BillAmountController.text = li34.data.invNo.toString();
              BillPaidAmountController.text =  DateFormat('dd/MM/yyyy').format(
                  DateTime.parse( li34.data.invDatetime.toString()));
              BillDiscountAmountController.text =
                  li34.data.billNotes.toString();
              if (li34.data.totalItems.toString() == "1")
                BillPaidStatusController.text = "Paid";
              else
                BillPaidStatusController.text = "UnPaid";

              CusNameController.text = li34.data.cusName.toString();
              CusCodeController.text = li34.data.cusCode.toString();
              PhoneController.text = li34.data.cusPhone.toString();
              CusStateController.text = li34.data.cusState.toString();
              CusDisrictController.text = li34.data.cusDistrict.toString();
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
          break;
        }
      case "Damage Claim Verify":
        {
          damage(widget.propertyid).then((value) async {
            setState(() {
              loading = true;
            });
            var url = String_values.base_url +
                'property-plan-services-view?serviceid=' +
                li4.items.serviceId;
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
              li6 =
                  VendorServiceDetailModel.fromJson(json.decode(response.body));
              setState(() {
                // ServiceByController.text=li.planServices.se

                PropertyNameController.text =
                    li6.property.propertyName.toString();
                GroupNameController.text = li6.property.groupName.toString();
                // if (li6.serviceType.toString() == "RES")
                //   ServiceController.text = "Residential";
                // else
                //   ServiceController.text = "Commercial";

                PropertyCodeController.text =
                    li6.property.propertyCode.toString();
                PropertyTypeController.text =
                    li6.property.propertyTypeName.toString();
                valuecontroller.text = li6.property.mapLocation.toString();

                CusNameController.text = li6.property.cusName.toString();
                CusCodeController.text = li6.property.cusCode.toString();
                PhoneController.text = li6.property.cusPhone.toString();
                GroupContactNameController.text =
                    li6.property.groupContactName.toString();
                GroupContactMobilController.text =
                    li6.property.groupContactPhone.toString();

                ServiceStartDateController.text =
                    DateFormat('dd/MM/yyyy').format(
                        DateTime.parse(  li6.planServices.pserviceDate.toString()));
                ServiceStatusController.text =
                    li6.planServices.pserviceServiceStatus.toString();
                if (li6.planServices.pserviceStatus.toString() == "A")
                  StatusController.text = "Active";
                else if (li6.planServices.pserviceStatus.toString() == "P")
                  StatusController.text = "Pending";
                ServiceStartAtController.text =
                    li6.planServices.pserviceStartAt.toString();
                ServiceEndAtController.text =
                    li6.planServices.pserviceEndAt.toString();
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
          });
          break;
        }
      case "Reservice Verify":
        {
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
            li6 = VendorServiceDetailModel.fromJson(json.decode(response.body));
            setState(() {
              // ServiceByController.text=li.planServices.se

              PropertyNameController.text =
                  li6.property.propertyName.toString();
              GroupNameController.text = li6.property.groupName.toString();
              // if (li.serviceType.toString() == "RES")
              //   ServiceController.text = "Residential";
              // else
              //   ServiceController.text = "Commercial";

              PropertyCodeController.text =
                  li6.property.propertyCode.toString();
              PropertyTypeController.text =
                  li6.property.propertyTypeName.toString();
              valuecontroller.text = li6.property.mapLocation.toString();

              CusNameController.text = li6.property.cusName.toString();
              CusCodeController.text = li6.property.cusCode.toString();
              PhoneController.text = li6.property.cusPhone.toString();
              GroupContactNameController.text =
                  li6.property.groupContactName.toString();
              GroupContactMobilController.text =
                  li6.property.groupContactPhone.toString();

              ServiceStartDateController.text =
                  DateFormat('dd/MM/yyyy').format(
                      DateTime.parse( li6.planServices.pserviceDate.toString()));
              ServiceStatusController.text =
                  li6.planServices.pserviceServiceStatus.toString();
              if (li6.planServices.pserviceStatus.toString() == "A")
                StatusController.text = "Active";
              else if (li6.planServices.pserviceStatus.toString() == "P")
                StatusController.text = "Pending";
              ServiceStartAtController.text =
                  li6.planServices.pserviceStartAt.toString();
              ServiceEndAtController.text =
                  li6.planServices.pserviceEndAt.toString();
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
          break;
        }
      case "Repair Request":
        {
          url = String_values.base_url + 'machine-repair-details/' + planid;
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
            li5 = MachineRepairDetails.fromJson(json.decode(response.body));
            setState(() {
              RepairCodeController.text = li5.data.repairCode.toString();
              RepairNoteController.text = li5.data.repairNote.toString();
              RepairStatusController.text = li5.data.repairStatus.toString();
              MachineNameController.text = li5.data.machineName.toString();
              MachineCodeController.text = li5.data.machineCode.toString();
              MachineTypeController.text = li5.data.machineType.toString();
              ManufacturerNameController.text =
                  li5.data.manufactureName.toString();
              ManufacturerNoController.text =
                  li5.data.manufactureNumber.toString();
              PurchaseDateController.text =   DateFormat('dd/MM/yyyy').format(
                  DateTime.parse(li5.data.purchaseDate.toString()));
              StateController.text = li5.data.stateName.toString();
              DistrictController.text = li5.data.districtName.toString();
              AssignbyController.text = li5.data.assignby.toString();
            });
          } else {
            setState(() {
              loading = false;
            });
            print("Retry");
          }
          print("response: ${response.statusCode}");
          print("response: ${response.body}");
          break;
        }
      case "Staff Request":
        {
          setState(() {
            loading = true;
          });
          var url = String_values.base_url + 'vendor-staff-details/' + planid;
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
            li45 = VendorStaffDetails.fromJson(json.decode(response.body));
            setState(() {
              StationName.text = li45.items.stationName.toString();
              NameController.text = li45.items.staffName.toString();
              MobileController.text = li45.items.staffPhone.toString();
              EmailController.text = li45.items.staffEmail.toString();
              StationCode.text = li45.items.stationCode.toString();
              VendorCode.text = li45.items.vendorCode.toString();
              CompanyNameController.text =
                  li45.items.vendorCompanyname.toString();
              li45.items.staffStatus.toString() == "D"
                  ? StatusController.text = "DeActive"
                  : StatusController.text = "Active";
              // ServiceController.text=li.res.planDatas.planServicetype.toString();
              // PropertyTypeController.text=li.res.planDatas.planPropertytypeId.toString();
              // valuecontroller.text=li.res.planDatas.planUnit.toString();
              // LiterFromController.text=li.res.planDatas.planSizeFrom.toString();
              // LiterToController.text=li.res.planDatas.planSizeTo.toString();
              // statusController.text=li.property.propertyStatus.toString();
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
          break;
        }
      case "Dstaff Request":
        {
          setState(() {
            loading = true;
          });
          var url = String_values.base_url + 'dvendor-staff-details/' + planid;
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
            li46 = DVStaffDetailModel.fromJson(json.decode(response.body));
            setState(() {
              StationName.text = li46.items.shopName.toString();
              NameController.text = li46.items.dstaffName.toString();
              MobileController.text = li46.items.dstaffPhone.toString();
              EmailController.text = li46.items.dstaffEmail.toString();
              StationCode.text = li46.items.shopCode.toString();
              VendorCode.text = li46.items.dvendorCode.toString();
              CompanyNameController.text =
                  li46.items.dvendorCompanyname.toString();
              li46.items.dstaffStatus.toString() == "D"
                  ? StatusController.text = "DeActive"
                  : StatusController.text = "Active";
              // ServiceController.text=li.res.planDatas.planServicetype.toString();
              // PropertyTypeController.text=li.res.planDatas.planPropertytypeId.toString();
              // valuecontroller.text=li.res.planDatas.planUnit.toString();
              // LiterFromController.text=li.res.planDatas.planSizeFrom.toString();
              // LiterToController.text=li.res.planDatas.planSizeTo.toString();
              // statusController.text=li.property.propertyStatus.toString();
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
          break;
        }
      case "Station Deactive":
        {
          setState(() {
            loading = true;
          });
          var url = String_values.base_url + 'service-station-view/' + planid;
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
            li47 = StationDetail.fromJson(json.decode(response.body));
            setState(() {
              StationName.text = li47.data.stationName.toString();
              addressController.text = li47.data.stationAddress.toString();
              StationCode.text = li47.data.stationCode.toString();
              StateController.text = li47.data.stateName.toString();
              DistrictController.text = li47.data.districtName.toString();
              StatusController.text = li47.data.stationStatus.toString();
              AssignController.text = li47.data.assignby.toString();
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
          break;
        }
      case "Spare Request":
        {
          setState(() {
            loading = true;
          });
          var url = String_values.base_url +
              'machine-spare-request-details/' +
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
            li48 = SpareRequestView.fromJson(json.decode(response.body));
            setState(() {
              SpareCodeController.text = li48.data.spareCode.toString();
              SpareNoteController.text = li48.data.spareNote.toString();
              MachineNameController.text = li48.data.machineName.toString();
              MachineCodeController.text = li48.data.machineCode.toString();
              MachineTypeController.text = li48.data.machineType.toString();
              ManufacturerNameController.text =
                  li48.data.manufactureName.toString();
              ManufacturerNoController.text =
                  li48.data.manufactureNumber.toString();
              PurchaseDateController.text =   DateFormat('dd/MM/yyyy').format(
                  DateTime.parse(li48.data.purchaseDate.toString()));
              StateController.text = li48.data.stateName.toString();
              DistrictController.text = li48.data.districtName.toString();
              // AssignbyController.text = li.data.assignby.toString();
            });
          } else {
            setState(() {
              loading = false;
            });
            print("Retry");
          }
          print("response: ${response.statusCode}");
          print("response: ${response.body}");
        }
    }
  }

  Future<http.Response> approval(planid) async {
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
      li2 = APDetails.fromJson(json.decode(response.body));

      setState(() {});
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

  Future<int> uploadImage(apid, aptblid, Aorr) async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer ${RegisterPagesState.token}'
    };
    var request;
    if (widget.verify == "Property Verify")
      request = http.MultipartRequest('POST',
          Uri.parse(String_values.base_url + 'approval-property-verify'));
    else if (widget.verify == "Repair Quote")
      request = http.MultipartRequest('POST',
          Uri.parse(String_values.base_url + 'approval-repair-quote-verify'));
    else if (widget.verify == "DamageVerify")
      request = http.MultipartRequest(
          'POST', Uri.parse(String_values.base_url + 'approval-damage-verify'));
    else if (widget.verify == "Service Verify")
      request = http.MultipartRequest('POST',
          Uri.parse(String_values.base_url + 'approval-service-verify'));
    else if (widget.verify == "Damage Claim Verify ")
      request = http.MultipartRequest('POST',
          Uri.parse(String_values.base_url + 'approval-damage-claim-verify'));
    else if (widget.verify == "Reservice Verify")
      request = http.MultipartRequest('POST',
          Uri.parse(String_values.base_url + 'approval-reservice-verify'));
    else if (widget.verify == "Bill Verify")
      request = http.MultipartRequest('POST',
          Uri.parse(String_values.base_url + 'approval-planbill-verify'));
    else if (widget.verify == "Repair Request")
      request = http.MultipartRequest(
          'POST', Uri.parse(String_values.base_url + 'approval-repair-verify'));
    else if (widget.verify == "Repair Quote")
      request = http.MultipartRequest('POST',
          Uri.parse(String_values.base_url + 'approval-repair-quote-verify'));
    else if (widget.verify == "Spare Request")
      request = http.MultipartRequest('POST',
          Uri.parse(String_values.base_url + 'approval-spare-req-verify'));
    else if (widget.verify == "Staff Request")
      request = http.MultipartRequest('POST',
          Uri.parse(String_values.base_url + 'approval-staff-req-verify'));
    else if (widget.verify == "Dstaff Request")
      request = http.MultipartRequest('POST',
          Uri.parse(String_values.base_url + 'approval-dstaff-req-verify'));
    else if (widget.verify == "Station Deactive")
      request = http.MultipartRequest(
          'POST',
          Uri.parse(
              String_values.base_url + 'approval-station-deactive-req-verify'));
    else if (widget.verify == "Station Retun Amount")
      request = http.MultipartRequest('POST',
          Uri.parse(String_values.base_url + 'approval-dstaff-req-verify'));

    //property_id plan_id pplan_name pplan_year pplan_service pplan_price pplan_tot_price pplan_start_date
    request.headers.addAll(headers);
    request.fields['ap_id'] = apid;
    request.fields['eap_status'] = Aorr;
    request.fields['ap_tbl_id'] = aptblid;
    var response = await request.send();
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);

      setState(() {
        loading = false;
      });
      if (value.toString().contains("true")) {
        Fluttertoast.showToast(
            msg: "Approved Successfully",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.SNACKBAR,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => EmployeeApprovalList()),
        );
      } else {
        ei = ErrorResponse.fromJson(jsonDecode(value));
        Fluttertoast.showToast(
            msg: ei.messages,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.SNACKBAR,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
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
      li2 = APDetails.fromJson(json.decode(response.body));

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

  List<String> items = List<String>.generate(7, (index) {
    return "Item - $index";
  });
  List<PlanListClass> listplan;

  TextEditingController SpareCodeController = new TextEditingController();
  TextEditingController SpareNoteController = new TextEditingController();
  TextEditingController PaidReferrenceNo = new TextEditingController();
  TextEditingController PaidStatusController = new TextEditingController();
  TextEditingController AssignController = new TextEditingController();
  TextEditingController OTPController = new TextEditingController();
  TextEditingController BillAmountController = new TextEditingController();
  TextEditingController DamageAmountController = new TextEditingController();
  TextEditingController TotalItemsController = new TextEditingController();
  TextEditingController BillPaidAmountController = new TextEditingController();

  TextEditingController NameController = new TextEditingController();
  TextEditingController MobileController = new TextEditingController();
  TextEditingController EmailController = new TextEditingController();

  TextEditingController StationName = new TextEditingController();
  TextEditingController StationCode = new TextEditingController();
  TextEditingController VendorCode = new TextEditingController();
  TextEditingController CompanyNameController = new TextEditingController();
  TextEditingController BillDiscountAmountController =
      new TextEditingController();
  TextEditingController BillPaidStatusController = new TextEditingController();

  TextEditingController StatusController = new TextEditingController();
  TextEditingController ServiceStatusController = new TextEditingController();
  TextEditingController ServiceStartDateController =
      new TextEditingController();
  TextEditingController ServiceByController = new TextEditingController();
  TextEditingController ComplaintController = new TextEditingController();
  TextEditingController DamageController = new TextEditingController();
  TextEditingController ServiceController = new TextEditingController();
  TextEditingController PlanPaidStatusController = new TextEditingController();
  TextEditingController PlanCurrentStatusController =
      new TextEditingController();
  TextEditingController InvoicedateController = new TextEditingController();
  TextEditingController FeedBackController = new TextEditingController();
  TextEditingController BillNoController = new TextEditingController();
  TextEditingController TotalItemscontroller = new TextEditingController();
  TextEditingController CusNameController = new TextEditingController();
  TextEditingController PhoneController = new TextEditingController();
  List<PlanServiceYearClass> listplanyear;
  TextEditingController CusStateController = new TextEditingController();
  TextEditingController InvoiceNoController = new TextEditingController();
  Completer<GoogleMapController> _controller = Completer();
  TextEditingController GroupContactMobileController =
      new TextEditingController();
  TextEditingController CusDisrictController = new TextEditingController();
  TextEditingController TotalServicesController = new TextEditingController();
  TextEditingController GroupCodeController = new TextEditingController();
  TextEditingController servicetypeController = new TextEditingController();
  TextEditingController BillNotesController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();
  TextEditingController statusController = new TextEditingController();
  TextEditingController CusCodeController = new TextEditingController();
  TextEditingController datecontroller = new TextEditingController();
  // TextEditingController ServiceByController = new TextEditingController();
  TextEditingController ClaimAmountController = new TextEditingController();
  TextEditingController RepairStatusController = new TextEditingController();
  TextEditingController RepairNoteController = new TextEditingController();
  TextEditingController DamageCodeController = new TextEditingController();
  TextEditingController DamageStatusController = new TextEditingController();
  TextEditingController DamageNoteController = new TextEditingController();

  TextEditingController RepairCodeController = new TextEditingController();

  TextEditingController PropertyCodeController = new TextEditingController();
  TextEditingController PropertyNameController = new TextEditingController();
  TextEditingController valuecontroller = new TextEditingController();
  TextEditingController GroupContactNameController =
      new TextEditingController();
  TextEditingController GroupNameController = new TextEditingController();
  TextEditingController GroupContactMobilController =
      new TextEditingController();
  TextEditingController PropertyTypeController = new TextEditingController();
  TextEditingController ServiceStartAtController = new TextEditingController();
  TextEditingController ServiceEndAtController = new TextEditingController();

//  TextEditingController SizeRangeControllermax = new TextEditingController();
  List<PlanListClass> selectedAvengers;
  bool sort;

  String dropdownValue = '-- Service Type --';

  String dropdownValue1 = '-- Property Type --';

  String dropdownValue2 = '-- Select Plan --';

  static List<String> friendsList = [null];

  TextEditingController MachineNameController = new TextEditingController();
  TextEditingController MachineCodeController = new TextEditingController();
  TextEditingController MachineTypeController = new TextEditingController();
  TextEditingController ManufacturerNameController =
      new TextEditingController();
  TextEditingController ManufacturerNoController = new TextEditingController();
  TextEditingController PurchaseDateController = new TextEditingController();
  TextEditingController StateController = new TextEditingController();
  TextEditingController DistrictController = new TextEditingController();
  TextEditingController AssignbyController = new TextEditingController();

  void initState() {
    print(widget.propertyid);
    print(widget.apid);
    approval(widget.apid).then((value) => details(widget.propertyid));
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
          : widget.verify == "Repair Quote"
              ? SingleChildScrollView(
                  child: new Column(
                    children: <Widget>[
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
                      //   margin: EdgeInsets.only(top: 10.0, bottom: 10),
                      //
                      //   child: new Text(
                      //     "Repair Verify",
                      //     textAlign: TextAlign.left,
                      //     style: TextStyle(
                      //         fontWeight: FontWeight.bold, color: Colors.red),
                      //   ),
                      // ),

                      Container(
                          margin: const EdgeInsets.only(top: 10),
                          color: Colors.red.shade50,
                          child: ExpansionTile(
                              backgroundColor: Colors.white,
                              initiallyExpanded: true,
                              title: Text(
                                "Repair Details",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.red),
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
                                    controller: RepairCodeController,
                                    decoration: InputDecoration(
                                      labelText: 'RePair Code',
                                      hintStyle: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16.0,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
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
                                    controller: RepairNoteController,
                                    decoration: InputDecoration(
                                      labelText: 'Repair Note',
                                      hintStyle: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16.0,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
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
                                    controller: RepairStatusController,
                                    decoration: InputDecoration(
                                      labelText: 'Repair Status',
                                      hintStyle: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16.0,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
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
                              initiallyExpanded: true,
                              title: Text(
                                "Machine Details",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.red),
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
                                    controller: MachineNameController,
                                    decoration: InputDecoration(
                                      labelText: 'Machine Name',
                                      hintStyle: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16.0,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
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
                                    controller: MachineCodeController,
                                    decoration: InputDecoration(
                                      labelText: 'Machine Code',
                                      hintStyle: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16.0,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
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
                                    controller: MachineTypeController,
                                    decoration: InputDecoration(
                                      labelText: 'Machine Type',
                                      hintStyle: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16.0,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
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
                                    controller: ManufacturerNameController,
                                    decoration: InputDecoration(
                                      labelText: 'Manufacturer Name',
                                      hintStyle: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16.0,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
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
                                    controller: ManufacturerNoController,
                                    decoration: InputDecoration(
                                      labelText: 'Manufacturer No',
                                      hintStyle: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16.0,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
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
                                    controller: PurchaseDateController,
                                    decoration: InputDecoration(
                                      labelText: 'Purchase Date',
                                      hintStyle: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16.0,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
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
                                    controller: StateController,
                                    decoration: InputDecoration(
                                      labelText: 'State Name',
                                      hintStyle: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16.0,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
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
                                    controller: DistrictController,
                                    decoration: InputDecoration(
                                      labelText: 'District Name',
                                      hintStyle: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16.0,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
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
                                    controller: AssignbyController,
                                    decoration: InputDecoration(
                                      labelText: 'Assign Name',
                                      hintStyle: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16.0,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
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
                          "Quotation Details",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.red),
                        ),
                      ),

                      // SingleChildScrollView(
                      //   scrollDirection: Axis.horizontal,
                      //   child: DataTable(
                      //     sortAscending: sort,
                      //     sortColumnIndex: 0,
                      //     columnSpacing: width / 20,
                      //     columns: [
                      //
                      //       DataColumn(
                      //         label: Center(
                      //             child: Wrap(
                      //               direction: Axis.vertical, //default
                      //               alignment: WrapAlignment.center,
                      //               children: [
                      //                 Text("Spare Part",
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
                      //                 Text("Qty",
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
                      //                 Text("Price",
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
                      //                 Text("Total",
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
                      //     rows: li.data.repairQuote
                      //         .map(
                      //           (list) => DataRow(cells: [
                      //         DataCell(Center(
                      //             child: Center(
                      //               child: Wrap(
                      //                   direction: Axis.vertical, //default
                      //                   alignment: WrapAlignment.center,
                      //                   children: [
                      //                     Text(
                      //                       list.sparePart.toString(),
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
                      //                     Text(list.spareQty.toString(),
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
                      //                         Text(list.sparePrice.toString(),
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
                      //                             Text(list.spareSubTotal.toString(),
                      //                                 textAlign: TextAlign.center)
                      //                           ]))),
                      //             ),
                      //
                      //       ]),
                      //     )
                      //         .toList(),
                      //   ),
                      // ),

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
                          "Approval Process",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.red),
                        ),
                      ),

                      SingleChildScrollView(
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
                                  Text("Order By",
                                      softWrap: true,
                                      style: TextStyle(fontSize: 12),
                                      textAlign: TextAlign.center),
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
                                  Text("Designation",
                                      softWrap: true,
                                      style: TextStyle(fontSize: 12),
                                      textAlign: TextAlign.center),
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
                                  Text("Approver",
                                      softWrap: true,
                                      style: TextStyle(fontSize: 12),
                                      textAlign: TextAlign.center),
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
                                  Text("Status",
                                      softWrap: true,
                                      style: TextStyle(fontSize: 12),
                                      textAlign: TextAlign.center),
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
                                  Text("Actions",
                                      softWrap: true,
                                      style: TextStyle(fontSize: 12),
                                      textAlign: TextAlign.center),
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
                          rows: li2.items
                              .map(
                                (list) => DataRow(cells: [
                                  DataCell(Center(
                                      child: Center(
                                    child: Wrap(
                                        direction: Axis.vertical, //default
                                        alignment: WrapAlignment.center,
                                        children: [
                                          Text(
                                            list.apDetailsOrderby.toString(),
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
                                          Text(list.urole.toString(),
                                              textAlign: TextAlign.center)
                                        ]),
                                  ))),
                                  DataCell(
                                    Center(
                                        child: Center(
                                            child: Wrap(
                                                direction:
                                                    Axis.vertical, //default
                                                alignment: WrapAlignment.center,
                                                children: [
                                          Text(list.assignby.toString(),
                                              textAlign: TextAlign.center)
                                        ]))),
                                  ),
                                  list.apStatus.toString() == "P"
                                      ? DataCell(
                                          Center(
                                              child: Center(
                                                  child: Wrap(
                                                      direction: Axis
                                                          .vertical, //default
                                                      alignment:
                                                          WrapAlignment.center,
                                                      children: [
                                                Text("Pending",
                                                    textAlign: TextAlign.center)
                                              ]))),
                                        )
                                      : DataCell(
                                          Center(
                                              child: Center(
                                                  child: Wrap(
                                                      direction: Axis
                                                          .vertical, //default
                                                      alignment:
                                                          WrapAlignment.center,
                                                      children: [
                                                Text("Approved",
                                                    textAlign: TextAlign.center)
                                              ]))),
                                        ),
                                  DataCell(
                                    (list.apStatus == "P" &&
                                            ((list.urole ==
                                                    EmployeeLoginPagesState
                                                        .Userrole) ||
                                                (EmployeeLoginPagesState
                                                        .Userrole ==
                                                    "SUPER ADMIN")))
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                  height: 30,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                      color: Colors.green,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  50))),
                                                  child: FlatButton(
                                                    onPressed: () {
                                                      check().then((value) {
                                                        if (value)
                                                          uploadImage(
                                                              list.apId,
                                                              list.apTblId,
                                                              "a");
                                                        else
                                                          showDialog<void>(
                                                            context: context,
                                                            barrierDismissible:
                                                                false, // user must tap button!
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                title: Text(
                                                                    "No Internet Connection"),
                                                                actions: <
                                                                    Widget>[
                                                                  TextButton(
                                                                    child: Text(
                                                                        'OK'),
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    },
                                                                  ),
                                                                ],
                                                              );
                                                            },
                                                          );
                                                      });
                                                    },
                                                    child: Text(
                                                      "Approve",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  )),
                                              Container(width: 10),
                                              Container(
                                                  height: 30,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                      color: Colors.grey,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  50))),
                                                  child: FlatButton(
                                                    onPressed: () {
                                                      check().then((value) {
                                                        if (value)
                                                          uploadImage(
                                                              list.apId,
                                                              list.apTblId,
                                                              "r");
                                                        else
                                                          showDialog<void>(
                                                            context: context,
                                                            barrierDismissible:
                                                                false, // user must tap button!
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                title: Text(
                                                                    "No Internet Connection"),
                                                                actions: <
                                                                    Widget>[
                                                                  TextButton(
                                                                    child: Text(
                                                                        'OK'),
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    },
                                                                  ),
                                                                ],
                                                              );
                                                            },
                                                          );
                                                      });
                                                    },
                                                    child: Text(
                                                      "Reject",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  )),
                                            ],
                                          )
                                        : (list.apStatus == "A")
                                            ? Container(child: Text("-"))
                                            : Center(
                                                child: Container(
                                                    child:
                                                        Text("Not Assigned"))),
                                  ),
                                ]),
                              )
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                )
              : widget.verify == "Property Verify"
                  ? SingleChildScrollView(
                      child: new Column(
                        children: <Widget>[
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
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red),
                            ),
                          ),
                          SizedBox(
                            height: height / 50,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 10.0, right: 10.0),
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
                            padding:
                                const EdgeInsets.only(left: 10.0, right: 10.0),
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
                            padding:
                                const EdgeInsets.only(left: 10.0, right: 10.0),
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
                            padding:
                                const EdgeInsets.only(left: 10.0, right: 10.0),
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
                            padding:
                                const EdgeInsets.only(left: 10.0, right: 10.0),
                            child: new TextFormField(
                              minLines: 3,
                              maxLines: 20,
                              enabled: false,
                              controller: valuecontroller,
                              decoration: InputDecoration(
                                labelText: 'Location',
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
                              "Customer Details",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red),
                            ),
                          ),
                          SizedBox(
                            height: height / 50,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 10.0, right: 10.0),
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
                            padding:
                                const EdgeInsets.only(left: 10.0, right: 10.0),
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
                            padding:
                                const EdgeInsets.only(left: 10.0, right: 10.0),
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
                            padding:
                                const EdgeInsets.only(left: 10.0, right: 10.0),
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
                              "Approval Process",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red),
                            ),
                          ),
                          SizedBox(
                            height: height / 50,
                          ),
                          SingleChildScrollView(
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
                                      Text("Order By",
                                          softWrap: true,
                                          style: TextStyle(fontSize: 12),
                                          textAlign: TextAlign.center),
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
                                      Text("Designation",
                                          softWrap: true,
                                          style: TextStyle(fontSize: 12),
                                          textAlign: TextAlign.center),
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
                                      Text("Approver",
                                          softWrap: true,
                                          style: TextStyle(fontSize: 12),
                                          textAlign: TextAlign.center),
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
                                      Text("Status",
                                          softWrap: true,
                                          style: TextStyle(fontSize: 12),
                                          textAlign: TextAlign.center),
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
                                      Text("Actions",
                                          softWrap: true,
                                          style: TextStyle(fontSize: 12),
                                          textAlign: TextAlign.center),
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
                              rows: li2.items
                                  .map(
                                    (list) => DataRow(cells: [
                                      DataCell(Center(
                                          child: Center(
                                        child: Wrap(
                                            direction: Axis.vertical, //default
                                            alignment: WrapAlignment.center,
                                            children: [
                                              Text(
                                                list.apDetailsOrderby
                                                    .toString(),
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
                                              Text(list.urole.toString(),
                                                  textAlign: TextAlign.center)
                                            ]),
                                      ))),
                                      DataCell(
                                        Center(
                                            child: Center(
                                                child: Wrap(
                                                    direction:
                                                        Axis.vertical, //default
                                                    alignment:
                                                        WrapAlignment.center,
                                                    children: [
                                              Text(list.assignby.toString(),
                                                  textAlign: TextAlign.center)
                                            ]))),
                                      ),
                                      list.apStatus.toString() == "P"
                                          ? DataCell(
                                              Center(
                                                  child: Center(
                                                      child: Wrap(
                                                          direction: Axis
                                                              .vertical, //default
                                                          alignment: WrapAlignment.center,
                                                          children: [
                                                    Text("Pending",
                                                        textAlign:
                                                            TextAlign.center)
                                                  ]))),
                                            )
                                          : DataCell(
                                              Center(
                                                  child: Center(
                                                      child: Wrap(
                                                          direction: Axis
                                                              .vertical, //default
                                                          alignment: WrapAlignment.center,
                                                          children: [
                                                    Text("Approved",
                                                        textAlign:
                                                            TextAlign.center)
                                                  ]))),
                                            ),
                                      DataCell(
                                        (list.apStatus == "P" &&
                                                ((list.urole ==
                                                        EmployeeLoginPagesState
                                                            .Userrole) ||
                                                    (EmployeeLoginPagesState
                                                            .Userrole ==
                                                        "SUPER ADMIN")))
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Container(
                                                      height: 30,
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                          color: Colors
                                                              .red.shade300,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          50))),
                                                      child: FlatButton(
                                                        onPressed: () {
                                                          uploadImage(
                                                              list.apId,
                                                              list.apTblId,
                                                              "a");
                                                        },
                                                        child: Text(
                                                          "Approve",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      )),
                                                  Container(width: 10),
                                                  Container(
                                                      height: 30,
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                          color: Colors.grey,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          50))),
                                                      child: FlatButton(
                                                        onPressed: () {
                                                          uploadImage(
                                                              list.apId,
                                                              list.apTblId,
                                                              "r");

                                                          check().then((value) {
                                                            if (value)
                                                              ;
                                                            else
                                                              showDialog<void>(
                                                                context:
                                                                    context,
                                                                barrierDismissible:
                                                                    false, // user must tap button!
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return AlertDialog(
                                                                    title: Text(
                                                                        "No Internet Connection"),
                                                                    actions: <
                                                                        Widget>[
                                                                      TextButton(
                                                                        child: Text(
                                                                            'OK'),
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        },
                                                                      ),
                                                                    ],
                                                                  );
                                                                },
                                                              );
                                                          });
                                                        },
                                                        child: Text(
                                                          "Reject",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      )),
                                                ],
                                              )
                                            : (list.apStatus == "A")
                                                ? Container(child: Text("-"))
                                                : Center(
                                                    child: Container(
                                                        child: Text(
                                                            "Not Assigned"))),
                                      ),
                                    ]),
                                  )
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                    )
                  : widget.verify == "DamageVerify"
                      ? SingleChildScrollView(
                          child: new Column(
                            children: <Widget>[
                              Container(
                                  margin: const EdgeInsets.only(top: 10),
                                  color: Colors.red.shade50,
                                  child: ExpansionTile(
                                      backgroundColor: Colors.white,
                                      initiallyExpanded: true,
                                      title: Text(
                                        "Damage Details",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.red),
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
                                            controller: DamageCodeController,
                                            decoration: InputDecoration(
                                              labelText: 'Damage Code',
                                              hintStyle: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 16.0,
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
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
                                            controller: DamageNoteController,
                                            decoration: InputDecoration(
                                              labelText: 'Damage Note',
                                              hintStyle: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 16.0,
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
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
                                            controller: DamageStatusController,
                                            decoration: InputDecoration(
                                              labelText: 'Damage Status',
                                              hintStyle: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 16.0,
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
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
                                        "Service Details",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.red),
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
                                            controller: ServiceByController,
                                            decoration: InputDecoration(
                                              labelText: 'Service By',
                                              hintStyle: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 16.0,
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
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
                                            controller:
                                                ServiceStartDateController,
                                            decoration: InputDecoration(
                                              labelText: 'Service Start Date',
                                              hintStyle: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 16.0,
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
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
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
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
                                            controller:
                                                ServiceStartAtController,
                                            decoration: InputDecoration(
                                              labelText: 'Service Start At',
                                              hintStyle: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 16.0,
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
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
                                            controller: ServiceEndAtController,
                                            decoration: InputDecoration(
                                              labelText: 'Service End At',
                                              hintStyle: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 16.0,
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
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
                                            controller: StatusController,
                                            decoration: InputDecoration(
                                              labelText: 'Status',
                                              hintStyle: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 16.0,
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: height / 50,
                                        ),
                                        (li6.planServices.pserviceServiceStatus
                                                    .toString() ==
                                                "COMPLETED")
                                            ? Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0),
                                                  color: Colors.white,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey,
                                                      offset: Offset(
                                                          0.0, 1.0), //(x,y)
                                                      blurRadius: 2.0,
                                                    ),
                                                  ],
                                                ),
                                                // color: Colors.white,
                                                margin: EdgeInsets.all(3.0),
                                                child: Center(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            16.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        new Text(
                                                          "Service Before Images",
                                                          textAlign:
                                                              TextAlign.left,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 14),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Container(),
                                        (li6.planServices.pserviceServiceStatus
                                                    .toString() ==
                                                "COMPLETED")
                                            ? Container(
                                                child: GridView.count(
                                                  physics: ScrollPhysics(),
                                                  shrinkWrap: true,
                                                  crossAxisCount: 2,
                                                  childAspectRatio: 1,
                                                  children: List.generate(
                                                    li6
                                                        .planServices
                                                        .pserviceBeforeImg
                                                        .length,
                                                    (index) {
                                                      return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(10.0),
                                                          child: Card(
                                                              elevation: 5,
                                                              clipBehavior: Clip
                                                                  .antiAlias,
                                                              child: InkWell(
                                                                onTap: () {
                                                                  showDialog(
                                                                      context:
                                                                          context,
                                                                      child: Image.network(li6
                                                                          .planServices
                                                                          .pserviceBeforeImg[
                                                                              index]
                                                                          .imgPath));
                                                                },
                                                                child: Image
                                                                    .network(
                                                                  li6
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
                                                ),
                                              )
                                            : Container(),
                                        SizedBox(
                                          height: height / 50,
                                        ),
                                        (li6.planServices.pserviceServiceStatus
                                                    .toString() ==
                                                "COMPLETED")
                                            ? Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0),
                                                  color: Colors.white,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey,
                                                      offset: Offset(
                                                          0.0, 1.0), //(x,y)
                                                      blurRadius: 2.0,
                                                    ),
                                                  ],
                                                ),
                                                // color: Colors.white,
                                                margin: EdgeInsets.all(3.0),
                                                child: Center(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            16.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        new Text(
                                                          "Service After Images",
                                                          textAlign:
                                                              TextAlign.left,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 14),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Container(),
                                        (li6.planServices.pserviceServiceStatus
                                                    .toString() ==
                                                "COMPLETED")
                                            ? Container(
                                                child: GridView.count(
                                                  physics: ScrollPhysics(),
                                                  shrinkWrap: true,
                                                  crossAxisCount: 2,
                                                  childAspectRatio: 1,
                                                  children: List.generate(
                                                    li6
                                                        .planServices
                                                        .pserviceAfterImg
                                                        .length,
                                                    (index) {
                                                      return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(10.0),
                                                          child: Card(
                                                              elevation: 5,
                                                              clipBehavior: Clip
                                                                  .antiAlias,
                                                              child: InkWell(
                                                                onTap: () {
                                                                  showDialog(
                                                                      context:
                                                                          context,
                                                                      child: Image.network(li6
                                                                          .planServices
                                                                          .pserviceAfterImg[
                                                                              index]
                                                                          .imgPath));
                                                                },
                                                                child: Image
                                                                    .network(
                                                                  li6
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
                                                ),
                                              )
                                            : Container(),
                                      ])),
                              Container(
                                  margin: const EdgeInsets.only(top: 10),
                                  color: Colors.red.shade50,
                                  child: ExpansionTile(
                                      backgroundColor: Colors.white,
                                      title: Text(
                                        "Property details",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.red),
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
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
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
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
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
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
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
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
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
                                            minLines: 3,
                                            maxLines: 20,
                                            enabled: false,
                                            controller: valuecontroller,
                                            decoration: InputDecoration(
                                              labelText: 'Location',
                                              hintStyle: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 16.0,
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
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
                                            fontWeight: FontWeight.w600,
                                            color: Colors.red),
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
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
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
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
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
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
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
                                            controller:
                                                GroupContactNameController,
                                            decoration: InputDecoration(
                                              labelText: 'Group Contact Name',
                                              hintStyle: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 16.0,
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: height / 50,
                                        ),
                                      ])),
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
                                  "Approval Process",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red),
                                ),
                              ),

                              SingleChildScrollView(
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
                                          Text("Order By",
                                              softWrap: true,
                                              style: TextStyle(fontSize: 12),
                                              textAlign: TextAlign.center),
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
                                          Text("Designation",
                                              softWrap: true,
                                              style: TextStyle(fontSize: 12),
                                              textAlign: TextAlign.center),
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
                                          Text("Approver",
                                              softWrap: true,
                                              style: TextStyle(fontSize: 12),
                                              textAlign: TextAlign.center),
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
                                          Text("Status",
                                              softWrap: true,
                                              style: TextStyle(fontSize: 12),
                                              textAlign: TextAlign.center),
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
                                          Text("Actions",
                                              softWrap: true,
                                              style: TextStyle(fontSize: 12),
                                              textAlign: TextAlign.center),
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
                                  rows: li2.items
                                      .map(
                                        (list) => DataRow(cells: [
                                          DataCell(Center(
                                              child: Center(
                                            child: Wrap(
                                                direction:
                                                    Axis.vertical, //default
                                                alignment: WrapAlignment.center,
                                                children: [
                                                  Text(
                                                    list.apDetailsOrderby
                                                        .toString(),
                                                    textAlign: TextAlign.center,
                                                  )
                                                ]),
                                          ))),
                                          DataCell(Center(
                                              child: Center(
                                            child: Wrap(
                                                direction:
                                                    Axis.vertical, //default
                                                alignment: WrapAlignment.center,
                                                children: [
                                                  Text(list.urole.toString(),
                                                      textAlign:
                                                          TextAlign.center)
                                                ]),
                                          ))),
                                          DataCell(
                                            Center(
                                                child: Center(
                                                    child: Wrap(
                                                        direction: Axis
                                                            .vertical, //default
                                                        alignment: WrapAlignment
                                                            .center,
                                                        children: [
                                                  Text(list.assignby.toString(),
                                                      textAlign:
                                                          TextAlign.center)
                                                ]))),
                                          ),
                                          list.apStatus.toString() == "P"
                                              ? DataCell(
                                                  Center(
                                                      child: Center(
                                                          child: Wrap(
                                                              direction: Axis
                                                                  .vertical, //default
                                                              alignment: WrapAlignment.center,
                                                              children: [
                                                        Text("Pending",
                                                            textAlign: TextAlign
                                                                .center)
                                                      ]))),
                                                )
                                              : DataCell(
                                                  Center(
                                                      child: Center(
                                                          child: Wrap(
                                                              direction: Axis
                                                                  .vertical, //default
                                                              alignment: WrapAlignment.center,
                                                              children: [
                                                        Text("Approved",
                                                            textAlign: TextAlign
                                                                .center)
                                                      ]))),
                                                ),
                                          DataCell(
                                            (list.apStatus == "P" &&
                                                    ((list.urole ==
                                                            EmployeeLoginPagesState
                                                                .Userrole) ||
                                                        (EmployeeLoginPagesState
                                                                .Userrole ==
                                                            "SUPER ADMIN")))
                                                ? Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Container(
                                                          height: 30,
                                                          alignment:
                                                              Alignment.center,
                                                          decoration: BoxDecoration(
                                                              color: Colors
                                                                  .red.shade300,
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          50))),
                                                          child: FlatButton(
                                                            onPressed: () {
                                                              print("claim");
                                                              tblid =
                                                                  list.apTblId;
                                                              DamageClaim(li4
                                                                  .items
                                                                  .damageId);
                                                            },
                                                            child: Text(
                                                              "Claim & Approve",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          )),
                                                      Container(width: 10),
                                                      Container(
                                                          height: 30,
                                                          alignment:
                                                              Alignment.center,
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  Colors.grey,
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          50))),
                                                          child: FlatButton(
                                                            onPressed: () {
                                                              uploadImage(
                                                                  list.apId,
                                                                  list.apTblId,
                                                                  "r");

                                                              check().then(
                                                                  (value) {
                                                                if (value)
                                                                  ;
                                                                else
                                                                  showDialog<
                                                                      void>(
                                                                    context:
                                                                        context,
                                                                    barrierDismissible:
                                                                        false, // user must tap button!
                                                                    builder:
                                                                        (BuildContext
                                                                            context) {
                                                                      return AlertDialog(
                                                                        title: Text(
                                                                            "No Internet Connection"),
                                                                        actions: <
                                                                            Widget>[
                                                                          TextButton(
                                                                            child:
                                                                                Text('OK'),
                                                                            onPressed:
                                                                                () {
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
                                                              "Reject",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          )),
                                                    ],
                                                  )
                                                : (list.apStatus == "A")
                                                    ? Container(
                                                        child: Text("-"))
                                                    : Center(
                                                        child: Container(
                                                            child: Text(
                                                                "Not Assigned"))),
                                          ),
                                        ]),
                                      )
                                      .toList(),
                                ),
                              ),
                            ],
                          ),
                        )
                      : widget.verify == "Service Verify"
                          ? SingleChildScrollView(
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
                                                fontWeight: FontWeight.w600,
                                                color: Colors.red),
                                          ),
                                          initiallyExpanded: true,
                                          children: [
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
                                                  labelText: 'Service By',
                                                  hintStyle: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 16.0,
                                                  ),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0),
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
                                                controller:
                                                    ServiceStartDateController,
                                                decoration: InputDecoration(
                                                  labelText:
                                                      'Service Start Date',
                                                  hintStyle: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 16.0,
                                                  ),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0),
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
                                                controller:
                                                    ServiceStatusController,
                                                decoration: InputDecoration(
                                                  labelText: 'Service Status',
                                                  hintStyle: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 16.0,
                                                  ),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0),
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
                                                controller:
                                                    ServiceStartAtController,
                                                decoration: InputDecoration(
                                                  labelText: 'Service Start At',
                                                  hintStyle: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 16.0,
                                                  ),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0),
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
                                                controller:
                                                    ServiceEndAtController,
                                                decoration: InputDecoration(
                                                  labelText: 'Service End At',
                                                  hintStyle: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 16.0,
                                                  ),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0),
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
                                                controller: StatusController,
                                                decoration: InputDecoration(
                                                  labelText: 'Status',
                                                  hintStyle: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 16.0,
                                                  ),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: height / 50,
                                            ),
                                            (li6.planServices
                                                        .pserviceServiceStatus
                                                        .toString() ==
                                                    "COMPLETED")
                                                ? Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5.0),
                                                      color: Colors.white,
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.grey,
                                                          offset: Offset(
                                                              0.0, 1.0), //(x,y)
                                                          blurRadius: 2.0,
                                                        ),
                                                      ],
                                                    ),
                                                    // color: Colors.white,
                                                    margin: EdgeInsets.all(3.0),
                                                    child: Center(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(16.0),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            new Text(
                                                              "Service Before Images",
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 14),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : Container(),
                                            (li6.planServices
                                                        .pserviceServiceStatus
                                                        .toString() ==
                                                    "COMPLETED")
                                                ? Container(
                                                    child: GridView.count(
                                                      physics: ScrollPhysics(),
                                                      shrinkWrap: true,
                                                      crossAxisCount: 2,
                                                      childAspectRatio: 1,
                                                      children: List.generate(
                                                        li6
                                                            .planServices
                                                            .pserviceBeforeImg
                                                            .length,
                                                        (index) {
                                                          return Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .all(
                                                                      10.0),
                                                              child: Card(
                                                                  elevation: 5,
                                                                  clipBehavior: Clip
                                                                      .antiAlias,
                                                                  child:
                                                                      InkWell(
                                                                    onTap: () {
                                                                      showDialog(
                                                                          context:
                                                                              context,
                                                                          child: Image.network(li6
                                                                              .planServices
                                                                              .pserviceBeforeImg[index]
                                                                              .imgPath));
                                                                    },
                                                                    child: Image
                                                                        .network(
                                                                      li6
                                                                          .planServices
                                                                          .pserviceBeforeImg[
                                                                              index]
                                                                          .imgPath,
                                                                      height:
                                                                          300,
                                                                      width:
                                                                          300,
                                                                    ),
                                                                  )));
                                                        },
                                                      ),
                                                    ),
                                                  )
                                                : Container(),
                                            SizedBox(
                                              height: height / 50,
                                            ),
                                            (li6.planServices
                                                        .pserviceServiceStatus
                                                        .toString() ==
                                                    "COMPLETED")
                                                ? Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5.0),
                                                      color: Colors.white,
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.grey,
                                                          offset: Offset(
                                                              0.0, 1.0), //(x,y)
                                                          blurRadius: 2.0,
                                                        ),
                                                      ],
                                                    ),
                                                    // color: Colors.white,
                                                    margin: EdgeInsets.all(3.0),
                                                    child: Center(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(16.0),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            new Text(
                                                              "Service After Images",
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 14),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : Container(),
                                            (li6.planServices
                                                        .pserviceServiceStatus
                                                        .toString() ==
                                                    "COMPLETED")
                                                ? Container(
                                                    child: GridView.count(
                                                      physics: ScrollPhysics(),
                                                      shrinkWrap: true,
                                                      crossAxisCount: 2,
                                                      childAspectRatio: 1,
                                                      children: List.generate(
                                                        li6
                                                            .planServices
                                                            .pserviceAfterImg
                                                            .length,
                                                        (index) {
                                                          return Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .all(
                                                                      10.0),
                                                              child: Card(
                                                                  elevation: 5,
                                                                  clipBehavior: Clip
                                                                      .antiAlias,
                                                                  child:
                                                                      InkWell(
                                                                    onTap: () {
                                                                      showDialog(
                                                                          context:
                                                                              context,
                                                                          child: Image.network(li6
                                                                              .planServices
                                                                              .pserviceAfterImg[index]
                                                                              .imgPath));
                                                                    },
                                                                    child: Image
                                                                        .network(
                                                                      li6
                                                                          .planServices
                                                                          .pserviceAfterImg[
                                                                              index]
                                                                          .imgPath,
                                                                      height:
                                                                          300,
                                                                      width:
                                                                          300,
                                                                    ),
                                                                  )));
                                                        },
                                                      ),
                                                    ),
                                                  )
                                                : Container(),
                                          ])),

                                  Container(
                                      margin: const EdgeInsets.only(top: 10),
                                      color: Colors.red.shade50,
                                      child: ExpansionTile(
                                          backgroundColor: Colors.white,
                                          title: Text(
                                            "Property details",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: Colors.red),
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
                                                controller:
                                                    PropertyNameController,
                                                decoration: InputDecoration(
                                                  labelText: 'Property Name',
                                                  hintStyle: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 16.0,
                                                  ),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0),
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
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0),
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
                                                controller:
                                                    PropertyCodeController,
                                                decoration: InputDecoration(
                                                  labelText: 'Property Code',
                                                  hintStyle: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 16.0,
                                                  ),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0),
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
                                                controller:
                                                    PropertyTypeController,
                                                decoration: InputDecoration(
                                                  labelText: 'Property Type',
                                                  hintStyle: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 16.0,
                                                  ),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0),
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
                                                minLines: 3,
                                                maxLines: 20,
                                                enabled: false,
                                                controller: valuecontroller,
                                                decoration: InputDecoration(
                                                  labelText: 'Location',
                                                  hintStyle: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 16.0,
                                                  ),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0),
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
                                                fontWeight: FontWeight.w600,
                                                color: Colors.red),
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
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0),
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
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0),
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
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0),
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
                                                controller:
                                                    GroupContactNameController,
                                                decoration: InputDecoration(
                                                  labelText:
                                                      'Group Contact Name',
                                                  hintStyle: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 16.0,
                                                  ),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: height / 50,
                                            ),
                                          ])),
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
                                    margin:
                                        EdgeInsets.only(top: 10.0, bottom: 10),

                                    child: new Text(
                                      "Approval Process",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red),
                                    ),
                                  ),

                                  SingleChildScrollView(
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
                                              Text("Order By",
                                                  softWrap: true,
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                  textAlign: TextAlign.center),
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
                                              Text("Designation",
                                                  softWrap: true,
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                  textAlign: TextAlign.center),
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
                                              Text("Approver",
                                                  softWrap: true,
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                  textAlign: TextAlign.center),
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
                                              Text("Status",
                                                  softWrap: true,
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                  textAlign: TextAlign.center),
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
                                              Text("Actions",
                                                  softWrap: true,
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                  textAlign: TextAlign.center),
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
                                      rows: li2.items
                                          .map(
                                            (list) => DataRow(cells: [
                                              DataCell(Center(
                                                  child: Center(
                                                child: Wrap(
                                                    direction:
                                                        Axis.vertical, //default
                                                    alignment:
                                                        WrapAlignment.center,
                                                    children: [
                                                      Text(
                                                        list.apDetailsOrderby
                                                            .toString(),
                                                        textAlign:
                                                            TextAlign.center,
                                                      )
                                                    ]),
                                              ))),
                                              DataCell(Center(
                                                  child: Center(
                                                child: Wrap(
                                                    direction:
                                                        Axis.vertical, //default
                                                    alignment:
                                                        WrapAlignment.center,
                                                    children: [
                                                      Text(
                                                          list.urole.toString(),
                                                          textAlign:
                                                              TextAlign.center)
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
                                                      Text(
                                                          list.assignby
                                                              .toString(),
                                                          textAlign:
                                                              TextAlign.center)
                                                    ]))),
                                              ),
                                              list.apStatus.toString() == "P"
                                                  ? DataCell(
                                                      Center(
                                                          child: Center(
                                                              child: Wrap(
                                                                  direction: Axis
                                                                      .vertical, //default
                                                                  alignment: WrapAlignment.center,
                                                                  children: [
                                                            Text("Pending",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center)
                                                          ]))),
                                                    )
                                                  : DataCell(
                                                      Center(
                                                          child: Center(
                                                              child: Wrap(
                                                                  direction: Axis
                                                                      .vertical, //default
                                                                  alignment: WrapAlignment.center,
                                                                  children: [
                                                            Text("Approved",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center)
                                                          ]))),
                                                    ),
                                              DataCell(
                                                (list.apStatus == "P" &&
                                                        ((list.urole ==
                                                                EmployeeLoginPagesState
                                                                    .Userrole) ||
                                                            (EmployeeLoginPagesState
                                                                    .Userrole ==
                                                                "SUPER ADMIN")))
                                                    ? Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Container(
                                                              height: 30,
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .red
                                                                      .shade300,
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              50))),
                                                              child: FlatButton(
                                                                onPressed: () {
                                                                  showDialog<
                                                                      void>(
                                                                    context:
                                                                        context,
                                                                    barrierDismissible:
                                                                        false,
                                                                    // user must tap button!
                                                                    builder:
                                                                        (BuildContext
                                                                            context) {
                                                                      return AlertDialog(
                                                                        title:
                                                                            Text(
                                                                          "Reshedule Date",
                                                                          style:
                                                                              TextStyle(color: Colors.red),
                                                                        ),
                                                                        content:
                                                                            Padding(
                                                                          padding: const EdgeInsets.only(
                                                                              left: 10.0,
                                                                              right: 10.0),
                                                                          child:
                                                                              new TextField(
                                                                            onTap:
                                                                                () async {
                                                                              DateTime date = DateTime(1900);
                                                                              FocusScope.of(context).requestFocus(new FocusNode());

                                                                              date = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now().subtract(new Duration(days: 23725)), lastDate: DateTime.now().add(new Duration(days: 365)));
                                                                              /*    var time =await showTimePicker(
                        initialTime: TimeOfDay.now(),
                        context: context,
                      );*/
                                                                              sql_dob = dateFormatter.format(date);
                                                                              print("date" + sql_dob);
                                                                              var month = date.month.toString();
                                                                              if (date.month == 1)
                                                                                month = 'January';
                                                                              else if (date.month == 2)
                                                                                month = 'February';
                                                                              else if (date.month == 3)
                                                                                month = 'March';
                                                                              else if (date.month == 4)
                                                                                month = 'April';
                                                                              else if (date.month == 5)
                                                                                month = 'May';
                                                                              else if (date.month == 6)
                                                                                month = 'June';
                                                                              else if (date.month == 7)
                                                                                month = 'July';
                                                                              else if (date.month == 8)
                                                                                month = 'August';
                                                                              else if (date.month == 9)
                                                                                month = 'September';
                                                                              else if (date.month == 10)
                                                                                month = 'October';
                                                                              else if (date.month == 11)
                                                                                month = 'November';
                                                                              else if (date.month == 12)
                                                                                month = 'December';

                                                                              if (date.day == 1 || date.day == 21 || date.day == 31) {
                                                                                datecontroller.text = date.day.toString() + 'st ' + month + ', ' + date.year.toString();
                                                                              } else if (date.day == 2 || date.day == 22) {
                                                                                datecontroller.text = date.day.toString() + 'nd ' + month + ', ' + date.year.toString();
                                                                              } else if (date.day == 3 || date.day == 23) {
                                                                                datecontroller.text = date.day.toString() + 'rd ' + month + ', ' + date.year.toString();
                                                                              } else {
                                                                                datecontroller.text = date.day.toString() + 'th ' + month + ', ' + date.year.toString();
                                                                              }
                                                                            },
                                                                            enabled:
                                                                                true,
                                                                            controller:
                                                                                datecontroller,
                                                                            decoration:
                                                                                InputDecoration(
                                                                              labelText: 'Reshedule Date',
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
                                                                        actions: [
                                                                          TextButton(
                                                                            child:
                                                                                Text('OK'),
                                                                            onPressed:
                                                                                () {
                                                                              check().then((value) {
                                                                                if (value) {
                                                                                  print("ok");
                                                                                  if (datecontroller.text.length > 0)
                                                                                    reservicecall();
                                                                                  else
                                                                                    showDialog<void>(
                                                                                      context: context,
                                                                                      barrierDismissible: false,
                                                                                      // user must tap button!
                                                                                      builder: (BuildContext context) {
                                                                                        return AlertDialog(
                                                                                          title: Text("Date cannot be Empty"),
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
                                                                                    barrierDismissible: false,
                                                                                    // user must tap button!
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
                                                                            child:
                                                                                Text('Cancel'),
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.of(context).pop();
                                                                            },
                                                                          ),
                                                                        ],
                                                                      );
                                                                    },
                                                                  );
                                                                },
                                                                child: Text(
                                                                  "Reservice",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              )),
                                                          Container(width: 10),
                                                          Container(
                                                              height: 30,
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .green,
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              50))),
                                                              child: FlatButton(
                                                                onPressed: () {
                                                                  check().then(
                                                                      (value) {
                                                                    if (value)
                                                                      uploadImage(
                                                                          list.apId,
                                                                          list.apTblId,
                                                                          "a");
                                                                    else
                                                                      showDialog<
                                                                          void>(
                                                                        context:
                                                                            context,
                                                                        barrierDismissible:
                                                                            false, // user must tap button!
                                                                        builder:
                                                                            (BuildContext
                                                                                context) {
                                                                          return AlertDialog(
                                                                            title:
                                                                                Text("No Internet Connection"),
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
                                                                  "Approve",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              )),
                                                          Container(width: 10),
                                                          Container(
                                                              height: 30,
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .grey,
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              50))),
                                                              child: FlatButton(
                                                                onPressed: () {
                                                                  check().then(
                                                                      (value) {
                                                                    if (value)
                                                                      uploadImage(
                                                                          list.apId,
                                                                          list.apTblId,
                                                                          "r");
                                                                    else
                                                                      showDialog<
                                                                          void>(
                                                                        context:
                                                                            context,
                                                                        barrierDismissible:
                                                                            false, // user must tap button!
                                                                        builder:
                                                                            (BuildContext
                                                                                context) {
                                                                          return AlertDialog(
                                                                            title:
                                                                                Text("No Internet Connection"),
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
                                                                  "Reject",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              )),
                                                        ],
                                                      )
                                                    : (list.apStatus == "A")
                                                        ? Container(
                                                            child: Text("-"))
                                                        : Center(
                                                            child: Container(
                                                                child: Text(
                                                                    "Not Assigned"))),
                                              ),
                                            ]),
                                          )
                                          .toList(),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : widget.verify == "Reservice Verify"
                              ? SingleChildScrollView(
                                  child: new Column(
                                    children: <Widget>[
                                      Container(
                                          margin:
                                              const EdgeInsets.only(top: 10),
                                          color: Colors.red.shade50,
                                          child: ExpansionTile(
                                              backgroundColor: Colors.white,
                                              initiallyExpanded: true,
                                              title: Text(
                                                "Re Service Details",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.red),
                                              ),
                                              children: [
                                                SizedBox(
                                                  height: height / 50,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10.0,
                                                          right: 10.0),
                                                  child: new TextField(
                                                    enabled: false,
                                                    controller:
                                                        ServiceByController,
                                                    decoration: InputDecoration(
                                                      labelText: 'Service By',
                                                      hintStyle: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 16.0,
                                                      ),
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5.0),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: height / 50,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10.0,
                                                          right: 10.0),
                                                  child: new TextField(
                                                    enabled: false,
                                                    controller:
                                                        ServiceStartDateController,
                                                    decoration: InputDecoration(
                                                      labelText:
                                                          'Service Start Date',
                                                      hintStyle: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 16.0,
                                                      ),
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5.0),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: height / 50,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10.0,
                                                          right: 10.0),
                                                  child: new TextField(
                                                    enabled: false,
                                                    controller:
                                                        ServiceStatusController,
                                                    decoration: InputDecoration(
                                                      labelText:
                                                          'Service Status',
                                                      hintStyle: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 16.0,
                                                      ),
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5.0),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: height / 50,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10.0,
                                                          right: 10.0),
                                                  child: new TextField(
                                                    enabled: false,
                                                    controller:
                                                        ServiceStartAtController,
                                                    decoration: InputDecoration(
                                                      labelText:
                                                          'Service Start At',
                                                      hintStyle: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 16.0,
                                                      ),
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5.0),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: height / 50,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10.0,
                                                          right: 10.0),
                                                  child: new TextField(
                                                    enabled: false,
                                                    controller:
                                                        ServiceEndAtController,
                                                    decoration: InputDecoration(
                                                      labelText:
                                                          'Service End At',
                                                      hintStyle: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 16.0,
                                                      ),
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5.0),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: height / 50,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10.0,
                                                          right: 10.0),
                                                  child: new TextField(
                                                    enabled: false,
                                                    controller:
                                                        StatusController,
                                                    decoration: InputDecoration(
                                                      labelText: 'Status',
                                                      hintStyle: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 16.0,
                                                      ),
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5.0),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: height / 50,
                                                ),
                                                (li6.planServices
                                                            .pserviceServiceStatus
                                                            .toString() ==
                                                        "COMPLETED")
                                                    ? Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      5.0),
                                                          color: Colors.white,
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color:
                                                                  Colors.grey,
                                                              offset: Offset(
                                                                  0.0,
                                                                  1.0), //(x,y)
                                                              blurRadius: 2.0,
                                                            ),
                                                          ],
                                                        ),
                                                        // color: Colors.white,
                                                        margin:
                                                            EdgeInsets.all(3.0),
                                                        child: Center(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(16.0),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                new Text(
                                                                  "Service Before Images",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .red,
                                                                      fontSize:
                                                                          14),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    : Container(),
                                                (li6.planServices
                                                            .pserviceServiceStatus
                                                            .toString() ==
                                                        "COMPLETED")
                                                    ? Container(
                                                        child: GridView.count(
                                                          physics:
                                                              ScrollPhysics(),
                                                          shrinkWrap: true,
                                                          crossAxisCount: 2,
                                                          childAspectRatio: 1,
                                                          children:
                                                              List.generate(
                                                            li6
                                                                .planServices
                                                                .pserviceBeforeImg
                                                                .length,
                                                            (index) {
                                                              return Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          10.0),
                                                                  child: Card(
                                                                      elevation:
                                                                          5,
                                                                      clipBehavior:
                                                                          Clip
                                                                              .antiAlias,
                                                                      child:
                                                                          InkWell(
                                                                        onTap:
                                                                            () {
                                                                          showDialog(
                                                                              context: context,
                                                                              child: Image.network(li6.planServices.pserviceBeforeImg[index].imgPath));
                                                                        },
                                                                        child: Image
                                                                            .network(
                                                                          li6
                                                                              .planServices
                                                                              .pserviceBeforeImg[index]
                                                                              .imgPath,
                                                                          height:
                                                                              300,
                                                                          width:
                                                                              300,
                                                                        ),
                                                                      )));
                                                            },
                                                          ),
                                                        ),
                                                      )
                                                    : Container(),
                                                SizedBox(
                                                  height: height / 50,
                                                ),
                                                (li6.planServices
                                                            .pserviceServiceStatus
                                                            .toString() ==
                                                        "COMPLETED")
                                                    ? Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      5.0),
                                                          color: Colors.white,
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color:
                                                                  Colors.grey,
                                                              offset: Offset(
                                                                  0.0,
                                                                  1.0), //(x,y)
                                                              blurRadius: 2.0,
                                                            ),
                                                          ],
                                                        ),
                                                        // color: Colors.white,
                                                        margin:
                                                            EdgeInsets.all(3.0),
                                                        child: Center(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(16.0),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                new Text(
                                                                  "Service After Images",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .red,
                                                                      fontSize:
                                                                          14),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    : Container(),
                                                (li6.planServices
                                                            .pserviceServiceStatus
                                                            .toString() ==
                                                        "COMPLETED")
                                                    ? Container(
                                                        child: GridView.count(
                                                          physics:
                                                              ScrollPhysics(),
                                                          shrinkWrap: true,
                                                          crossAxisCount: 2,
                                                          childAspectRatio: 1,
                                                          children:
                                                              List.generate(
                                                            li6
                                                                .planServices
                                                                .pserviceAfterImg
                                                                .length,
                                                            (index) {
                                                              return Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          10.0),
                                                                  child: Card(
                                                                      elevation:
                                                                          5,
                                                                      clipBehavior:
                                                                          Clip
                                                                              .antiAlias,
                                                                      child:
                                                                          InkWell(
                                                                        onTap:
                                                                            () {
                                                                          showDialog(
                                                                              context: context,
                                                                              child: Image.network(li6.planServices.pserviceAfterImg[index].imgPath));
                                                                        },
                                                                        child: Image
                                                                            .network(
                                                                          li6
                                                                              .planServices
                                                                              .pserviceAfterImg[index]
                                                                              .imgPath,
                                                                          height:
                                                                              300,
                                                                          width:
                                                                              300,
                                                                        ),
                                                                      )));
                                                            },
                                                          ),
                                                        ),
                                                      )
                                                    : Container(),
                                              ])),
                                      Container(
                                          margin:
                                              const EdgeInsets.only(top: 10),
                                          color: Colors.red.shade50,
                                          child: ExpansionTile(
                                              backgroundColor: Colors.white,
                                              initiallyExpanded: false,
                                              title: Text(
                                                "Property Details",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.red),
                                              ),
                                              children: [
                                                SizedBox(
                                                  height: height / 50,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10.0,
                                                          right: 10.0),
                                                  child: new TextField(
                                                    enabled: false,
                                                    controller:
                                                        PropertyNameController,
                                                    decoration: InputDecoration(
                                                      labelText:
                                                          'Property Name',
                                                      hintStyle: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 16.0,
                                                      ),
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5.0),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: height / 50,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10.0,
                                                          right: 10.0),
                                                  child: new TextField(
                                                    enabled: false,
                                                    controller:
                                                        GroupNameController,
                                                    decoration: InputDecoration(
                                                      labelText: 'Group Name',
                                                      hintStyle: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 16.0,
                                                      ),
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5.0),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: height / 50,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10.0,
                                                          right: 10.0),
                                                  child: new TextField(
                                                    enabled: false,
                                                    controller:
                                                        PropertyCodeController,
                                                    decoration: InputDecoration(
                                                      labelText:
                                                          'Property Code',
                                                      hintStyle: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 16.0,
                                                      ),
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5.0),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: height / 50,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10.0,
                                                          right: 10.0),
                                                  child: new TextField(
                                                    enabled: false,
                                                    controller:
                                                        PropertyTypeController,
                                                    decoration: InputDecoration(
                                                      labelText:
                                                          'Property Type',
                                                      hintStyle: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 16.0,
                                                      ),
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5.0),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: height / 50,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10.0,
                                                          right: 10.0),
                                                  child: new TextFormField(
                                                    minLines: 3,
                                                    maxLines: 20,
                                                    enabled: false,
                                                    controller: valuecontroller,
                                                    decoration: InputDecoration(
                                                      labelText: 'Location',
                                                      hintStyle: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 16.0,
                                                      ),
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5.0),
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
                                          margin:
                                              const EdgeInsets.only(top: 10),
                                          color: Colors.red.shade50,
                                          child: ExpansionTile(
                                              backgroundColor: Colors.white,
                                              initiallyExpanded: false,
                                              title: Text(
                                                "Customer Details",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.red),
                                              ),
                                              children: [
                                                SizedBox(
                                                  height: height / 50,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10.0,
                                                          right: 10.0),
                                                  child: new TextField(
                                                    enabled: false,
                                                    controller:
                                                        CusNameController,
                                                    decoration: InputDecoration(
                                                      labelText:
                                                          'Customer Name',
                                                      hintStyle: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 16.0,
                                                      ),
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5.0),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: height / 50,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10.0,
                                                          right: 10.0),
                                                  child: new TextField(
                                                    enabled: false,
                                                    controller:
                                                        CusCodeController,
                                                    decoration: InputDecoration(
                                                      labelText:
                                                          'Customer Code',
                                                      hintStyle: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 16.0,
                                                      ),
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5.0),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: height / 50,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10.0,
                                                          right: 10.0),
                                                  child: new TextField(
                                                    enabled: false,
                                                    controller: PhoneController,
                                                    decoration: InputDecoration(
                                                      labelText:
                                                          'Contact Mobile',
                                                      hintStyle: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 16.0,
                                                      ),
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5.0),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: height / 50,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10.0,
                                                          right: 10.0),
                                                  child: new TextField(
                                                    enabled: false,
                                                    controller:
                                                        GroupContactNameController,
                                                    decoration: InputDecoration(
                                                      labelText:
                                                          'Group Contact Name',
                                                      hintStyle: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 16.0,
                                                      ),
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5.0),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: height / 50,
                                                ),
                                              ])),
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
                                        margin: EdgeInsets.only(
                                            top: 10.0, bottom: 10),

                                        child: new Text(
                                          "Approval Process",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red),
                                        ),
                                      ),

                                      SingleChildScrollView(
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
                                                  Text("Order By",
                                                      softWrap: true,
                                                      style: TextStyle(
                                                          fontSize: 12),
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
                                                  Text("Designation",
                                                      softWrap: true,
                                                      style: TextStyle(
                                                          fontSize: 12),
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
                                                  Text("Approver",
                                                      softWrap: true,
                                                      style: TextStyle(
                                                          fontSize: 12),
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
                                                  Text("Status",
                                                      softWrap: true,
                                                      style: TextStyle(
                                                          fontSize: 12),
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
                                                  Text("Actions",
                                                      softWrap: true,
                                                      style: TextStyle(
                                                          fontSize: 12),
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
                                          rows: li2.items
                                              .map(
                                                (list) => DataRow(cells: [
                                                  DataCell(Center(
                                                      child: Center(
                                                    child: Wrap(
                                                        direction: Axis
                                                            .vertical, //default
                                                        alignment: WrapAlignment
                                                            .center,
                                                        children: [
                                                          Text(
                                                            list.apDetailsOrderby
                                                                .toString(),
                                                            textAlign: TextAlign
                                                                .center,
                                                          )
                                                        ]),
                                                  ))),
                                                  DataCell(Center(
                                                      child: Center(
                                                    child: Wrap(
                                                        direction: Axis
                                                            .vertical, //default
                                                        alignment: WrapAlignment
                                                            .center,
                                                        children: [
                                                          Text(
                                                              list.urole
                                                                  .toString(),
                                                              textAlign:
                                                                  TextAlign
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
                                                          Text(
                                                              list.assignby
                                                                  .toString(),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center)
                                                        ]))),
                                                  ),
                                                  list.apStatus.toString() ==
                                                          "P"
                                                      ? DataCell(
                                                          Center(
                                                              child: Center(
                                                                  child: Wrap(
                                                                      direction:
                                                                          Axis.vertical, //default
                                                                      alignment: WrapAlignment.center,
                                                                      children: [
                                                                Text("Pending",
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center)
                                                              ]))),
                                                        )
                                                      : DataCell(
                                                          Center(
                                                              child: Center(
                                                                  child: Wrap(
                                                                      direction:
                                                                          Axis.vertical, //default
                                                                      alignment: WrapAlignment.center,
                                                                      children: [
                                                                Text("Approved",
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center)
                                                              ]))),
                                                        ),
                                                  DataCell(
                                                    (list.apStatus == "P" &&
                                                            ((list.urole ==
                                                                    EmployeeLoginPagesState
                                                                        .Userrole) ||
                                                                (EmployeeLoginPagesState
                                                                        .Userrole ==
                                                                    "SUPER ADMIN")))
                                                        ? Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Container(
                                                                  height: 30,
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  decoration: BoxDecoration(
                                                                      color: Colors
                                                                          .green,
                                                                      borderRadius:
                                                                          BorderRadius.all(Radius.circular(
                                                                              50))),
                                                                  child:
                                                                      FlatButton(
                                                                    onPressed:
                                                                        () {
                                                                      check().then(
                                                                          (value) {
                                                                        if (value)
                                                                          uploadImage(
                                                                              list.apId,
                                                                              list.apTblId,
                                                                              "a");
                                                                        else
                                                                          showDialog<
                                                                              void>(
                                                                            context:
                                                                                context,
                                                                            barrierDismissible:
                                                                                false, // user must tap button!
                                                                            builder:
                                                                                (BuildContext context) {
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
                                                                      "Approve",
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                  )),
                                                              Container(
                                                                  width: 10),
                                                              Container(
                                                                  height: 30,
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  decoration: BoxDecoration(
                                                                      color: Colors
                                                                          .grey,
                                                                      borderRadius:
                                                                          BorderRadius.all(Radius.circular(
                                                                              50))),
                                                                  child:
                                                                      FlatButton(
                                                                    onPressed:
                                                                        () {
                                                                      check().then(
                                                                          (value) {
                                                                        if (value)
                                                                          uploadImage(
                                                                              list.apId,
                                                                              list.apTblId,
                                                                              "r");
                                                                        else
                                                                          showDialog<
                                                                              void>(
                                                                            context:
                                                                                context,
                                                                            barrierDismissible:
                                                                                false, // user must tap button!
                                                                            builder:
                                                                                (BuildContext context) {
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
                                                                      "Reject",
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                  )),
                                                            ],
                                                          )
                                                        : (list.apStatus == "A")
                                                            ? Container(
                                                                child:
                                                                    Text("-"))
                                                            : Center(
                                                                child: Container(
                                                                    child: Text(
                                                                        "Not Assigned"))),
                                                  ),
                                                ]),
                                              )
                                              .toList(),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : widget.verify == "Bill Verify"
                                  ? SingleChildScrollView(
                                      child: new Column(
                                        children: <Widget>[
                                          Container(
                                              margin: const EdgeInsets.only(
                                                  top: 10),
                                              color: Colors.red.shade50,
                                              child: ExpansionTile(
                                                  backgroundColor: Colors.white,
                                                  initiallyExpanded: true,
                                                  title: Text(
                                                    "Bill Details",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.red),
                                                  ),
                                                  children: [
                                                    SizedBox(
                                                      height: height / 50,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10.0,
                                                              right: 10.0),
                                                      child: new TextField(
                                                        enabled: false,
                                                        controller:
                                                            BillNoController,
                                                        decoration:
                                                            InputDecoration(
                                                          labelText: 'Bill No',
                                                          hintStyle: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 16.0,
                                                          ),
                                                          border:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5.0),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: height / 50,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10.0,
                                                              right: 10.0),
                                                      child: new TextField(
                                                        enabled: false,
                                                        controller:
                                                            InvoiceNoController,
                                                        decoration:
                                                            InputDecoration(
                                                          labelText:
                                                              'Invoice No',
                                                          hintStyle: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 16.0,
                                                          ),
                                                          border:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5.0),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: height / 50,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10.0,
                                                              right: 10.0),
                                                      child: new TextField(
                                                        enabled: false,
                                                        controller:
                                                            InvoicedateController,
                                                        decoration:
                                                            InputDecoration(
                                                          labelText:
                                                              'Invoice date',
                                                          hintStyle: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 16.0,
                                                          ),
                                                          border:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5.0),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: height / 50,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10.0,
                                                              right: 10.0),
                                                      child: new TextField(
                                                        enabled: false,
                                                        controller:
                                                            BillNotesController,
                                                        decoration:
                                                            InputDecoration(
                                                          labelText:
                                                              'Bill Notes',
                                                          hintStyle: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 16.0,
                                                          ),
                                                          border:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5.0),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: height / 50,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10.0,
                                                              right: 10.0),
                                                      child: new TextFormField(
                                                        enabled: false,
                                                        controller:
                                                            TotalItemscontroller,
                                                        decoration:
                                                            InputDecoration(
                                                          labelText:
                                                              'Total Items',
                                                          hintStyle: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 16.0,
                                                          ),
                                                          border:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5.0),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: height / 50,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10.0,
                                                              right: 10.0),
                                                      child: new TextField(
                                                        enabled: false,
                                                        controller:
                                                            BillAmountController,
                                                        decoration:
                                                            InputDecoration(
                                                          labelText:
                                                              'Bill Amount',
                                                          hintStyle: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 16.0,
                                                          ),
                                                          border:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5.0),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: height / 50,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10.0,
                                                              right: 10.0),
                                                      child: new TextField(
                                                        enabled: false,
                                                        controller:
                                                            BillPaidAmountController,
                                                        decoration:
                                                            InputDecoration(
                                                          labelText:
                                                              'Bill Paid Amount',
                                                          hintStyle: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 16.0,
                                                          ),
                                                          border:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5.0),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: height / 50,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10.0,
                                                              right: 10.0),
                                                      child: new TextField(
                                                        enabled: false,
                                                        controller:
                                                            BillDiscountAmountController,
                                                        decoration:
                                                            InputDecoration(
                                                          labelText:
                                                              'Bill Discount Amount',
                                                          hintStyle: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 16.0,
                                                          ),
                                                          border:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5.0),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: height / 50,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10.0,
                                                              right: 10.0),
                                                      child: new TextFormField(
                                                        enabled: false,
                                                        controller:
                                                            BillPaidStatusController,
                                                        decoration:
                                                            InputDecoration(
                                                          labelText:
                                                              'Bill Status',
                                                          hintStyle: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 16.0,
                                                          ),
                                                          border:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5.0),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: height / 50,
                                                    ),
                                                  ])),
                                          Container(
                                              margin: const EdgeInsets.only(
                                                  top: 10),
                                              color: Colors.red.shade50,
                                              child: ExpansionTile(
                                                  backgroundColor: Colors.white,
                                                  initiallyExpanded: true,
                                                  title: Text(
                                                    "Paid Bill Details",
                                                    style: TextStyle(
                                                        fontWeight:
                                                        FontWeight.w600,
                                                        color: Colors.red),
                                                  ),
                                                  children: [
                                                    SizedBox(
                                                      height: height / 50,
                                                    ),
                                                    Padding(
                                                      padding:
                                                      const EdgeInsets.only(
                                                          left: 10.0,
                                                          right: 10.0),
                                                      child: new TextField(
                                                        enabled: false,
                                                        controller:
                                                        PaidReferrenceNo,
                                                        decoration:
                                                        InputDecoration(
                                                          labelText: 'Paid Reference No',
                                                          hintStyle: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 16.0,
                                                          ),
                                                          border:
                                                          OutlineInputBorder(
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                5.0),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: height / 50,
                                                    ),
                                                    Padding(
                                                      padding:
                                                      const EdgeInsets.only(
                                                          left: 10.0,
                                                          right: 10.0),
                                                      child: new TextField(
                                                        enabled: false,
                                                        controller:
                                                        PaidStatusController,
                                                        decoration:
                                                        InputDecoration(
                                                          labelText:
                                                          'Paid Status',
                                                          hintStyle: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 16.0,
                                                          ),
                                                          border:
                                                          OutlineInputBorder(
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                5.0),
                                                          ),
                                                        ),
                                                      ),
                                                    ),

                                                    SizedBox(
                                                      height: height / 50,
                                                    ),
                                                  ])),
                                          Container(
                                              margin: const EdgeInsets.only(
                                                  top: 10),
                                              color: Colors.red.shade50,
                                              child: ExpansionTile(
                                                  backgroundColor: Colors.white,
                                                  initiallyExpanded: false,
                                                  title: Text(
                                                    "Customer Details",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.red),
                                                  ),
                                                  children: [
                                                    SizedBox(
                                                      height: height / 50,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10.0,
                                                              right: 10.0),
                                                      child: new TextField(
                                                        enabled: false,
                                                        controller:
                                                            CusNameController,
                                                        decoration:
                                                            InputDecoration(
                                                          labelText:
                                                              'Customer Name',
                                                          hintStyle: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 16.0,
                                                          ),
                                                          border:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5.0),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: height / 50,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10.0,
                                                              right: 10.0),
                                                      child: new TextField(
                                                        enabled: false,
                                                        controller:
                                                            CusCodeController,
                                                        decoration:
                                                            InputDecoration(
                                                          labelText:
                                                              'Customer Code',
                                                          hintStyle: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 16.0,
                                                          ),
                                                          border:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5.0),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: height / 50,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10.0,
                                                              right: 10.0),
                                                      child: new TextField(
                                                        enabled: false,
                                                        controller:
                                                            PhoneController,
                                                        decoration:
                                                            InputDecoration(
                                                          labelText:
                                                              'Contact Mobile',
                                                          hintStyle: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 16.0,
                                                          ),
                                                          border:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5.0),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: height / 50,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10.0,
                                                              right: 10.0),
                                                      child: new TextField(
                                                        enabled: false,
                                                        controller:
                                                            CusStateController,
                                                        decoration:
                                                            InputDecoration(
                                                          labelText:
                                                              'Group Contact Name',
                                                          hintStyle: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 16.0,
                                                          ),
                                                          border:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5.0),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: height / 50,
                                                    ),
                                                  ])),
                                          Container(
                                            padding: EdgeInsets.all(16),
                                            width: width,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey,
                                                  offset:
                                                      Offset(0.0, 1.0), //(x,y)
                                                  blurRadius: 1.0,
                                                ),
                                              ],
                                            ),
                                            // color: Colors.white,
                                            margin: EdgeInsets.only(
                                                top: 10.0, bottom: 10),

                                            child: new Text(
                                              "Approval Process",
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.red),
                                            ),
                                          ),
                                          SingleChildScrollView(
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
                                                    alignment:
                                                        WrapAlignment.center,
                                                    children: [
                                                      Text("Order By",
                                                          softWrap: true,
                                                          style: TextStyle(
                                                              fontSize: 12),
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
                                                    alignment:
                                                        WrapAlignment.center,
                                                    children: [
                                                      Text("Designation",
                                                          softWrap: true,
                                                          style: TextStyle(
                                                              fontSize: 12),
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
                                                    alignment:
                                                        WrapAlignment.center,
                                                    children: [
                                                      Text("Approver",
                                                          softWrap: true,
                                                          style: TextStyle(
                                                              fontSize: 12),
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
                                                    alignment:
                                                        WrapAlignment.center,
                                                    children: [
                                                      Text("Status",
                                                          softWrap: true,
                                                          style: TextStyle(
                                                              fontSize: 12),
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
                                                    alignment:
                                                        WrapAlignment.center,
                                                    children: [
                                                      Text("Actions",
                                                          softWrap: true,
                                                          style: TextStyle(
                                                              fontSize: 12),
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
                                              rows: li2.items
                                                  .map(
                                                    (list) => DataRow(cells: [
                                                      DataCell(Center(
                                                          child: Center(
                                                        child: Wrap(
                                                            direction: Axis
                                                                .vertical, //default
                                                            alignment:
                                                                WrapAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                list.apDetailsOrderby
                                                                    .toString(),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              )
                                                            ]),
                                                      ))),
                                                      DataCell(Center(
                                                          child: Center(
                                                        child: Wrap(
                                                            direction: Axis
                                                                .vertical, //default
                                                            alignment: WrapAlignment.center,
                                                            children: [
                                                              Text(
                                                                  list.urole
                                                                      .toString(),
                                                                  textAlign:
                                                                      TextAlign
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
                                                              Text(
                                                                  list.assignby
                                                                      .toString(),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center)
                                                            ]))),
                                                      ),
                                                      list.apStatus
                                                                  .toString() ==
                                                              "P"
                                                          ? DataCell(
                                                              Center(
                                                                  child: Center(
                                                                      child:
                                                                          Wrap(
                                                                              direction: Axis.vertical, //default
                                                                              alignment: WrapAlignment.center,
                                                                              children: [
                                                                    Text(
                                                                        "Pending",
                                                                        textAlign:
                                                                            TextAlign.center)
                                                                  ]))),
                                                            )
                                                          : DataCell(
                                                              Center(
                                                                  child: Center(
                                                                      child:
                                                                          Wrap(
                                                                              direction: Axis.vertical, //default
                                                                              alignment: WrapAlignment.center,
                                                                              children: [
                                                                    Text(
                                                                        "Approved",
                                                                        textAlign:
                                                                            TextAlign.center)
                                                                  ]))),
                                                            ),
                                                      DataCell(
                                                        (list.apStatus == "P" &&
                                                                ((list.urole ==
                                                                        EmployeeLoginPagesState
                                                                            .Userrole) ||
                                                                    (EmployeeLoginPagesState
                                                                            .Userrole ==
                                                                        "SUPER ADMIN")))
                                                            ? Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Container(
                                                                      height:
                                                                          30,
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      decoration: BoxDecoration(
                                                                          color: Colors
                                                                              .red
                                                                              .shade300,
                                                                          borderRadius: BorderRadius.all(Radius.circular(
                                                                              50))),
                                                                      child:
                                                                          FlatButton(
                                                                        onPressed:
                                                                            () {
                                                                          uploadImage(
                                                                              list.apId,
                                                                              list.apTblId,
                                                                              "a");
                                                                        },
                                                                        child:
                                                                            Text(
                                                                          "Approve",
                                                                          style:
                                                                              TextStyle(color: Colors.white),
                                                                        ),
                                                                      )),
                                                                  Container(
                                                                      width:
                                                                          10),
                                                                  Container(
                                                                      height:
                                                                          30,
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      decoration: BoxDecoration(
                                                                          color: Colors
                                                                              .grey,
                                                                          borderRadius: BorderRadius.all(Radius.circular(
                                                                              50))),
                                                                      child:
                                                                          FlatButton(
                                                                        onPressed:
                                                                            () {
                                                                          uploadImage(
                                                                              list.apId,
                                                                              list.apTblId,
                                                                              "r");

                                                                          check()
                                                                              .then((value) {
                                                                            if (value)
                                                                              ;
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
                                                                        },
                                                                        child:
                                                                            Text(
                                                                          "Reject",
                                                                          style:
                                                                              TextStyle(color: Colors.white),
                                                                        ),
                                                                      )),
                                                                ],
                                                              )
                                                            : (list.apStatus ==
                                                                    "A")
                                                                ? Container(
                                                                    child: Text(
                                                                        "-"))
                                                                : Center(
                                                                    child: Container(
                                                                        child: Text(
                                                                            "Not Assigned"))),
                                                      ),
                                                    ]),
                                                  )
                                                  .toList(),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : widget.verify == "Damage Claim Verify"
                                      ? SingleChildScrollView(
                                          child: new Column(
                                            children: <Widget>[
                                              Container(
                                                  margin: const EdgeInsets.only(
                                                      top: 10),
                                                  color: Colors.red.shade50,
                                                  child: ExpansionTile(
                                                      backgroundColor:
                                                          Colors.white,
                                                      initiallyExpanded: true,
                                                      title: Text(
                                                        "Damage Details",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Colors.red),
                                                      ),
                                                      children: [
                                                        SizedBox(
                                                          height: height / 50,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 10.0,
                                                                  right: 10.0),
                                                          child: new TextField(
                                                            enabled: false,
                                                            controller:
                                                                DamageCodeController,
                                                            decoration:
                                                                InputDecoration(
                                                              labelText:
                                                                  'Damage Code',
                                                              hintStyle:
                                                                  TextStyle(
                                                                color:
                                                                    Colors.grey,
                                                                fontSize: 16.0,
                                                              ),
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5.0),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: height / 50,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 10.0,
                                                                  right: 10.0),
                                                          child: new TextField(
                                                            enabled: false,
                                                            controller:
                                                                DamageNoteController,
                                                            decoration:
                                                                InputDecoration(
                                                              labelText:
                                                                  'Damage Note',
                                                              hintStyle:
                                                                  TextStyle(
                                                                color:
                                                                    Colors.grey,
                                                                fontSize: 16.0,
                                                              ),
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5.0),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: height / 50,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 10.0,
                                                                  right: 10.0),
                                                          child: new TextField(
                                                            enabled: false,
                                                            controller:
                                                                DamageAmountController,
                                                            decoration:
                                                                InputDecoration(
                                                              labelText:
                                                                  'Damage Amount',
                                                              hintStyle:
                                                                  TextStyle(
                                                                color:
                                                                    Colors.grey,
                                                                fontSize: 16.0,
                                                              ),
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5.0),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: height / 50,
                                                        ),
                                                      ])),
                                              Container(
                                                  margin: const EdgeInsets.only(
                                                      top: 10),
                                                  color: Colors.red.shade50,
                                                  child: ExpansionTile(
                                                      backgroundColor:
                                                          Colors.white,
                                                      initiallyExpanded: false,
                                                      title: Text(
                                                        "Service Details",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Colors.red),
                                                      ),
                                                      children: [
                                                        SizedBox(
                                                          height: height / 50,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 10.0,
                                                                  right: 10.0),
                                                          child: new TextField(
                                                            enabled: false,
                                                            controller:
                                                                ServiceByController,
                                                            decoration:
                                                                InputDecoration(
                                                              labelText:
                                                                  'Service By',
                                                              hintStyle:
                                                                  TextStyle(
                                                                color:
                                                                    Colors.grey,
                                                                fontSize: 16.0,
                                                              ),
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5.0),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: height / 50,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 10.0,
                                                                  right: 10.0),
                                                          child: new TextField(
                                                            enabled: false,
                                                            controller:
                                                                ServiceStartDateController,
                                                            decoration:
                                                                InputDecoration(
                                                              labelText:
                                                                  'Service Start Date',
                                                              hintStyle:
                                                                  TextStyle(
                                                                color:
                                                                    Colors.grey,
                                                                fontSize: 16.0,
                                                              ),
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5.0),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: height / 50,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 10.0,
                                                                  right: 10.0),
                                                          child: new TextField(
                                                            enabled: false,
                                                            controller:
                                                                ServiceStatusController,
                                                            decoration:
                                                                InputDecoration(
                                                              labelText:
                                                                  'Service Status',
                                                              hintStyle:
                                                                  TextStyle(
                                                                color:
                                                                    Colors.grey,
                                                                fontSize: 16.0,
                                                              ),
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5.0),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: height / 50,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 10.0,
                                                                  right: 10.0),
                                                          child: new TextField(
                                                            enabled: false,
                                                            controller:
                                                                ServiceStartAtController,
                                                            decoration:
                                                                InputDecoration(
                                                              labelText:
                                                                  'Service Start At',
                                                              hintStyle:
                                                                  TextStyle(
                                                                color:
                                                                    Colors.grey,
                                                                fontSize: 16.0,
                                                              ),
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5.0),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: height / 50,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 10.0,
                                                                  right: 10.0),
                                                          child: new TextField(
                                                            enabled: false,
                                                            controller:
                                                                ServiceEndAtController,
                                                            decoration:
                                                                InputDecoration(
                                                              labelText:
                                                                  'Service End At',
                                                              hintStyle:
                                                                  TextStyle(
                                                                color:
                                                                    Colors.grey,
                                                                fontSize: 16.0,
                                                              ),
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5.0),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: height / 50,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 10.0,
                                                                  right: 10.0),
                                                          child: new TextField(
                                                            enabled: false,
                                                            controller:
                                                                StatusController,
                                                            decoration:
                                                                InputDecoration(
                                                              labelText:
                                                                  'Status',
                                                              hintStyle:
                                                                  TextStyle(
                                                                color:
                                                                    Colors.grey,
                                                                fontSize: 16.0,
                                                              ),
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5.0),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: height / 50,
                                                        ),
                                                        (li6.planServices
                                                                    .pserviceServiceStatus
                                                                    .toString() ==
                                                                "COMPLETED")
                                                            ? Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5.0),
                                                                  color: Colors
                                                                      .white,
                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                      color: Colors
                                                                          .grey,
                                                                      offset: Offset(
                                                                          0.0,
                                                                          1.0), //(x,y)
                                                                      blurRadius:
                                                                          2.0,
                                                                    ),
                                                                  ],
                                                                ),
                                                                // color: Colors.white,
                                                                margin:
                                                                    EdgeInsets
                                                                        .all(
                                                                            3.0),
                                                                child: Center(
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                            .all(
                                                                        16.0),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        new Text(
                                                                          "Service Before Images",
                                                                          textAlign:
                                                                              TextAlign.left,
                                                                          style: TextStyle(
                                                                              color: Colors.red,
                                                                              fontSize: 14),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                            : Container(),
                                                        (li6.planServices
                                                                    .pserviceServiceStatus
                                                                    .toString() ==
                                                                "COMPLETED")
                                                            ? Container(
                                                                child: GridView
                                                                    .count(
                                                                  physics:
                                                                      ScrollPhysics(),
                                                                  shrinkWrap:
                                                                      true,
                                                                  crossAxisCount:
                                                                      2,
                                                                  childAspectRatio:
                                                                      1,
                                                                  children: List
                                                                      .generate(
                                                                    li6
                                                                        .planServices
                                                                        .pserviceBeforeImg
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
                                                                                  showDialog(context: context, child: Image.network(li6.planServices.pserviceBeforeImg[index].imgPath));
                                                                                },
                                                                                child: Image.network(
                                                                                  li6.planServices.pserviceBeforeImg[index].imgPath,
                                                                                  height: 300,
                                                                                  width: 300,
                                                                                ),
                                                                              )));
                                                                    },
                                                                  ),
                                                                ),
                                                              )
                                                            : Container(),
                                                        SizedBox(
                                                          height: height / 50,
                                                        ),
                                                        (li6.planServices
                                                                    .pserviceServiceStatus
                                                                    .toString() ==
                                                                "COMPLETED")
                                                            ? Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5.0),
                                                                  color: Colors
                                                                      .white,
                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                      color: Colors
                                                                          .grey,
                                                                      offset: Offset(
                                                                          0.0,
                                                                          1.0), //(x,y)
                                                                      blurRadius:
                                                                          2.0,
                                                                    ),
                                                                  ],
                                                                ),
                                                                // color: Colors.white,
                                                                margin:
                                                                    EdgeInsets
                                                                        .all(
                                                                            3.0),
                                                                child: Center(
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                            .all(
                                                                        16.0),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        new Text(
                                                                          "Service After Images",
                                                                          textAlign:
                                                                              TextAlign.left,
                                                                          style: TextStyle(
                                                                              color: Colors.red,
                                                                              fontSize: 14),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                            : Container(),
                                                        (li6.planServices
                                                                    .pserviceServiceStatus
                                                                    .toString() ==
                                                                "COMPLETED")
                                                            ? Container(
                                                                child: GridView
                                                                    .count(
                                                                  physics:
                                                                      ScrollPhysics(),
                                                                  shrinkWrap:
                                                                      true,
                                                                  crossAxisCount:
                                                                      2,
                                                                  childAspectRatio:
                                                                      1,
                                                                  children: List
                                                                      .generate(
                                                                    li6
                                                                        .planServices
                                                                        .pserviceAfterImg
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
                                                                                  showDialog(context: context, child: Image.network(li6.planServices.pserviceAfterImg[index].imgPath));
                                                                                },
                                                                                child: Image.network(
                                                                                  li6.planServices.pserviceAfterImg[index].imgPath,
                                                                                  height: 300,
                                                                                  width: 300,
                                                                                ),
                                                                              )));
                                                                    },
                                                                  ),
                                                                ),
                                                              )
                                                            : Container(),
                                                      ])),

                                              Container(
                                                  margin: const EdgeInsets.only(
                                                      top: 10),
                                                  color: Colors.red.shade50,
                                                  child: ExpansionTile(
                                                      backgroundColor:
                                                          Colors.white,
                                                      initiallyExpanded: false,
                                                      title: Text(
                                                        "Property Details",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Colors.red),
                                                      ),
                                                      children: [
                                                        SizedBox(
                                                          height: height / 50,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 10.0,
                                                                  right: 10.0),
                                                          child: new TextField(
                                                            enabled: false,
                                                            controller:
                                                                PropertyNameController,
                                                            decoration:
                                                                InputDecoration(
                                                              labelText:
                                                                  'Property Name',
                                                              hintStyle:
                                                                  TextStyle(
                                                                color:
                                                                    Colors.grey,
                                                                fontSize: 16.0,
                                                              ),
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5.0),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: height / 50,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 10.0,
                                                                  right: 10.0),
                                                          child: new TextField(
                                                            enabled: false,
                                                            controller:
                                                                GroupNameController,
                                                            decoration:
                                                                InputDecoration(
                                                              labelText:
                                                                  'Group Name',
                                                              hintStyle:
                                                                  TextStyle(
                                                                color:
                                                                    Colors.grey,
                                                                fontSize: 16.0,
                                                              ),
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5.0),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: height / 50,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 10.0,
                                                                  right: 10.0),
                                                          child: new TextField(
                                                            enabled: false,
                                                            controller:
                                                                PropertyCodeController,
                                                            decoration:
                                                                InputDecoration(
                                                              labelText:
                                                                  'Property Code',
                                                              hintStyle:
                                                                  TextStyle(
                                                                color:
                                                                    Colors.grey,
                                                                fontSize: 16.0,
                                                              ),
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5.0),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: height / 50,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 10.0,
                                                                  right: 10.0),
                                                          child: new TextField(
                                                            enabled: false,
                                                            controller:
                                                                PropertyTypeController,
                                                            decoration:
                                                                InputDecoration(
                                                              labelText:
                                                                  'Property Type',
                                                              hintStyle:
                                                                  TextStyle(
                                                                color:
                                                                    Colors.grey,
                                                                fontSize: 16.0,
                                                              ),
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5.0),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: height / 50,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 10.0,
                                                                  right: 10.0),
                                                          child:
                                                              new TextFormField(
                                                            minLines: 3,
                                                            maxLines: 20,
                                                            enabled: false,
                                                            controller:
                                                                valuecontroller,
                                                            decoration:
                                                                InputDecoration(
                                                              labelText:
                                                                  'Location',
                                                              hintStyle:
                                                                  TextStyle(
                                                                color:
                                                                    Colors.grey,
                                                                fontSize: 16.0,
                                                              ),
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5.0),
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
                                                  margin: const EdgeInsets.only(
                                                      top: 10),
                                                  color: Colors.red.shade50,
                                                  child: ExpansionTile(
                                                      backgroundColor:
                                                          Colors.white,
                                                      initiallyExpanded: false,
                                                      title: Text(
                                                        "Customer Details",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Colors.red),
                                                      ),
                                                      children: [
                                                        SizedBox(
                                                          height: height / 50,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 10.0,
                                                                  right: 10.0),
                                                          child: new TextField(
                                                            enabled: false,
                                                            controller:
                                                                CusNameController,
                                                            decoration:
                                                                InputDecoration(
                                                              labelText:
                                                                  'Customer Name',
                                                              hintStyle:
                                                                  TextStyle(
                                                                color:
                                                                    Colors.grey,
                                                                fontSize: 16.0,
                                                              ),
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5.0),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: height / 50,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 10.0,
                                                                  right: 10.0),
                                                          child: new TextField(
                                                            enabled: false,
                                                            controller:
                                                                CusCodeController,
                                                            decoration:
                                                                InputDecoration(
                                                              labelText:
                                                                  'Customer Code',
                                                              hintStyle:
                                                                  TextStyle(
                                                                color:
                                                                    Colors.grey,
                                                                fontSize: 16.0,
                                                              ),
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5.0),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: height / 50,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 10.0,
                                                                  right: 10.0),
                                                          child: new TextField(
                                                            enabled: false,
                                                            controller:
                                                                PhoneController,
                                                            decoration:
                                                                InputDecoration(
                                                              labelText:
                                                                  'Contact Mobile',
                                                              hintStyle:
                                                                  TextStyle(
                                                                color:
                                                                    Colors.grey,
                                                                fontSize: 16.0,
                                                              ),
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5.0),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: height / 50,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 10.0,
                                                                  right: 10.0),
                                                          child: new TextField(
                                                            enabled: false,
                                                            controller:
                                                                GroupContactNameController,
                                                            decoration:
                                                                InputDecoration(
                                                              labelText:
                                                                  'Group Contact Name',
                                                              hintStyle:
                                                                  TextStyle(
                                                                color:
                                                                    Colors.grey,
                                                                fontSize: 16.0,
                                                              ),
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5.0),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: height / 50,
                                                        ),
                                                      ])),
                                              Container(
                                                padding: EdgeInsets.all(16),
                                                width: width,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey,
                                                      offset: Offset(
                                                          0.0, 1.0), //(x,y)
                                                      blurRadius: 1.0,
                                                    ),
                                                  ],
                                                ),
                                                // color: Colors.white,
                                                margin: EdgeInsets.only(
                                                    top: 10.0, bottom: 10),

                                                child: new Text(
                                                  "Approval Process",
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.red),
                                                ),
                                              ),

                                              SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: DataTable(
                                                  sortAscending: sort,
                                                  sortColumnIndex: 0,
                                                  columnSpacing: width / 20,
                                                  columns: [
                                                    DataColumn(
                                                      label: Center(
                                                          child: Wrap(
                                                        direction: Axis
                                                            .vertical, //default
                                                        alignment: WrapAlignment
                                                            .center,
                                                        children: [
                                                          Text("Order By",
                                                              softWrap: true,
                                                              style: TextStyle(
                                                                  fontSize: 12),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center),
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
                                                        direction: Axis
                                                            .vertical, //default
                                                        alignment: WrapAlignment
                                                            .center,
                                                        children: [
                                                          Text("Designation",
                                                              softWrap: true,
                                                              style: TextStyle(
                                                                  fontSize: 12),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center),
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
                                                        direction: Axis
                                                            .vertical, //default
                                                        alignment: WrapAlignment
                                                            .center,
                                                        children: [
                                                          Text("Approver",
                                                              softWrap: true,
                                                              style: TextStyle(
                                                                  fontSize: 12),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center),
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
                                                        direction: Axis
                                                            .vertical, //default
                                                        alignment: WrapAlignment
                                                            .center,
                                                        children: [
                                                          Text("Status",
                                                              softWrap: true,
                                                              style: TextStyle(
                                                                  fontSize: 12),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center),
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
                                                        direction: Axis
                                                            .vertical, //default
                                                        alignment: WrapAlignment
                                                            .center,
                                                        children: [
                                                          Text("Actions",
                                                              softWrap: true,
                                                              style: TextStyle(
                                                                  fontSize: 12),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center),
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
                                                  rows: li2.items
                                                      .map(
                                                        (list) => DataRow(
                                                            cells: [
                                                              DataCell(Center(
                                                                  child: Center(
                                                                child: Wrap(
                                                                    direction: Axis
                                                                        .vertical, //default
                                                                    alignment:
                                                                        WrapAlignment
                                                                            .center,
                                                                    children: [
                                                                      Text(
                                                                        list.apDetailsOrderby
                                                                            .toString(),
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
                                                                    alignment: WrapAlignment.center,
                                                                    children: [
                                                                      Text(
                                                                          list.urole
                                                                              .toString(),
                                                                          textAlign:
                                                                              TextAlign.center)
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
                                                                      Text(
                                                                          list.assignby
                                                                              .toString(),
                                                                          textAlign:
                                                                              TextAlign.center)
                                                                    ]))),
                                                              ),
                                                              list.apStatus
                                                                          .toString() ==
                                                                      "P"
                                                                  ? DataCell(
                                                                      Center(
                                                                          child:
                                                                              Center(
                                                                                  child:
                                                                                      Wrap(
                                                                                          direction: Axis.vertical, //default
                                                                                          alignment: WrapAlignment.center,
                                                                                          children: [
                                                                            Text("Pending",
                                                                                textAlign: TextAlign.center)
                                                                          ]))),
                                                                    )
                                                                  : DataCell(
                                                                      Center(
                                                                          child:
                                                                              Center(
                                                                                  child:
                                                                                      Wrap(
                                                                                          direction: Axis.vertical, //default
                                                                                          alignment: WrapAlignment.center,
                                                                                          children: [
                                                                            Text("Approved",
                                                                                textAlign: TextAlign.center)
                                                                          ]))),
                                                                    ),
                                                              DataCell(
                                                                (list.apStatus ==
                                                                            "P" &&
                                                                        ((list.urole == EmployeeLoginPagesState.Userrole) ||
                                                                            (EmployeeLoginPagesState.Userrole ==
                                                                                "SUPER ADMIN")))
                                                                    ? Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Container(
                                                                              height: 30,
                                                                              alignment: Alignment.center,
                                                                              decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.all(Radius.circular(50))),
                                                                              child: FlatButton(
                                                                                onPressed: () {
                                                                                  print("claim");
                                                                                  tblid = list.apTblId;
                                                                                  uploadImage(widget.apid, tblid, "a");
                                                                                },
                                                                                child: Text(
                                                                                  "Approve",
                                                                                  style: TextStyle(color: Colors.white),
                                                                                ),
                                                                              )),
                                                                          Container(
                                                                              width: 10),
                                                                          Container(
                                                                              height: 30,
                                                                              alignment: Alignment.center,
                                                                              decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.all(Radius.circular(50))),
                                                                              child: FlatButton(
                                                                                onPressed: () {
                                                                                  uploadImage(list.apId, list.apTblId, "r");

                                                                                  check().then((value) {
                                                                                    if (value)
                                                                                      ;
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
                                                                                },
                                                                                child: Text(
                                                                                  "Reject",
                                                                                  style: TextStyle(color: Colors.white),
                                                                                ),
                                                                              )),
                                                                        ],
                                                                      )
                                                                    : (list.apStatus ==
                                                                            "A")
                                                                        ? Container(
                                                                            child: Text(
                                                                                "-"))
                                                                        : Center(
                                                                            child:
                                                                                Container(child: Text("Not Assigned"))),
                                                              ),
                                                            ]),
                                                      )
                                                      .toList(),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : widget.verify == "Repair Request"
                                          ? SingleChildScrollView(
                                              child: new Column(
                                              children: <Widget>[
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
                                                //   margin: EdgeInsets.only(top: 10.0, bottom: 10),
                                                //
                                                //   child: new Text(
                                                //     "Repair Verify",
                                                //     textAlign: TextAlign.left,
                                                //     style: TextStyle(
                                                //         fontWeight: FontWeight.bold, color: Colors.red),
                                                //   ),
                                                // ),

                                                Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            top: 10),
                                                    color: Colors.red.shade50,
                                                    child: ExpansionTile(
                                                        backgroundColor:
                                                            Colors.white,
                                                        initiallyExpanded: true,
                                                        title: Text(
                                                          "Repair Details",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color:
                                                                  Colors.red),
                                                        ),
                                                        children: [
                                                          SizedBox(
                                                            height: height / 50,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 10.0,
                                                                    right:
                                                                        10.0),
                                                            child:
                                                                new TextField(
                                                              enabled: false,
                                                              controller:
                                                                  RepairCodeController,
                                                              decoration:
                                                                  InputDecoration(
                                                                labelText:
                                                                    'RePair Code',
                                                                hintStyle:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontSize:
                                                                      16.0,
                                                                ),
                                                                border:
                                                                    OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5.0),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: height / 50,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 10.0,
                                                                    right:
                                                                        10.0),
                                                            child:
                                                                new TextField(
                                                              enabled: false,
                                                              controller:
                                                                  RepairNoteController,
                                                              decoration:
                                                                  InputDecoration(
                                                                labelText:
                                                                    'Repair Note',
                                                                hintStyle:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontSize:
                                                                      16.0,
                                                                ),
                                                                border:
                                                                    OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5.0),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: height / 50,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 10.0,
                                                                    right:
                                                                        10.0),
                                                            child:
                                                                new TextField(
                                                              enabled: false,
                                                              controller:
                                                                  RepairStatusController,
                                                              decoration:
                                                                  InputDecoration(
                                                                labelText:
                                                                    'Repair Status',
                                                                hintStyle:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontSize:
                                                                      16.0,
                                                                ),
                                                                border:
                                                                    OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5.0),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: height / 50,
                                                          ),
                                                        ])),
                                                Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            top: 10),
                                                    color: Colors.red.shade50,
                                                    child: ExpansionTile(
                                                        backgroundColor:
                                                            Colors.white,
                                                        initiallyExpanded: true,
                                                        title: Text(
                                                          "Machine Details",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color:
                                                                  Colors.red),
                                                        ),
                                                        children: [
                                                          SizedBox(
                                                            height: height / 50,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 10.0,
                                                                    right:
                                                                        10.0),
                                                            child:
                                                                new TextField(
                                                              enabled: false,
                                                              controller:
                                                                  MachineNameController,
                                                              decoration:
                                                                  InputDecoration(
                                                                labelText:
                                                                    'Machine Name',
                                                                hintStyle:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontSize:
                                                                      16.0,
                                                                ),
                                                                border:
                                                                    OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5.0),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: height / 50,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 10.0,
                                                                    right:
                                                                        10.0),
                                                            child:
                                                                new TextField(
                                                              enabled: false,
                                                              controller:
                                                                  MachineCodeController,
                                                              decoration:
                                                                  InputDecoration(
                                                                labelText:
                                                                    'Machine Code',
                                                                hintStyle:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontSize:
                                                                      16.0,
                                                                ),
                                                                border:
                                                                    OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5.0),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: height / 50,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 10.0,
                                                                    right:
                                                                        10.0),
                                                            child:
                                                                new TextField(
                                                              enabled: false,
                                                              controller:
                                                                  MachineTypeController,
                                                              decoration:
                                                                  InputDecoration(
                                                                labelText:
                                                                    'Machine Type',
                                                                hintStyle:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontSize:
                                                                      16.0,
                                                                ),
                                                                border:
                                                                    OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5.0),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: height / 50,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 10.0,
                                                                    right:
                                                                        10.0),
                                                            child:
                                                                new TextField(
                                                              enabled: false,
                                                              controller:
                                                                  ManufacturerNameController,
                                                              decoration:
                                                                  InputDecoration(
                                                                labelText:
                                                                    'Manufacturer Name',
                                                                hintStyle:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontSize:
                                                                      16.0,
                                                                ),
                                                                border:
                                                                    OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5.0),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: height / 50,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 10.0,
                                                                    right:
                                                                        10.0),
                                                            child:
                                                                new TextField(
                                                              enabled: false,
                                                              controller:
                                                                  ManufacturerNoController,
                                                              decoration:
                                                                  InputDecoration(
                                                                labelText:
                                                                    'Manufacturer No',
                                                                hintStyle:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontSize:
                                                                      16.0,
                                                                ),
                                                                border:
                                                                    OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5.0),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: height / 50,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 10.0,
                                                                    right:
                                                                        10.0),
                                                            child:
                                                                new TextField(
                                                              enabled: false,
                                                              controller:
                                                                  PurchaseDateController,
                                                              decoration:
                                                                  InputDecoration(
                                                                labelText:
                                                                    'Purchase Date',
                                                                hintStyle:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontSize:
                                                                      16.0,
                                                                ),
                                                                border:
                                                                    OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5.0),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: height / 50,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 10.0,
                                                                    right:
                                                                        10.0),
                                                            child:
                                                                new TextField(
                                                              enabled: false,
                                                              controller:
                                                                  StateController,
                                                              decoration:
                                                                  InputDecoration(
                                                                labelText:
                                                                    'State Name',
                                                                hintStyle:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontSize:
                                                                      16.0,
                                                                ),
                                                                border:
                                                                    OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5.0),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: height / 50,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 10.0,
                                                                    right:
                                                                        10.0),
                                                            child:
                                                                new TextField(
                                                              enabled: false,
                                                              controller:
                                                                  DistrictController,
                                                              decoration:
                                                                  InputDecoration(
                                                                labelText:
                                                                    'District Name',
                                                                hintStyle:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontSize:
                                                                      16.0,
                                                                ),
                                                                border:
                                                                    OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5.0),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: height / 50,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 10.0,
                                                                    right:
                                                                        10.0),
                                                            child:
                                                                new TextField(
                                                              enabled: false,
                                                              controller:
                                                                  AssignbyController,
                                                              decoration:
                                                                  InputDecoration(
                                                                labelText:
                                                                    'Assign Name',
                                                                hintStyle:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontSize:
                                                                      16.0,
                                                                ),
                                                                border:
                                                                    OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5.0),
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
                                                  padding: EdgeInsets.all(16),
                                                  width: width,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.grey,
                                                        offset: Offset(
                                                            0.0, 1.0), //(x,y)
                                                        blurRadius: 1.0,
                                                      ),
                                                    ],
                                                  ),
                                                  // color: Colors.white,
                                                  margin: EdgeInsets.only(
                                                      top: 10.0, bottom: 10),

                                                  child: new Text(
                                                    "Approval Process",
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.red),
                                                  ),
                                                ),

                                                SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  child: DataTable(
                                                    sortAscending: sort,
                                                    sortColumnIndex: 0,
                                                    columnSpacing: width / 20,
                                                    columns: [
                                                      DataColumn(
                                                        label: Center(
                                                            child: Wrap(
                                                          direction: Axis
                                                              .vertical, //default
                                                          alignment:
                                                              WrapAlignment
                                                                  .center,
                                                          children: [
                                                            Text("Order By",
                                                                softWrap: true,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        12),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center),
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
                                                          direction: Axis
                                                              .vertical, //default
                                                          alignment:
                                                              WrapAlignment
                                                                  .center,
                                                          children: [
                                                            Text("Designation",
                                                                softWrap: true,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        12),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center),
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
                                                          direction: Axis
                                                              .vertical, //default
                                                          alignment:
                                                              WrapAlignment
                                                                  .center,
                                                          children: [
                                                            Text("Approver",
                                                                softWrap: true,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        12),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center),
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
                                                          direction: Axis
                                                              .vertical, //default
                                                          alignment:
                                                              WrapAlignment
                                                                  .center,
                                                          children: [
                                                            Text("Status",
                                                                softWrap: true,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        12),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center),
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
                                                          direction: Axis
                                                              .vertical, //default
                                                          alignment:
                                                              WrapAlignment
                                                                  .center,
                                                          children: [
                                                            Text("Actions",
                                                                softWrap: true,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        12),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center),
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
                                                    rows: li2.items
                                                        .map(
                                                          (list) => DataRow(
                                                              cells: [
                                                                DataCell(Center(
                                                                    child:
                                                                        Center(
                                                                  child: Wrap(
                                                                      direction:
                                                                          Axis
                                                                              .vertical, //default
                                                                      alignment:
                                                                          WrapAlignment
                                                                              .center,
                                                                      children: [
                                                                        Text(
                                                                          list.apDetailsOrderby
                                                                              .toString(),
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                        )
                                                                      ]),
                                                                ))),
                                                                DataCell(Center(
                                                                    child:
                                                                        Center(
                                                                  child: Wrap(
                                                                      direction:
                                                                          Axis.vertical, //default
                                                                      alignment: WrapAlignment.center,
                                                                      children: [
                                                                        Text(
                                                                            list.urole
                                                                                .toString(),
                                                                            textAlign:
                                                                                TextAlign.center)
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
                                                                        Text(
                                                                            list.assignby
                                                                                .toString(),
                                                                            textAlign:
                                                                                TextAlign.center)
                                                                      ]))),
                                                                ),
                                                                list.apStatus
                                                                            .toString() ==
                                                                        "P"
                                                                    ? DataCell(
                                                                        Center(
                                                                            child:
                                                                                Center(
                                                                                    child:
                                                                                        Wrap(
                                                                                            direction: Axis.vertical, //default
                                                                                            alignment: WrapAlignment.center,
                                                                                            children: [
                                                                              Text("Pending", textAlign: TextAlign.center)
                                                                            ]))),
                                                                      )
                                                                    : DataCell(
                                                                        Center(
                                                                            child:
                                                                                Center(
                                                                                    child:
                                                                                        Wrap(
                                                                                            direction: Axis.vertical, //default
                                                                                            alignment: WrapAlignment.center,
                                                                                            children: [
                                                                              Text("Approved", textAlign: TextAlign.center)
                                                                            ]))),
                                                                      ),
                                                                DataCell(
                                                                  (list.apStatus ==
                                                                              "P" &&
                                                                          ((list.urole == EmployeeLoginPagesState.Userrole) ||
                                                                              (EmployeeLoginPagesState.Userrole ==
                                                                                  "SUPER ADMIN")))
                                                                      ? Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Container(
                                                                                height: 30,
                                                                                alignment: Alignment.center,
                                                                                decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.all(Radius.circular(50))),
                                                                                child: FlatButton(
                                                                                  onPressed: () {
                                                                                    check().then((value) {
                                                                                      if (value)
                                                                                        uploadImage(list.apId, list.apTblId, "a");
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
                                                                                  },
                                                                                  child: Text(
                                                                                    "Approve",
                                                                                    style: TextStyle(color: Colors.white),
                                                                                  ),
                                                                                )),
                                                                            Container(width: 10),
                                                                            Container(
                                                                                height: 30,
                                                                                alignment: Alignment.center,
                                                                                decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.all(Radius.circular(50))),
                                                                                child: FlatButton(
                                                                                  onPressed: () {
                                                                                    check().then((value) {
                                                                                      if (value)
                                                                                        uploadImage(list.apId, list.apTblId, "r");
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
                                                                                  },
                                                                                  child: Text(
                                                                                    "Reject",
                                                                                    style: TextStyle(color: Colors.white),
                                                                                  ),
                                                                                )),
                                                                          ],
                                                                        )
                                                                      : (list.apStatus ==
                                                                              "A")
                                                                          ? Container(
                                                                              child: Text("-"))
                                                                          : Center(child: Container(child: Text("Not Assigned"))),
                                                                ),
                                                              ]),
                                                        )
                                                        .toList(),
                                                  ),
                                                ),
                                              ],
                                            ))
                                          : widget.verify == "Staff Request"
                                              ? SingleChildScrollView(
                                                  child: new Column(
                                                  children: <Widget>[
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
                                                    //   margin: EdgeInsets.only(top: 10.0, bottom: 10),
                                                    //
                                                    //   child: new Text(
                                                    //     "Repair Verify",
                                                    //     textAlign: TextAlign.left,
                                                    //     style: TextStyle(
                                                    //         fontWeight: FontWeight.bold, color: Colors.red),
                                                    //   ),
                                                    // ),

                                                    Container(
                                                        margin: const EdgeInsets
                                                            .only(top: 10),
                                                        color:
                                                            Colors.red.shade50,
                                                        child: ExpansionTile(
                                                            backgroundColor:
                                                                Colors.white,
                                                            initiallyExpanded:
                                                                true,
                                                            title: Text(
                                                              "Vendor Details",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: Colors
                                                                      .red),
                                                            ),
                                                            children: [
                                                              SizedBox(
                                                                height:
                                                                    height / 50,
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                        .only(
                                                                    left: 10.0,
                                                                    right:
                                                                        10.0),
                                                                child:
                                                                    new TextField(
                                                                  enabled:
                                                                      false,
                                                                  controller:
                                                                      VendorCode,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    labelText:
                                                                        'Vendor Code',
                                                                    hintStyle:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .grey,
                                                                      fontSize:
                                                                          16.0,
                                                                    ),
                                                                    border:
                                                                        OutlineInputBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5.0),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height:
                                                                    height / 50,
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                        .only(
                                                                    left: 10.0,
                                                                    right:
                                                                        10.0),
                                                                child:
                                                                    new TextField(
                                                                  enabled:
                                                                      false,
                                                                  controller:
                                                                      CompanyNameController,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    labelText:
                                                                        'Vendor Company Name',
                                                                    hintStyle:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .grey,
                                                                      fontSize:
                                                                          16.0,
                                                                    ),
                                                                    border:
                                                                        OutlineInputBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5.0),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height:
                                                                    height / 50,
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                        .only(
                                                                    left: 10.0,
                                                                    right:
                                                                        10.0),
                                                                child:
                                                                    new TextField(
                                                                  enabled:
                                                                      false,
                                                                  controller:
                                                                      StationName,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    labelText:
                                                                        'Station Name',
                                                                    hintStyle:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .grey,
                                                                      fontSize:
                                                                          16.0,
                                                                    ),
                                                                    border:
                                                                        OutlineInputBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5.0),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height:
                                                                    height / 50,
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                        .only(
                                                                    left: 10.0,
                                                                    right:
                                                                        10.0),
                                                                child:
                                                                    new TextField(
                                                                  enabled:
                                                                      false,
                                                                  controller:
                                                                      StationCode,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    labelText:
                                                                        'Station Code',
                                                                    hintStyle:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .grey,
                                                                      fontSize:
                                                                          16.0,
                                                                    ),
                                                                    border:
                                                                        OutlineInputBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5.0),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height:
                                                                    height / 50,
                                                              ),
                                                            ])),
                                                    Container(
                                                        margin: const EdgeInsets
                                                            .only(top: 10),
                                                        color:
                                                            Colors.red.shade50,
                                                        child: ExpansionTile(
                                                            backgroundColor:
                                                                Colors.white,
                                                            initiallyExpanded:
                                                                true,
                                                            title: Text(
                                                              "Staff Details",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: Colors
                                                                      .red),
                                                            ),
                                                            children: [
                                                              SizedBox(
                                                                height:
                                                                    height / 50,
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                        .only(
                                                                    left: 10.0,
                                                                    right:
                                                                        10.0),
                                                                child:
                                                                    new TextField(
                                                                  enabled:
                                                                      false,
                                                                  controller:
                                                                      NameController,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    labelText:
                                                                        'Staff Name',
                                                                    hintStyle:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .grey,
                                                                      fontSize:
                                                                          16.0,
                                                                    ),
                                                                    border:
                                                                        OutlineInputBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5.0),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height:
                                                                    height / 50,
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                        .only(
                                                                    left: 10.0,
                                                                    right:
                                                                        10.0),
                                                                child:
                                                                    new TextField(
                                                                  enabled:
                                                                      false,
                                                                  controller:
                                                                      MobileController,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    labelText:
                                                                        'Phone',
                                                                    hintStyle:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .grey,
                                                                      fontSize:
                                                                          16.0,
                                                                    ),
                                                                    border:
                                                                        OutlineInputBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5.0),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height:
                                                                    height / 50,
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                        .only(
                                                                    left: 10.0,
                                                                    right:
                                                                        10.0),
                                                                child:
                                                                    new TextField(
                                                                  enabled:
                                                                      false,
                                                                  controller:
                                                                      EmailController,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    labelText:
                                                                        'Email',
                                                                    hintStyle:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .grey,
                                                                      fontSize:
                                                                          16.0,
                                                                    ),
                                                                    border:
                                                                        OutlineInputBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5.0),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height:
                                                                    height / 50,
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                        .only(
                                                                    left: 10.0,
                                                                    right:
                                                                        10.0),
                                                                child:
                                                                    new TextField(
                                                                  enabled:
                                                                      false,
                                                                  controller:
                                                                      StatusController,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    labelText:
                                                                        'Status',
                                                                    hintStyle:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .grey,
                                                                      fontSize:
                                                                          16.0,
                                                                    ),
                                                                    border:
                                                                        OutlineInputBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5.0),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height:
                                                                    height / 50,
                                                              ),
                                                            ])),
                                                    SizedBox(
                                                      height: height / 50,
                                                    ),

                                                    Container(
                                                      padding:
                                                          EdgeInsets.all(16),
                                                      width: width,
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.grey,
                                                            offset: Offset(0.0,
                                                                1.0), //(x,y)
                                                            blurRadius: 1.0,
                                                          ),
                                                        ],
                                                      ),
                                                      // color: Colors.white,
                                                      margin: EdgeInsets.only(
                                                          top: 10.0,
                                                          bottom: 10),

                                                      child: new Text(
                                                        "Approval Process",
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.red),
                                                      ),
                                                    ),

                                                    SingleChildScrollView(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      child: DataTable(
                                                        sortAscending: sort,
                                                        sortColumnIndex: 0,
                                                        columnSpacing:
                                                            width / 20,
                                                        columns: [
                                                          DataColumn(
                                                            label: Center(
                                                                child: Wrap(
                                                              direction: Axis
                                                                  .vertical, //default
                                                              alignment:
                                                                  WrapAlignment
                                                                      .center,
                                                              children: [
                                                                Text("Order By",
                                                                    softWrap:
                                                                        true,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            12),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center),
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
                                                              direction: Axis
                                                                  .vertical, //default
                                                              alignment:
                                                                  WrapAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                    "Designation",
                                                                    softWrap:
                                                                        true,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            12),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center),
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
                                                              direction: Axis
                                                                  .vertical, //default
                                                              alignment:
                                                                  WrapAlignment
                                                                      .center,
                                                              children: [
                                                                Text("Approver",
                                                                    softWrap:
                                                                        true,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            12),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center),
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
                                                              direction: Axis
                                                                  .vertical, //default
                                                              alignment:
                                                                  WrapAlignment
                                                                      .center,
                                                              children: [
                                                                Text("Status",
                                                                    softWrap:
                                                                        true,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            12),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center),
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
                                                              direction: Axis
                                                                  .vertical, //default
                                                              alignment:
                                                                  WrapAlignment
                                                                      .center,
                                                              children: [
                                                                Text("Actions",
                                                                    softWrap:
                                                                        true,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            12),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center),
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
                                                        rows: li2.items
                                                            .map(
                                                              (list) => DataRow(
                                                                  cells: [
                                                                    DataCell(
                                                                        Center(
                                                                            child:
                                                                                Center(
                                                                      child: Wrap(
                                                                          direction: Axis.vertical, //default
                                                                          alignment: WrapAlignment.center,
                                                                          children: [
                                                                            Text(
                                                                              list.apDetailsOrderby.toString(),
                                                                              textAlign: TextAlign.center,
                                                                            )
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
                                                                            Text(list.urole.toString(),
                                                                                textAlign: TextAlign.center)
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
                                                                            Text(list.assignby.toString(),
                                                                                textAlign: TextAlign.center)
                                                                          ]))),
                                                                    ),
                                                                    list.apStatus.toString() ==
                                                                            "P"
                                                                        ? DataCell(
                                                                            Center(
                                                                                child:
                                                                                    Center(
                                                                                        child:
                                                                                            Wrap(
                                                                                                direction: Axis.vertical, //default
                                                                                                alignment: WrapAlignment.center,
                                                                                                children: [
                                                                                  Text("Pending", textAlign: TextAlign.center)
                                                                                ]))),
                                                                          )
                                                                        : DataCell(
                                                                            Center(
                                                                                child:
                                                                                    Center(
                                                                                        child:
                                                                                            Wrap(
                                                                                                direction: Axis.vertical, //default
                                                                                                alignment: WrapAlignment.center,
                                                                                                children: [
                                                                                  Text("Approved", textAlign: TextAlign.center)
                                                                                ]))),
                                                                          ),
                                                                    DataCell(
                                                                      (list.apStatus == "P" &&
                                                                              ((list.urole == EmployeeLoginPagesState.Userrole) || (EmployeeLoginPagesState.Userrole == "SUPER ADMIN")))
                                                                          ? Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                Container(
                                                                                    height: 30,
                                                                                    alignment: Alignment.center,
                                                                                    decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.all(Radius.circular(50))),
                                                                                    child: FlatButton(
                                                                                      onPressed: () {
                                                                                        check().then((value) {
                                                                                          if (value)
                                                                                            uploadImage(list.apId, list.apTblId, "a");
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
                                                                                      },
                                                                                      child: Text(
                                                                                        "Approve",
                                                                                        style: TextStyle(color: Colors.white),
                                                                                      ),
                                                                                    )),
                                                                                Container(width: 10),
                                                                                Container(
                                                                                    height: 30,
                                                                                    alignment: Alignment.center,
                                                                                    decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.all(Radius.circular(50))),
                                                                                    child: FlatButton(
                                                                                      onPressed: () {
                                                                                        check().then((value) {
                                                                                          if (value)
                                                                                            uploadImage(list.apId, list.apTblId, "r");
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
                                                                                      },
                                                                                      child: Text(
                                                                                        "Reject",
                                                                                        style: TextStyle(color: Colors.white),
                                                                                      ),
                                                                                    )),
                                                                              ],
                                                                            )
                                                                          : (list.apStatus == "A")
                                                                              ? Container(child: Text("-"))
                                                                              : Center(child: Container(child: Text("Not Assigned"))),
                                                                    ),
                                                                  ]),
                                                            )
                                                            .toList(),
                                                      ),
                                                    ),
                                                  ],
                                                ))
                                              : widget.verify ==
                                                      "Dstaff Request"
                                                  ? SingleChildScrollView(
                                                      child: new Column(
                                                      children: <Widget>[
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
                                                        //   margin: EdgeInsets.only(top: 10.0, bottom: 10),
                                                        //
                                                        //   child: new Text(
                                                        //     "Repair Verify",
                                                        //     textAlign: TextAlign.left,
                                                        //     style: TextStyle(
                                                        //         fontWeight: FontWeight.bold, color: Colors.red),
                                                        //   ),
                                                        // ),

                                                        Container(
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 10),
                                                            color:
                                                                Colors.red
                                                                    .shade50,
                                                            child:
                                                                ExpansionTile(
                                                                    backgroundColor:
                                                                        Colors
                                                                            .white,
                                                                    initiallyExpanded:
                                                                        true,
                                                                    title: Text(
                                                                      "DVendor Details",
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .w600,
                                                                          color:
                                                                              Colors.red),
                                                                    ),
                                                                    children: [
                                                                  SizedBox(
                                                                    height:
                                                                        height /
                                                                            50,
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            10.0,
                                                                        right:
                                                                            10.0),
                                                                    child:
                                                                        new TextField(
                                                                      enabled:
                                                                          false,
                                                                      controller:
                                                                          VendorCode,
                                                                      decoration:
                                                                          InputDecoration(
                                                                        labelText:
                                                                            'DVendor Code',
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
                                                                  ),
                                                                  SizedBox(
                                                                    height:
                                                                        height /
                                                                            50,
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            10.0,
                                                                        right:
                                                                            10.0),
                                                                    child:
                                                                        new TextField(
                                                                      enabled:
                                                                          false,
                                                                      controller:
                                                                          CompanyNameController,
                                                                      decoration:
                                                                          InputDecoration(
                                                                        labelText:
                                                                            'DVendor Company Name',
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
                                                                  ),
                                                                  SizedBox(
                                                                    height:
                                                                        height /
                                                                            50,
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            10.0,
                                                                        right:
                                                                            10.0),
                                                                    child:
                                                                        new TextField(
                                                                      enabled:
                                                                          false,
                                                                      controller:
                                                                          StationName,
                                                                      decoration:
                                                                          InputDecoration(
                                                                        labelText:
                                                                            'Shop Name',
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
                                                                  ),
                                                                  SizedBox(
                                                                    height:
                                                                        height /
                                                                            50,
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            10.0,
                                                                        right:
                                                                            10.0),
                                                                    child:
                                                                        new TextField(
                                                                      enabled:
                                                                          false,
                                                                      controller:
                                                                          StationCode,
                                                                      decoration:
                                                                          InputDecoration(
                                                                        labelText:
                                                                            'Shop Code',
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
                                                                  ),
                                                                  SizedBox(
                                                                    height:
                                                                        height /
                                                                            50,
                                                                  ),
                                                                ])),
                                                        Container(
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 10),
                                                            color:
                                                                Colors.red
                                                                    .shade50,
                                                            child:
                                                                ExpansionTile(
                                                                    backgroundColor:
                                                                        Colors
                                                                            .white,
                                                                    initiallyExpanded:
                                                                        true,
                                                                    title: Text(
                                                                      "Staff Details",
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .w600,
                                                                          color:
                                                                              Colors.red),
                                                                    ),
                                                                    children: [
                                                                  SizedBox(
                                                                    height:
                                                                        height /
                                                                            50,
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            10.0,
                                                                        right:
                                                                            10.0),
                                                                    child:
                                                                        new TextField(
                                                                      enabled:
                                                                          false,
                                                                      controller:
                                                                          NameController,
                                                                      decoration:
                                                                          InputDecoration(
                                                                        labelText:
                                                                            'Staff Name',
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
                                                                  ),
                                                                  SizedBox(
                                                                    height:
                                                                        height /
                                                                            50,
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            10.0,
                                                                        right:
                                                                            10.0),
                                                                    child:
                                                                        new TextField(
                                                                      enabled:
                                                                          false,
                                                                      controller:
                                                                          MobileController,
                                                                      decoration:
                                                                          InputDecoration(
                                                                        labelText:
                                                                            'Phone',
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
                                                                  ),
                                                                  SizedBox(
                                                                    height:
                                                                        height /
                                                                            50,
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            10.0,
                                                                        right:
                                                                            10.0),
                                                                    child:
                                                                        new TextField(
                                                                      enabled:
                                                                          false,
                                                                      controller:
                                                                          EmailController,
                                                                      decoration:
                                                                          InputDecoration(
                                                                        labelText:
                                                                            'Email',
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
                                                                  ),
                                                                  SizedBox(
                                                                    height:
                                                                        height /
                                                                            50,
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            10.0,
                                                                        right:
                                                                            10.0),
                                                                    child:
                                                                        new TextField(
                                                                      enabled:
                                                                          false,
                                                                      controller:
                                                                          StatusController,
                                                                      decoration:
                                                                          InputDecoration(
                                                                        labelText:
                                                                            'Status',
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
                                                                  ),
                                                                  SizedBox(
                                                                    height:
                                                                        height /
                                                                            50,
                                                                  ),
                                                                ])),
                                                        SizedBox(
                                                          height: height / 50,
                                                        ),

                                                        Container(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  16),
                                                          width: width,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white,
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color:
                                                                    Colors.grey,
                                                                offset: Offset(
                                                                    0.0,
                                                                    1.0), //(x,y)
                                                                blurRadius: 1.0,
                                                              ),
                                                            ],
                                                          ),
                                                          // color: Colors.white,
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: 10.0,
                                                                  bottom: 10),

                                                          child: new Text(
                                                            "Approval Process",
                                                            textAlign:
                                                                TextAlign.left,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color:
                                                                    Colors.red),
                                                          ),
                                                        ),

                                                        SingleChildScrollView(
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          child: DataTable(
                                                            sortAscending: sort,
                                                            sortColumnIndex: 0,
                                                            columnSpacing:
                                                                width / 20,
                                                            columns: [
                                                              DataColumn(
                                                                label: Center(
                                                                    child: Wrap(
                                                                  direction: Axis
                                                                      .vertical, //default
                                                                  alignment:
                                                                      WrapAlignment
                                                                          .center,
                                                                  children: [
                                                                    Text(
                                                                        "Order By",
                                                                        softWrap:
                                                                            true,
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                12),
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
                                                                  direction: Axis
                                                                      .vertical, //default
                                                                  alignment:
                                                                      WrapAlignment
                                                                          .center,
                                                                  children: [
                                                                    Text(
                                                                        "Designation",
                                                                        softWrap:
                                                                            true,
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                12),
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
                                                                  direction: Axis
                                                                      .vertical, //default
                                                                  alignment:
                                                                      WrapAlignment
                                                                          .center,
                                                                  children: [
                                                                    Text(
                                                                        "Approver",
                                                                        softWrap:
                                                                            true,
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                12),
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
                                                                  direction: Axis
                                                                      .vertical, //default
                                                                  alignment:
                                                                      WrapAlignment
                                                                          .center,
                                                                  children: [
                                                                    Text(
                                                                        "Status",
                                                                        softWrap:
                                                                            true,
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                12),
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
                                                                  direction: Axis
                                                                      .vertical, //default
                                                                  alignment:
                                                                      WrapAlignment
                                                                          .center,
                                                                  children: [
                                                                    Text(
                                                                        "Actions",
                                                                        softWrap:
                                                                            true,
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                12),
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
                                                            rows: li2.items
                                                                .map(
                                                                  (list) =>
                                                                      DataRow(
                                                                          cells: [
                                                                        DataCell(Center(
                                                                            child: Center(
                                                                          child: Wrap(
                                                                              direction: Axis.vertical, //default
                                                                              alignment: WrapAlignment.center,
                                                                              children: [
                                                                                Text(
                                                                                  list.apDetailsOrderby.toString(),
                                                                                  textAlign: TextAlign.center,
                                                                                )
                                                                              ]),
                                                                        ))),
                                                                        DataCell(Center(
                                                                            child: Center(
                                                                          child:
                                                                              Wrap(
                                                                                  direction: Axis.vertical, //default
                                                                                  alignment: WrapAlignment.center,
                                                                                  children: [
                                                                                Text(list.urole.toString(), textAlign: TextAlign.center)
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
                                                                                Text(list.assignby.toString(), textAlign: TextAlign.center)
                                                                              ]))),
                                                                        ),
                                                                        list.apStatus.toString() ==
                                                                                "P"
                                                                            ? DataCell(
                                                                                Center(
                                                                                    child: Center(
                                                                                        child: Wrap(
                                                                                            direction: Axis.vertical, //default
                                                                                            alignment: WrapAlignment.center,
                                                                                            children: [Text("Pending", textAlign: TextAlign.center)]))),
                                                                              )
                                                                            : DataCell(
                                                                                Center(
                                                                                    child: Center(
                                                                                        child: Wrap(
                                                                                            direction: Axis.vertical, //default
                                                                                            alignment: WrapAlignment.center,
                                                                                            children: [Text("Approved", textAlign: TextAlign.center)]))),
                                                                              ),
                                                                        DataCell(
                                                                          (list.apStatus == "P" && ((list.urole == EmployeeLoginPagesState.Userrole) || (EmployeeLoginPagesState.Userrole == "SUPER ADMIN")))
                                                                              ? Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  children: [
                                                                                    Container(
                                                                                        height: 30,
                                                                                        alignment: Alignment.center,
                                                                                        decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.all(Radius.circular(50))),
                                                                                        child: FlatButton(
                                                                                          onPressed: () {
                                                                                            check().then((value) {
                                                                                              if (value)
                                                                                                uploadImage(list.apId, list.apTblId, "a");
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
                                                                                          },
                                                                                          child: Text(
                                                                                            "Approve",
                                                                                            style: TextStyle(color: Colors.white),
                                                                                          ),
                                                                                        )),
                                                                                    Container(width: 10),
                                                                                    Container(
                                                                                        height: 30,
                                                                                        alignment: Alignment.center,
                                                                                        decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.all(Radius.circular(50))),
                                                                                        child: FlatButton(
                                                                                          onPressed: () {
                                                                                            check().then((value) {
                                                                                              if (value)
                                                                                                uploadImage(list.apId, list.apTblId, "r");
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
                                                                                          },
                                                                                          child: Text(
                                                                                            "Reject",
                                                                                            style: TextStyle(color: Colors.white),
                                                                                          ),
                                                                                        )),
                                                                                  ],
                                                                                )
                                                                              : (list.apStatus == "A")
                                                                                  ? Container(child: Text("-"))
                                                                                  : Center(child: Container(child: Text("Not Assigned"))),
                                                                        ),
                                                                      ]),
                                                                )
                                                                .toList(),
                                                          ),
                                                        ),
                                                      ],
                                                    ))
                                                  : widget.verify ==
                                                          "Station Deactive"
                                                      ? SingleChildScrollView(
                                                          child: new Column(
                                                          children: <Widget>[
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
                                                            //   margin: EdgeInsets.only(top: 10.0, bottom: 10),
                                                            //
                                                            //   child: new Text(
                                                            //     "Repair Verify",
                                                            //     textAlign: TextAlign.left,
                                                            //     style: TextStyle(
                                                            //         fontWeight: FontWeight.bold, color: Colors.red),
                                                            //   ),
                                                            // ),

                                                            Container(
                                                                margin:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top:
                                                                            10),
                                                                color: Colors
                                                                    .red
                                                                    .shade50,
                                                                child:
                                                                    ExpansionTile(
                                                                        backgroundColor:
                                                                            Colors
                                                                                .white,
                                                                        initiallyExpanded:
                                                                            true,
                                                                        title:
                                                                            Text(
                                                                          "Station Details",
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.w600,
                                                                              color: Colors.red),
                                                                        ),
                                                                        children: [
                                                                      SizedBox(
                                                                        height:
                                                                            height /
                                                                                50,
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsets.only(
                                                                            left:
                                                                                10.0,
                                                                            right:
                                                                                10.0),
                                                                        child:
                                                                            new TextField(
                                                                          enabled:
                                                                              false,
                                                                          controller:
                                                                              StationName,
                                                                          decoration:
                                                                              InputDecoration(
                                                                            labelText:
                                                                                'Station Name',
                                                                            hintStyle:
                                                                                TextStyle(
                                                                              color: Colors.grey,
                                                                              fontSize: 16.0,
                                                                            ),
                                                                            border:
                                                                                OutlineInputBorder(
                                                                              borderRadius: BorderRadius.circular(5.0),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            height /
                                                                                50,
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsets.only(
                                                                            left:
                                                                                10.0,
                                                                            right:
                                                                                10.0),
                                                                        child:
                                                                            new TextField(
                                                                          enabled:
                                                                              false,
                                                                          controller:
                                                                              addressController,
                                                                          decoration:
                                                                              InputDecoration(
                                                                            labelText:
                                                                                'Address',
                                                                            hintStyle:
                                                                                TextStyle(
                                                                              color: Colors.grey,
                                                                              fontSize: 16.0,
                                                                            ),
                                                                            border:
                                                                                OutlineInputBorder(
                                                                              borderRadius: BorderRadius.circular(5.0),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            height /
                                                                                50,
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsets.only(
                                                                            left:
                                                                                10.0,
                                                                            right:
                                                                                10.0),
                                                                        child:
                                                                            new TextField(
                                                                          enabled:
                                                                              false,
                                                                          controller:
                                                                              StatusController,
                                                                          decoration:
                                                                              InputDecoration(
                                                                            labelText:
                                                                                'Status',
                                                                            hintStyle:
                                                                                TextStyle(
                                                                              color: Colors.grey,
                                                                              fontSize: 16.0,
                                                                            ),
                                                                            border:
                                                                                OutlineInputBorder(
                                                                              borderRadius: BorderRadius.circular(5.0),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            height /
                                                                                50,
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsets.only(
                                                                            left:
                                                                                10.0,
                                                                            right:
                                                                                10.0),
                                                                        child:
                                                                            new TextField(
                                                                          enabled:
                                                                              false,
                                                                          controller:
                                                                              StateController,
                                                                          decoration:
                                                                              InputDecoration(
                                                                            labelText:
                                                                                'State',
                                                                            hintStyle:
                                                                                TextStyle(
                                                                              color: Colors.grey,
                                                                              fontSize: 16.0,
                                                                            ),
                                                                            border:
                                                                                OutlineInputBorder(
                                                                              borderRadius: BorderRadius.circular(5.0),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            height /
                                                                                50,
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsets.only(
                                                                            left:
                                                                                10.0,
                                                                            right:
                                                                                10.0),
                                                                        child:
                                                                            new TextField(
                                                                          enabled:
                                                                              false,
                                                                          controller:
                                                                              DistrictController,
                                                                          decoration:
                                                                              InputDecoration(
                                                                            labelText:
                                                                                'District',
                                                                            hintStyle:
                                                                                TextStyle(
                                                                              color: Colors.grey,
                                                                              fontSize: 16.0,
                                                                            ),
                                                                            border:
                                                                                OutlineInputBorder(
                                                                              borderRadius: BorderRadius.circular(5.0),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            height /
                                                                                50,
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsets.only(
                                                                            left:
                                                                                10.0,
                                                                            right:
                                                                                10.0),
                                                                        child:
                                                                            new TextField(
                                                                          enabled:
                                                                              false,
                                                                          controller:
                                                                              AssignController,
                                                                          decoration:
                                                                              InputDecoration(
                                                                            labelText:
                                                                                'Assigned For',
                                                                            hintStyle:
                                                                                TextStyle(
                                                                              color: Colors.grey,
                                                                              fontSize: 16.0,
                                                                            ),
                                                                            border:
                                                                                OutlineInputBorder(
                                                                              borderRadius: BorderRadius.circular(5.0),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            height /
                                                                                50,
                                                                      ),
                                                                    ])),

                                                            Container(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(16),
                                                              width: width,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: Colors
                                                                        .grey,
                                                                    offset: Offset(
                                                                        0.0,
                                                                        1.0), //(x,y)
                                                                    blurRadius:
                                                                        1.0,
                                                                  ),
                                                                ],
                                                              ),
                                                              // color: Colors.white,
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      top: 10.0,
                                                                      bottom:
                                                                          10),

                                                              child: new Text(
                                                                "Approval Process",
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .red),
                                                              ),
                                                            ),

                                                            SingleChildScrollView(
                                                              scrollDirection:
                                                                  Axis.horizontal,
                                                              child: DataTable(
                                                                sortAscending:
                                                                    sort,
                                                                sortColumnIndex:
                                                                    0,
                                                                columnSpacing:
                                                                    width / 20,
                                                                columns: [
                                                                  DataColumn(
                                                                    label: Center(
                                                                        child: Wrap(
                                                                      direction:
                                                                          Axis.vertical, //default
                                                                      alignment:
                                                                          WrapAlignment
                                                                              .center,
                                                                      children: [
                                                                        Text(
                                                                            "Order By",
                                                                            softWrap:
                                                                                true,
                                                                            style:
                                                                                TextStyle(fontSize: 12),
                                                                            textAlign: TextAlign.center),
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
                                                                      direction:
                                                                          Axis.vertical, //default
                                                                      alignment:
                                                                          WrapAlignment
                                                                              .center,
                                                                      children: [
                                                                        Text(
                                                                            "Designation",
                                                                            softWrap:
                                                                                true,
                                                                            style:
                                                                                TextStyle(fontSize: 12),
                                                                            textAlign: TextAlign.center),
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
                                                                      direction:
                                                                          Axis.vertical, //default
                                                                      alignment:
                                                                          WrapAlignment
                                                                              .center,
                                                                      children: [
                                                                        Text(
                                                                            "Approver",
                                                                            softWrap:
                                                                                true,
                                                                            style:
                                                                                TextStyle(fontSize: 12),
                                                                            textAlign: TextAlign.center),
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
                                                                      direction:
                                                                          Axis.vertical, //default
                                                                      alignment:
                                                                          WrapAlignment
                                                                              .center,
                                                                      children: [
                                                                        Text(
                                                                            "Status",
                                                                            softWrap:
                                                                                true,
                                                                            style:
                                                                                TextStyle(fontSize: 12),
                                                                            textAlign: TextAlign.center),
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
                                                                      direction:
                                                                          Axis.vertical, //default
                                                                      alignment:
                                                                          WrapAlignment
                                                                              .center,
                                                                      children: [
                                                                        Text(
                                                                            "Actions",
                                                                            softWrap:
                                                                                true,
                                                                            style:
                                                                                TextStyle(fontSize: 12),
                                                                            textAlign: TextAlign.center),
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
                                                                rows: li2.items
                                                                    .map(
                                                                      (list) =>
                                                                          DataRow(
                                                                              cells: [
                                                                            DataCell(Center(
                                                                                child: Center(
                                                                              child: Wrap(
                                                                                  direction: Axis.vertical, //default
                                                                                  alignment: WrapAlignment.center,
                                                                                  children: [
                                                                                    Text(
                                                                                      list.apDetailsOrderby.toString(),
                                                                                      textAlign: TextAlign.center,
                                                                                    )
                                                                                  ]),
                                                                            ))),
                                                                            DataCell(Center(
                                                                                child: Center(
                                                                              child:
                                                                                  Wrap(
                                                                                      direction: Axis.vertical, //default
                                                                                      alignment: WrapAlignment.center,
                                                                                      children: [
                                                                                    Text(list.urole.toString(), textAlign: TextAlign.center)
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
                                                                                    Text(list.assignby.toString(), textAlign: TextAlign.center)
                                                                                  ]))),
                                                                            ),
                                                                            list.apStatus.toString() == "P"
                                                                                ? DataCell(
                                                                                    Center(
                                                                                        child: Center(
                                                                                            child: Wrap(
                                                                                                direction: Axis.vertical, //default
                                                                                                alignment: WrapAlignment.center,
                                                                                                children: [Text("Pending", textAlign: TextAlign.center)]))),
                                                                                  )
                                                                                : DataCell(
                                                                                    Center(
                                                                                        child: Center(
                                                                                            child: Wrap(
                                                                                                direction: Axis.vertical, //default
                                                                                                alignment: WrapAlignment.center,
                                                                                                children: [Text("Approved", textAlign: TextAlign.center)]))),
                                                                                  ),
                                                                            DataCell(
                                                                              (list.apStatus == "P" && ((list.urole == EmployeeLoginPagesState.Userrole) || (EmployeeLoginPagesState.Userrole == "SUPER ADMIN")))
                                                                                  ? Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                      children: [
                                                                                        Container(
                                                                                            height: 30,
                                                                                            alignment: Alignment.center,
                                                                                            decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.all(Radius.circular(50))),
                                                                                            child: FlatButton(
                                                                                              onPressed: () {
                                                                                                check().then((value) {
                                                                                                  if (value)
                                                                                                    uploadImage(list.apId, list.apTblId, "a");
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
                                                                                              },
                                                                                              child: Text(
                                                                                                "Approve",
                                                                                                style: TextStyle(color: Colors.white),
                                                                                              ),
                                                                                            )),
                                                                                        Container(width: 10),
                                                                                        Container(
                                                                                            height: 30,
                                                                                            alignment: Alignment.center,
                                                                                            decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.all(Radius.circular(50))),
                                                                                            child: FlatButton(
                                                                                              onPressed: () {
                                                                                                check().then((value) {
                                                                                                  if (value)
                                                                                                    uploadImage(list.apId, list.apTblId, "r");
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
                                                                                              },
                                                                                              child: Text(
                                                                                                "Reject",
                                                                                                style: TextStyle(color: Colors.white),
                                                                                              ),
                                                                                            )),
                                                                                      ],
                                                                                    )
                                                                                  : (list.apStatus == "A")
                                                                                      ? Container(child: Text("-"))
                                                                                      : Center(child: Container(child: Text("Not Assigned"))),
                                                                            ),
                                                                          ]),
                                                                    )
                                                                    .toList(),
                                                              ),
                                                            ),
                                                          ],
                                                        ))
                                                      : widget.verify ==
                                                              "Spare Request"
                                                          ? SingleChildScrollView(
                                                              child: new Column(
                                                                children: <
                                                                    Widget>[
                                                                  Container(
                                                                      margin: const EdgeInsets
                                                                              .only(
                                                                          top:
                                                                              10),
                                                                      color: Colors
                                                                          .red
                                                                          .shade50,
                                                                      child: ExpansionTile(
                                                                          backgroundColor: Colors.white,
                                                                          initiallyExpanded: true,
                                                                          title: Text(
                                                                            "Spare Details",
                                                                            style:
                                                                                TextStyle(fontWeight: FontWeight.w600, color: Colors.red),
                                                                          ),
                                                                          children: [
                                                                            SizedBox(
                                                                              height: height / 50,
                                                                            ),
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                                                                              child: new TextField(
                                                                                enabled: false,
                                                                                controller: SpareCodeController,
                                                                                decoration: InputDecoration(
                                                                                  labelText: 'Spare Code',
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
                                                                                controller: SpareNoteController,
                                                                                decoration: InputDecoration(
                                                                                  labelText: 'Spare Note',
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
                                                                      margin: const EdgeInsets
                                                                              .only(
                                                                          top:
                                                                              10),
                                                                      color: Colors
                                                                          .red
                                                                          .shade50,
                                                                      child: ExpansionTile(
                                                                          backgroundColor: Colors.white,
                                                                          initiallyExpanded: true,
                                                                          title: Text(
                                                                            "Machine Details",
                                                                            style:
                                                                                TextStyle(fontWeight: FontWeight.w600, color: Colors.red),
                                                                          ),
                                                                          children: [
                                                                            SizedBox(
                                                                              height: height / 50,
                                                                            ),
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                                                                              child: new TextField(
                                                                                enabled: false,
                                                                                controller: MachineNameController,
                                                                                decoration: InputDecoration(
                                                                                  labelText: 'Machine Name',
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
                                                                                controller: MachineCodeController,
                                                                                decoration: InputDecoration(
                                                                                  labelText: 'Machine Code',
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
                                                                                controller: MachineTypeController,
                                                                                decoration: InputDecoration(
                                                                                  labelText: 'Machine Type',
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
                                                                                controller: ManufacturerNameController,
                                                                                decoration: InputDecoration(
                                                                                  labelText: 'Manufacturer Name',
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
                                                                                controller: ManufacturerNoController,
                                                                                decoration: InputDecoration(
                                                                                  labelText: 'Manufacturer No',
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
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                                                                              child: new TextField(
                                                                                enabled: false,
                                                                                controller: StateController,
                                                                                decoration: InputDecoration(
                                                                                  labelText: 'State Name',
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
                                                                                controller: DistrictController,
                                                                                decoration: InputDecoration(
                                                                                  labelText: 'District Name',
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

                                                                            // Padding(
                                                                            //   padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                                                                            //   child: new TextField(
                                                                            //     enabled: false,
                                                                            //     controller: AssignbyController,
                                                                            //     decoration: InputDecoration(
                                                                            //       labelText: 'Assign Name',
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
                                                                            // SizedBox(
                                                                            //   height: height / 50,
                                                                            // ),
                                                                          ])),
                                                                  Container(
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            16),
                                                                    width:
                                                                        width,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Colors
                                                                          .white,
                                                                      boxShadow: [
                                                                        BoxShadow(
                                                                          color:
                                                                              Colors.grey,
                                                                          offset: Offset(
                                                                              0.0,
                                                                              1.0), //(x,y)
                                                                          blurRadius:
                                                                              1.0,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    // color: Colors.white,
                                                                    margin: EdgeInsets.only(
                                                                        top:
                                                                            10.0,
                                                                        bottom:
                                                                            10),

                                                                    child:
                                                                        new Text(
                                                                      "Approval Process",
                                                                      textAlign:
                                                                          TextAlign
                                                                              .left,
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color:
                                                                              Colors.red),
                                                                    ),
                                                                  ),
                                                                  SingleChildScrollView(
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
                                                                            direction:
                                                                                Axis.vertical, //default
                                                                            alignment:
                                                                                WrapAlignment.center,
                                                                            children: [
                                                                              Text("Order By", softWrap: true, style: TextStyle(fontSize: 12), textAlign: TextAlign.center),
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
                                                                            direction:
                                                                                Axis.vertical, //default
                                                                            alignment:
                                                                                WrapAlignment.center,
                                                                            children: [
                                                                              Text("Designation", softWrap: true, style: TextStyle(fontSize: 12), textAlign: TextAlign.center),
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
                                                                            direction:
                                                                                Axis.vertical, //default
                                                                            alignment:
                                                                                WrapAlignment.center,
                                                                            children: [
                                                                              Text("Approver", softWrap: true, style: TextStyle(fontSize: 12), textAlign: TextAlign.center),
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
                                                                            direction:
                                                                                Axis.vertical, //default
                                                                            alignment:
                                                                                WrapAlignment.center,
                                                                            children: [
                                                                              Text("Status", softWrap: true, style: TextStyle(fontSize: 12), textAlign: TextAlign.center),
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
                                                                            direction:
                                                                                Axis.vertical, //default
                                                                            alignment:
                                                                                WrapAlignment.center,
                                                                            children: [
                                                                              Text("Actions", softWrap: true, style: TextStyle(fontSize: 12), textAlign: TextAlign.center),
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
                                                                      rows: li2
                                                                          .items
                                                                          .map(
                                                                            (list) =>
                                                                                DataRow(cells: [
                                                                              DataCell(Center(
                                                                                  child: Center(
                                                                                child: Wrap(
                                                                                    direction: Axis.vertical, //default
                                                                                    alignment: WrapAlignment.center,
                                                                                    children: [
                                                                                      Text(
                                                                                        list.apDetailsOrderby.toString(),
                                                                                        textAlign: TextAlign.center,
                                                                                      )
                                                                                    ]),
                                                                              ))),
                                                                              DataCell(Center(
                                                                                  child: Center(
                                                                                child:
                                                                                    Wrap(
                                                                                        direction: Axis.vertical, //default
                                                                                        alignment: WrapAlignment.center,
                                                                                        children: [
                                                                                      Text(list.urole.toString(), textAlign: TextAlign.center)
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
                                                                                      Text(list.assignby.toString(), textAlign: TextAlign.center)
                                                                                    ]))),
                                                                              ),
                                                                              list.apStatus.toString() == "P"
                                                                                  ? DataCell(
                                                                                      Center(
                                                                                          child: Center(
                                                                                              child: Wrap(
                                                                                                  direction: Axis.vertical, //default
                                                                                                  alignment: WrapAlignment.center,
                                                                                                  children: [Text("Pending", textAlign: TextAlign.center)]))),
                                                                                    )
                                                                                  : DataCell(
                                                                                      Center(
                                                                                          child: Center(
                                                                                              child: Wrap(
                                                                                                  direction: Axis.vertical, //default
                                                                                                  alignment: WrapAlignment.center,
                                                                                                  children: [Text("Approved", textAlign: TextAlign.center)]))),
                                                                                    ),
                                                                              DataCell(
                                                                                (list.apStatus == "P" && ((list.urole == EmployeeLoginPagesState.Userrole) || (EmployeeLoginPagesState.Userrole == "SUPER ADMIN")))
                                                                                    ? Row(
                                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                        children: [
                                                                                          Container(
                                                                                              height: 30,
                                                                                              alignment: Alignment.center,
                                                                                              decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.all(Radius.circular(50))),
                                                                                              child: FlatButton(
                                                                                                onPressed: () {
                                                                                                  print("claim");
                                                                                                  tblid = list.apTblId;
                                                                                                  uploadImage(widget.apid, tblid, "a");
                                                                                                },
                                                                                                child: Text(
                                                                                                  "Approve",
                                                                                                  style: TextStyle(color: Colors.white),
                                                                                                ),
                                                                                              )),
                                                                                          Container(width: 10),
                                                                                          Container(
                                                                                              height: 30,
                                                                                              alignment: Alignment.center,
                                                                                              decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.all(Radius.circular(50))),
                                                                                              child: FlatButton(
                                                                                                onPressed: () {
                                                                                                  uploadImage(list.apId, list.apTblId, "r");

                                                                                                  check().then((value) {
                                                                                                    if (value)
                                                                                                      ;
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
                                                                                                },
                                                                                                child: Text(
                                                                                                  "Reject",
                                                                                                  style: TextStyle(color: Colors.white),
                                                                                                ),
                                                                                              )),
                                                                                        ],
                                                                                      )
                                                                                    : (list.apStatus == "A")
                                                                                        ? Container(child: Text("-"))
                                                                                        : Center(child: Container(child: Text("Not Assigned"))),
                                                                              ),
                                                                            ]),
                                                                          )
                                                                          .toList(),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            )
                                                          : Column(
                                                              children: [
                                                                Container(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              16),
                                                                  width: width,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .white,
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                        color: Colors
                                                                            .grey,
                                                                        offset: Offset(
                                                                            0.0,
                                                                            1.0), //(x,y)
                                                                        blurRadius:
                                                                            1.0,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  // color: Colors.white,
                                                                  margin: EdgeInsets.only(
                                                                      top: 10.0,
                                                                      bottom:
                                                                          10),

                                                                  child:
                                                                      new Text(
                                                                    "Approval Process",
                                                                    textAlign:
                                                                        TextAlign
                                                                            .left,
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Colors
                                                                            .red),
                                                                  ),
                                                                ),
                                                                SingleChildScrollView(
                                                                  scrollDirection:
                                                                      Axis.horizontal,
                                                                  child:
                                                                      DataTable(
                                                                    sortColumnIndex:
                                                                        0,
                                                                    columnSpacing:
                                                                        width /
                                                                            20,
                                                                    columns: [
                                                                      DataColumn(
                                                                        label: Center(
                                                                            child: Wrap(
                                                                          direction:
                                                                              Axis.vertical, //default
                                                                          alignment:
                                                                              WrapAlignment.center,
                                                                          children: [
                                                                            Text("Order By",
                                                                                softWrap: true,
                                                                                style: TextStyle(fontSize: 12),
                                                                                textAlign: TextAlign.center),
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
                                                                          direction:
                                                                              Axis.vertical, //default
                                                                          alignment:
                                                                              WrapAlignment.center,
                                                                          children: [
                                                                            Text("Designation",
                                                                                softWrap: true,
                                                                                style: TextStyle(fontSize: 12),
                                                                                textAlign: TextAlign.center),
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
                                                                          direction:
                                                                              Axis.vertical, //default
                                                                          alignment:
                                                                              WrapAlignment.center,
                                                                          children: [
                                                                            Text("Approver",
                                                                                softWrap: true,
                                                                                style: TextStyle(fontSize: 12),
                                                                                textAlign: TextAlign.center),
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
                                                                          direction:
                                                                              Axis.vertical, //default
                                                                          alignment:
                                                                              WrapAlignment.center,
                                                                          children: [
                                                                            Text("Status",
                                                                                softWrap: true,
                                                                                style: TextStyle(fontSize: 12),
                                                                                textAlign: TextAlign.center),
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
                                                                          direction:
                                                                              Axis.vertical, //default
                                                                          alignment:
                                                                              WrapAlignment.center,
                                                                          children: [
                                                                            Text("Actions",
                                                                                softWrap: true,
                                                                                style: TextStyle(fontSize: 12),
                                                                                textAlign: TextAlign.center),
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
                                                                    rows: li2
                                                                        .items
                                                                        .map(
                                                                          (list) =>
                                                                              DataRow(cells: [
                                                                            DataCell(Center(
                                                                                child: Center(
                                                                              child: Wrap(
                                                                                  direction: Axis.vertical, //default
                                                                                  alignment: WrapAlignment.center,
                                                                                  children: [
                                                                                    Text(
                                                                                      list.apDetailsOrderby.toString(),
                                                                                      textAlign: TextAlign.center,
                                                                                    )
                                                                                  ]),
                                                                            ))),
                                                                            DataCell(Center(
                                                                                child: Center(
                                                                              child:
                                                                                  Wrap(
                                                                                      direction: Axis.vertical, //default
                                                                                      alignment: WrapAlignment.center,
                                                                                      children: [
                                                                                    Text(list.urole.toString(), textAlign: TextAlign.center)
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
                                                                                    Text(list.assignby.toString(), textAlign: TextAlign.center)
                                                                                  ]))),
                                                                            ),
                                                                            list.apStatus.toString() == "P"
                                                                                ? DataCell(
                                                                                    Center(
                                                                                        child: Center(
                                                                                            child: Wrap(
                                                                                                direction: Axis.vertical, //default
                                                                                                alignment: WrapAlignment.center,
                                                                                                children: [Text("Pending", textAlign: TextAlign.center)]))),
                                                                                  )
                                                                                : DataCell(
                                                                                    Center(
                                                                                        child: Center(
                                                                                            child: Wrap(
                                                                                                direction: Axis.vertical, //default
                                                                                                alignment: WrapAlignment.center,
                                                                                                children: [Text("Approved", textAlign: TextAlign.center)]))),
                                                                                  ),
                                                                            DataCell(
                                                                              (list.apStatus == "P" && ((list.urole == EmployeeLoginPagesState.Userrole) || (EmployeeLoginPagesState.Userrole == "SUPER ADMIN")))
                                                                                  ? Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                      children: [
                                                                                        Container(
                                                                                            height: 30,
                                                                                            alignment: Alignment.center,
                                                                                            decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.all(Radius.circular(50))),
                                                                                            child: FlatButton(
                                                                                              onPressed: () {
                                                                                                print("claim");
                                                                                                tblid = list.apTblId;
                                                                                                uploadImage(widget.apid, tblid, "a");
                                                                                              },
                                                                                              child: Text(
                                                                                                "Approve",
                                                                                                style: TextStyle(color: Colors.white),
                                                                                              ),
                                                                                            )),
                                                                                        Container(width: 10),
                                                                                        Container(
                                                                                            height: 30,
                                                                                            alignment: Alignment.center,
                                                                                            decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.all(Radius.circular(50))),
                                                                                            child: FlatButton(
                                                                                              onPressed: () {
                                                                                                uploadImage(list.apId, list.apTblId, "r");

                                                                                                check().then((value) {
                                                                                                  if (value)
                                                                                                    ;
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
                                                                                              },
                                                                                              child: Text(
                                                                                                "Reject",
                                                                                                style: TextStyle(color: Colors.white),
                                                                                              ),
                                                                                            )),
                                                                                      ],
                                                                                    )
                                                                                  : (list.apStatus == "A")
                                                                                      ? Container(child: Text("-"))
                                                                                      : Center(child: Container(child: Text("Not Assigned"))),
                                                                            ),
                                                                          ]),
                                                                        )
                                                                        .toList(),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),

      appBar: AppBar(
        title: Image.asset('logotitle.png', height: 40),
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
