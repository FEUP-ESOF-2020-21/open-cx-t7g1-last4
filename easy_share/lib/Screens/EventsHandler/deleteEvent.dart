import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DeleteEvent extends StatelessWidget {

  final DocumentSnapshot _event;

  const DeleteEvent(this._event);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Warning!!!",style: TextStyle(fontSize: 20),textAlign: TextAlign.center,),
      content: Text(
        "Are you sure  you want to delete this event?",
        style: TextStyle(fontSize: 18),
      ),
    actions: <Widget>[
      FlatButton(
        child: Text("Yes",style: TextStyle(fontSize: 18),),
        onPressed: (){
          _event.reference.delete();
          Navigator.of(context).pop();
        },
      ),
      FlatButton(
        child: Text("No",style: TextStyle(fontSize: 18),),
        onPressed: (){
          Navigator.of(context).pop();
        },
      )
    ],
    );
  }
}
