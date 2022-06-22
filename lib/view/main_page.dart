import 'package:firestart/providers/auth_provider.dart';
import 'package:firestart/view/create_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';




class MainPage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SampleShop'),
        backgroundColor: Colors.purple,
      ),
        body: Consumer(
            builder: (context, ref, child) {
              final authData = ref.watch(authProvider);
              return Container();
            }
    ),
      drawer: Consumer(
        builder: (context, ref, child) {
          final authData = ref.watch(authProvider);
          return Drawer(
            child: ListView(
              children: [
                DrawerHeader(child: Text(authData[0].username)),
                ListTile(
                  leading: Icon(Icons.mail),
                  title: Text(authData[0].email),
                ),
                ListTile(
                  leading: Icon(Icons.settings_rounded),
                  title: Text('customize post'),
                ),
                ListTile(
                  onTap: (){
                    Navigator.of(context).pop();
                    Get.to(() => CreatePage(), transition: Transition.leftToRight);
                  },
                  leading: Icon(Icons.add_business_rounded),
                  title: Text('create Post'),
                ),

                ListTile(
                  onTap: (){
                    Navigator.of(context).pop();
                    ref.read(authProvider.notifier).userLogOut();
                  },
                  leading: Icon(Icons.exit_to_app),
                  title: Text('logOut'),
                ),
              ],
            ),
          );
        }
      ),
    );
  }
}
