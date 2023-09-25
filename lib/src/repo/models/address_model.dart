import 'dart:convert';

import 'package:benji_user/src/repo/models/user/user_model.dart';
import 'package:http/http.dart' as http;

import '../utils/base_url.dart';
import '../utils/helpers.dart';

class Address {
  final String? id;
  final String? streetAddress;
  final int? user;
  final String? title;
  final String? details;
  final String? recipientName;
  final String? phone;
  final String? country;
  final String? state;
  final String? city;
  final bool? isCurrent;

  Address({
    this.id,
    this.streetAddress,
    this.user,
    this.title,
    this.details,
    this.recipientName,
    this.phone,
    this.country,
    this.state,
    this.city,
    this.isCurrent,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'],
      streetAddress: json['street_address'],
      user: json['user'],
      title: json['title'],
      details: json['details'],
      recipientName: json['recipient_name'],
      phone: json['phone'],
      country: json['country'],
      state: json['state'],
      city: json['city'],
      isCurrent: json['is_current'],
    );
  }
}

Future<List<Address>> getAddressesByUser() async {
  int? userId = (await getUser() as User).id;

  final response = await http.get(
    Uri.parse('$baseURL/clients/listMyAddresses?user_id=$userId'),
    headers: await authHeader(),
  );

  if (response.statusCode == 200) {
    return (jsonDecode(response.body) as List)
        .map((item) => Address.fromJson(item))
        .toList();
  } else {
    throw Exception('Failed to load user address');
  }
}

Future<Address> getCurrentAddress() async {
  int? userId = (await getUser())!.id;

  final response = await http.get(
    Uri.parse('$baseURL/clients/getCurrentAddress/$userId'),
    headers: await authHeader(),
  );

  if (response.statusCode == 200) {
    return Address.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to get user address');
  }
}

Future<Address> setCurrentAddress(
  String addressId,
) async {
  int? userId = (await getUser())!.id;

  final response = await http.put(
    Uri.parse('$baseURL/clients/setCurrentAddress/$addressId?user_id=$userId'),
    headers: await authHeader(),
  );

  if (response.statusCode == 200) {
    return Address.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to set address');
  }
}

Future<bool> deleteAddress(
  String addressId,
) async {
  final response = await http.delete(
    Uri.parse('$baseURL/address/deleteAddress/$addressId'),
    headers: await authHeader(),
  );

  if (response.statusCode == 200) {
    return response.body == "Address deleted successfully";
  } else {
    throw Exception('Failed to delete address');
  }
}
