import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:auto_size_text/auto_size_text.dart';


class Event extends StatelessWidget {

  final DocumentSnapshot _document;

  Event(this._document);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FittedBox( fit: BoxFit.fitWidth,
          child: Text(_document['Nome']),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget> [
          Padding(
            padding: EdgeInsets.only(top: 15.0,left: 8.0),
            child: Title(
              child: eventStatus(),
              color: Colors.black,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start ,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 30.0,left: 8.0),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.circle,size: 10,),
                    Text(" Date ",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Icon(Icons.calendar_today)
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15.0,left: 30.0),
                child:
                    Text("- From:   ${DateFormat('dd/MM/yyyy | HH:mm').format(_document['Inicio'].toDate()).toString()}",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15.0,left: 30.0),
                child:
                    Text("- To:   ${DateFormat('dd/MM/yyyy | HH:mm').format(_document['Fim'].toDate()).toString()}",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20.0,left: 8.0),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.circle,size: 10,),
                    Text(" Location ",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Icon(Icons.add_location_outlined)
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15.0,left: 30.0),
                child:
                    Text("- "+_document['Local'],
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20.0,left: 8.0),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.circle,size: 10,),
                    Text(" Virtual ",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Icon(Icons.wifi)
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15.0,left: 30.0),
                child:eventVirtual(),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20.0,left: 8.0),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.circle,size: 10,),
                    Text(" Description ",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Icon(Icons.text_snippet_outlined)
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15.0,left: 30.0),
                child:AutoSizeText(
                  "- " + _document['Descricao'],
                  style:  TextStyle(fontSize: 16),
                    ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget eventStatus(){
    if (_document['Cancelado'])
      return Text("Status: Canceled ",
        style: TextStyle(fontSize: 20 , fontWeight: FontWeight.bold, decoration:  TextDecoration.underline),);
    else if (_document['Terminou'])
      return Text("Status: Unavailable ",
        style: TextStyle(fontSize: 20 , fontWeight: FontWeight.bold, decoration:  TextDecoration.underline),);

    return Text("Status: Available ",
      style: TextStyle(fontSize: 20 , fontWeight: FontWeight.bold, decoration:  TextDecoration.underline),);
  }

  Widget eventVirtual(){
    if (_document['Virtual'])
      return Text("- Yes ",
        style: TextStyle(
          fontSize: 16,
        ),
      );

    return Text("- No ",
      style: TextStyle(
        fontSize: 16,
      ),
    );
  }
}
