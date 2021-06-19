import 'dart:convert';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './Homepage.dart';
import 'package:http/http.dart' as http;

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  var nameController = TextEditingController()..text = "";
  var emailController = TextEditingController()..text = "";
  var passController = TextEditingController()..text = "";
  var phoneController = TextEditingController()..text = "";
  var addressController = TextEditingController()..text = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          "Update Profile",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.red,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 16, top: 25, right: 16),
        child: ListView(
          children: [
            Text(
              "Update Profile",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "Just type what you want to change And Hit Save Button And Wait Until Done",
              style: TextStyle(fontSize: 18, color: Colors.black54),
            ),
            SizedBox(
              height: 1,
            ),
            SizedBox(
              height: 35,
            ),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(bottom: 3),
                labelText: "Username",
                labelStyle: TextStyle(
                  fontSize: 30,
                ),
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(bottom: 3),
                labelText: "Email",
                labelStyle: TextStyle(
                  fontSize: 30,
                ),
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(
              height: 15,
            ),
            TextField(
              controller: passController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(bottom: 3),
                labelText: "Password",
                labelStyle: TextStyle(
                  fontSize: 30,
                ),
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              keyboardType: TextInputType.visiblePassword,
            ),
            SizedBox(
              height: 15,
            ),
            TextField(
              controller: addressController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(bottom: 3),
                labelText: "Address",
                labelStyle: TextStyle(
                  fontSize: 30,
                ),
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(bottom: 3),
                labelText: "Phone",
                labelStyle: TextStyle(
                  fontSize: 30,
                ),
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(
              height: 100,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlineButton(
                  padding: EdgeInsets.symmetric(horizontal: 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "CANCEL",
                    style: TextStyle(
                      fontSize: 14,
                      letterSpacing: 2.2,
                      color: Colors.black,
                    ),
                  ),
                ),
                RaisedButton(
                  onPressed: () async {
                    if (await EditCus(
                            nameController.text,
                            passController.text,
                            addressController.text,
                            phoneController.text,
                            emailController.text) ==
                        true) {
                      print("It's Done With Flutter");
                      Navigator.pushReplacement(context,
                          new MaterialPageRoute(builder: (_) {
                        return HomePage();
                      }));
                    } else {
                      return Flushbar(
                        title: "Failed",
                        message: "SomeThing Went Wrong Please Try Again Later",
                      );
                    }
                  },
                  color: Colors.deepOrange,
                  padding: EdgeInsets.symmetric(horizontal: 50),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: Text(
                    "SAVE",
                    style: TextStyle(
                      fontSize: 14,
                      letterSpacing: 2.2,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

Future<bool> EditCus(String name, String pass, String address, String phone,
    String email) async {
  //Set Shared memory to store Token in phone like cookies in web app
  SharedPreferences _setdata = await SharedPreferences.getInstance();
  int id = _setdata.getInt("Customer_id");
  // Api Url
  var url = Uri.parse("https://node-js-flutter.herokuapp.com/Customers/Edit");
  // Send Data To Api
  final res = await http.post(url,
      body: json.encode({
        "id": id,
        "username": name,
        "password": pass,
        "phone": phone,
        "email": email,
        "address": address
      }),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "${_setdata.getString('token')}"
      });

  if (res.statusCode == 201) {
    print("it's Update correctly");
    // To get json specific value with out this code i can't get by value by name
    var body = json.decode(res.body);
    print("$body");
    _setdata.setString("phone", body["phone"]);
    _setdata.setString("email", body["email"]);
    _setdata.setString("username", body["username"]);
    _setdata.setInt("Customer_id", body["cus_id"]);
    //print(body["token"]);
    return true;
  } else {
    //Should here make some dialog for customer to know what is wrong and till him to resign
    print("It's Failed!!");
    return false;
  }
}
