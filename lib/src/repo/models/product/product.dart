import 'dart:convert';

import 'package:benji_user/src/repo/models/category/sub_category.dart';
import 'package:http/http.dart' as http;

import '../../utils/base_url.dart';
import '../../utils/helpers.dart';
import '../vendor/vendor.dart';

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final int quantityAvailable;
  final String? productImage;
  final bool isAvailable;
  final bool isTrending;
  final bool isRecommended;
  final VendorModel vendorId;
  final SubCategory subCategoryId;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.quantityAvailable,
    required this.productImage,
    required this.isAvailable,
    required this.isTrending,
    required this.isRecommended,
    required this.vendorId,
    required this.subCategoryId,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      quantityAvailable: json['quantity_available'],
      productImage: json['product_image'],
      isAvailable: json['is_available'],
      isTrending: json['is_trending'],
      isRecommended: json['is_recommended'],
      vendorId: VendorModel.fromJson(json['vendor']),
      subCategoryId: SubCategory.fromJson(json['sub_category']),
    );
  }
}

Future<Map<String, List<Product>>> getVendorProductsAndSubCategoryName(
    vendorId) async {
  final response = await http.get(
    Uri.parse(
        '$baseURL/clients/sortVendorsAvailableProductsBySubCategory/$vendorId'),
    headers: await authHeader(),
  );
  if (response.statusCode == 200) {
    Map jsonObject = jsonDecode(response.body);
    return jsonObject.map(
      (key, value) {
        return MapEntry(key,
            (value as List).map((item) => Product.fromJson(item)).toList());
      },
    );
  } else {
    throw Exception('Failed to load user product');
  }
}

Future<Product> getProductById(String id) async {
  final response = await http.get(
    Uri.parse('$baseURL/products/product/$id'),
    headers: await authHeader(),
  );

  if (response.statusCode == 200) {
    return Product.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load user product');
  }
}

Future<List<Product>> getProducts({limit = 10}) async {
  final response = await http.get(
    Uri.parse('$baseURL/products/listProduct'),
    headers: await authHeader(),
  );

  if (response.statusCode == 200) {
    return (jsonDecode(response.body) as List)
        .map((item) => Product.fromJson(item))
        .toList();
  } else {
    throw Exception('Failed to load user product');
  }
}

Future<List<Product>> getProductsBySubCategory(subCategoryId) async {
  final response = await http.get(
    Uri.parse(
        '$baseURL/clients/filterProductsBySubCategory/$subCategoryId'),
    headers: await authHeader(),
  );

  if (response.statusCode == 200) {
    return (jsonDecode(response.body) as List)
        .map((item) => Product.fromJson(item))
        .toList();
  } else {
    throw Exception('Failed to load user product');
  }
}

Future<List<Product>> getProductsByVendorSubCategory(
    vendorId, subCategoryId) async {
  final response = await http.get(
    Uri.parse(
        '$baseURL/clients/filterVendorsProductsBySubCategory/$vendorId/$subCategoryId'),
    headers: await authHeader(),
  );

  if (response.statusCode == 200 && response.body != '"No matching query"') {
    return (jsonDecode(response.body) as List)
        .map((item) => Product.fromJson(item))
        .toList();
  } else if (response.body == '"No matching query"') {
    return [];
  } else {
    throw Exception('Failed to load user product');
  }
}

Future<List<Product>> getProductsByVendor(vendorId,
    {start = 0, end = 10}) async {
  final response = await http.get(
    Uri.parse(
        '$baseURL/vendors/$vendorId/listMyProducts?start=$start&end=$end'),
    headers: await authHeader(),
  );

  if (response.statusCode == 200) {
    return (jsonDecode(response.body)["items"] as List)
        .map((item) => Product.fromJson(item))
        .toList();
  } else {
    throw Exception('Failed to load user product');
  }
}

Future<List<Product>> getProductsBySearching(query) async {
  final response = await http.get(
    Uri.parse('$baseURL/clients/searchProducts?query=$query'),
    headers: await authHeader(),
  );

  if (response.statusCode == 200 && response.body != '"No matching query"') {
    return (jsonDecode(response.body) as List)
        .map((item) => Product.fromJson(item))
        .toList();
  } else if (response.body == '"No matching query"') {
    return [];
  } else {
    throw Exception('Failed to load user product');
  }
}
