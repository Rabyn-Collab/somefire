import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firestart/view/auth_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';



void main () async {
WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp();
runApp(ProviderScope(child: Home()));

}


class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
       home: Counter(),
    );
  }
}


class Counter extends StatelessWidget {

  int number = 0;

  StreamController numStream = StreamController<int>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container()
    );
  }
}
