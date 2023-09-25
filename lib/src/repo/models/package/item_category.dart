import 'dart:convert';

import 'package:benji_user/src/repo/utils/base_url.dart';
import 'package:benji_user/src/repo/utils/helpers.dart';
import 'package:http/http.dart' as http;

class ItemCategory {
  final String id;
  final String name;

  ItemCategory({
    required this.id,
    required this.name,
  });

  factory ItemCategory.fromJson(Map<String, dynamic> json) {
    return ItemCategory(
      id: json['id'],
      name: json['name'],
    );
  }
}

Future<List<ItemCategory>> getPackageCategory() async {
  final response = await http.get(
      Uri.parse('$baseURL/sendPackage/getPackageCategory/'),
      headers: await authHeader());

  if (response.statusCode == 200) {
    return (jsonDecode(response.body) as List)
        .map((item) => ItemCategory.fromJson(item))
        .toList();
  } else {
    throw Exception('Failed to load items category');
  }
}
