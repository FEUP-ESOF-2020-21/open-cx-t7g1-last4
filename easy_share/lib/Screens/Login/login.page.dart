import 'package:easy_share/Screens/Login/authentication_service.dart';
import 'package:easy_share/Screens/Login/register.page.dart';
import 'package:easy_share/Screens/home.page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class LoginPage extends StatelessWidget {

  //guarda o email inserido pelo utilizador
  final _email = TextEditingController();
  //guarda a password inserida pelo utilizador
  final _password = TextEditingController();

  // a partir dos dados introduzidos no email e password vai tentar ligar-se a base de dados
  void submit(BuildContext context) async{
    try{
       String uid = await context.read<AuthenticationService>().logIn(
          email: _email.text.trim(),
          password: _password.text.trim());
      print("Signed in with ID $uid");
       Navigator.of(context).push(MaterialPageRoute(
           builder: (BuildContext context) => HomePage()));
    }catch (e){ //caso não seja possivel ligar a base de dados é lançada uma exceção
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.only(
          top:  60,
          left: 40,
          right: 40,
        ),
        child: ListView(
          children: <Widget> [
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
            TextFormField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  labelText: "E-mail",
                  labelStyle: TextStyle(
                    color: Colors.black38,
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                  )
              ),
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _password,
              keyboardType: TextInputType.text,
              obscureText: true,
              decoration: InputDecoration(
                  labelText: "Password",
                  labelStyle: TextStyle(
                    color: Colors.black38,
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                  )
              ),
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),
            ButtonTheme(
              minWidth: 100,
              height: 40,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                onPressed: () {
                    submit(context);
                } ,
                child: Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ) ,
            ),
            Container(
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget> [
                  FlatButton(
                    child: Text(
                      "Signup",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: 15
                      ),
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
                          decoration: TextDecoration.underline,
                          fontSize: 15
                      ),
                    ),
                    onPressed: (){},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

  }
}
