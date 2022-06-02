import 'package:firestart/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.purple,
              title: Text('Fire App'),
              actions: [
                TextButton(
                    onPressed: () {
                   ref.read(authProvider).userLogOut();
                    },
                    child: Text(
                      'Log Out', style: TextStyle(color: Colors.white),))
              ],
            ),
            body: Container());
      }
    );
  }
}
