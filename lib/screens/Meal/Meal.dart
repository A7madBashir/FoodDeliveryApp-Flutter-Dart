import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import '../homepage/HomePage.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';
import '../Card/CheckCard.dart';
import '../Card/purchases.dart';
import 'dart:io';

class Meal extends StatefulWidget {
  //Meal Id For Send To Api To Get Specific Data
  final int meal_id;
  //For Attributes I Define Thim For Send them to Check Card Screen

  Meal(
    this.meal_id,
  );
  @override
  _MealState createState() => _MealState();
}

class _MealState extends State<Meal> {
  int m_id;
  String name;
  String image;
  int count;
  var price;
  int _count = 0;

  fetchphotos(int id) async {
    //Should Send Meal Id To Get Meal Info
    var url = Uri.parse(
        "https://node-js-flutter.herokuapp.com/api/mobile/meal/byid/$id");
    var res = await http.get(url);
    if (res.statusCode == 200) {
      var obj = json.decode(res.body);
      return obj;
    } else {
      return null;
    }
  }

  fetchrest(int id) async {
    //Should Send Meal Id To Get Restuarnt info
    var url = Uri.parse(
        "https://node-js-flutter.herokuapp.com/api/mobile/Meal/Resturant/byid/$id");
    var res = await http.get(url);
    if (res.statusCode == 200) {
      var obj = json.decode(res.body);
      return obj;
    } else {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    fetchphotos(widget.meal_id);
    fetchrest(widget.meal_id);
  }

  @override
  Widget build(BuildContext context) {
    List<Purchases> purchist =
        Provider.of<Purchasess>(context, listen: true).purchasesList;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 50),
            child: FutureBuilder(
                future: fetchphotos(widget.meal_id),
                builder: (ctx, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    m_id = snapshot.data[0]["m_id"];
                    name = snapshot.data[0]['m_name'];
                    image = snapshot.data[0]['image'];
                    price = double.parse(snapshot.data[0]['price'].toString());

                    return Column(
                      children: <Widget>[
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              IconButton(
                                padding: EdgeInsets.only(
                                    left: 10, right: 10, top: 10),
                                icon: Icon(
                                  Icons.arrow_back_ios,
                                  size: 30,
                                ),
                                color: Colors.deepOrange,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ]),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 2),
                          padding: EdgeInsets.all(3),
                          //width:double.infinity,
                          child: Image.memory(
                              base64Decode(snapshot.data[0]['image'])),
                        ),
                        Container(
                          child: FutureBuilder(
                              future: fetchrest(widget.meal_id),
                              builder: (ctx, snap) {
                                if (snap.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else {
                                  return Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          RichText(
                                            text: TextSpan(children: [
                                              TextSpan(
                                                text: snap.data[0]['rest_name']
                                                //"pasta"
                                                ,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20),
                                              ),
                                            ]),
                                          ),
                                          Text(
                                            snap.data[0]['address'],
                                            textAlign: TextAlign.end,
                                            style: TextStyle(
                                              fontSize: 23,
                                              color: Colors.deepOrange,
                                            ),
                                          )
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            snap.data[0]['phone'],
                                            textAlign: TextAlign.end,
                                            style: TextStyle(
                                              fontSize: 23,
                                              color: Colors.deepOrange,
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  );
                                }
                              }),
                        ),
                        Divider(
                          height: 4,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                  text: snapshot.data[0]['m_name']
                                  //"pasta"
                                  ,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              ]),
                            ),
                            Text(
                              "${snapshot.data[0]['price']} S.P",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline
                                  .copyWith(color: Colors.deepOrange),
                            )
                          ],
                        ),
                        Text(snapshot.data[0]['Description']),
                        SizedBox(
                          height: 20,
                        ),
                        Divider(
                          height: 2,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        SizedBox(height: 20),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              IconButton(
                                  icon: Icon(
                                    Icons.remove,
                                    size: 30,
                                  ),
                                  color: Colors.deepOrange,
                                  onPressed: () {
                                    setState(() {
                                      if (_count != 0) {
                                        _count--;
                                      }
                                      count = _count;
                                    });
                                  }),
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  color: Colors.deepOrange,
                                  border: Border.all(
                                      color: Colors.deepOrange, width: 20.0),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Text(
                                  "$_count",
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.add,
                                  size: 30,
                                ),
                                color: Colors.deepOrange,
                                onPressed: () {
                                  setState(() {
                                    _count++;
                                    count = _count;
                                  });
                                },
                              ),
                            ]),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                if (count == 0) {
                                  Navigator.pop(context);
                                } else {
                                  if (purchist.isNotEmpty) {
                                    Navigator.of(context).pop();
                                    Flushbar(
                                      title: "Refuesd",
                                      duration: Duration(milliseconds: 3500),
                                      message:
                                          "Can't Add When Currently have an order",
                                      icon: Icon(
                                        Icons.info,
                                        color: Colors.white,
                                      ),
                                    ).show(context);
                                  } else {
                                    setState(() {
                                      purchist.add(Purchases(
                                          m_id: m_id,
                                          name: name,
                                          image: image,
                                          count: count,
                                          price: price));
                                    });
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => HomePage()));
                                  }
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 9, horizontal: 9),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.deepOrange),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      "Add To Bag",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    Icon(
                                      Icons.shopping_cart,
                                      color: Colors.deepOrange,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    );
                  }
                }),
          ),
        ),
      ),
    );
  }
}
