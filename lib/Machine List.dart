
import 'package:flutter/material.dart';

class MachineList extends StatefulWidget {
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _MachineListState createState() => _MachineListState();
}

class _MachineListState extends State<MachineList> {
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
        title: Text("Machine List"),
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
                new Flexible(
                    flex: 1,
                    child: Text(
                      "Machine Code",
                      style: TextStyle(
                          fontWeight: FontWeight.w900, color: Colors.white),
                    )),
                new Flexible(
                    flex: 1,
                    child: Text(
                      "Contract Date",
                      style: TextStyle(
                          fontWeight: FontWeight.w900, color: Colors.white),
                    )),
                new Flexible(
                    flex: 2,
                    child: Text(
                      "Machine Holder Name",
                      style: TextStyle(
                          fontWeight: FontWeight.w900, color: Colors.white),
                    )),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                new Flexible(flex: 1, child: Text("MN7845")),
                new Flexible(flex: 1, child: Text("17.8.20")),
                new Flexible(flex: 2, child: Text("Shubah raja")),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(flex: 1, child: Text("MN1260")),
                Flexible(flex: 1, child: Text("15.8.20")),
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
                Flexible(flex: 1, child: Text("1.8.20")),
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
                Flexible(flex: 1, child: Text("7.8.20")),
                Flexible(flex: 2, child: Text("Sowmya Rajesh")),
              ],
            ),
          ),
        ],
      )), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
