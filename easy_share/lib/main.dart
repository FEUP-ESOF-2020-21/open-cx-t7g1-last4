import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_share/Screens/Login/login.page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ESOF',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      initialRoute: '/',
      routes: {
        "/": (context) => HomePage(),
        "/loginPage": (context) => LoginPage(),
        //"/agendAppMain": (context) => AgendAppMain()
      },
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: ListView(
            padding: EdgeInsets.only(
              top: 60.0,
              left: 40.0,
              right: 40.0,
            ),
            children: <Widget>[
              SizedBox(
                width: 128,
                height: 128,
                child: Image.asset('assets/logo.png'),
              ),
              SizedBox(
                width: 80,
                height: 80,
                child: Center(
                  child: Text(
                    "Welcome To EasyShare",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 29,
                      fontFamily: "CaviarDreams",
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 100.0,
              ),
              SizedBox(

                width: 100.0,
                height: 50.0,
                child: RaisedButton.icon(
                  onPressed: () =>
                      Navigator.of(context).pushNamed("/loginPage"),
                  icon: Icon(
                    Icons.account_circle_outlined,
                    color: Colors.white,
                  ),
                  color: Colors.deepOrange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  label: Text(
                    "Login",
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        fontFamily: "CaviarDreams",
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 100,
                height: 50,
                child: RaisedButton.icon(
                  onPressed: () {},
                  color: Colors.deepOrange,
                  icon: Icon(
                    Icons.add_circle_outline,
                    color: Colors.white,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  label: Text(
                    "Signup",
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        fontFamily: "CaviarDreams",
                        fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
