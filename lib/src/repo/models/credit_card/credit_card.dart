import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../utils/base_url.dart';
import '../../utils/helpers.dart';
import '../user/user_model.dart';

class CreditCard {
  String id;
  String cardName;
  String cardNumber;
  String? cvv;
  String? expiryMonth;
  String expiryYear;
  String created;
  User client;

  CreditCard({
    required this.id,
    required this.cardName,
    required this.cardNumber,
    this.cvv,
    this.expiryMonth,
    required this.expiryYear,
    required this.created,
    required this.client,
  });

  factory CreditCard.fromJson(Map<String, dynamic> json) {
    return CreditCard(
      id: json['id'],
      cardName: json['card_name'],
      cardNumber: json['card_number'],
      cvv: json['cvv'],
      expiryMonth: json['expiry_month'],
      expiryYear: json['expiry_year'],
      created: json['created'],
      client: User.fromJson(json['client']),
    );
  }
}

Future<CreditCard> createCreditCard(clientId, Map body) async {
  final response = await http.post(
      Uri.parse('$baseURL/clients/saveUserCard/$clientId'),
      body: body,
      headers: await authHeader());

  if (response.statusCode == 200) {
    return CreditCard.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to add credit card');
  }
}

Future<List<CreditCard>> getCardDataByUser() async {
  int? userId = (await getUser() as User).id;

  final response = await http.get(
    Uri.parse('$baseURL/clients/getClientSavedCards/$userId'),
    headers: await authHeader(),
  );

  if (response.statusCode == 200) {
    return (jsonDecode(response.body) as List)
        .map((item) => CreditCard.fromJson(item))
        .toList();
  } else {
    throw Exception('Failed to get credit cards');
  }
}
