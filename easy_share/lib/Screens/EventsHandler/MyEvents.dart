import 'package:easy_share/Screens/Login/authentication_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../MainDrawer.dart';
import 'eventInfo.dart';

class MyEvents extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyEvents',
          style: TextStyle(fontSize: 25),
        ),
        centerTitle: true,
      ),
      drawer: MainDrawer('MyEvents'),
      body: Container(
        width: double.infinity,
        child: StreamBuilder(
          stream: getUserEventsStreamSnapshot(context),
          builder: (context,snapshot){
            if (!snapshot.hasData){
              return const Text("Loading...");
            }
            return new ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (BuildContext context,int index) =>
                    buildEvents(context,snapshot.data.documents[index])
            );
          } ,
        ),
      ),
    );
  }

  Stream<QuerySnapshot> getUserEventsStreamSnapshot(BuildContext context) async*{
    final uid = await context.read<AuthenticationService>().getuid();
    yield* FirebaseFirestore.instance.collection('userData').doc(uid).collection('events').orderBy('Inicio',descending: true).snapshots();
  }

  Widget buildEvents(BuildContext context,DocumentSnapshot document) {
    return new Container(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                child: Row(
                  children: <Widget>[
                    eventEnded(document),
                    Container(
                      alignment: Alignment.centerLeft,
                      width: 200,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(context,
                            MaterialPageRoute(
                                builder: (BuildContext context) => EventInfo(document)),);
                        },
                        child: Text("  " + document['Nome'] + "  ",
                          style: new TextStyle(fontSize: 30.0, color: Colors.black),
                          softWrap: false,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: Row(
                  children: <Widget>[
                    Text("${DateFormat('dd/MM/yyyy | HH:mm')
                        .format(document['Inicio'].toDate())
                        .toString()} - ${DateFormat('dd/MM/yyyy | HH:mm')
                        .format(document['Fim'].toDate())
                        .toString()}", style: TextStyle(fontSize: 16),),
                    Spacer(),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: Row(
                  children: <Widget>[
                    Text("Location: " + document['Local'] + "  ",
                      style: TextStyle(fontSize: 16),),
                    isVirtual(document['Virtual']),
                    Spacer(),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: Row(
                  children: <Widget>[
                    eventStatus(document),
                    Spacer(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget isVirtual(bool virtual){
    if (virtual)
      return Icon(Icons.wifi,size: 20,);
    return Icon(Icons.wifi_off,size: 20,);
  }

  Widget eventEnded(DocumentSnapshot doc) {
    if (doc['Cancelado'])
      return Icon(Icons.event_busy_rounded,);
    else if (doc['Terminou'])
      return Icon(Icons.event_available,);

    return Icon(Icons.event,);
  }

  Widget eventStatus(DocumentSnapshot doc) {
    if (doc['Cancelado'])
      return Text("Status: Canceled ",
        style: TextStyle(fontSize: 16 , fontWeight: FontWeight.bold, decoration:  TextDecoration.underline),);
    else if (doc['Terminou'])
      return Text("Status: Unavailable ",
        style: TextStyle(fontSize: 16 , fontWeight: FontWeight.bold, decoration:  TextDecoration.underline),);

    return Text("Status: Available ",
      style: TextStyle(fontSize: 16 , fontWeight: FontWeight.bold, decoration:  TextDecoration.underline),);
  }
}
