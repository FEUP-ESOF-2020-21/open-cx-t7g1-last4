import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';

import 'Login/login.page.dart';

class AddEventPage extends StatefulWidget {
  @override
  _AddEventState createState() => _AddEventState();
}

class _AddEventState extends State<AddEventPage> {
  bool _isHidden = true;
  DateTime selectedDate;
  bool isVirtual = false;

  void _toggleVisibility() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      resizeToAvoidBottomPadding: false,
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.only(
          top: 60,
          left: 40,
          right: 40,
        ),
        child: ListView(
          children: <Widget>[
            SizedBox(
              width: 100,
              height: 25,
            ),
            Text(
              'Add event',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 50.0,
                color: Colors.deepOrange,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 40.0,
            ),
            buildTextField("Name"),
            SizedBox(
              height: 20.0,
            ),
            buildDataInputField(),
            SizedBox(
              height: 30.0,
            ),
            buildTextField("Description"),
            SizedBox(
              height: 20.0,
            ),
            buildLocationInputField(),
            SizedBox(height: 20.0),
            buildButtonContainer(),
          ],
        ),
      ),
    );
  }

  Widget buildDataInputField() {
    return DateTimeField(
      selectedDate: selectedDate,
      onDateSelected: (DateTime date) {
        setState(() {
          selectedDate = date;
        });
      },
      lastDate: DateTime(2020),
    );
  }

  // Widget buildLocationInputField() {
  //   return new Container(
  //     child: new Row(
  //       children: <Widget>[
  //         new Checkbox(
  //             value: isVirtual,
  //             onChanged: (bool newValue) {
  //               setState(() {
  //                 isVirtual = newValue;
  //               });
  //             }),
  //         new TextField(
  //           decoration: InputDecoration(
  //               border: InputBorder.none, hintText: 'Enter a search term'),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget buildLocationInputField() {
    return CheckboxListTile(
      title: Text("This event will be virtual!"),
      value: isVirtual,
      onChanged: (val) {
        setState(
          () {
            isVirtual = val;
          },
        );
      },
    );
  }

  Widget buildTextField(String hintText) {
    return TextField(
      style: new TextStyle(color: Colors.black),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.black38,
          fontWeight: FontWeight.w400,
          fontSize: 20,
        ),
      ),
    );
  }

  Widget buildButtonContainer() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
          return new LoginPage();
        }));
      },
      child: ButtonTheme(
        minWidth: 100,
        height: 40,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
          onPressed: () {},
          child: Text(
            "Create event",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}
