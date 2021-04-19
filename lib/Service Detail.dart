import 'dart:io';

import 'package:flutter/material.dart';

class ServiceDetail extends StatefulWidget {
  @override
  _ServiceDetailState createState() => _ServiceDetailState();
}

class _ServiceDetailState extends State<ServiceDetail> {
  List<Object> images = List<Object>();
  Future<File> _imageFile;
  File _image;
  bool ischecked = false;
  bool ischeckedPurity = false;
  bool ischeckedQuality = false;
  bool ischeckedDamages = false;

  DateTime _dateTime;
  TimeOfDay _timeOfDay;
  List<ListItem> _PropertyType = [ListItem(1, "Property Name")];
  List<ListItem> _TankType = [ListItem(1, "Tank"), ListItem(4, "Cylinder")];
  List<ListItem> _PlanType = [ListItem(1, "Group")];
  List<ListItem> _ServiceType = [ListItem(1, "Service Type")];

  List<DropdownMenuItem<ListItem>> _dropdownMenuItems;
  ListItem _selectedItem;

  List<DropdownMenuItem<ListItem>> _dropdownMenuItems_service_type;
  ListItem _selectedItemone__service_type;

  List<DropdownMenuItem<ListItem>> _dropdownMenuItems_PlanType;
  ListItem _selectedItemone_PlanType;

  List<DropdownMenuItem<ListItem>> _dropdownMenuItems__TankType;
  ListItem _selectedItemone__TankType;

  void initState() {
    super.initState();

    _dateTime = DateTime.now();
    _timeOfDay = TimeOfDay.now();
    _dropdownMenuItems = buildDropDownMenuItems(_PropertyType);
    _selectedItem = _dropdownMenuItems[0].value;

    _dropdownMenuItems_service_type = buildDropDownMenuItems((_ServiceType));
    _selectedItemone__service_type = _dropdownMenuItems_service_type[0].value;

    _dropdownMenuItems_PlanType = buildDropDownMenuItems((_PlanType));
    _selectedItemone_PlanType = _dropdownMenuItems_PlanType[0].value;

    _dropdownMenuItems__TankType = buildDropDownMenuItems((_TankType));
    _selectedItemone__TankType = _dropdownMenuItems__TankType[0].value;

    images.add("Add Image");
    images.add("Add Image");
    images.add("Add Image");
    images.add("Add Image");
  }

  void onChanged(bool value) {
    setState(() {
      ischecked = value;
    });
  }

  List<DropdownMenuItem<ListItem>> buildDropDownMenuItems(List listItems) {
    List<DropdownMenuItem<ListItem>> items = List();
    for (ListItem listItem in listItems) {
      items.add(
        DropdownMenuItem(
          child: Text(listItem.name),
          value: listItem,
        ),
      );
    }
    return items;
  }

