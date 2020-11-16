import 'package:easy_share/Screens/Login/authentication_service.dart';
import 'package:easy_share/main.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'MainDrawer.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
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
      body: Center(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        child: Icon(Icons.add),
      ),
    );
  }
}

