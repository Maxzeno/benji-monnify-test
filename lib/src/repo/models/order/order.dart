import 'dart:convert';

import 'package:benji_user/src/repo/models/address_model.dart';
import 'package:benji_user/src/repo/models/order/order_item.dart';
import 'package:benji_user/src/repo/utils/base_url.dart';
import 'package:benji_user/src/repo/utils/helpers.dart';
import 'package:http/http.dart' as http;

import '../user/user_model.dart';

class Order {
  final String id;
  final int totalPrice;
  final String assignedStatus;
  final String deliveryStatus;
  final User client;
  final Address deliveryAddress;
  final List<OrderItem> orderItems;
  final DateTime created;

  Order({
    required this.id,
    required this.totalPrice,
    required this.assignedStatus,
    required this.deliveryStatus,
    required this.client,
    required this.deliveryAddress,
    required this.orderItems,
    required this.created,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    List<OrderItem> orderItems = [];
    for (var item in json['orderitems']) {
      orderItems.add(OrderItem.fromJson(item));
    }

    return Order(
      id: json['id'],
      totalPrice: json['total_price'],
      assignedStatus: json['assigned_status'],
      deliveryStatus: json['delivery_status'],
      client: User.fromJson(json['client']),
      deliveryAddress: Address.fromJson(json['delivery_address']),
      orderItems: orderItems,
      created: DateTime.parse(json['created']),
    );
  }
}

Future<List<Order>> getOrders(id) async {
  final response = await http.get(
    Uri.parse('$baseURL/clients/listClientOrders/$id'),
    headers: await authHeader(),
  );

  if (response.statusCode == 200) {
    return (jsonDecode(response.body) as List)
        .map((item) => Order.fromJson(item))
        .toList();
  } else {
    throw Exception('Failed to load order');
  }
}
