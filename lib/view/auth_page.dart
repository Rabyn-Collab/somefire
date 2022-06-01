import 'dart:io';

import 'package:firestart/providers/auth_provider.dart';
import 'package:firestart/providers/image_provider.dart';
import 'package:firestart/providers/loginProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';



class AuthPage extends StatelessWidget {

  final _form = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final mailController = TextEditingController();
  final passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer(
          builder: (context, ref, child) {
            final isLogin = ref.watch(loginProvider);
            final isView = ref.watch(isViewPro).isView;
            final image = ref.watch(imageProvider).image;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                   Text(isLogin ?  'Login Form' : 'SignUp Form', style: TextStyle(fontSize: 18),),
                    SizedBox(height: 20,),
                    if(isLogin == false) TextFormField(
                      controller: nameController,
                      validator: (val){
                        if(val!.isEmpty){
                          return 'please provide username';
                        }else if(val.length > 20){
                          return 'maximum character is 20';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          hintText: 'username'
                      ),
                    ),
                    SizedBox(height: 20,),
                    TextFormField(
                      validator: (val){
                        if(val!.isEmpty){
                          return 'please provide username';
                        }else if(!val.contains('@')){
                          return 'please provide valid email';
                        }
                        return null;
                      },
                      controller: mailController,
                      decoration: InputDecoration(
                          hintText: 'email'
                      ),
                    ),
                    SizedBox(height: 20,),

                    TextFormField(
                      controller: passController,
                      obscureText: isView,
                      validator: (val){
                        if(val!.isEmpty){
                          return 'please provide password';
                        }else if(val.length > 16 || val.length < 6){
                          return 'invalid password';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: (){
                           ref.read(isViewPro).toggle();
                          },
                        icon: Icon(Icons.remove_red_eye),
                        ),
                          hintText: 'password'
                      ),
                    ),
                    SizedBox(height: 20,),

                    if(isLogin == false) InkWell(
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
                            if(isLogin){


                            }else{

                              if(image == null){

                              }else{
                                await ref.read(authProvider).userSignUp(
                                    email: mailController.text.trim(),
                                    password: passController.text.trim(),
                                    userName: nameController.text.trim(),
                                    image: image);

                              }


                            }


                          }

                        }, child: Text('Submit')
                    ),
                    SizedBox(height: 20,),
                    Row(
                      children: [
                        Text(isLogin ? 'not a member' : 'already member'),


                        TextButton(
                            onPressed: (){
                              ref.read(loginProvider.notifier).toggle();

                            }, child: Text(isLogin ? 'SignUp' : 'Login')
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          }
        );
  }
}
