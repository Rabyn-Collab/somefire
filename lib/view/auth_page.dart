import 'dart:io';

import 'package:firestart/providers/auth_provider.dart';
import 'package:firestart/providers/image_provider.dart';
import 'package:firestart/providers/loginProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
            final isLoad = ref.watch(loadingProvider);
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

                    ElevatedButton(
                       style: ElevatedButton.styleFrom(
                         minimumSize: Size(200, 45)
                       ),
                        onPressed: () async{
                          _form.currentState!.save();
                          SystemChannels.textInput.invokeMethod('TextInput.hide');
                          if(isLogin){
                            ref.read(authProvider.notifier).userLogin(
                                email: mailController.text.trim(),
                                password: passController.text.trim(),
                            );
                          }else{
                            ref.read(authProvider.notifier).userSignUp(
                                email: mailController.text.trim(),
                                password: passController.text.trim(),
                                full_name: nameController.text.trim()
                            );
                          }

                        }, child:isLoad ?  Center(child: CircularProgressIndicator(
                      color: Colors.white,
                    )): Text('Submit')
                    ),
                    SizedBox(height: 20,),
                    Row(
                      children: [
                        Text(isLogin ? 'not a member' : 'already member'),
                        TextButton(
                            onPressed: (){
                              ref.read(loginProvider.notifier).toggle();

                            }, child:  Text(isLogin ? 'SignUp' : 'Login')
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
