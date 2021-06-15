import 'dart:convert';
import './SearchMeal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  var charctar = 1;
  var have = 2;
  String m_name = "";
  String rest_name;
  final myController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.only(left: 50.0),
              child: IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          SearchMeal(m_name: m_name, rest_name: rest_name)));
                },
                color: Colors.black,
              ),
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.only(left: 2.0, right: 20),
              child: TextField(
                controller: myController,
                onChanged: (_) {
                  setState(() {
                    m_name = myController.text;
                  });
                },
                cursorColor: Colors.black,
                cursorWidth: 1.0,
                textAlign: TextAlign.center,
                textAlignVertical: TextAlignVertical.bottom,
                decoration: InputDecoration(
                    hintText: "Type What you Like!",
                    fillColor: Colors.black,
                    hoverColor: Colors.black,
                    focusColor: Colors.black,
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 0))),
              ),
            )),
            Padding(
              padding: EdgeInsets.only(right: 4, left: 8),
              child: IconButton(
                icon: Icon(Icons.tune),
                onPressed: () => showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                      title: Text("Choose One!"),
                      content: Container(
                        height: 120,
                        child: Column(
                          children: [
                            RadioListTile(
                              title: Text("Meal"),
                              groupValue: charctar,
                              onChanged: (_) {
                                setState(() {
                                  // m_name = myController.text;
                                  rest_name = null;
                                  charctar = 1;
                                  Navigator.pop(ctx);
                                });
                              },
                              value: 1,
                              //child: Text("All"),
                            ),
                            RadioListTile(
                              title: Text("Restaurant"),
                              groupValue: charctar,
                              onChanged: (_) {
                                setState(() {
                                  rest_name = myController.text;
                                  m_name = null;
                                  charctar = 2;
                                  Navigator.pop(ctx);
                                });
                              },
                              value: 2,
                              //child: Text("All"),
                            ),
                          ],
                        ),
                      )),
                ),
              ),
            )
          ],
          backgroundColor: Colors.deepOrange,
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.white12,
          padding: EdgeInsets.all(50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "hint:",
                    style: TextStyle(
                      fontSize: 23,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
              SizedBox(
                height: 37,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text("#crispy"),
                  Text("#meat"),
                  Text("#salad"),
                  Text("#potato"),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("#hotdog"),
                  Text("#burger"),
                  Text("#shish kebab"),
                  Text("#fish"),
                ],
              ),
            ],
          ),
        ));
  }
}
