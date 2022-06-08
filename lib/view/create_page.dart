import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firestart/providers/auth_provider.dart';
import 'package:firestart/providers/crud_provider.dart';
import 'package:firestart/providers/image_provider.dart';
import 'package:firestart/providers/loginProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';



class CreatePage extends StatelessWidget {

  final _form = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descController = TextEditingController();

final uid = FirebaseAuth.instance.currentUser!.uid;
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
                    Text( 'Create Form' , style: TextStyle(fontSize: 18),),
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
                        child: image == null ? Center(child: Text('please select image'),) : Image.file(File(image.path)),
                      ),
                    ),

                    SizedBox(height: 20,),

                    ElevatedButton(
                        onPressed: () async{
                          _form.currentState!.save();
                          if(_form.currentState!.validate()){
                              if(image == null){
                                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    duration: Duration(seconds: 1),
                                    content: Text('please select an image')));
                              }else{
                              final response =  await ref.read(crudProvider).addPostData(
                                 title: titleController.text.trim(),
                                    description: descController.text.trim(),
                                    userId: uid,
                                    image: image);
                              if(response == 'success'){
                                Navigator.of(context).pop();
                              }

                              }



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
