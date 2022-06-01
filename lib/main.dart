import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firestart/view/auth_page.dart';
import 'package:firestart/view/status_page.dart';
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
       home: StatusPage(),
    );
  }
}


class Counter extends StatelessWidget {

  int number = 0;

  StreamController<int> numStream = StreamController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: StreamBuilder<int>(
              stream: numStream.stream,
              builder: (context, snapshot) {
                if(snapshot.hasData){
                  return Text('${snapshot.data}',
                  style: TextStyle(fontSize: 50),);
                }else{
                  return Text('0', style: TextStyle(fontSize: 50),);
                }

              }
            )
        ),
      floatingActionButton: FloatingActionButton(
          onPressed: (){
           numStream.sink.add(number++);
          },
      child: Icon(Icons.add),
      ),
    );
  }
}
