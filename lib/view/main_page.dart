import 'package:firebase_auth/firebase_auth.dart';
import 'package:firestart/providers/auth_provider.dart';
import 'package:firestart/providers/crud_provider.dart';
import 'package:firestart/widgets/drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



class MainPage extends StatelessWidget {

final uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final userData = ref.watch(usersStream);
        final postData = ref.watch(postStream);
        return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.purple,
              title: Text('Fire App'),
            ),
            drawer: DrawerWidget(),
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
                      loading: () =>Center(child: CircularProgressIndicator())
                  ),
                ),
                Container(
                  child: postData.when(
                      data: (data){
                        return Expanded(child: ListView.builder(
                          shrinkWrap: true,
                            itemCount: data.length,
                            itemBuilder: (context, index){
                              final dat = data[index];
                              return Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                    Text(dat.title),
                                      if(uid == dat.userId)  IconButton(onPressed: (){}, icon: Icon(Icons.more_horiz))
                                    ],
                                  ),
                                  if(uid != dat.userId)   SizedBox(height: 10,),
                                  Container(
                                      height: 300,
                                      child: Image.network(dat.imageUrl)),
                                  if(uid == dat.userId) SizedBox(height: 15,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(dat.description),
                                    if(uid != dat.userId)  IconButton(onPressed: (){}, icon: Icon(Icons.thumb_up))
                                    ],
                                  ),
                                ],
                              );
                            }
                        ));
                      },
                      error: (err, stack) => Container(child: Text('$err'),),
                      loading: () => Center(child: CircularProgressIndicator(
                        color: Colors.purple,
                      ),)
                  ),
                )

              ],
            )
        );
      }
    );
  }
}
