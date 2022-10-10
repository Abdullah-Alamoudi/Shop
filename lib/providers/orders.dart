import 'package:flutter/material.dart';
import 'package:shop/providers/cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  String authToken;
  String userId;

  gerData(String auToken, String uId, List<OrderItem> orders) {
    authToken = auToken;
    userId = uId;
    _orders = orders;
    notifyListeners();
  }

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetechAndSetProducts() async {
    //final url='https://shop-8a230-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken';
    final url =
        'https://shop-8a230-default-rtdb.firebaseio.com/orders/$userId.json'; // userid for fetech order user just.

    try {
      final res = await http.get(url);
      final extractedData = json.decode(res.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      final List<OrderItem> loadedOrders = [];
      extractedData.forEach((orderId, orderData) {
        loadedOrders.add(OrderItem(
          id: orderId,
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          products: (orderData['products'] as List<dynamic>)
              .map((item) => CartItem(
                    id: item['id'],
                    title: item['title'],
                    quntity: item['quntity'],
                    price: item['price'],
                  ))
              .toList(),
        ));
      });
      _orders = loadedOrders.reversed.toList();
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> addOrder(List<CartItem> cartproduct, double total) async {
    // final url='https://shop-8a230-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken';
    final url =
        'https://shop-8a230-default-rtdb.firebaseio.com/orders/$userId.json';

    try {
      final timestamp = DateTime.now();
      final res = await http.post(url,
          body: json.encode({
            'amount': total,
            'dateTime': timestamp.toIso8601String(),
            'products': cartproduct.map((np) => {
                  'id': np.id,
                  'title': np.title,
                  'quntity': np.quntity,
                  'price': np.price
                })
          }));
      _orders.insert(
          0,
          OrderItem(
            id: json.decode(res.body)['name'],
            amount: total,
            products: cartproduct,
            dateTime: timestamp,
          ));
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }
}
