import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:new_app/view/loginPage.dart';
// import 'dart:convert' show json, base64, ascii;

import 'package:shared_preferences/shared_preferences.dart';

// const SERVER_IP = 'http://192.168.1.167:5000';
// final storage = FlutterSecureStorage();

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'flutter login',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  SharedPreferences sharedPreferences;
    
  @override
  void initState(){
    super.initState();
    CheckLoginStatus();  
  }

  CheckLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();  
    if(sharedPreferences.getString("token") == null){
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginPage()), (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title : Text(
          'flutter Login', 
          style: TextStyle(
            color: Colors.white
        ),),
        actions: <Widget>[
          RaisedButton(onPressed: () {
            sharedPreferences.clear();
            sharedPreferences.commit();
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginPage()), (Route<dynamic> route) => false);
          },
          child: Text('Logout', style : TextStyle(color : Colors.white)),
          ),
        ],
      ),

      body: Center(
        child : Text('Main Page')
      ),

      drawer: Drawer(
        child : new ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: new Text('nodejs'), 
              accountEmail: new Text('kaveesha@gmail.com')),
              new ListTile(
                title : Text('List Products'),
                trailing : new Icon(Icons.list),
                onTap: (){},
              ),
              new ListTile(
                title : Text('Add Products'),
                trailing : new Icon(Icons.add),
                onTap: (){},
              ),
              new ListTile(
                title : Text('Register User'),
                trailing : new Icon(Icons.add),
                onTap: (){},
              ),
          ],
        ),
      ),

    );
  }

  
}

