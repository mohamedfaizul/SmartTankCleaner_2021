//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';
//
// class TestApp extends StatefulWidget {
//   @override
//   _TestAppState createState() => _TestAppState();
// }
//
// class _TestAppState extends State<TestApp> {
//   static const platform = const MethodChannel("razorpay_flutter");
//
//   Razorpay _razorpay;
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Razorpay Sample App'),
//         ),
//         body: Center(
//             child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//               RaisedButton(onPressed: openCheckout, child: Text('Open'))
//             ])),
//       ),
//     );
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _razorpay = Razorpay();
//     _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
//     _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
//     _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     _razorpay.clear();
//   }
//
//   void openCheckout() async {
//     var options = {
//       'key': 'rzp_test_10fJOmey4FyE43',
//       'amount': 2000,
//       'name': 'Bala',
//       'description': 'Fine T-Shirt',
//       'prefill': {'contact': '7418230370', 'email': 'bala.future3@gmail.com'},
//       'external': {
//         'wallets': ['paytm', 'gpay']
//       }
//     };
//
//     try {
//       _razorpay.open(options);
//     } catch (e) {
//       debugPrint(e);
//     }
//   }
//
//   void _handlePaymentSuccess(PaymentSuccessResponse response) {
//     Fluttertoast.showToast(
//       msg: "SUCCESS: " + response.paymentId,
//     );
//   }
//
//   void _handlePaymentError(PaymentFailureResponse response) {
//     Fluttertoast.showToast(
//       msg: "ERROR: " + response.code.toString() + " - " + response.message,
//     );
//   }
//
//   void _handleExternalWallet(ExternalWalletResponse response) {
//     Fluttertoast.showToast(
//       msg: "EXTERNAL_WALLET: " + response.walletName,
//     );
//   }
// }
// //
// // class Test1 extends StatefulWidget {
// //   @override
// //   _Test1State createState() => _Test1State();
// // }
// //
// // class _Test1State extends State<Test1> {
// //   String payment_response = null;
// //
// //   //Live
// //   String mid = "lQCWin23992442785846";
// //   String PAYTM_MERCHANT_KEY = "khpasXNr_6xH#XKT";
// //   String website = "WEBSTAGING";
// //   bool testing = true;
// //
// //   //Testing
// //   // String mid = "TEST_MID_HERE";
// //   // String PAYTM_MERCHANT_KEY = "TEST_KEY_HERE";
// //   // String website = "WEBSTAGING";
// //   // bool testing = true;
// //
// //   double amount = 1;
// //   bool loading = false;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       home: Scaffold(
// //         appBar: AppBar(
// //           title: const Text('Paytm example app'),
// //         ),
// //         body: SingleChildScrollView(
// //           child: Padding(
// //             padding: EdgeInsets.all(10.0),
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.stretch,
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               children: <Widget>[
// //                 Text(
// //                     'Test Credentials works only on Android. Also make sure Paytm APP is not installed (For Testing).'),
// //
// //                 SizedBox(
// //                   height: 10,
// //                 ),
// //
// //                 TextFormField(
// //                   initialValue: mid,
// //
// //                   decoration: InputDecoration(hintText: "Enter MID here"),
// //                   keyboardType: TextInputType.text,
// //                 ),
// //                 TextFormField(
// //                   initialValue: PAYTM_MERCHANT_KEY,
// //                   decoration:
// //                   InputDecoration(hintText: "Enter Merchant Key here"),
// //                   keyboardType: TextInputType.text,
// //                 ),
// //                 TextFormField(
// //                   initialValue: website,
// //                   decoration: InputDecoration(
// //                       hintText: "Enter Website here (Probably DEFAULT)"),
// //                   keyboardType: TextInputType.text,
// //                 ),
// //                 TextField(
// //                   onChanged: (value) {
// //                     try {
// //                       amount = double.tryParse(value);
// //                     } catch (e) {
// //                       print(e);
// //                     }
// //                   },
// //                   decoration: InputDecoration(hintText: "Enter Amount here"),
// //                   keyboardType: TextInputType.number,
// //                 ),
// //                 SizedBox(
// //                   height: 10,
// //                 ),
// //                 payment_response != null
// //                     ? Text('Response: $payment_response\n')
// //                     : Container(),
// // //                loading
// // //                    ? Center(
// // //                        child: Container(
// // //                            width: 50,
// // //                            height: 50,
// // //                            child: CircularProgressIndicator()),
// // //                      )
// // //                    : Container(),
// //                 RaisedButton(
// //                   onPressed: () {
// //                     //Firstly Generate CheckSum bcoz Paytm Require this
// //                     generateTxnToken(0);
// //                   },
// //                   color: Colors.blue,
// //                   child: Text(
// //                     "Pay using Wallet",
// //                     style: TextStyle(color: Colors.white),
// //                   ),
// //                 ),
// //                 RaisedButton(
// //                   onPressed: () {
// //                     //Firstly Generate CheckSum bcoz Paytm Require this
// //                     generateTxnToken(1);
// //                   },
// //                   color: Colors.blue,
// //                   child: Text(
// //                     "Pay using Net Banking",
// //                     style: TextStyle(color: Colors.white),
// //                   ),
// //                 ),
// //                 RaisedButton(
// //                   onPressed: () {
// //                     //Firstly Generate CheckSum bcoz Paytm Require this
// //                     generateTxnToken(2);
// //                   },
// //                   color: Colors.blue,
// //                   child: Text(
// //                     "Pay using UPI",
// //                     style: TextStyle(color: Colors.white),
// //                   ),
// //                 ),
// //                 RaisedButton(
// //                   onPressed: () {
// //                     //Firstly Generate CheckSum bcoz Paytm Require this
// //                     generateTxnToken(3);
// //                   },
// //                   color: Colors.blue,
// //                   child: Text(
// //                     "Pay using Credit Card",
// //                     style: TextStyle(color: Colors.white),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   void generateTxnToken(int mode) async {
// //     setState(() {
// //       loading = true;
// //     });
// //     String orderId = DateTime.now().millisecondsSinceEpoch.toString();
// //
// //     String callBackUrl = (testing
// //         ? 'https://securegw-stage.paytm.in'
// //         : 'https://securegw.paytm.in') +
// //         '/theia/paytmCallback?ORDER_ID=' +
// //         orderId;
// //
// //     var url = 'https://desolate-anchorage-29312.herokuapp.com/generateTxnToken';
// //
// //     var body = json.encode({
// //       "mid": mid,
// //       "key_secret": PAYTM_MERCHANT_KEY,
// //       "website": website,
// //       "orderId": orderId,
// //       "amount": amount.toString(),
// //       "callbackUrl": callBackUrl,
// //       "custId": "122",
// //       "mode": mode.toString(),
// //       "testing": testing ? 0 : 1
// //     });
// //
// //     try {
// //       final response = await http.post(
// //         url,
// //         body: body,
// //         headers: {'Content-type': "application/json"},
// //       );
// //       print("Response is");
// //       print(response.body);
// //       String txnToken = response.body;
// //       setState(() {
// //         payment_response = txnToken;
// //       });
// //
// //       var paytmResponse = Paytm.payWithPaytm(
// //           mid, orderId, txnToken, amount.toString(), callBackUrl, testing);
// //
// //       paytmResponse.then((value) {
// //         print(value);
// //         setState(() {
// //           loading = false;
// //           payment_response = value.toString();
// //         });
// //       });
// //     } catch (e) {
// //       print(e);
// //     }
// //   }
// // }
