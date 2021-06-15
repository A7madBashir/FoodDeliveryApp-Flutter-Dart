import 'dart:async';
import 'package:flushbar/flushbar.dart';
import 'package:flutter_login_signup/GoogleMap/location_map.dart';
import 'package:flutter_login_signup/screens/Card/orderProvider.dart';
import 'package:flutter_login_signup/screens/homepage/HomePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './purchases.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CheckCard extends StatefulWidget {
  @override
  _CheckCardState createState() => _CheckCardState();
}

class _CheckCardState extends State<CheckCard> {
  int order_id;
  int rest_id;
  Future<bool> SendOrder(
      double price, int count, int customer, int m_id) async {
    SharedPreferences _getData = await SharedPreferences.getInstance();
    var uri =
        Uri.parse("https://node-js-flutter.herokuapp.com/Customers/order");
    final res = await http.post(
      uri,
      body: json.encode(
          {"price": price, "count": count, "customer": customer, "m_id": m_id}),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "${_getData.getString('token')}"
      },
    );
    if (res.statusCode == 201) {
      print("Work");
      print("result body" + res.body);
      var data = json.decode(res.body);
      order_id = data["or_id"];
      rest_id = data["rest_id"];
      //Here Will Get order id that equal the room id in socket so you should send it to socket screen
      return true;
    } else {
      print("Failed");
      return false;
    }
  }

  int _id;

  int _cus;

  int _count;

  double _price;

  bool tracking = false;

  Widget buildText(int id, String name, int count, double price) {
    _id = id;
    _count = count;
    //
    price *= count;
    _price = price;
    //
    var mealname =
        name.length >= 20 ? name.replaceRange(20, name.length, '...') : name;
    return Positioned(
      bottom: 10,
      right: 10,
      child: Container(
        width: 180,
        color: Colors.black54,
        margin: EdgeInsets.only(left: 100, top: 20),
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        child: Text(
          "$name\n$count\n$price S.P",
          style: TextStyle(fontSize: 26, color: Colors.white),
          softWrap: true,
          overflow: TextOverflow.fade,
          maxLines: 4,
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
    } else {
      print("wrong");
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Order> orderlist =
        Provider.of<Orders>(context, listen: true).orderList;
    List<Purchases> purchist =
        Provider.of<Purchasess>(context, listen: true).purchasesList;
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              centerTitle: true,
              title: Text(
                "Check Cart!",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            //If There is no Purchaes It's will give me "No Purch.." else if there purchaes and didnot order
            //will give List of Childern.. else if there is orders will give me "Already Have An Order"
            body: orderlist.isNotEmpty
                ? Stack(children: [
                    GridView(
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        mainAxisSpacing: 0,
                        crossAxisSpacing: 10,
                        maxCrossAxisExtent: 500,
                        childAspectRatio: 2,
                      ),
                      children: purchist
                          .map((item) => Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                elevation: 6,
                                margin: EdgeInsets.all(10),
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        topRight: Radius.circular(15),
                                      ),
                                      child: Image.memory(
                                          base64Decode(item.image),
                                          fit: BoxFit.cover),
                                    ),
                                    buildText(item.m_id, item.name, item.count,
                                        item.price),
                                  ],
                                ),
                              ))
                          .toList(),
                    ),
                    Center(
                        child: Text(
                      "Track Your Order on Map",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 25),
                    ))
                  ])
                : purchist.isEmpty
                    ? Center(
                        child: Text('No Purchaes Added.',
                            style: TextStyle(fontSize: 22)))
                    : Stack(
                        children: [
                          GridView(
                            gridDelegate:
                                SliverGridDelegateWithMaxCrossAxisExtent(
                              mainAxisSpacing: 0,
                              crossAxisSpacing: 10,
                              maxCrossAxisExtent: 500,
                              childAspectRatio: 2,
                            ),
                            children: purchist
                                .map((item) => Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      elevation: 6,
                                      margin: EdgeInsets.all(10),
                                      child: Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(15),
                                              topRight: Radius.circular(15),
                                            ),
                                            child: Image.memory(
                                                base64Decode(item.image),
                                                fit: BoxFit.cover),
                                          ),
                                          buildText(item.m_id, item.name,
                                              item.count, item.price),
                                          Positioned(
                                            left: 10,
                                            bottom: 10,
                                            child: FloatingActionButton(
                                              heroTag: item.price,
                                              backgroundColor:
                                                  Colors.deepOrange,
                                              onPressed: () =>
                                                  Provider.of<Purchasess>(
                                                          context,
                                                          listen: false)
                                                      .delete(item.name),
                                              child: Icon(Icons.delete,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ))
                                .toList(),
                          ),
                          Positioned(
                            bottom: 10,
                            right: 115,
                            child: ElevatedButton(
                              onPressed: () async {
                                SharedPreferences _getData =
                                    await SharedPreferences.getInstance();
                                _cus = _getData.getInt("Customer_id");
                                Loading(context, true);
                                //// Here Will send The data to database and get order id for room in socket
                                if (await SendOrder(
                                        _price, _count, _cus, _id) ==
                                    true) {
                                  Loading(context, false);
                                  setState(() {
                                    // purchist.removeWhere(
                                    //     (element) => element.m_id == _id);
                                    orderlist.add(Order(or_id: order_id));

                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => HomePage(
                                                sIndex: 2,
                                                meal: _id,
                                                resturant: rest_id,
                                                order: order_id)));
                                  });
                                }
                              },
                              //style: ButtonStyle(),
                              child: Container(
                                width: 150,
                                alignment: Alignment.center,
                                height: 40,
                                // decoration:
                                //BoxDecoration(borderRadius: BorderRadius.circular(20)),
                                child: Text(
                                  "Done!",
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          )
                        ],
                      )));
  }
}
