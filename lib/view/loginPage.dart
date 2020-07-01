import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_app/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  bool isLoading = false;

  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  
   
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(statusBarColor : Colors.transparent));
    return Scaffold(
      body: Container(
        decoration : BoxDecoration(
          gradient : LinearGradient(
            colors : [Colors.blue, Colors.teal],
            begin : Alignment.topCenter,
            end : Alignment.bottomCenter
          ),

        ),
        child: isLoading ? Center(
          child : CircularProgressIndicator()
        ) : ListView(
          children: <Widget>[
            heardSection(),
            textSection(),
            buttonSection(),
          ],
        ),
      ),
    );
  }      

  signIn(String email, pass) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      'email' : email,
      'password' : pass,
    };

    var jsonResponse = null;
    var response = await http.post("http://192.168.91.2:3000/api/authenticate", body: data);

    if(response.statusCode == 200){
      jsonResponse = json.decode(response.body);

      print('response status : ${response.statusCode}');
      print('response body : ${response.body}');

      if(jsonResponse != null){
      setState(() {
        isLoading = false;
      });
      sharedPreferences.setString("token", jsonResponse['token']);
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => HomePage()), (Route<dynamic> route) => false);
    }
    }

    else{
      setState(() {
        isLoading = false;
      });
      print(response.body);
    }
    }

    
    Container buttonSection(){
      return Container(
        width : MediaQuery.of(context).size.width,
        height: 40.0,
        padding: EdgeInsets.symmetric(horizontal : 15.0),
        child: RaisedButton(
          onPressed: emailController.text == "" || passwordController.text == "" ? null : () {
            setState(() {
              isLoading = true;
            });
            signIn(emailController.text, passwordController.text);
          },
          elevation: 0.0,
          color: Colors.purple,
          child: Text('Sign in', style: TextStyle(color: Colors.white),),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          ),
      );
  }  

  Container textSection(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal : 15.0, vertical : 20.0),
      child: Column(
        children : <Widget>[
          TextField(
            controller : emailController,
            cursorColor : Colors.white,
            style: TextStyle(color : Colors.white),
            decoration: InputDecoration(
              icon : Icon(Icons.email, color : Colors.white),
              hintText: "Email",
              border: UnderlineInputBorder(borderSide : BorderSide(color: Colors.white)),
              hintStyle: TextStyle(color : Colors.white)
            ),
          ),
          SizedBox(height : 30.0),

          TextField(
            controller : passwordController,
            cursorColor : Colors.white,
            style: TextStyle(color : Colors.white),
            decoration: InputDecoration(
              icon : Icon(Icons.lock, color : Colors.white),
              hintText: "Password",
              border: UnderlineInputBorder(borderSide : BorderSide(color: Colors.white)),
              hintStyle: TextStyle(color : Colors.white)
            ),
          ),
        ],
      ),
    );
  }

  Container heardSection(){
    return Container(
      margin : EdgeInsets.only(top : 50.0),
      padding: EdgeInsets.symmetric(horizontal : 20.0, vertical : 30.0),
      child: Text("Flutter Login", style : TextStyle(color: Colors.white, fontSize : 40.0, fontWeight: FontWeight.bold )),
    );
  }
}