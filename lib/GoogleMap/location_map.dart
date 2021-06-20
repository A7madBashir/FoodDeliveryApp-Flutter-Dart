import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_login_signup/screens/Card/orderProvider.dart';
import 'package:flutter_login_signup/screens/Card/purchases.dart';
import 'package:flutter_login_signup/screens/homepage/HomePage.dart';
import 'package:flutter_restart/flutter_restart.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'location_provider.dart';
// import 'package:google_map_polyline/google_map_polyline.dart';

class LocationMap extends StatefulWidget {
  int order_id;
  int rest;
  int meal_id;
  LocationMap({this.order_id, this.rest, this.meal_id});
  @override
  _LocationMapState createState() => _LocationMapState();
}

class _LocationMapState extends State<LocationMap> {
  @override
  void initState() {
    connectToServer();
    super.initState();
    widget.rest != null ? resturant_id = widget.rest : resturant_id = null;
    Provider.of<LocationProvider>(context, listen: false).initialization();
    print("Room Id ${widget.order_id}");
    if (widget.order_id != null) {
      order_id = widget.order_id;
      join(order_id);
    } else {
      order_id = null;
    }
    online();
    sendResturant();
  }

  int resturant_id;
  int order_id;
  double deliveryLati = 0;
  double deliveryLong = 0;
  bool haveDelivery = false;
//Socket Section
  Socket socket;

  connectToServer() {
    try {
      // Configure socket transports must be sepecified
      socket = io('https://node-js-flutter.herokuapp.com', <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
      });

      // Handle socket events
      // socket.on('connect', (_) {});
      socket.on('get-location', (data) async {
        print("Getting Delivery Location :$data");
        if (mounted) {
          haveDelivery = true;
          setState(() {
            if (data != null) {
              deliveryLati = data["latitude"];
              deliveryLong = data["longitude"];
              print("Delivery Location Position $deliveryLati,$deliveryLong");
            }
          });
        } else {
          return;
        }
      });
      socket.on('disconnect', (_) => disconnect);
      // print("Disconnecting");
    } catch (e) {
      print("It didnot work?!");
      print(e.toString());
    }
    socket.connect();
  }

  join(room) {
    //after get last order id from database send this id to socket to join customer room
    if (room != null) {
      print("Joining Private Room");
      socket.emit('order-room', room);
    }
  }

  online() {
    //till the delivery that there is an order waiting you!!!
    //it's should send room id
    if (widget.order_id != null && haveDelivery == false) {
      print("Getting The Delivery...");
      socket.emit('get-delivery', widget.order_id);
    }
  }

  sendLocation(var lati, var long, var room, var name) {
    socket.emit('location',
        {"latitude": lati, "longitude": long, "room": room, "name": name});
  }

  leave(room) {
    socket.emit('leave-room', room);
  }

  sendResturant() async {
    print("Resturant Id => $resturant_id");
    if (resturant_id != null)
      Future.delayed(Duration(seconds: 7), () {
        socket.emit('resturant-id',
            {"resturantid": resturant_id, "room": widget.order_id});
      });
  }

  disconnect() {
    print("Disconnecting");
    socket.disconnect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.order_id != null
          ? googleMapUI()
          : Center(
              child: Text(
                "You haven't order yet!",
                style: TextStyle(fontSize: 25),
              ),
            ),
    );
  }

  //Warning Dialog For
  showAlertDialog(BuildContext context) {
    List<Purchases> purchist =
        Provider.of<Purchasess>(context, listen: false).purchasesList;
    List<Order> orderlist =
        Provider.of<Orders>(context, listen: false).orderList;
    // set up the buttons
    Widget noButton = FlatButton(
      child: Text("No"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget yesButton = FlatButton(
      child: Text("Yes"),
      onPressed: () async {
        setState(() {
          try {
            leave(widget.order_id);
          } catch (e) {
            print("Wrong");
          }
          disconnect();

          Provider.of<Orders>(context, listen: false)
              .deleteorder(widget.order_id);
          purchist.removeWhere((element) => element.m_id == widget.meal_id);
          widget.order_id = null;
          widget.rest = null;
          resturant_id = null;
          haveDelivery = false;
        });
        // Navigator.pushReplacement(
        //     context, MaterialPageRoute(builder: (context) => HomePage()));
        Navigator.pop(context);
        await Navigator.pushReplacement(
            context,
            new MaterialPageRoute(
                builder: (_) => HomePage(
                      meal: null,
                      order: null,
                      resturant: null,
                      sIndex: 0,
                    )));
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Check Received!"),
      content: Text("Are You Sure You received the Order?"),
      actions: [
        noButton,
        yesButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget googleMapUI() {
    //Send All need Data To Server

    return Consumer<LocationProvider>(builder: (consumerContext, model, child) {
      if (model.locationPosition != null) {
        sendResturant();
        online();
        sendLocation(model.locationPosition.latitude,
            model.locationPosition.longitude, order_id, "Customer");
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: GoogleMap(
                mapType: MapType.normal,
                polylines: haveDelivery == true
                    ? model.polyLine(deliveryLati, deliveryLong)
                    : null,
                initialCameraPosition: CameraPosition(
                  target: model.locationPosition,
                  zoom: 18,
                ),
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                markers: Set<Marker>.of(model.markers.values),
                onMapCreated: (GoogleMapController controller) async {
                  Provider.of<LocationProvider>(context, listen: false)
                      .setMapController(controller);
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Meal Delivered?",
                  style: TextStyle(fontSize: 15, color: Colors.green[300]),
                ),
                IconButton(
                    onPressed: () {
                      //Before Activate the event should make alert dialog yes/no to sure if really delivered
                      // model.disconnect();
                      // model.leave(room);
                      showAlertDialog(context);
                    },
                    icon: Icon(
                      Icons.done,
                      size: 28,
                      color: Colors.redAccent[700],
                    )),
              ],
            )
          ],
        );
      }

      return Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    });
  }
}
