import 'package:flutter/material.dart';
import 'package:flutter_login_signup/Login_Signup/welcomePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../homepage/HomePage.dart';
// import 'package:resturant_project/changepassword.dart';
// import 'package:resturant_project/myprofile.dart';
import '../homepage/Editprofile.dart';
// import 'package:resturant_project/shopping.dart';

class MyDrawer extends StatefulWidget {
  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  String name;
  String phone;
  String email;

  Future userInfo() async {
    SharedPreferences _getData = await SharedPreferences.getInstance();
    setState(() {
      name = _getData.getString("username");
      phone = _getData.getString("phone");
      email = _getData.getString("email");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userInfo();
  }

  Future deleteData() async {
    SharedPreferences _deleteData = await SharedPreferences.getInstance();
    if (await _deleteData.clear()) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);
    return Container(
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: name != null
            ? Drawer(
                child: ListView(
                  children: [
                    UserAccountsDrawerHeader(
                      accountName: Text(
                        "$name",
                        style: TextStyle(color: Colors.black, fontSize: 22),
                      ),
                      accountEmail: Text(
                        "$email\t\t\t\t$phone",
                        style: TextStyle(color: Colors.black87, fontSize: 18),
                      ),
                      currentAccountPicture: GestureDetector(
                        child: CircleAvatar(
                            backgroundColor: Colors.black,
                            child: Text("${name.substring(0, 2)}")),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(right: 10, left: 10),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => HomePage()));
                            },
                            child: ListTile(
                              title: Text(
                                "Home",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 20),
                              ),
                              leading: Icon(
                                Icons.home,
                                color: Colors.red,
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.black54,
                                size: 17,
                              ),
                            ),
                          ),
                          Divider(
                            color: Colors.grey[500],
                          ),
                        ],
                      ),
                    ),
                    //------------------------

                    Column(
                      children: [
                        Theme(
                          data: theme,
                          child: ExpansionTile(
                            title: Text("My Account"),
                            children: [
                              Container(
                                padding: EdgeInsets.only(right: 10, left: 10),
                                child: Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  new EditProfile()),
                                        );
                                      },
                                      child: ListTile(
                                        title: Text(
                                          "Edit Profile",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20),
                                        ),
                                        leading: Icon(
                                          Icons.edit,
                                          color: Colors.red,
                                        ),
                                        trailing: Icon(
                                          Icons.arrow_forward_ios,
                                          color: Colors.black54,
                                          size: 17,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(right: 10, left: 10),
                                child: Column(
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        if (await deleteData() == true) {
                                          print("delete All Data");
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    WelcomePage()),
                                          );
                                        } else {
                                          print(
                                              "Failed Didnot Delete All data");
                                        }
                                      },
                                      child: ListTile(
                                        title: Text(
                                          "Log out",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20),
                                        ),
                                        leading: Icon(
                                          Icons.logout,
                                          color: Colors.red,
                                        ),
                                        trailing: Icon(
                                          Icons.arrow_forward_ios,
                                          color: Colors.black54,
                                          size: 17,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Divider(
                          color: Colors.grey[500],
                        ),
                      ],
                    ),
                  ],
                ),
              )
            : Container(),
      ),
    );
  }
}
