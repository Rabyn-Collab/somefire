import 'package:firestart/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';




class MainPage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Consumer(
            builder: (context, ref, child) {
              final authData = ref.watch(authProvider);
              return Container();
            }
    )
    );
  }
}
