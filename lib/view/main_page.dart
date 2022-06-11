import 'package:firebase_auth/firebase_auth.dart';
import 'package:firestart/models/user.dart';
import 'package:firestart/providers/auth_provider.dart';
import 'package:firestart/providers/crud_provider.dart';
import 'package:firestart/view/detail_page.dart';
import 'package:firestart/view/edit_page.dart';
import 'package:firestart/widgets/drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

class MainPage extends StatelessWidget {
  final uid = FirebaseAuth.instance.currentUser!.uid;
late UserData user;
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final userData = ref.watch(usersStream);
      final postData = ref.watch(postStream);
      print(postData);
      return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.purple,
            title: Text('Fire App'),
          ),
          drawer: DrawerWidget(),
          body: ListView(
            children: [
              Container(
                height: 170,
                child: userData.when(
                    data: (data) {
                      user = data.firstWhere((element) => element.userId == uid);
                      final dat = data
                          .where((element) => element.userId != uid)
                          .toList();
                      return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: dat.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    radius: 40,
                                    backgroundImage:
                                        NetworkImage(dat[index].userImageUrl),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(dat[index].username)
                                ],
                              ),
                            );
                          });
                    },
                    error: (err, stack) => Text('$err'),
                    loading: () => Center()),
              ),
              Container(
                height: 612,
                child: postData.when(
                    data: (data) {
                      print(data);
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            final dat = data[index];
                            return Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(dat.title),
                                    if (uid == dat.userId)
                                      IconButton(
                                          onPressed: () {
                                            Get.defaultDialog(
                                                title: 'customize post',
                                                content:
                                                    Text('edit or remove post'),
                                                actions: [
                                                  IconButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                        Get.to(
                                                            () => EditPage(dat),
                                                            transition: Transition
                                                                .leftToRight);
                                                      },
                                                      icon: Icon(Icons.edit)),
                                                  IconButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                        Get.defaultDialog(
                                                          title: 'Are you sure',
                                                          content: Text('you want to remove this post'),
                                                          actions: [
                                                            TextButton(onPressed: ()async{
                                                              await ref.read(crudProvider).removeData(
                                                                  postId: dat.id, photoId: dat.imageId);
                                                              Navigator.of(context)
                                                                  .pop();
                                                            }, child: Text('yes')),
                                                            TextButton(onPressed: (){
                                                              Navigator.of(context)
                                                                  .pop();
                                                            }, child: Text('no')),
                                                          ]
                                                        );
                                                      },
                                                      icon: Icon(Icons.delete))
                                                ]);
                                          },
                                          icon: Icon(Icons.more_horiz))
                                  ],
                                ),
                                if (uid != dat.userId)
                                  SizedBox(
                                    height: 10,
                                  ),
                                InkWell(
                                  onTap: (){
                                    Get.to(() => DetailPage(dat, user), transition: Transition.leftToRight);
                                  },
                                  child: Container(
                                      height: 300,
                                      child: Image.network(dat.imageUrl)),
                                ),
                                if (uid == dat.userId)
                                  SizedBox(
                                    height: 15,
                                  ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(dat.description),
                                    if (uid != dat.userId)
                                      Row(
                                        children: [
                                          IconButton(
                                              onPressed: () {
                                               if(dat.like.usernames.contains(user.username)){
                                                 ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                     duration: Duration(seconds: 1),
                                                     content: Text('You\'ve already like this post')));
                                               }else{
                                                 ref.read(crudProvider).addLike(
                                                     postId: dat.id, like: dat.like.likes, username: user.username);
                                               }

                                              },
                                              icon: Icon(Icons.thumb_up)),
                                          if(dat.like.likes !=0) Text(dat.like.likes.toString(), style: TextStyle(fontSize: 20),)
                                        ],
                                      )
                                  ],
                                ),
                              ],
                            );
                          });
                    },
                    error: (err, stack) => Container(
                          child: Text('$err'),
                        ),
                    loading: () => Center(
                          child: CircularProgressIndicator(
                            color: Colors.purple,
                          ),
                        )),
              )
            ],
          ));
    });
  }
}
