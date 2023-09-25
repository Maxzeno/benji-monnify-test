import 'dart:convert';

import 'package:benji_user/src/repo/models/user/user_model.dart';
import 'package:benji_user/src/repo/models/vendor/vendor.dart';
import 'package:http/http.dart' as http;

import '../../utils/base_url.dart';
import '../../utils/helpers.dart';

class Ratings {
  final String? id;
  final double? ratingValue;
  final String? comment;
  final DateTime? created;
  final User client;
  final VendorModel? vendor;

  Ratings({
    this.id,
    this.ratingValue,
    this.comment,
    this.created,
    required this.client,
    required this.vendor,
  });

  factory Ratings.fromJson(Map<String, dynamic> json) {
    return Ratings(
      id: json['id'],
      ratingValue: json['rating_value'],
      comment: json['comment'],
      created: DateTime.parse(json['created']),
      client: User.fromJson(json['client']),
      vendor:
          json['vendor'] == null ? null : VendorModel.fromJson(json['vendor']),
    );
  }
}

Future<List<Ratings>> getRatingsByVendorId(int id,
    {start = 0, end = 20}) async {
  final response = await http.get(
    Uri.parse(
        '$baseURL/vendors/$id/getAllVendorRatings?start=$start&end=$end'),
    headers: await authHeader(),
  );

  if (response.statusCode == 200) {
    return (jsonDecode(response.body)['items'] as List)
        .map((item) => Ratings.fromJson(item))
        .toList()
        .reversed
        .toList();
  } else {
    throw Exception('Failed to load ratings');
  }
}

Future<List<Ratings>> getRatingsByVendorIdAndRating(int id, int rating,
    {start = 0, end = 20}) async {
  final response = await http.get(
    Uri.parse(
        '$baseURL/clients/filterVendorReviewsByRating/$id?rating_value=$rating'),
    headers: await authHeader(),
  );

  if (response.statusCode == 200) {
    return (jsonDecode(response.body) as List)
        .map((item) => Ratings.fromJson(item))
        .toList()
        .reversed
        .toList();
  } else {
    throw Exception('Failed to load ratings');
  }
}

Future<List<Ratings>> getRatingsByProductId(String id,
    {start = 0, end = 20}) async {
  final response = await http.get(
    Uri.parse('$baseURL/clients/listAllProductRatings/$id'),
    headers: await authHeader(),
  );
  if (response.statusCode == 200) {
    return (jsonDecode(response.body) as List)
        .map((item) => Ratings.fromJson(item))
        .toList()
        .reversed
        .toList();
  } else {
    throw Exception('Failed to load ratings');
  }
}

Future<List<Ratings>> getRatingsByProductIdAndRating(String id, int rating,
    {start = 0, end = 20}) async {
  final response = await http.get(
    Uri.parse(
        '$baseURL/clients/filterProductReviewsByRating/$id?rating_value=$rating'),
    headers: await authHeader(),
  );

  if (response.statusCode == 200) {
    return (jsonDecode(response.body) as List)
        .map((item) => Ratings.fromJson(item))
        .toList()
        .reversed
        .toList();
  } else {
    throw Exception('Failed to load ratings');
  }
}
