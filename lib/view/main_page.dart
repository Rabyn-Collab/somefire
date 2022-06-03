import 'package:firebase_auth/firebase_auth.dart';
import 'package:firestart/providers/auth_provider.dart';
import 'package:firestart/providers/crud_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



class MainPage extends StatelessWidget {

final uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final userData = ref.watch(usersStream);
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
            body:ListView(
              children: [
                Container(
                  height: 170,
                  child: userData.when(
                      data: (data){
                        final dat = data.where((element) => element.userId != uid).toList();
                        return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: dat.length,
                            itemBuilder: (context, index){
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                      radius: 40,
                                      backgroundImage: NetworkImage(dat[index].userImageUrl),
                                    ),
                                    SizedBox(height: 10,),
                                    Text(dat[index].username)
                                  ],
                                ),
                              );
                            });
                      },
                      error: (err, stack) => Text('$err'),
                      loading: () =>CircularProgressIndicator()
                  ),
                )

              ],
            )
        );
      }
    );
  }
}
