import 'dart:convert';

import 'package:benji_user/src/repo/models/shop_type.dart';
import 'package:http/http.dart' as http;

import '../../utils/base_url.dart';
import '../../utils/helpers.dart';

class VendorModel {
  final int? id;
  final String? email;
  final String? phone;
  final String? username;
  final String? code;
  final bool? isOnline;
  final String? firstName;
  final String? lastName;
  final String? gender;
  final String? address;
  final String? shopName;
  final double? averageRating;
  final int? numberOfClientsReactions;
  final String? shopImage;
  final String? profileLogo;
  final ShopTypeModel? shopType;

  VendorModel({
    this.id,
    this.email,
    this.phone,
    this.username,
    this.code,
    this.isOnline = true,
    this.firstName,
    this.lastName,
    this.gender,
    this.address,
    this.shopName,
    this.averageRating,
    this.numberOfClientsReactions,
    this.shopImage,
    this.profileLogo,
    this.shopType,
  });

  factory VendorModel.fromJson(Map<String, dynamic> json) {
    return VendorModel(
      id: json['id'],
      email: json['email'],
      phone: json['phone'],
      username: json['username'],
      code: json['code'],
      isOnline: json['is_online'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      gender: json['gender'],
      address: json['address'],
      shopName: json['shop_name'],
      averageRating: json['average_rating'],
      numberOfClientsReactions: json['number_of_clients_reactions'],
      shopImage: json['shop_image'],
      profileLogo: json['profileLogo'],
      shopType: json['shop_type'] == null
          ? null
          : ShopTypeModel.fromJson(json['shop_type']),
    );
  }
}

Future<VendorModel> getVendorById(id) async {
  final response = await http.get(
    Uri.parse('$baseURL/vendors/getVendor/$id'),
    headers: await authHeader(),
  );

  if (response.statusCode == 200) {
    return VendorModel.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load vendor');
  }
}

Future<List<VendorModel>> getPopularVendors({start = 1, end = 10}) async {
  final response = await http.get(
    Uri.parse('$baseURL/clients/getPopularVendors'),
    headers: await authHeader(),
  );

  if (response.statusCode == 200) {
    return (jsonDecode(response.body) as List)
        .map((item) => VendorModel.fromJson(item))
        .toList();
  } else {
    throw Exception('Failed to load vendor');
  }
}

Future<List<VendorModel>> getVendors({start = 1, end = 10}) async {
  final response = await http.get(
    Uri.parse('$baseURL/vendors/getAllVendor?start=$start&end=$end'),
    headers: await authHeader(),
  );

  if (response.statusCode == 200) {
    return (jsonDecode(response.body)['items'] as List)
        .map((item) => VendorModel.fromJson(item))
        .toList();
  } else {
    throw Exception('Failed to load vendor');
  }
}
