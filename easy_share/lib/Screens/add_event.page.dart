import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';

import 'Login/login.page.dart';

class AddEventPage extends StatefulWidget {
  @override
  _AddEventState createState() => _AddEventState();
}

class _AddEventState extends State<AddEventPage> {
  DateTime selectedDate;
  bool _isVirtual = false;
  Text buttonText = Text("Create Event");

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
              'Add Event',
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

  Widget buildLocationInputField() {
    return Wrap(
      alignment: WrapAlignment.spaceEvenly,
      spacing: 1,
      runSpacing: 1,
      children: [
        buildLocationVirtualCheckbox(),
        buildTextField("Where will it be?"),
      ],
    );
  }

  Widget buildLocationVirtualCheckbox() {
    return CheckboxListTile(
      title: Text("This event will be virtual!"),
      value: _isVirtual,
      onChanged: (val) {
        setState(
          () {
            _isVirtual = val;
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
        showAlert();
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
            onPressed: () {
              setState(() {
                buttonText = Text("Your event was added!");
              });
            },
            child: buttonText),
      ),
    );
  }
}

//mostra um alerta com a mensagem do erro ocorrido
Widget showAlert() {
  return Container(
    color: Colors.amberAccent,
    width: double.infinity,
    padding: EdgeInsets.all(8.0),
    child: Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Icon(Icons.error_outline),
        ),
        Expanded(child: Text("Your event was added!")),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {},
          ),
        ),
      ],
    ),
  );
}
