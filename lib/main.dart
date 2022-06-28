import 'package:firestart/models/cart_item.dart';
import 'package:firestart/models/user.dart';
import 'package:firestart/view/status_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';

final boxProvider = Provider<List<User>>((ref) => []);
final boxCart = Provider<List<CartItem>>((ref) => []);

void main () async{
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(CartItemAdapter());
  final userBox = await Hive.openBox<User>('users');
  final cartBox = await Hive.openBox<CartItem>('carts');
  runApp(ProviderScope(
      overrides: [
        boxProvider.overrideWithValue(userBox.values.toList().cast<User>()),
        boxCart.overrideWithValue(cartBox.values.toList().cast<CartItem>())
        ],
      child: Home()));
}


class Home extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        home: StatusPage()
    );
  }
}
