import 'package:easy_share/Screens/Login/authentication_service.dart';
import 'package:easy_share/Screens/Login/register.page.dart';
import 'package:easy_share/Screens/home.page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:easy_share/main.dart';
import '../MainDrawer.dart';

class LoginFacebookPage extends StatefulWidget {
  @override
  _LoginFacebookPageState createState() => _LoginFacebookPageState();
}

class _LoginFacebookPageState extends State<LoginFacebookPage> {
  bool _isLoggedInFacebook = false;

  //string que vai conter a informação do erro obtido
  String _error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My social networks",
          style: TextStyle(
            fontSize: 25,
          ),
        ),
        centerTitle: true,
      ),
      drawer: MainDrawer(),
      body: showFacebookLogin(),
    );
  }

  Widget showFacebookLogin() {
    if (!_isLoggedInFacebook)
      return Container(
        color: Colors.white,
        width: double.infinity,
        padding: EdgeInsets.only(
          top: 60,
          left: 40,
          right: 40,
        ),
        child: ListView(
          children: <Widget>[
            Text(
              'Facebook:',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            SignInButton(
              Buttons.Facebook,
              text: "Login with Facebook",
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
              onPressed: () => submitFacebook(),
            ),
          ],
        ),
      );

    return Text('Already logged in with Facebook.');
  }

  // Trigger when click to login with facebook
  void submitFacebook() async {
    final fb = FacebookLogin();
    final uid = await fb.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email,
    ]);
    print(uid);
    switch (uid.status) {
      case FacebookLoginStatus.Success:
        print("Signed in with ID $uid");
        _isLoggedInFacebook = true;
        Navigator.of(context).pop(); // para remover o welcomePage
        Navigator.of(context).pop(); // para remover o loginPage
        Navigator.of(context).push(
            MaterialPageRoute(builder: (BuildContext context) => HomePage()));
        break;
      case FacebookLoginStatus.Cancel:
        print("The user canceled the login");
        break;
      case FacebookLoginStatus.Error:
        print("There was an Error");
        break;
    }
  }
}
