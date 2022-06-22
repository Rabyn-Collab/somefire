import 'dart:io';
import 'package:firestart/providers/crud_provider.dart';
import 'package:firestart/providers/image_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';




class CreatePage extends StatelessWidget {

  final _form = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descController = TextEditingController();
  final priceController = TextEditingController();


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
                    TextFormField(
                      keyboardType: TextInputType.number,
                      validator: (val){
                        if(val!.isEmpty) {
                          return 'please provide price';
                        }
                        return null;
                      },
                      controller: priceController,
                      decoration: InputDecoration(
                          hintText: 'price'
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

                              }else{
                                final response = await ref.read(crudProvider).productAdd(
                                    label: titleController.text.trim(),
                                    detail: descController.text.trim(),
                                    price: int.parse(priceController.text.trim()),
                                    image: image);
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
