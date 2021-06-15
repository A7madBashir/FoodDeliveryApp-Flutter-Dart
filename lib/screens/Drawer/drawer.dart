import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);
    return Container(
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Drawer(
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(
                  "Name",
                  style: TextStyle(color: Colors.black, fontSize: 22),
                ),
                accountEmail: Text(
                  "Name@mail.com",
                  style: TextStyle(color: Colors.grey, fontSize: 18),
                ),
                currentAccountPicture: GestureDetector(
                  child: CircleAvatar(
                    backgroundColor: Colors.grey,
                    child: Icon(
                      Icons.person,
                      color: Colors.black38,
                    ),
                  ),
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
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (_) => HomePage()));
                      },
                      child: ListTile(
                        title: Text(
                          "Home",
                          style: TextStyle(color: Colors.black, fontSize: 20),
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
                                        color: Colors.black, fontSize: 20),
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
                                onTap: () {
                                  //Log out Just delete Token And Data From The Phone
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //       builder: (context) =>
                                  //           WelcomePage()),
                                  // );
                                },
                                child: ListTile(
                                  title: Text(
                                    "Log out",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 20),
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
        ),
      ),
    );
  }
}
