import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'dart:async';
import 'package:draw/draw.dart';

import 'package:http/http.dart' as http;

class EventInfo extends StatefulWidget {
  final DocumentSnapshot _document;

  EventInfo(this._document);

  @override
  _EventInfoState createState() => _EventInfoState();
}

class _EventInfoState extends State<EventInfo> {
  bool _isPublished = false;
  List<String> _redditSubs = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FittedBox(
          fit: BoxFit.fitWidth,
          child: Text(widget._document['Nome']),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 15.0, left: 8.0),
            child: Title(
              child: eventStatus(),
              color: Colors.black,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 30.0, left: 8.0),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.circle,
                      size: 10,
                    ),
                    Text(
                      " Date ",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Icon(Icons.calendar_today)
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15.0, left: 30.0),
                child: Text(
                  "- From:   ${DateFormat('dd/MM/yyyy | HH:mm').format(widget._document['Inicio'].toDate()).toString()}",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15.0, left: 30.0),
                child: Text(
                  "- To:   ${DateFormat('dd/MM/yyyy | HH:mm').format(widget._document['Fim'].toDate()).toString()}",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20.0, left: 8.0),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.circle,
                      size: 10,
                    ),
                    Text(
                      " Location ",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Icon(Icons.add_location_outlined)
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15.0, left: 30.0),
                child: Text(
                  "- " + widget._document['Local'],
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20.0, left: 8.0),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.circle,
                      size: 10,
                    ),
                    Text(
                      " Virtual ",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Icon(Icons.wifi)
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15.0, left: 30.0),
                child: eventVirtual(),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20.0, left: 8.0),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.circle,
                      size: 10,
                    ),
                    Text(
                      " Description ",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Icon(Icons.text_snippet_outlined)
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15.0, left: 30.0),
                child: AutoSizeText(
                  "- " + widget._document['Descricao'],
                  style: TextStyle(fontSize: 16),
                ),
              ),
              showRedditsWhereItWasPublished(),
              getRedditButton(),
            ],
          ),
        ],
      ),
    );
  }

  Widget getRedditButton() {
    if (_redditSubs.length == 0) {
      return Padding(
        padding: EdgeInsets.only(top: 20.0, left: 30.0),
        child: RaisedButton(
          color: Colors.deepOrange,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
              side: BorderSide(color: Colors.red)),
          onPressed: () {
            submitPostReddit(
                widget._document['Nome'],
                getPostTitle(widget._document),
                getPostContent(widget._document));
          },
          child: Text("Share on Reddit!", style: TextStyle(fontSize: 20)),
        ),
      );
    }

    return SizedBox(height: 0.0);
  }

  Widget eventStatus() {
    if (widget._document['Cancelado'])
      return Text(
        "Status: Canceled ",
        style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline),
      );
    else if (widget._document['Terminou'])
      return Text(
        "Status: Unavailable ",
        style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline),
      );

    return Text(
      "Status: Available ",
      style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.underline),
    );
  }

  Widget eventVirtual() {
    if (widget._document['Virtual'])
      return Text(
        "- Yes ",
        style: TextStyle(
          fontSize: 16,
        ),
      );

    return Text(
      "- No ",
      style: TextStyle(
        fontSize: 16,
      ),
    );
  }

  //mostra um alerta com a mensagem do erro ocorrido
  Widget showRedditsWhereItWasPublished() {
    if (_redditSubs.length != 0) {
      return Container(
        padding: EdgeInsets.all(8.0),
        child: Column(children: <Widget>[
          SizedBox(height: 30.0),
          Text("This event was published in the following subreddits: ",
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Icon(Icons.share),
              ),
              Expanded(
                child: SizedBox(
                    height: 150.0,
                    child: ListView.builder(
                      itemCount: _redditSubs.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text('${_redditSubs[index]}'),
                        );
                      },
                    )),
              )
            ],
          ),
        ]),
      );
    }
    return SizedBox(
      height: 0,
    );
  }

  Future<void> submitPostReddit(
      String name, String postTitle, String postContent) async {
    Reddit reddit = await Reddit.createScriptInstance(
      clientId: "z-ugkvCVoM1zeg",
      clientSecret: "-6DSZV2N2qKAWAVjy3WuFCwKMPJZfQ",
      userAgent: "mariapia",
      username: "johneasyshare",
      password: "easyshare123", // Fake
    );
    List<String> words = name.split(" ");
    // Stream<SubredditRef> subs = reddit.subreddits.search(postTitle);
    //var post = await subs.submit(postTitle, selftext: postContent);
    List<SubredditRef> subs = [];
    for (var i = 0; i < words.length; i++) {
      List<SubredditRef> subsForWord =
          await reddit.subreddits.searchByName(words[i]);
      subs = subs + subsForWord;
    }

    setState(() {
      _redditSubs = subs.map((s) => s.displayName).toList();
    });
    print("Subreddits to post to: ${_redditSubs}");

    for (var i = 0; i < subs.length; i++) {
      var post = await subs[i].submit(postTitle, selftext: postContent);
    }

    showRedditsWhereItWasPublished();

    return;
  }
}

String getPostTitle(DocumentSnapshot _document) {
  return "${Text(_document['Nome']).data}: new event coming soon!";
}

String getPostContent(DocumentSnapshot _document) {
  return "**${Text(_document['Nome']).data}**: new event coming soon!  \n" +
      "* What is it? ${_document['Descricao']}   \n" +
      "* When? from ${DateFormat('dd/MM/yyyy | HH:mm').format(_document['Inicio'].toDate()).toString()} " +
      "until ${DateFormat('dd/MM/yyyy | HH:mm').format(_document['Fim'].toDate()).toString()}  \n" +
      "* Where? ${_document['Local']} ";
}
