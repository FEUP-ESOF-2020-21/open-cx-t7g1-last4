import 'dart:collection';
import 'package:easy_share/Screens/EventsHandler/editEvent.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'EventsHandler/eventInfo.dart';
import 'Login/authentication_service.dart';
import 'add_event.page.dart';
import 'package:auto_size_text/auto_size_text.dart';


import 'MainDrawer.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home",
          style: TextStyle(
            fontSize: 25,
          ),
        ),
        centerTitle: true,
      ),
      drawer: MainDrawer("Home Page"),
      body: Container(
        width: double.infinity,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 15, 0, 10),
              child: Title(
                color: Colors.black,
                child:Text(
                  "Upcoming Events",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ) ,
                ),
              ),
            ),
            listEvents(context),
          ],
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => AddEventPage()));
        },
        child: Icon(Icons.add),
      ),
    );
  }


  Widget listEvents(BuildContext context){
    return Container(
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
    );
  }

  Stream<QuerySnapshot> getUserEventsStreamSnapshot(BuildContext context) async*{
    final uid = await context.read<AuthenticationService>().getuid();
    yield* FirebaseFirestore.instance.collection('userData').doc(uid).collection('events').orderBy('Inicio').snapshots();
  }

  Widget buildEvents(BuildContext context,DocumentSnapshot document){
    atualizarEstadoEventos(document);
    if( !document['Terminou']) {
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
                      Icon(Icons.event),
                      Container(
                        alignment: Alignment.centerLeft,
                        width: 230,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) => EventInfo(document)),);
                          },
                          child: AutoSizeText(document['Nome'] + "  ",
                            textAlign: TextAlign.start,
                            style: new TextStyle(fontSize: 25.0, color: Colors.black),
                          ),
                        ),
                      ),
                      Spacer(),
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.grey,),
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) => UpdateEvent(document)),
                                  (route) => false);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.highlight_remove, color: Colors.red,),
                        onPressed: () {},
                      )
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
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }else{
      return Container();
    }
  }

  Widget isVirtual(bool virtual){
    if (virtual)
      return Icon(Icons.wifi,size: 20,);
    return Icon(Icons.wifi_off,size: 20,);
  }

  void atualizarEstadoEventos(DocumentSnapshot document) {
    final _now = DateTime.now();
    if ( ((document['Fim'].toDate()).isBefore(_now)) && (!document['Terminou']) ){
      Map<String,Object> map = new HashMap<String,Object>();
      map.putIfAbsent("Terminou", () => true);
      document.reference.update(map);
    }
    return;
  }

}

