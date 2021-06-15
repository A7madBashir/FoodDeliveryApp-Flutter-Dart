import 'dart:convert';
import '../Meal/Meal.dart';
import '../homepage/view_restaurant.dart';

import '../homepage/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchMeal extends StatefulWidget {
  //Meal Name For Send To DataBase
  final m_name;
  //Resturant Name For Send To DataBase
  final rest_name;

  const SearchMeal({this.m_name, this.rest_name});

  @override
  _SearchMealState createState() => _SearchMealState();
}

class _SearchMealState extends State<SearchMeal> {
  Future sendMeal(String namemeal) async {
    var url = Uri.parse(
        'https://node-js-flutter.herokuapp.com/api/mobile/Meal/SearchMeal/$namemeal');
    var res = await http.get(url);
    if (res.statusCode == 200) {
      var obj = json.decode(res.body);
      // print(obj[0]['id']);
      return obj;
    } else {
      return "";
    }
  }

  Future sendResturant(String namerest) async {
    var url = Uri.parse(
        'https://node-js-flutter.herokuapp.com/api/mobile/Meal/SearchResturant/$namerest');
    var res = await http.get(url);
    if (res.statusCode == 200) {
      var obj = json.decode(res.body);
      return obj;
    } else {
      return "";
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sendMeal(widget.m_name);
    sendResturant(widget.rest_name);
  }

//Get Meal Function
  GetMeal(String m_name) {
    return FutureBuilder(
        future: sendMeal(m_name),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (_, index) => Column(
                children: [
                  SizedBox(height: 5),
                  Card(
                    elevation: 15,
                    color: Colors.deepOrange,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 3,
                          child: Container(
                            padding: EdgeInsets.only(right: 10),
                            width: 130,
                            child: Hero(
                              tag: 1,
                              child: Image.memory(
                                  base64Decode(snapshot.data[index]["image"]),
                                  fit: BoxFit.fill),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Column(
                            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(height: 10),
                              Text(
                                snapshot.data[index]["m_name"],
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              Divider(color: Colors.white),
                              Container(
                                width: 200,
                                child: Text(
                                  snapshot.data[index]["Description"],
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14),
                                  softWrap: true,
                                  overflow: TextOverflow.fade,
                                  textAlign: TextAlign.justify,
                                  maxLines: 3,
                                ),
                              ),
                              Divider(color: Colors.white),
                              Text(
                                "${snapshot.data[index]["price"]}",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18),
                              ),
                              SizedBox(height: 13),
                            ],
                          ),
                        ),
                        Expanded(
                            flex: 1,
                            child: IconButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Meal(
                                              snapshot.data[index]['m_id'])));
                                },
                                icon: Icon(Icons.arrow_forward_ios))),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        });
  }

//Get Resturant Function
  GetRest(String rest_name) {
    return FutureBuilder(
        future: sendResturant(rest_name),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (_, index) => Column(
                children: [
                  SizedBox(height: 5),
                  Card(
                    elevation: 15,
                    color: Colors.deepOrange,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 3,
                          child: Container(
                            padding: EdgeInsets.only(right: 10),
                            width: 130,
                            child: Hero(
                              tag: 1,
                              child: Image.memory(
                                  base64Decode(snapshot.data[index]["image"]),
                                  fit: BoxFit.fill),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Column(
                            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(height: 10),
                              Text(
                                snapshot.data[index]["rest_name"],
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              Divider(color: Colors.white),
                              Container(
                                width: 200,
                                child: Text(
                                  snapshot.data[index]["address"],
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14),
                                  softWrap: true,
                                  overflow: TextOverflow.fade,
                                  textAlign: TextAlign.justify,
                                  maxLines: 3,
                                ),
                              ),
                              Divider(color: Colors.white),
                              Text(
                                snapshot.data[index]["phone"],
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18),
                              ),
                              SizedBox(height: 13),
                            ],
                          ),
                        ),
                        Expanded(
                            flex: 1,
                            child: IconButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ViewRestaurant(
                                                rest_id: snapshot.data[index]
                                                    ["rest_id"],
                                              )));
                                },
                                icon: Icon(Icons.arrow_forward_ios))),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    print(widget.m_name);
    print(widget.rest_name);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepOrange,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
        ),
        body: widget.m_name != null
            ? GetMeal(widget.m_name)
            : GetRest(widget.rest_name),
      ),
    );
  }
}
