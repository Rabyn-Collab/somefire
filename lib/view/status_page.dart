import 'package:firestart/providers/auth_provider.dart';
import 'package:firestart/view/auth_page.dart';
import 'package:firestart/view/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



class StatusPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Consumer(
            builder: (context, ref, child) {
              final authData = ref.watch(authStream);
              return authData.when(
                  data: (data){
                    if(data == null){
                      return AuthPage();
                    }else{
                      return MainPage();
                    }

                  },
                  error: (err, stack) => Center(child: Text('$err')),
                  loading: () => Center(child: CircularProgressIndicator(),)
              );
            }
    )
    );
  }
}


