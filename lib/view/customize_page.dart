import 'package:firestart/providers/crud_provider.dart';
import 'package:firestart/view/edit_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import '../api.dart';




class CustomizePage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:  Consumer(
            builder: (context, ref, child) {
              final products = ref.watch(productProvider);
              return products.when(
                  data: (data){
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (context, index){
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: ListTile(
                                leading: Image.network('${Api.baseUrl}/${data[index].image}', fit: BoxFit.cover,),
                                title: Text(data[index].product_name),
                                trailing: Container(
                                  width: 100,
                                  child: Row(
                                    children: [
                                    IconButton(
                                        onPressed: (){
                                          Get.to(() => EditPage(data[index]), transition: Transition.leftToRight);
                                        }, icon: Icon(Icons.edit)),
                                    IconButton(
                                        onPressed: (){

                                        }, icon: Icon(Icons.delete)
                                    ),
                                    ],
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

    );
  }
}
