import 'package:easy_share/Screens/Login/authentication_service.dart';
import 'package:easy_share/main.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
            children: [
              Text("home page"),
              RaisedButton(
                onPressed: (){
                  context.read<AuthenticationService>().signOut();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => WelcomePage()));
                },
                child: Text("SignOut"),
              )
            ],
          )
      ),
    );
  }
}