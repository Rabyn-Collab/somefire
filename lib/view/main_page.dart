import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firestart/notification_service.dart';
import 'package:firestart/providers/crud_provider.dart';
import 'package:firestart/view/detail_page.dart';
import 'package:firestart/view/edit_page.dart';
import 'package:firestart/view/recent_chats.dart';
import 'package:firestart/view/user_detail.dart';
import 'package:firestart/widgets/drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
class MainPage extends StatefulWidget {

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final uid = FirebaseAuth.instance.currentUser!.uid;

late types.User user;

  @override
  void initState() {
    super.initState();

    // 1. This method call when app in terminated state and you get a notification
    // when you click on notification app open from terminated state and you can get notification data in this method

    FirebaseMessaging.instance.getInitialMessage().then(
          (message) {
        print("FirebaseMessaging.instance.getInitialMessage");
        if (message != null) {
          print("New Notification");
          // if (message.data['_id'] != null) {
          //   Navigator.of(context).push(
          //     MaterialPageRoute(
          //       builder: (context) => DemoScreen(
          //         id: message.data['_id'],
          //       ),
          //     ),
          //   );
          // }
          LocalNotificationService.createanddisplaynotification(message);
        }
      },
    );

    // 2. This method only call when App in forground it mean app must be opened
    FirebaseMessaging.onMessage.listen(
          (message) {
        print("FirebaseMessaging.onMessage.listen");
        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
          print("message.data11 ${message.data}");
          LocalNotificationService.createanddisplaynotification(message);

        }
      },
    );

    // 3. This method only call when App in background and not terminated(not closed)
    FirebaseMessaging.onMessageOpenedApp.listen(
          (message) {
        print("FirebaseMessaging.onMessageOpenedApp.listen");
        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
          print("message.data22 ${message.data['_id']}");
          LocalNotificationService.createanddisplaynotification(message);
        }
      },
    );

    getToken();
  }



  Future<void> getToken()async{
    final response = await FirebaseMessaging.instance.getToken();
    print(response);
  }



  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final userData = ref.watch(usersStream);
      final postData = ref.watch(postStream);
      return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.purple,
            title: Text('Fire App'),
            actions: [
              TextButton(onPressed: (){
                Get.to(() => RecentChats(), transition: Transition.leftToRight);
              }, child: Text('Recent Chats', style: TextStyle(color: Colors.white),))
            ],
          ),
          drawer: DrawerWidget(),
          body: ListView(
            children: [
              Container(
                height: 170,
                child: userData.when(
                    data: (data) {
                      user = data.firstWhere((element) => element.metadata!['userId'] == uid);
                      final dat = data
                          .where((element) => element.metadata!['userId'] != uid)
                          .toList();
                      return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: dat.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  InkWell(
                                    onTap: (){
                                      Get.to(() => UserDetail(dat[index]), transition: Transition.leftToRight);
                                    },
                                    child: CircleAvatar(
                                      radius: 40,
                                      backgroundImage:
                                          NetworkImage(dat[index].imageUrl!),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(dat[index].firstName!)
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
                                               if(dat.like.usernames.contains(user.firstName)){
                                                 ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                     duration: Duration(seconds: 1),
                                                     content: Text('You\'ve already like this post')));
                                               }else{
                                                 ref.read(crudProvider).addLike(
                                                     postId: dat.id, like: dat.like.likes, username: user.firstName!);
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
