import 'dart:convert';

import 'package:benji_user/src/repo/models/product/product.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<String> addToInstance(String instanceName, String id,
    {int qty = 1}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Map instance = jsonDecode(prefs.getString(instanceName) ?? '{}');

  if (instance[id] != null) {
    instance[id] += qty;
    await prefs.setString(instanceName, jsonEncode(instance));
    return await countInstance(instanceName, all: true);
  }
  instance[id] = qty;
  await prefs.setString(instanceName, jsonEncode(instance));
  return await countInstance(instanceName, all: true);
}

Future<String> removeFromInstance(String instanceName, String id,
    {bool removeAll = false}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  Map instance = jsonDecode(prefs.getString(instanceName) ?? '{}');
  if (instance[id] != null) {
    if (instance[id] == 1 || removeAll) {
      instance.remove(id);
      await prefs.setString(instanceName, jsonEncode(instance));
      return await countInstance(instanceName, all: true);
    }
    instance[id] -= 1;

    await prefs.setString(instanceName, jsonEncode(instance));
    return await countInstance(instanceName, all: true);
  }
  return await countInstance(instanceName, all: true);
}

Future<Map<String, dynamic>> getInstance(
  String instanceName,
) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? instance = prefs.getString(instanceName);
  if (instance == null) {
    return {};
  }
  return jsonDecode(instance);
}

Future<List<Product>> getInstanceProduct(String instanceName,
    [Function(String)? whenError]) async {
  List<Product> res = [];
  Map instance = await getInstance(instanceName);
  for (String item in instance.keys) {
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

Future<String> countInstance(String instanceName, {all = false}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Map instance = jsonDecode(prefs.getString(instanceName) ?? '{}');
  int total = 0;
  for (int num in instance.values) {
    total = total + num;
  }
  if (all) {
    return total.toString();
  }
  return total <= 10 ? total.toString() : '10+';
}

Future<int> countItemInstance(String instanceName) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Map instance = jsonDecode(prefs.getString(instanceName) ?? '{}');

  return instance.length;
}

Future<String> countSingleInstance(String instanceName, String id) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Map instance = jsonDecode(prefs.getString(instanceName) ?? '{}');
  int? total = instance[id];

  return (total ?? 0).toString();
}
