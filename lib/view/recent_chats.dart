import 'package:firebase_auth/firebase_auth.dart';
import 'package:firestart/providers/room_provider.dart';
import 'package:firestart/view/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';



class RecentChats extends StatelessWidget {

  final uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Consumer(
            builder: (context, ref, child) {
              final roomsData = ref.watch(roomStream);
              return roomsData.when(
                  data: (data){
                    return ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index){
                          final friend = data[index].users.firstWhere((element) => element.id !=uid);
                          return ListTile(
                            onTap: (){
                             Get.to(() => ChatPage(room: data[index], user: friend.metadata!['userToken']));
                            },
                            leading: CircleAvatar(
                         backgroundImage: NetworkImage(data[index].imageUrl!),
                            ),
                            title: Text(data[index].name!),
                          );
                        }
                    );
                  },
                  error: (err, stack) => Text('$err'),
                  loading: () => Center(child: CircularProgressIndicator(
                    color: Colors.purple,
                  ),)
              );
            }
              ));
  }
}
