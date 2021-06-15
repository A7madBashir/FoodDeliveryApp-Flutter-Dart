import 'package:flutter/material.dart';
import 'package:flutter_login_signup/GoogleMap/location_map.dart';
import '../Card/CheckCard.dart';
import '../Meal/Meal.dart';
import '../Search/Search.dart';
import '../Search/SearchMeal.dart';
import '../Drawer/drawer.dart';
import './view_restaurant.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import '../Card/purchases.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  final int sIndex;
  final int order;
  final int meal;
  final int resturant;
  const HomePage({this.sIndex, this.resturant, this.order, this.meal});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<ScaffoldState> _keyDrawer = GlobalKey<ScaffoldState>();
  //Meal Id Attribute For Send To Meal Screen

  Future fetchPhotos() async {
    var url =
        Uri.parse('https://node-js-flutter.herokuapp.com/api/mobile/meal');
    var res = await http.get(url);
    if (res.statusCode == 200) {
      var obj = json.decode(res.body);
      return obj;
    }
  }

  Future fetchRestPhotos() async {
    var url =
        Uri.parse('https://node-js-flutter.herokuapp.com/api/mobile/Resturant');
    var res = await http.get(url);
    if (res.statusCode == 200) {
      var obj = json.decode(res.body);
      return obj;
    }
  }

  @override
  void initState() {
    super.initState();
    fetchPhotos();
    fetchRestPhotos();
    setState(() {
      widget.sIndex != null
          ? selectedinedex = widget.sIndex
          : selectedinedex = 0;

      widget.order != null ? _order = widget.order : _order = null;
      widget.meal != null ? meal_id = widget.meal : meal_id = null;
      widget.resturant != null ? restId = widget.resturant : restId = null;
    });
  }

  int meal_id;
  int restId;
  int _order;
  int selectedinedex;
  void _x1(int index) {
    setState(() {
      selectedinedex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      CheckCard(),
      LocationMap(order_id: _order, meal_id: meal_id, rest: restId)
    ];
    List<Purchases> purchist =
        Provider.of<Purchasess>(context, listen: true).purchasesList;
    return Scaffold(
      backgroundColor: Colors.grey[100],
      key: _keyDrawer,
      drawer: MyDrawer(),
      body: selectedinedex == 0
          ? SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(top: 35),
                    padding: EdgeInsets.only(left: 15.0),
                    child: Text(
                      "what would you like to eat?",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(15.0),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _keyDrawer.currentState.openDrawer();
                          },
                          child: Icon(
                            Icons.menu,
                            color: Colors.red,
                            size: 35,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 45,
                            padding: EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(25)),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Search()));
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Search",
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.black38),
                                  ),
                                  Icon(
                                    Icons.search,
                                    color: Colors.red,
                                    size: 30,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.only(top: 10, bottom: 7, left: 14),
                          child: Text(
                            "Popular Food",
                            style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                                fontSize: 25),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 280,
                          child: FutureBuilder(
                            future: fetchPhotos(),
                            builder: (ctx, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else {
                                return ListView.builder(
                                    itemCount: snapshot.data.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return SingleCard(
                                        snapshot.data[index]["m_id"],
                                        snapshot.data[index]["m_name"]
                                            .toString(),
                                        snapshot.data[index]["image"],
                                        snapshot.data[index]["price"]
                                            .toString(),
                                      );
                                    });
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 6, left: 14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Restaurant",
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 540,
                                child: FutureBuilder(
                                  future: fetchRestPhotos(),
                                  builder: (ctx, snp) {
                                    if (snp.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    } else {
                                      return ListView.builder(
                                          itemCount: snp.data.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return SingleProduct(
                                              proId: snp.data[index]['rest_id'],
                                              proImage: snp.data[index]
                                                  ['image'],
                                              proName: snp.data[index]
                                                      ['rest_name']
                                                  .toString(),
                                              proDescription: snp.data[index]
                                                      ['address']
                                                  .toString(),
                                            );
                                          });
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          : pages[selectedinedex - 1],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedinedex,
        selectedItemColor: Colors.red,
        selectedFontSize: 10,
        unselectedItemColor: Colors.grey,
        unselectedFontSize: 12,
        showSelectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant),
            title: Text("Restaurant"),
          ),
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                Icon(Icons.shopping_bag),
                purchist.isEmpty == false
                    ? Positioned(
                        right: 3,
                        child: Icon(
                          Icons.circle,
                          size: 5,
                          color: Colors.deepOrange,
                        ))
                    : Positioned(
                        right: 3,
                        child: Icon(
                          Icons.circle,
                          size: 5,
                          color: Colors.white,
                        ))
              ],
            ),
            // activeIcon: ,
            title: Text("Shopping Bag"),
          ),
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                Icon(Icons.location_on_outlined),
                _order != null
                    ? Positioned(
                        right: 3,
                        child: Icon(
                          Icons.circle,
                          size: 5,
                          color: Colors.deepOrange,
                        ))
                    : Positioned(
                        right: 3,
                        child: Icon(
                          Icons.circle,
                          size: 5,
                          color: Colors.white,
                        ))
              ],
            ),
            // activeIcon: ,
            title: Text("Map"),
          ),
        ],
        onTap: _x1,
      ),
    );
  }
}

class SingleCard extends StatelessWidget {
  final int cid;
  final String cName;
  final String cImage;
  final String cPrice;

  SingleCard(this.cid, this.cName, this.cImage, this.cPrice);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 8),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Meal(cid)));
        },
        child: Container(
          width: 237,
          child: Card(
            elevation: 6,
            color: Colors.grey[200],
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    width: 200,
                    height: 180,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.white,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: MemoryImage(
                          base64Decode(cImage),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              cName,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Text(
                                  "$cPrice S.P",
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
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
            ),
          ),
        ),
      ),
    );
  }
}

class SingleProduct extends StatelessWidget {
  final int proId;
  final String proName;
  final String proDescription;
  final String proImage;

  const SingleProduct(
      {this.proId, this.proName, this.proDescription, this.proImage});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => new ViewRestaurant(
                    rest_id: proId,
                  )),
        );
      },
      child: Container(
        height: 280,
        child: Padding(
          padding: const EdgeInsets.only(right: 13.0, bottom: 12),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            elevation: 10,
            child: Column(children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
                child: Image.memory(
                  base64Decode(
                    proImage,
                  ),
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          proName,
                          style: TextStyle(color: Colors.orange, fontSize: 25),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          proDescription,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                              fontSize: 10),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
