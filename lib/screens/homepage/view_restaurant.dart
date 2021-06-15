import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../Meal/Meal.dart';
import 'package:http/http.dart' as http;

//This Screen rsepone a Resturant id from main screen that have all resturant so this id i'll send
//it to api to resend me the specefic data from DataBase

class ViewRestaurant extends StatefulWidget {
  final int rest_id;

  const ViewRestaurant({Key key, this.rest_id}) : super(key: key);

  @override
  _ViewRestaurantState createState() => _ViewRestaurantState();
}

class _ViewRestaurantState extends State<ViewRestaurant> {
  //get Meals from resturant
  Future fecthDataRest(int id) async {
    var url = Uri.parse(
        'https://node-js-flutter.herokuapp.com/api/mobile/Meal/ByResturantId/$id');
    var res = await http.get(url);
    if (res.statusCode == 200) {
      var obj = json.decode(res.body);
      return obj;
    }
  }

//Get Resturant From Database
  Future fecthRest(int id) async {
    var url = Uri.parse(
        'https://node-js-flutter.herokuapp.com/api/mobile/Resturant/byid/$id');
    var res = await http.get(url);
    if (res.statusCode == 200) {
      var obj = json.decode(res.body);
      return obj;
    }
  }

  @override
  void initState() {
    super.initState();
    fecthDataRest(widget.rest_id);
    fecthRest(widget.rest_id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 325,
                child: FutureBuilder(
                  future: fecthRest(widget.rest_id),
                  builder: (ctx, snap) {
                    if (snap.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return ListView.builder(
                          itemCount: snap.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            return BackImage(
                              name: snap.data[index]['rest_name'].toString(),
                              image: snap.data[index]['image'],
                              address: snap.data[index]['address'],
                              phone: snap.data[index]['phone'],
                            );
                          });
                    }
                  },
                ),
              ),
              Column(
                children: [
                  Container(
                    color: Colors.grey[300],
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: FutureBuilder(
                      future: fecthDataRest(widget.rest_id),
                      builder: (ctx, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Explain(
                                id: snapshot.data[index]["m_id"],
                                img: snapshot.data[index]["image"],
                                name: snapshot.data[index]["m_name"].toString(),
                                price: snapshot.data[index]["price"].toString(),
                                desc: snapshot.data[index]["Description"]
                                    .toString(),
                              );
                            },
                          );
                        }
                      },
                    ),
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

class BackImage extends StatelessWidget {
  final String image;
  final String name;
  final String address;
  final String phone;

  BackImage({this.image, this.name, this.address, this.phone});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 300,
          width: MediaQuery.of(context).size.width,
          child: Stack(children: [
            Container(
              height: 280,
              width: MediaQuery.of(context).size.width,
              child: Image.memory(
                base64Decode(
                  image,
                ),
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              left: 10,
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back, color: Colors.deepOrange),
              ),
            ),
          ]),
        ),
        Container(
          color: Colors.grey[300],
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 0),
                      child: Text(
                        name,
                        style: TextStyle(color: Colors.orange, fontSize: 20),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 0),
                      child: Text(
                        address,
                        style: TextStyle(color: Colors.orange, fontSize: 20),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Text(
                        phone,
                        style: TextStyle(color: Colors.orange, fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class Explain extends StatelessWidget {
  final int id;
  final String img;
  final String name;
  final String desc;
  final String price;

  Explain({
    this.img,
    this.name,
    this.desc,
    this.price,
    this.id,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Meal(id)),
        );
      },
      child: Container(
        color: Colors.grey[200],
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.symmetric(vertical: 10),
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                Container(
                  height: 400,
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.memory(
                          base64Decode(
                            img,
                          ),
                          height: 200,
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 12.0, left: 8, bottom: 8),
                                        child: Text(
                                          name,
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: 17.0, bottom: 10, left: 20),
                                        child: Text(
                                          "$price S.P",
                                          style: TextStyle(
                                              color: Colors.orange,
                                              fontSize: 14),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 8.0, left: 13, right: 7),
                            child: Text(
                              desc,
                              style: TextStyle(
                                color: Colors.black26,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
