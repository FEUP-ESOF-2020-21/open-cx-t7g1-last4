import 'package:easy_share/Screens/home.page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import 'Login/authentication_service.dart';

class MainDrawer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              color: Theme.of(context).primaryColor,
              child: FutureBuilder(
                future: context.watch<AuthenticationService>().getCurrentUser(),
                builder: (context,snapshot){
                  if(snapshot.connectionState == ConnectionState.done){
                    return userInfo(snapshot);
                  }else{
                    return CircularProgressIndicator();
                  }
                },
              )
            ),
            SizedBox(height: 20,),
            ListTile(
              leading: Icon(Icons.home_outlined),
              title: Text("Home",style: TextStyle(fontSize: 18),),
              onTap: (){
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => HomePage()));
              },
            ),
            ListTile(
              leading: Icon(Icons.account_circle_outlined),
              title: Text("Profile",style: TextStyle(fontSize: 18),),
            ),
            ListTile(
              leading: Icon(Icons.event),
              title: Text("MyEvents",style: TextStyle(fontSize: 18),),
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Logout",style: TextStyle(fontSize: 18),),
              onTap: (){
                context.read<AuthenticationService>().signOut();
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => WelcomePage()));
              },
          ),
        ],
      ),
    );
  }

  Widget userInfo(AsyncSnapshot snapshot)  {
    return Column(
        children: <Widget>[
          SizedBox(height: 40,),
          Text("${snapshot.data.displayName}",
          style: TextStyle(
            fontSize: 22,
          ) ,
          ),
          Text("${snapshot.data.email}"),
        ],
    );
  }

}
