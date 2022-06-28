import 'package:firestart/providers/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api.dart';




class CartPage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Consumer(
        builder: (context, ref, child) {
          final cartData = ref.watch(cartProvider);
          final total = ref.watch(cartProvider.notifier).total;
          return Scaffold(
              body: cartData.isEmpty ?  Container(
                child: Center(child: Text('add some item to cart'),),
              ) : Column(
                children: [
                  Expanded(
                    child: Container(
                      child: ListView.builder(
                          itemCount: cartData.length,
                          itemBuilder: (context, index){
                            final cart = cartData[index];
                            return Container(
                              height: 200,
                              width: double.infinity,
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  return Row(
                                    children: [
                                      Image.network(
                                          '${Api.baseUrl}/${cart.imageUrl}', width: constraints.maxWidth * 0.4,
                                        height: constraints.maxHeight,
                                        fit: BoxFit.fitHeight,),
                                      SizedBox(width: 20,),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(cart.title.toUpperCase()),
                                          Text('Rs.${cart.price}'),
                                          Text('x  ${cart.quantity}'),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 25),
                                            child: Row(
                                              children: [
                                                OutlinedButton(
                                                    onPressed: (){
                                                      ref.read(cartProvider.notifier).addSingle(cart);
                                                    }, child: Icon(Icons.add)),
                                                SizedBox(width: 30,),
                                                OutlinedButton(
                                                    onPressed: (){
                                                      ref.read(cartProvider.notifier).removeSingle(cart);
                                                    }, child: Icon(Icons.remove)),
                                              ],
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  );
                                }
                              ),
                            );
                          }),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Total', style: TextStyle(fontSize: 20),),
                            Text('$total', style: TextStyle(fontSize: 17),)
                          ],
                        ),
                        SizedBox(height: 10,),
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
                                    },
                                    child: Text('Check Out'.toUpperCase(),
                                      style: TextStyle(fontSize: 15),)),
                              );
                            }
                        ),
                      ],
                    ),
                  )
                ],
              )
          );
        }
          );
  }
}
