import 'dart:convert';

import 'package:flutter/material.dart';
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
          "Edit Profile",
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
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              child: Form(
                child: ListView(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        top: 15,
                        bottom: 18,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "Edit Profile",
                        style: TextStyle(color: Colors.red, fontSize: 25),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(13),
                      padding: EdgeInsets.only(left: 23, right: 23),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          hintText: "Name",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          bottom: 25, left: 13, right: 13, top: 13),
                      padding: EdgeInsets.only(left: 23, right: 23),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          hintText: "Email",
                          border: InputBorder.none,
                        ),
                        /*validator: ( value){
                          if(value.isEmpty && value.indexOf(".")==-1 && value.indexOf("@")==-1){return("Please Enter Your Email");}return null;
                        },*/
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 20, left: 15, right: 15),
                      padding: EdgeInsets.only(left: 20, right: 23),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextFormField(
                        keyboardType: TextInputType.phone,
                        obscureText: true,
                        controller: phoneController,
                        decoration: InputDecoration(
                          hintText: "Phone",
                          border: InputBorder.none,
                        ),
                        /*validator: ( va){
                          if(va.isEmpty && va.length<6){return "Please Enter Password";}return null;
                        },*/
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 20, left: 15, right: 15),
                      padding: EdgeInsets.only(left: 20, right: 23),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextFormField(
                        obscureText: true,
                        controller: addressController,
                        decoration: InputDecoration(
                          hintText: "Address",
                          border: InputBorder.none,
                        ),
                        /*validator: ( va){
                          if(va.isEmpty && va.length<6){return "Please Enter Password";}return null;
                        },*/
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 20, left: 15, right: 15),
                      padding: EdgeInsets.only(left: 20, right: 23),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextFormField(
                        obscureText: true,
                        controller: passController,
                        decoration: InputDecoration(
                          hintText: "Password",
                          border: InputBorder.none,
                        ),
                        /*validator: ( va){
                          if(va.isEmpty && va.length<6){return "Please Enter Password";}return null;
                        },*/
                      ),
                    ),
                    SingleChildScrollView(
                      child: MaterialButton(
                          onPressed: () async {
                            //Send User Id
                            if (await EditCus(
                                    1,
                                    nameController.text,
                                    passController.text,
                                    addressController.text,
                                    phoneController.text,
                                    emailController.text) ==
                                true) {
                              print("Really work");
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => HomePage(),
                                  ));
                            } else {
                              print("no is it not");
                            }
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage()),
                            );
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            alignment: Alignment.center,
                            child: Text(
                              "Done",
                              style:
                                  TextStyle(color: Colors.amber, fontSize: 22),
                            ),
                            margin: EdgeInsets.only(
                                top: 15, bottom: 50, left: 75, right: 75),
                            padding: EdgeInsets.all(9),
                            decoration: BoxDecoration(
                              color: Colors.red[400],
                              borderRadius: BorderRadius.circular(10),
                            ),
                          )),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

Future<bool> EditCus(int id, String name, String pass, String address,
    String phone, String email) async {
  //Set Shared memory to store Token in phone like cookies in web app
  // SharedPreferences _setdata = await SharedPreferences.getInstance();

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
      headers: {"Content-Type": "application/json", "Authorization": 'token'});

  if (res.statusCode == 201) {
    print("it's run correctly");
    // To get json specific value with out this code i can't get by value by name
    Map<String, dynamic> body = json.decode(res.body);
    // _setdata.setString("token", body["token"]);
    // _setdata.setInt("Customer_id", body["user"]["cus_id"]);
    //print(body["token"]);
    return body["success"];
  } else {
    //Should here make some dialog for customer to know what is wrong and till him to resign
    print("It's Failed!!");
    return null;
  }
}
