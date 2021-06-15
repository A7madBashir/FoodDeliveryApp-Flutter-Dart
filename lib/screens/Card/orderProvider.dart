import 'package:flutter/material.dart';

class Order {
  final int or_id;

  Order({
    @required this.or_id,
  });
}

class Orders with ChangeNotifier {
  List<Order> orderList = [];

  void add({int or_id}) {
    orderList.add(Order(or_id: or_id));
    notifyListeners();
  }

  void deleteorder(int order_id) {
    orderList.removeWhere((element) => element.or_id == order_id);
    notifyListeners();
    print("Item Deleted");
  }
}
