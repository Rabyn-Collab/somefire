import 'package:firestart/api.dart';
import 'package:firestart/models/product.dart';
import 'package:firestart/providers/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';




class DetailPage extends StatelessWidget {
 final Product product;
  DetailPage(this.product);
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    return Scaffold(

      backgroundColor: Colors.purple,
        body: SafeArea(
          child: Container(
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(37)
                    ),
                  ),
                  margin: EdgeInsets.only(top: height * 0.30),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 70, left: 15, right: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Align(
                                  alignment: Alignment.topLeft,
                                  child: Text('Description:-', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600),)),
                              SizedBox(height: 10,),
                              Text(product.product_detail),
                            ],
                          ),
                        ),
                        Consumer(
                          builder: (context, ref, child) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.black,
                                      minimumSize: Size(0, 50),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              25)
                                      )
                                  ),
                                  onPressed: () {
                                 final response = ref.read(cartProvider.notifier).addToCart(product);
                                 if(response == 'success'){
                                 //  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                     duration: Duration(milliseconds: 1500),
                                       content: Text('success fully added to cart'),
                                     action: SnackBarAction(
                                         label: 'Go to Cart',
                                         onPressed: (){

                                         }),
                                   ));
                                 }else{
                                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                       duration: Duration(milliseconds: 1500),
                                       content: Text(response),
                                     action: SnackBarAction(
                                         label: 'Go to Cart',
                                         onPressed: (){

                                         }),
                                   ));
                                 }
                                  },
                                  child: Text('add to cart'.toUpperCase(),
                                    style: TextStyle(fontSize: 15),)),
                            );
                          }
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product.product_name, style: TextStyle(fontSize: 20, color: Colors.white),),
                      SizedBox(height: height * 0.07,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 50),
                            child: Text('Rs. ${product.price}', style: TextStyle(fontSize: 17, color: Colors.white),),
                          ),
                         SizedBox(width: 20,),
                          Expanded(child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Hero(
                                  tag: product.image,
                                  child: Image.network('${Api.baseUrl}/${product.image}')))),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        )
    );
  }
}
