import 'package:flutter/material.dart';
import 'login.page.dart';
import 'package:easy_share/Screens/Login/authentication_service.dart';
import 'package:easy_share/Screens/home.page.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isHidden = true;

  //guarda o username inserido pelo utilizador
  final _username = TextEditingController();
  //guarda o email inserido pelo utilizador
  final _email = TextEditingController();
  //guarda a password inserida pelo utilizador
  final _password = TextEditingController();
  //chave para poder verificar o email e a password colocados
  final formKey = GlobalKey<FormState>();
  //string que vai conter a informação do erro obtido
  String _error;

  void _toggleVisibility() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      resizeToAvoidBottomPadding: false,
      body:Container(
        color: Colors.white,
        padding: EdgeInsets.only(
          top:  60,
          left: 40,
          right: 40,
        ),
        child: ListView(
          children: <Widget>[
            SizedBox(
              width: 100,
              height: 100,
              ),

            Text(
              'Signup',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 50.0,
                color: Colors.deepOrange,
                fontWeight: FontWeight.bold,
              ),
            ),


            Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: _username,
                    decoration: InputDecoration(
                        labelText: "Username",
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
                    validator: EmailValidator.validate,
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
                        )
                    ),
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            buildButtonContainer(),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(String hintText) {
    return TextField(
      style: new TextStyle(color: Colors.black),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.black38,
          fontWeight: FontWeight.w400,
          fontSize: 20,
        ),
        // border: OutlineInputBorder(
        //   borderRadius: BorderRadius.circular(20.0),
        // ),
        suffixIcon: hintText == "Password"
            ? IconButton(
          onPressed: _toggleVisibility,
          icon: _isHidden
              ? Icon(Icons.visibility_off)
              : Icon(Icons.visibility),
        )
            : null,
      ),
      obscureText: hintText == "Password" ? _isHidden : false,
    );
  }

  Widget buildButtonContainer() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
          return new LoginPage();
        }));
      },
      child: ButtonTheme(
        minWidth: 100,
        height: 40,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
          onPressed: () { submit(context);} ,
          child: Text(
            "Create account",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }

  // a partir dos dados introduzidos no email e password vai tentar ligar-se a base de dados
  void submit(BuildContext context) async{
    if (validate()) {
      try {
        String uid = await context.read<AuthenticationService>().signUp(
            email: _email.text.trim(),
            username: _username.text.trim(),
            password: _password.text.trim());
        print("Signed up with ID $uid");
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => HomePage()));
      } catch (e) { //caso não seja possivel ligar a base de dados é lançada uma exceção
        setState(() {
          _error = e.message;
        });
        print(e);
      }
    }
  }

  //função que verifica se os inputs do email e da password são validos
  bool validate(){
    final form = formKey.currentState;
    if (form.validate()){
      form.save();
      return true;
    }
    return false;
  }


}
