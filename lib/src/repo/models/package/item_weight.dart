import 'dart:convert';

import 'package:benji_user/src/repo/utils/base_url.dart';
import 'package:benji_user/src/repo/utils/helpers.dart';
import 'package:http/http.dart' as http;

class ItemWeight {
  final String id;
  final int start;
  final int end;
  final String title;

  ItemWeight({
    required this.id,
    required this.start,
    required this.end,
    required this.title,
  });

  factory ItemWeight.fromJson(Map<String, dynamic> json) {
    return ItemWeight(
      id: json['id'],
      start: json['start'],
      end: json['end'],
      title: json['title'],
    );
  }
}

Future<List<ItemWeight>> getPackageWeight() async {
  final response = await http.get(
      Uri.parse('$baseURL/sendPackage/getPackageWeight/'),
      headers: await authHeader());

  if (response.statusCode == 200) {
    return (jsonDecode(response.body) as List)
        .map((item) => ItemWeight.fromJson(item))
        .toList();
  } else {
    throw Exception('Failed to load items weight');
  }
}
