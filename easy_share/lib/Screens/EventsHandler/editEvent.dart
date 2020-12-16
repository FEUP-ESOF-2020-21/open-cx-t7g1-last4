import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:date_field/date_field.dart';

import '../home.page.dart';


class UpdateEvent extends StatefulWidget {
  final DocumentSnapshot _event;

  UpdateEvent(this._event);

  @override
  _UpdateEventState createState() => _UpdateEventState();
}

class _UpdateEventState extends State<UpdateEvent> {

  bool _firtTime = true;
  String _name;
  String _location ;
  String _description;
  bool _virtual ;
  DateTime _inicio;
  DateTime _fim;
  final formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    setState(() {
      if (_firtTime) {
        _virtual = widget._event['Virtual'];
        _inicio = widget._event['Inicio'].toDate();
        _fim = widget._event['Fim'].toDate();
        _firtTime = false;
      }
    });
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
              'Edit Event',
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
                  TextFormField(
                    validator: TextFieldValidator.validate,
                    onSaved: (text){
                      _name = text;
                    },
                    initialValue: widget._event['Nome'],
                    keyboardType: TextInputType.text,
                    style: TextStyle(
                      fontSize: 20
                    ),
                    decoration: InputDecoration(
                      labelText: 'Name',
                      labelStyle: TextStyle(
                        fontSize: 25,

                      ),
                    ),
                  ),
                  TextFormField(
                    validator: TextFieldValidator.validate,
                    onSaved: (text){
                      _location = text;
                    },
                    initialValue: widget._event['Local'],
                    keyboardType: TextInputType.text,
                    style: TextStyle(
                        fontSize: 20
                    ),
                    decoration: InputDecoration(
                      labelText: 'Location',
                      labelStyle: TextStyle(
                        fontSize: 25,

                      ),
                    ),
                  ),
                  SizedBox(height: 30,),
                  Text(
                    "Start Date",
                    style: TextStyle(fontSize: 20),
                  ),
                  DateTimeFormField(
                    firstDate: DateTime(DateTime.now().year),
                    lastDate: DateTime(DateTime.now().year + 50),
                    initialValue: _inicio,
                    mode: DateFieldPickerMode.dateAndTime,
                    autovalidate: true,
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
                  ),
                  SizedBox(height: 20,),
                  Text(
                    "End Date",
                    style: TextStyle(fontSize: 20),
                  ),
                  DateTimeFormField(
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
                  ),
                  SizedBox(height: 20,),
                  Row(
                    children: <Widget>[
                      Text("This event will be virtual!",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      Checkbox(
                        value: _virtual,
                        onChanged: (bool checkBox){
                          setState(() {
                            _virtual = checkBox;
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),
                  TextFormField(
                    onSaved: (text){
                      _description = text;
                    },
                    initialValue: widget._event['Descricao'],
                    keyboardType: TextInputType.multiline,
                    maxLines: 4,
                    style: TextStyle(
                        fontSize: 20
                    ),
                    decoration: InputDecoration(
                      labelText: 'Description',
                      labelStyle: TextStyle(
                        fontSize: 25,

                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      RaisedButton(
                        child: Text("Save Changes",style: TextStyle(fontSize: 20),),
                        color: Colors.deepOrange,

                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.red)
                        ),
                        onPressed: (){
                          submit();
                        },
                      ),
                      RaisedButton(
                        child: Text("Cancel Edit",style: TextStyle(fontSize: 20),),
                        color: Colors.deepOrange,

                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.red)
                        ),
                        onPressed: (){
                          Navigator.pushAndRemoveUntil(context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) => HomePage()),
                                  (route) => false);
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 60,),
                ],
              ),
            ),
          ],
        ),
      ),
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

  void submit() {
    if (validate()) {
        Map<String,Object> evento = new HashMap<String,Object>();
        evento.putIfAbsent("Nome", () => _name);
        evento.putIfAbsent("Local", () => _location);
        evento.putIfAbsent("Inicio", () => _inicio);
        evento.putIfAbsent("Fim", () => _fim);
        evento.putIfAbsent("Virtual", () => _virtual);
        evento.putIfAbsent("Descricao", () => _description);

        evento.putIfAbsent("Cancelado", () => false);

        if (DateTime.now().isBefore(_fim))
          evento.putIfAbsent("Terminou", () => false);
        else
          evento.putIfAbsent("Terminou", () => true);

        widget._event.reference.set(evento);

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
