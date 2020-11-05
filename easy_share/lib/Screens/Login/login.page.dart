import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
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
                onPressed: () {} ,
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
                    onPressed: (){},
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
