
import 'package:flutter/material.dart';

class ServicerList extends StatefulWidget {
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _ServicerListState createState() => _ServicerListState();
}

class _ServicerListState extends State<ServicerList> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Servicer List"),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          Container(
            margin: EdgeInsets.only(left: 5, right: 5),
            //color: Colors.redAccent,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: Colors.redAccent,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0.0, 1.0), //(x,y)
                  blurRadius: 6.0,
                ),
              ],
            ),
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Machine Name",
                  style: TextStyle(
                      fontWeight: FontWeight.w900, color: Colors.white),
                ),
                Text(
                  "Mobile No",
                  style: TextStyle(
                      fontWeight: FontWeight.w900, color: Colors.white),
                ),
                Text(
                  "                  Name",
                  style: TextStyle(
                      fontWeight: FontWeight.w900, color: Colors.white),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                new Flexible(flex: 1, child: Text("MN7845")),
                new Flexible(flex: 1, child: Text("9874561230")),
                new Flexible(flex: 1, child: Text("Shubah raja")),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(flex: 1, child: Text("MN1260")),
                Flexible(flex: 1, child: Text("7845123691")),
                Flexible(flex: 2, child: Text("Sathish Mary")),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(flex: 1, child: Text("MN4560")),
                Flexible(flex: 1, child: Text("7895555555")),
                Flexible(flex: 2, child: Text("Rajesh Raja")),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(flex: 1, child: Text("MN3333")),
                Flexible(flex: 1, child: Text("7888888888")),
                Flexible(flex: 2, child: Text("Sowmya Rajesh")),
              ],
            ),
          ),
        ],
      )), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
