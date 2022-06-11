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



class Profile extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple,
          actions: [
            TextButton(onPressed: (){
              showModalBottomSheet(
                  elevation: 7,
                  isDismissible: true,
                  isScrollControlled: false,
                  context: context, builder: (context) {
                return BottomSHow();
              }
              );
            }, child: Text('show botom'))
          ],
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              DrawerHeader(child: Image.network('https://images.unsplash.com/photo-1500917293891-ef795e70e1f6?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8bW9kZWxzfGVufDB8MHwwfHw%3D&auto=format&fit=crop&w=500&q=60')),
              ListTile(
                onTap: (){
                  showModalBottomSheet(
                    elevation: 7,
                      isDismissible: true,
                      isScrollControlled: false,
                      context: context, builder: (context) {
                      return BottomSHow();
                  }
                  );

                },
                leading: Icon(Icons.ac_unit),
                title: Text(';lsdkf;lsdkf'),
                trailing: Icon(Icons.arrow_back),

              ),
            ],
          ),
        ),
        body: Container());
  }
}



class BottomSHow extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
    height: 500,
    child: Image.network('https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTB8fG1vZGVsc3xlbnwwfDB8MHx8&auto=format&fit=crop&w=500&q=60'));
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
