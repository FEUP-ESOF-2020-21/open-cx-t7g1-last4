import 'dart:collection';
import 'package:easy_share/Screens/Login/authentication_service.dart';
import 'package:intl/intl.dart';
import 'package:date_field/date_field.dart';
import 'package:easy_share/Screens/home.page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddEventPage extends StatefulWidget {
  @override
  _AddEventState createState() => _AddEventState();
}

class _AddEventState extends State<AddEventPage> {
  DateTime _inicio = DateTime.now();
  DateTime _fim = DateTime.now().add(Duration(hours: 1));
  String _name;
  String _location;
  String _description;
  bool _isVirtual = false;
  final formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.only(
          top: 60,
          left: 40,
          right: 40,
        ),
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[
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
            Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  buildTextField("Name"),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text("Start Date",style: TextStyle(fontSize: 20),),
                  buildDataInputField("inicio"),
                  SizedBox(height: 20,),
                  Text("End Date",style: TextStyle(fontSize: 20),),
                  buildDataInputField("fim"),
                  SizedBox(
                    height: 5.0,
                  ),
                  buildTextField("Description"),
                  SizedBox(
                    height: 20.0,
                  ),
                  buildLocationInputField(),
                  SizedBox(height: 20.0),
                  buildButtonContainer(),
                  SizedBox(height: 60.0,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDataInputField(String text) {
    if (text == "inicio"){
      return DateTimeFormField(
        firstDate: DateTime(DateTime.now().year),
        lastDate: DateTime(DateTime.now().year + 50),
        autovalidate: true,
        initialValue: _inicio,
        mode: DateFieldPickerMode.dateAndTime,
        validator: (DateTime time){
          return time.isBefore(_fim) ? null:"Start Date Must Be Before Then End Date";
        },
        dateFormat: DateFormat('dd/MM/yyyy | HH:mm'),
        textStyle: TextStyle(fontSize: 20),
        onDateSelected: (DateTime date){
          setState(() {
            _inicio = date;
          });
        },
      );
    }
    return DateTimeFormField(
      firstDate: DateTime(DateTime.now().year),
      lastDate: DateTime(DateTime.now().year + 50),
      initialValue: _fim,
      autovalidate: true,
      mode: DateFieldPickerMode.dateAndTime,
      validator: (DateTime time){
        return time.isAfter(_inicio) ? null:"End Date Must Be After Then Start Date";
      },
      dateFormat: DateFormat('dd/MM/yyyy | HH:mm'),
      textStyle: TextStyle(fontSize: 20),
      onDateSelected: (DateTime date){
        setState(() {
          _fim = date;
        });
      },
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
      title: Text("This event will be virtual!",style: TextStyle(fontSize: 20),),
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
    if (hintText != "Description"){
      return TextFormField(
        validator: TextFieldValidator.validate,
        style: new TextStyle(fontSize: 20),
        onSaved: (String input){
          switch (hintText){
            case "Where will it be?":
              _location = input;
              break;
            case "Name":
              _name = input;
              break;
          }
        },
        decoration: InputDecoration(
          labelText: hintText,
          labelStyle: TextStyle(
            color: Colors.black38,
            fontWeight: FontWeight.w400,
            fontSize: 20,
          ),
        ),
      );
    }
    return TextFormField(
      style: new TextStyle(fontSize: 20),
      onSaved: (String input){
        _description = input;
      },
      maxLines: 4,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
        labelText: hintText,
        labelStyle: TextStyle(
          color: Colors.black38,
          fontWeight: FontWeight.w400,
          fontSize: 20,
        ),
      ),
    );
  }

  Widget buildButtonContainer() {
    return ButtonTheme(
        minWidth: 100,
        height: 40,
        child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
            onPressed: () {
              submit();
            },
            child: Text("Create Event",style: TextStyle(fontSize: 20),)),
      );
  }
  bool validate(){
    final form = formKey.currentState;
    if (form.validate()){
      form.save();
      return true;
    }
    return false;
  }

  Future<void> submit() async {
    if (validate()) {
      final uid = await context.read<AuthenticationService>().getuid();

      Map<String,Object> evento = new HashMap<String,Object>();
      evento.putIfAbsent("Nome", () => _name);
      evento.putIfAbsent("Local", () => _location);
      evento.putIfAbsent("Inicio", () => _inicio);
      evento.putIfAbsent("Fim", () => _fim);
      evento.putIfAbsent("Virtual", () => _isVirtual);
      evento.putIfAbsent("Descricao", () => _description);

      evento.putIfAbsent("Cancelado", () => false);

      if (DateTime.now().isBefore(_fim))
        evento.putIfAbsent("Terminou", () => false);
      else
        evento.putIfAbsent("Terminou", () => true);

      FirebaseFirestore.instance.collection('userData').doc(uid).collection('events').add(evento);

      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(
              builder: (BuildContext context) => HomePage()),
              (route) => false);
    }
  }
}

class TextFieldValidator {
  static String validate(String input){
    return input.isEmpty ? ("This field can't be empty!") : null;
  }
}