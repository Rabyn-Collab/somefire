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
        final userData = ref.watch(currentUserStream);
       final isLoad =  ref.watch(loadingProvider);
        return Drawer(
            child: userData.when(
                data: (data){
                  return ListView(
                    children: [
                    DrawerHeader(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(data.imageUrl!),
                              colorFilter: ColorFilter.mode(
                              Colors.black26,
                              BlendMode.darken
                              ),
                              fit: BoxFit.cover)
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(data.firstName!, style: TextStyle(color: Colors.white),),
                            Text(data.metadata!['email'],style: TextStyle(color: Colors.white)),
                          ],
                        )
                    ),


                      ListTile(
                        onTap: (){
                          Navigator.of(context).pop();
           Get.to(() =>CreatePage(), transition: Transition.leftToRight);
                        },
                        leading: Icon(Icons.add_box_sharp),
                        title: Text('post create'),
                      ),
                      ListTile(
                        onTap: (){
                          Navigator.of(context).pop();
                          if(isLoad){
                            ref.read(loadingProvider.notifier).toggle();
                          }
                          ref.read(authProvider).userLogOut();
                        },
                        leading: Icon(Icons.exit_to_app),
                        title: Text('user LogOut'),
                      ),

                    ],
                  );
                },
                error: (err, stack) => Center(child: Text('$err'),),
                loading: () => Center(child: CircularProgressIndicator(),)
            )
        );
      }
    );
  }
}
