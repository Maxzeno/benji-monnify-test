import 'dart:convert';

import 'package:benji_user/src/repo/models/product/product.dart';
import 'package:benji_user/src/repo/models/vendor/vendor.dart';
import 'package:shared_preferences/shared_preferences.dart';

String instanceNameProduct = 'favoriteProduct';
String instanceNameVendor = 'favoriteVendors';

//============================ PRODUCT ================================//

Future<bool> favoriteItP(String id) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Map products = jsonDecode(prefs.getString(instanceNameProduct) ?? '{}');

  bool? res;
  bool val = products[id] == null || products[id] == false;
  if (val) {
    products[id] = val;
    res = true;
  } else {
    if (products[id] != null) {
      products.remove(id);
    }
    res = false;
  }

  bool isSet = await prefs.setString(instanceNameProduct, jsonEncode(products));
  if (isSet == false) {
    throw Exception('Error occured while tring to set favorite');
  }

  return res;
}

Future<Map> getFavoriteP() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Map products = jsonDecode(prefs.getString(instanceNameProduct) ?? '{}');
  return products;
}

Future<bool> getFavoritePSingle(String id) async {
  Map products = await getFavoriteP();

  return products[id] ?? false;
}

Future<List<Product>> getFavoriteProduct([Function(String)? whenError]) async {
  List<Product> res = [];
  Map favorities = await getFavoriteP();
  for (String item in favorities.keys) {
    try {
      res.add(await getProductById(item));
    } catch (e) {
      if (whenError != null) {
        whenError(item);
      }
    }
  }
  return res;
}

//================================ VENDOR =========================//
Future<bool> favoriteItV(String id) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Map vendors = jsonDecode(prefs.getString(instanceNameVendor) ?? '{}');

  bool? res;
  bool val = vendors[id] == null || vendors[id] == false;
  if (val) {
    vendors[id] = val;
    res = true;
  } else {
    if (vendors[id] != null) {
      vendors.remove(id);
    }
    res = false;
  }

  bool isSet = await prefs.setString(instanceNameVendor, jsonEncode(vendors));
  if (isSet == false) {
    throw Exception('Error occured while tring to set favorite');
  }

  return res;
}

Future<Map> getFavoriteV() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Map vendors = jsonDecode(prefs.getString(instanceNameVendor) ?? '{}');
  return vendors;
}

Future<bool> getFavoriteVSingle(String id) async {
  Map vendors = await getFavoriteV();

  return vendors[id] ?? false;
}

Future<List<VendorModel>> getFavoriteVendor(
    [Function(String)? whenError]) async {
  List<VendorModel> res = [];
  Map favorities = await getFavoriteV();
  for (String item in favorities.keys) {
    try {
      res.add(await getVendorById(item));
    } catch (e) {
      if (whenError != null) {
        whenError(item);
      }
    }
  }
  return res;
}
