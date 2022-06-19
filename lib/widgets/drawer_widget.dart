import 'package:firestart/providers/auth_provider.dart';
import 'package:firestart/providers/crud_provider.dart';
import 'package:firestart/providers/loginProvider.dart';
import 'package:firestart/view/create_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final isLoad = ref.watch(loadingProvider);
        return Drawer(
            child: ListView(children: [
          DrawerHeader(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [],
          )),
          ListTile(
            onTap: () {
              Navigator.of(context).pop();
              Get.to(() => CreatePage(), transition: Transition.leftToRight);
            },
            leading: Icon(Icons.add_box_sharp),
            title: Text('post create'),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pop();
            },
            leading: Icon(Icons.exit_to_app),
            title: Text('user LogOut'),
          ),
        ]));
      },
    );
  }
}
