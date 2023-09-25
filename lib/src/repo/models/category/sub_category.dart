import 'dart:convert';

import 'package:benji_user/src/repo/utils/base_url.dart';
import 'package:benji_user/src/repo/utils/helpers.dart';
import 'package:http/http.dart' as http;

import 'category.dart';

class SubCategory {
  final String id;
  final String name;
  final String description;
  final bool isActive;
  final Category category;

  SubCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.isActive,
    required this.category,
  });

  factory SubCategory.fromJson(Map<String, dynamic> json) {
    return SubCategory(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      isActive: json['is_active'],
      category: Category.fromJson(json['category']),
    );
  }
}

Future<List<SubCategory>> getSubCategories() async {
  final response = await http.get(Uri.parse('$baseURL/sub_categories/list'),
      headers: await authHeader());

  if (response.statusCode == 200) {
    return (jsonDecode(response.body) as List)
        .map((item) => SubCategory.fromJson(item))
        .toList();
  } else {
    throw Exception('Failed to load sub category');
  }
}