  String searchAddr;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.redAccent[100],
      body: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: new ListView(
          padding: EdgeInsets.all(2.0),
          addRepaintBoundaries: true,
          shrinkWrap: true,
          children: <Widget>[
            new Card(
              elevation: 10.0,
              color: Colors.redAccent[100],
              margin: EdgeInsets.all(3.0),
              child: InkWell(
//                onTap: () {
//                  Navigator.push(context,
//                      MaterialPageRoute(builder: (context) => TodayDETAILS()));
//                },
                splashColor: Colors.redAccent,
                borderRadius: BorderRadius.circular(15),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Row(
                              children: <Widget>[
                                new Text(
                                  "Basic information ",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                  padding: const EdgeInsets.only(left: 20.0, right: 10.0),
                  decoration: new BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(2.0)),
                      border: new Border.all(color: Colors.black38)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                        value: _selectedItemone__TankType,
                        items: _dropdownMenuItems__TankType,
                        onChanged: (value) {
                          setState(() {
                            _selectedItemone__TankType = value;
                          });
                        }),
                  ),
                ),
                new Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: new TextField(
                      decoration: InputDecoration(
                        hintText: 'Property name',
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
                ),
              ],
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: new TextField(
                      decoration: InputDecoration(
                        hintText: 'Residential',
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
                ),
                new Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: new TextField(
                      decoration: InputDecoration(
                        hintText: 'Capacity 100l',
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
                ),
              ],
            ),
            new Flexible(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: new TextField(
                  decoration: InputDecoration(
                    hintText: 'Service count',
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
            ),
            new Flexible(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: new TextField(
                  decoration: InputDecoration(
                    hintText: 'Status Pending',
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
            ),
            new Card(
              elevation: 10.0,
              color: Colors.redAccent[100],
              margin: EdgeInsets.all(3.0),
              child: InkWell(
//                onTap: () {
//                  Navigator.push(context,
//                      MaterialPageRoute(builder: (context) => TodayDETAILS()));
//                },
                splashColor: Colors.redAccent,
                borderRadius: BorderRadius.circular(15),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Row(
                              children: <Widget>[
                                new Text(
                                  "Operation ",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                          "Schedule  Date  :${_dateTime.day}-${_dateTime.month}-${_dateTime.year}"),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                          "Schedule  Time  :${_timeOfDay.hour}:${_timeOfDay.minute}"),
                    ),
                  ],
                ),
              ),
            ),
            new Flexible(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: new TextField(
                  decoration: InputDecoration(
                    hintText: 'Servicer Type: Vendor',
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
            ),
            new Flexible(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: new TextField(
                  decoration: InputDecoration(
                    hintText: 'Servicer Name',
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
            ),
            SizedBox(
              height: 1200,
            ),
            new Card(
              elevation: 10.0,
              color: Colors.redAccent[100],
              margin: EdgeInsets.all(3.0),
              child: InkWell(
//                onTap: () {
//                  Navigator.push(context,
//                      MaterialPageRoute(builder: (context) => TodayDETAILS()));
//                },
                splashColor: Colors.redAccent,
                borderRadius: BorderRadius.circular(15),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Row(
                              children: <Widget>[
                                new Text(
                                  "Verification ",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: new TextField(
                      decoration: InputDecoration(
                        hintText: 'Verified By ;Name',
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
                ),
              ],
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(
                  width: 20,
                ),
                new Text('Verification OTP'),
                new Checkbox(
                    value: ischecked,
                    activeColor: Colors.red,
                    onChanged: (bool value1) {
                      onChanged(value1);
                    }),
              ],
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(
                  width: 20,
                ),
                new Text('Purity'),
                new Checkbox(
                    value: ischeckedPurity,
                    activeColor: Colors.red,
                    onChanged: (bool value2) {
                      onChanged(value2);
                    }),
              ],
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(
                  width: 20,
                ),
                new Text('Quality'),
                new Checkbox(
                    value: ischeckedQuality,
                    activeColor: Colors.red,
                    onChanged: (bool value3) {
                      onChanged(value3);
                    }),
              ],
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(
                  width: 20,
                ),
                new Text('Damages'),
                new Checkbox(
                    value: ischeckedDamages,
                    activeColor: Colors.red,
                    onChanged: (bool value4) {
                      onChanged(value4);
                    }),
              ],
            ),
            buildTextFieldNumbers('Damage Summary'),
            new Card(
              elevation: 10.0,
              color: Colors.redAccent[100],
              margin: EdgeInsets.all(3.0),
              child: InkWell(
//                onTap: () {
//                  Navigator.push(context,
//                      MaterialPageRoute(builder: (context) => TodayDETAILS()));
//                },
                splashColor: Colors.redAccent,
                borderRadius: BorderRadius.circular(15),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Row(
                              children: <Widget>[
                                new Text(
                                  "Photo ",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: buildGridView(),
            ),
            new Card(
              elevation: 10.0,
              color: Colors.redAccent[100],
              margin: EdgeInsets.all(3.0),
              child: InkWell(
//                onTap: () {
//                  Navigator.push(context,
//                      MaterialPageRoute(builder: (context) => TodayDETAILS()));
//                },
                splashColor: Colors.redAccent,
                borderRadius: BorderRadius.circular(15),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Row(
                              children: <Widget>[
                                new Text(
                                  "Files ",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new RaisedButton(
                      child: Text('Delete'),
                      color: Colors.redAccent,
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      onPressed: () {
//                        Navigator.push(
//                            context,
//                            MaterialPageRoute(
//                              builder: (BuildContext context) => PlanService(),
//                            ));
                      },
                    ),
                    SizedBox(width: 20),
                    new RaisedButton(
                      child: Text('Cancel'),
                      color: Colors.redAccent,
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      onPressed: () {},
                    ),
                    SizedBox(width: 20),
                    new RaisedButton(
                      child: Text('Edit'),
                      color: Colors.green,
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Service Details'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.home,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              Icons.home,
              color: Colors.white,
            ),
            onPressed: () {},
          )
        ],
      ),
    );
  }

  buildTextFieldSignup(String hintText) {
    return TextField(
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: 16.0,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
      //obscureText: hintText == "Password" ? isHidden : false,
    );
  }

  buildTextFieldNumbers(String hintText) {
    return TextField(
      maxLines: 5,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: 16.0,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
      //obscureText: hintText == "Password" ? isHidden : false,
    );
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget buildGridView() {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 3,
      childAspectRatio: 1,
      children: List.generate(images.length, (index) {
        if (images[index] is ImageUploadModel) {
          ImageUploadModel uploadModel = images[index];
          return Card(
            elevation: 10.0,
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: <Widget>[
                Image.file(
                  uploadModel.imageFile,
                  width: 300,
                  height: 300,
                ),
                Positioned(
                  right: 5,
                  top: 5,
                  child: InkWell(
                    child: Icon(
                      Icons.remove_circle,
                      size: 20,
                      color: Colors.red,
                    ),
                    onTap: () {
                      setState(() {
                        images.replaceRange(index, index + 1, ['Add Image']);
                      });
                    },
                  ),
                ),
              ],
            ),
          );
        } else {
          return Card(
            elevation: 10.0,
            child: IconButton(
              icon: Icon(Icons.add),
              onPressed: () {},
            ),
          );
        }
      }),
    );
  }
}

_pickaDate() {}

class ImageUploadModel {
  bool isUploaded;
  bool uploading;
  File imageFile;
  String imageUrl;

  ImageUploadModel({
    this.isUploaded,
    this.uploading,
    this.imageFile,
    this.imageUrl,
  });
}

class ListItem {
  int value;
  String name;

  ListItem(this.value, this.name);
}
