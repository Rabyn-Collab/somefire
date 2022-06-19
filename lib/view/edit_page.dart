import 'dart:io';
import 'package:firestart/providers/auth_provider.dart';
import 'package:firestart/providers/crud_provider.dart';
import 'package:firestart/providers/image_provider.dart';
import 'package:firestart/providers/loginProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';



class EditPage extends StatelessWidget {


  final _form = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(
          builder: (context, ref, child) {
            final image = ref.watch(imageProvider).image;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    Text( 'Edit Form' , style: TextStyle(fontSize: 18),),
                    SizedBox(height: 20,),
                    TextFormField(
                      controller: titleController,
                      validator: (val){
                        if(val!.isEmpty){
                          return 'please provide title';
                        }else if(val.length > 50){
                          return 'maximum character is 50';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          hintText: 'title'
                      ),
                    ),
                    SizedBox(height: 20,),
                    TextFormField(
                      validator: (val){
                        if(val!.isEmpty) {
                          return 'please provide description';
                        }
                        return null;
                      },
                      controller: descController,
                      decoration: InputDecoration(
                          hintText: 'description'
                      ),
                    ),
                    SizedBox(height: 20,),
                    InkWell(
                      onTap: (){
                        ref.read(imageProvider).imagePick();
                      },
                      child: Container(
                        decoration:  BoxDecoration(
                            border: Border.all(color: Colors.black)
                        ),
                        height: 150,
                        width: 150,
                        //child: image == null ? Image.network(post.imageUrl)  : Image.file(File(image.path)),
                      ),
                    ),

                    SizedBox(height: 20,),

                    ElevatedButton(
                        onPressed: () async{
                          _form.currentState!.save();
                          if(_form.currentState!.validate()){


                          }

                        }, child: Text('Submit')
                    ),


                  ],
                ),
              ),
            );
          }
      ),
    );
  }
}
