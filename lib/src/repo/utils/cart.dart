import 'package:benji_user/src/repo/models/product/product.dart';
import 'package:benji_user/src/repo/utils/help_instance.dart';

String cartName = 'cart';

Future<String> addToCart(String id, {int qty = 1}) async {
  return await addToInstance(cartName, id, qty: 1);
}

Future<String> removeFromCart(String id, {bool removeAll = false}) async {
  return await removeFromInstance(cartName, id, removeAll: removeAll);
}

Future<Map<String, dynamic>> getCart() async {
  return await getInstance(cartName);
}

Future<List<Product>> getCartProduct([Function(String)? whenError]) async {
  return await getInstanceProduct(cartName, whenError);
}

Future<String> countCart({all = false}) async {
  return await countInstance(cartName, all: all);
}

Future<int> countItemCart() async {
  return await countItemInstance(cartName);
}

Future<String> countSingleCart(String id) async {
  return await countSingleInstance(cartName, id);
}
