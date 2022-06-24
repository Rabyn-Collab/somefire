import 'dart:io';
import 'package:firestart/api.dart';
import 'package:firestart/models/product.dart';
import 'package:firestart/providers/crud_provider.dart';
import 'package:firestart/providers/image_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



class EditPage extends StatelessWidget {

final Product product;
EditPage(this.product);
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
                    Text( 'Edit Form' , style: TextStyle(fontSize: 18),),
                    SizedBox(height: 20,),
                    TextFormField(
                      controller: titleController..text = product.product_name,
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
                      controller: descController..text = product.product_detail,
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
                      controller: priceController..text = product.price.toString(),
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
                        child: image == null ? Image.network('${Api.baseUrl}/${product.image}')  : Image.file(File(image.path)),
                      ),
                    ),

                    SizedBox(height: 20,),

                    ElevatedButton(
                        onPressed: () async{
                          _form.currentState!.save();
                          if(_form.currentState!.validate()){
                             if(image == null){
                               final response = await ref.read(crudProvider).updateProduct(
                                   label: titleController.text.trim(),
                                   detail: descController.text.trim(),
                                   price: int.parse(priceController.text.trim()),
                                   productId: product.id
                               );
                               ref.refresh(productProvider);
                               if(response == 'success'){
                                 Navigator.of(context).pop();
                               }
                             }else{
                               final response = await ref.read(crudProvider).updateProduct(
                                   label: titleController.text.trim(),
                                   detail: descController.text.trim(),
                                   price: int.parse(priceController.text.trim()),
                                   productId: product.id,
                                 image: image,
                                 imagePath: product.image
                               );
                               ref.refresh(productProvider);
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
