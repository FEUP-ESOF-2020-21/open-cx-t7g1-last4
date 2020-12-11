import 'package:easy_share/Screens/Login/authentication_service.dart';
import 'package:easy_share/Screens/Login/register.page.dart';
import 'package:easy_share/Screens/home.page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import '../MainDrawer.dart';

class LoginFacebookPage extends StatefulWidget {
  @override
  _LoginFacebookPageState createState() => _LoginFacebookPageState();
}

class _LoginFacebookPageState extends State<LoginFacebookPage> {
  //guarda o email inserido pelo utilizador
  final _email = TextEditingController();

  //guarda a password inserida pelo utilizador
  final _password = TextEditingController();

  //chave para poder verificar o email e a password colocados
  final formKey = GlobalKey<FormState>();

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
              'No current account connected.',
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

  // a partir dos dados introduzidos no email e password vai tentar ligar-se a base de dados
  void submit(BuildContext context) async {
    if (validate()) {
      try {
        String uid = await context
            .read<AuthenticationService>()
            .logIn(email: _email.text.trim(), password: _password.text.trim());
        print("Signed in with ID $uid");
        Navigator.of(context).pop(); // para remover o welcomePage
        Navigator.of(context).pop(); // para remover o loginPage
        Navigator.of(context).push(
            MaterialPageRoute(builder: (BuildContext context) => HomePage()));
      } catch (e) {
        //caso não seja possivel ligar a base de dados é lançada uma exceção
        setState(() {
          _error = e.message;
        });
        print(e);
      }
    }
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

  //função que verifica se os inputs do email e da password são validos
  bool validate() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  //mostra um alerta com a mensagem do erro ocorrido
  Widget showAlert() {
    if (_error != null) {
      return Container(
        color: Colors.amberAccent,
        width: double.infinity,
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(Icons.error_outline),
            ),
            Expanded(
              child: AutoSizeText(
                _error,
                maxLines: 3,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    _error = null;
                  });
                },
              ),
            ),
          ],
        ),
      );
    }
    return SizedBox(
      height: 0,
    );
  }
}
