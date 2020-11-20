import 'package:easy_share/Screens/Login/authentication_service.dart';
import 'package:easy_share/main.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'add_event.page.dart';

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
        actions: <Widget> [
          IconButton(
            onPressed: (){},
            icon: Icon(
              Icons.sync,
              color: Colors.white,
            ),
            iconSize: 30,
          ),
        ],
      ),
      drawer: MainDrawer(),
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
}

