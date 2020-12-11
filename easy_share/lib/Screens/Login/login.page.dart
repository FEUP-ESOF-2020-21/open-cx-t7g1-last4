import 'package:easy_share/Screens/Login/authentication_service.dart';
import 'package:easy_share/Screens/Login/login_facebook.page.dart';
import 'package:easy_share/Screens/Login/register.page.dart';
import 'package:easy_share/Screens/home.page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //guarda o email inserido pelo utilizador
  final _email = TextEditingController();

  //guarda a password inserida pelo utilizador
  final _password = TextEditingController();

  //chave para poder verificar o email e a password colocados
  final formKey = GlobalKey<FormState>();

  //string que vai conter a informação do erro obtido
  String _error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        width: double.infinity,
        padding: EdgeInsets.only(
          top: 60,
          left: 40,
          right: 40,
        ),
        child: ListView(
          children: <Widget>[
            SizedBox(
              width: 100,
              height: 100,
              child: Icon(
                Icons.account_circle_outlined,
                size: 150,
                color: Colors.deepOrange,
              ),
            ),
            SizedBox(
              height: 80,
            ),
            Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    validator: EmailValidator.validate,
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        labelText: "E-mail",
                        labelStyle: TextStyle(
                          color: Colors.black38,
                          fontWeight: FontWeight.w400,
                          fontSize: 20,
                        )),
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    validator: PasswordValidator.validate,
                    controller: _password,
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    decoration: InputDecoration(
                        labelText: "Password",
                        labelStyle: TextStyle(
                          color: Colors.black38,
                          fontWeight: FontWeight.w400,
                          fontSize: 20,
                        )),
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            showAlert(),
            ButtonTheme(
              minWidth: 100,
              height: 40,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                onPressed: () {
                  submit(context);
                },
                child: Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            Container(
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                    child: Text(
                      "Signup",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          decoration: TextDecoration.underline, fontSize: 15),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => RegisterPage()));
                    },
                  ),
                  FlatButton(
                    child: Text(
                      "Recover Password",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          decoration: TextDecoration.underline, fontSize: 15),
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
