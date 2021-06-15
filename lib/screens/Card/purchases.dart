import 'package:flutter/material.dart';

class Purchases {
  final int m_id;
  final String name;
  final String image;
  final int count;
  final double price;

  Purchases({
    @required this.m_id,
    @required this.name,
    @required this.image,
    @required this.count,
    @required this.price,
  });
}

class Purchasess with ChangeNotifier {
  List<Purchases> purchasesList = [];

  void add({int m_id, String name, String image, int count, double price}) {
    purchasesList.add(Purchases(
        m_id: m_id, name: name, image: image, count: count, price: price));
    notifyListeners();
  }

  void delete(String name) {
    purchasesList.removeWhere((element) => element.name == name);
    notifyListeners();
    print("Item Deleted");
  }
}
