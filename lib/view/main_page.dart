import 'package:firestart/api.dart';
import 'package:firestart/providers/auth_provider.dart';
import 'package:firestart/providers/crud_provider.dart';
import 'package:firestart/view/cart_page.dart';
import 'package:firestart/view/create_page.dart';
import 'package:firestart/view/customize_page.dart';
import 'package:firestart/view/detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import 'order_page.dart';




class MainPage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SampleShop'),
        backgroundColor: Colors.purple,
        actions: [
          IconButton(
              onPressed: (){
            Get.to(() => CartPage(), transition: Transition.leftToRight);
          }, icon: Icon(Icons.shopping_cart))
        ],
      ),
        body: Consumer(
            builder: (context, ref, child) {
              final authData = ref.watch(authProvider);
              final products = ref.watch(productProvider);
              return products.when(
                  data: (data){
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GridView.builder(
                        itemCount: data.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 5,
                            crossAxisSpacing: 5,
                            childAspectRatio: 3/2
                          ),
                          itemBuilder: (context, index){
                           return InkWell(
                             onTap: (){
                               Get.to(() => DetailPage(data[index]), transition: Transition.leftToRight);
                             },
                             child: GridTile(
                                 child: Hero(
                                     tag: data[index].image,
                                     child: Image.network('${Api.baseUrl}/${data[index].image}', fit: BoxFit.cover,)),
                             footer: Container(
                               height: 30,
                               color: Colors.black,
                               child: Padding(
                                 padding: const EdgeInsets.symmetric(horizontal: 10),
                                 child: Row(
                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                   children: [
                                     Text(data[index].product_name, style: TextStyle(color: Colors.white),),
                                     Text('Rs.' + data[index].price.toString(), style: TextStyle(color: Colors.white),),
                                   ],
                                 ),
                               ),
                             ),
                             ),
                           );
                          }
                      ),
                    );
                  },
                  error: (err, stack) => Center(child: Text('$err')),
                  loading: () => Center(child: CircularProgressIndicator(),)
              );
            }
    ),
      drawer: Consumer(
        builder: (context, ref, child) {
          final authData = ref.watch(authProvider);
          return Drawer(
            child: ListView(
              children: [
                DrawerHeader(child: Text(authData[0].username)),
                ListTile(
                  leading: Icon(Icons.mail),
                  title: Text(authData[0].email),
                ),
                ListTile(
                  onTap: (){
                    Navigator.of(context).pop();
                    Get.to(() => CustomizePage(), transition: Transition.leftToRight);
                  },
                  leading: Icon(Icons.settings_rounded),
                  title: Text('customize product'),
                ),
                ListTile(
                  onTap: (){
                    Navigator.of(context).pop();
                    Get.to(() => CreatePage(), transition: Transition.leftToRight);
                  },
                  leading: Icon(Icons.add_business_rounded),
                  title: Text('create product'),
                ),

                ListTile(
                  onTap: (){
                    Navigator.of(context).pop();
                    Get.to(() => OrderPage(), transition: Transition.leftToRight);
                  },
                  leading: Icon(Icons.access_time_filled_rounded),
                  title: Text('order history'),
                ),

                ListTile(
                  onTap: (){
                    Navigator.of(context).pop();
                    ref.read(authProvider.notifier).userLogOut();
                  },
                  leading: Icon(Icons.exit_to_app),
                  title: Text('logOut'),
                ),
              ],
            ),
          );
        }
      ),
    );
  }
}
