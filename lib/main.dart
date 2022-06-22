import 'package:firestart/models/user.dart';
import 'package:firestart/view/status_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';

final boxProvider = Provider<List<User>>((ref) => []);

void main () async{
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  final userBox = await Hive.openBox<User>('users');
  runApp(ProviderScope(
      overrides: [
        boxProvider.overrideWithValue(userBox.values.toList().cast<User>()),
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
