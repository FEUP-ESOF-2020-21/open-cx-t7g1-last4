import 'package:easy_share/Screens/Login/authentication_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_share/Screens/Login/login.page.dart';
import 'package:easy_share/Screens/Login/register.page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'Screens/home.page.dart';
import 'Screens/add_event.page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider<AuthenticationService>(
            create: (_) => AuthenticationService(FirebaseAuth.instance),
          ),
          StreamProvider(
            create: (context) =>
                context.read<AuthenticationService>().authStateChanges,
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'ESOF - EasyShare',
          theme: ThemeData(
            primarySwatch: Colors.deepOrange,
          ),
          initialRoute: "/",
          routes: {
            "/": (context) => AuthenticationWrapper(),
            "/loginPage": (context) => LoginPage(),
            "/registerPage": (context) => RegisterPage(),
            "/addEventPage": (context) => AddEventPage(),
          },
        ));
  }
}

//classe que verifica se o utilizador se encontra logado, caso contrário vai para o WelcomePage
class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();

    if (firebaseUser != null) {
      // se firebaseUser == null então o conta do utilizador não está aberta
      return HomePage();
    }
    return WelcomePage();
  }
}

//classe que representa o ecrã incial quando o utilizador entra pela primeira vez na aplicação ou quando não está logado
class WelcomePage extends StatelessWidget {
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
                  ),
                  color: Colors.deepOrange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  label: Text(
                    "Login",
                    style: TextStyle(fontSize: 25),
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
                  onPressed: () =>
                      Navigator.of(context).pushNamed("/registerPage"),
                  color: Colors.deepOrange,
                  icon: Icon(
                    Icons.add_circle_outline,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  label: Text(
                    "Signup",
                    style: TextStyle(
                      fontSize: 25,
                    ),
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
