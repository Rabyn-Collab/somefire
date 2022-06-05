import 'package:firestart/providers/auth_provider.dart';
import 'package:firestart/providers/crud_provider.dart';
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
        return Drawer(
            child: userData.when(
                data: (data){
                  return ListView(
                    children: [
                    DrawerHeader(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(data.userImageUrl),
                              colorFilter: ColorFilter.mode(
                              Colors.black26,
                              BlendMode.darken
                              ),
                              fit: BoxFit.cover)
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(data.username, style: TextStyle(color: Colors.white),),
                            Text(data.email,style: TextStyle(color: Colors.white)),
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
                          ref.read(authProvider).userLogOut();
                        },
                        leading: Icon(Icons.exit_to_app),
                        title: Text('user LogOut'),
                      ),

                    ],
                  );
                },
                error: (err, stack) => Center(child: Text('something went wrong'),),
                loading: () => Center(child: CircularProgressIndicator(),)
            )
        );
      }
    );
  }
}