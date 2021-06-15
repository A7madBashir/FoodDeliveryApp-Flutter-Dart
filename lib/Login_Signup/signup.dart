import 'dart:convert';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_signup/screens/homepage/HomePage.dart';
import 'package:flutter_login_signup/Login_Signup/Widget/bezierContainer.dart';
import 'package:flutter_login_signup/Login_Signup/loginPage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import './Customer/Custoemr.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

TextEditingController name = TextEditingController();
TextEditingController pass = TextEditingController();
TextEditingController phone = TextEditingController();
TextEditingController address = TextEditingController();
TextEditingController email = TextEditingController();

class _SignUpPageState extends State<SignUpPage> {
  Future<bool> SignupCus(String name, String pass, String address, String phone,
      String email) async {
    //Set Shared memory to store Token in phone like cookies in web app
    SharedPreferences _setdata = await SharedPreferences.getInstance();

    // Api Url
    String url = "https://node-js-flutter.herokuapp.com/Customers/register";
    // Send Data To Api
    final res = await http.post(url,
        body: json.encode({
          "username": name,
          "password": pass,
          "phone": phone,
          "email": email,
          "address": address
        }),
        headers: {"Content-Type": "application/json"});

    if (res.statusCode == 200) {
      print("it's run correctly");
      final responestring = customerFromJson(res.body);
      // To get json specific value with out this code i can't get by value by name
      Map<String, dynamic> body = json.decode(res.body);
      _setdata.setString("token", body["token"]);
      _setdata.setInt("Customer_id", body["user"]["cus_id"]);
      //print(body["token"]);
      return body["success"];
    } else {
      //Should here make some dialog for customer to know what is wrong and till him to resign
      print("It's Null Failed!!");
      return null;
    }
  }

  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            Text('Back',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  Future<Widget> Loading(BuildContext ctx, bool load) async {
    if (load) {
      showDialog(
        context: ctx,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Loading..."),
            content: Container(
              height: 50,
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.min,
                children: [
                  new CircularProgressIndicator(),
                ],
              ),
            ),
          );
        },
      );
    } else if (!load) {
      Navigator.pop(ctx);
      showDialog(
          context: ctx,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Container(
                height: 50,
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 37,
                      color: Colors.red[300],
                    ),
                    new Text(
                      "Something went worng!",
                      style: TextStyle(color: Colors.black38),
                    ),
                  ],
                ),
              ),
            );
          });
      Future.delayed(Duration(seconds: 3), () {
        Navigator.pop(ctx);
      });
    } else {
      print("wrong");
    }
  }

  Widget _entryField(String title, TextEditingController _controller,
      {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
              controller: _controller,
              keyboardType: title == "Mobile Phone"
                  ? TextInputType.number
                  : TextInputType.text,
              obscureText: isPassword,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true))
        ],
      ),
    );
  }

  Widget _submitButton() {
    // ignore: deprecated_member_use

    return FlatButton(
      onPressed: () async {
        if (name.text == "" ||
            pass.text == "" ||
            address.text == "" ||
            phone.text == "" ||
            email.text == "") {
          return Flushbar(
            duration: Duration(seconds: 3),
            flushbarPosition: FlushbarPosition.TOP,
            title: "Wrong",
            message: "Please Fill All The Fields",
          );
        }
        Loading(context, true);
        if (await SignupCus(
                name.text, pass.text, address.text, phone.text, email.text) ==
            true) {
          print("Done");
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomePage()));
        } else {
          print("wrong");
          setState(() {
            Loading(context, false);
          });
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xfffbb448), Color(0xfff7892b)])),
        child: Text(
          'Register Now',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _loginAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Already have an account ?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Login',
              style: TextStyle(
                  color: Color(0xfff79c4f),
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: '3',
          style: GoogleFonts.portLligatSans(
            textStyle: Theme.of(context).textTheme.display1,
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Color(0xffe46b10),
          ),
          children: [
            TextSpan(
              text: 'wa',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
            TextSpan(
              text: 'fi',
              style: TextStyle(color: Color(0xffe46b10), fontSize: 30),
            ),
          ]),
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        _entryField("Username", name),
        _entryField("Email", email),
        _entryField("Mobile Phone", phone),
        _entryField("Address", address),
        _entryField("Password", pass, isPassword: true),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        height: height,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: -MediaQuery.of(context).size.height * .15,
              right: -MediaQuery.of(context).size.width * .4,
              child: BezierContainer(),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: height * .2),
                    _title(),
                    SizedBox(
                      height: 50,
                    ),
                    _emailPasswordWidget(),
                    SizedBox(
                      height: 20,
                    ),
                    _submitButton(),
                    SizedBox(height: height * .14),
                    _loginAccountLabel(),
                  ],
                ),
              ),
            ),
            Positioned(top: 40, left: 0, child: _backButton()),
          ],
        ),
      ),
    );
  }
}
