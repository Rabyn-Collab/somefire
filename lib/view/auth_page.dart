import 'package:firestart/providers/loginProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';



class AuthPage extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Consumer(
          builder: (context, ref, child) {
            final isLogin = ref.watch(loginProvider);
            final isView = ref.watch(isViewPro).isView;
            print(isView);
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: [
                 Text(isLogin ?  'Login Form' : 'SignUp Form', style: TextStyle(fontSize: 18),),
                  SizedBox(height: 20,),
                  if(isLogin == false) TextFormField(
                    decoration: InputDecoration(
                        hintText: 'username'
                    ),
                  ),
                  SizedBox(height: 20,),
                  TextFormField(
                    decoration: InputDecoration(
                        hintText: 'email'
                    ),
                  ),
                  SizedBox(height: 20,),

                  TextFormField(
                    obscureText: isView,
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

                  if(isLogin == false) Container(
                    decoration:  BoxDecoration(
                      border: Border.all(color: Colors.black)
                    ),
                    height: 150,
                    width: 150,
                    child: Center(child: Text('please select image'),),
                  ),

                  SizedBox(height: 20,),

                  ElevatedButton(
                      onPressed: (){

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
            );
          }
        )
    );
  }
}
