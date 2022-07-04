import 'package:firestart/api.dart';
import 'package:firestart/providers/auth_provider.dart';
import 'package:firestart/providers/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';



class OrderPage extends StatelessWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Consumer(
            builder: (context, ref, child) {
              final box = ref.watch(authProvider);
              final orderData = ref.watch(historyProvider(box[0].id));
              return orderData.when(
                  data: (data){
                    return data.isEmpty ? Center(
                      child: Container(
                        child: Text('There is no order history to show'),
                      ),
                    ) : ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index){

                          final dateTime = DateTime.parse(data[index].dateTime);
                          final dateString = DateFormat('dd-MM-yyyy').format(dateTime);
                          String formattedDate = DateFormat.jm().format(dateTime);
                          print(formattedDate + ' ' + dateString);
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('$dateString $formattedDate'),
                                SizedBox(height: 10,),
                                Column(
                                  children: data[index].products.map((e){
                                    return Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                            height: 150,
                                            width: 200,
                                            child: Image.network('${Api.baseUrl}/${e.imageUrl}')),
                                        SizedBox(width: 50,),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(e.title),
                                            SizedBox(height: 70,),
                                            Text('${e.quantity} * ${e.price}')
                                          ],
                                        )

                                      ],
                                    );
                                  }).toList(),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Total:-'),
                                    Text('${data[index].amount}')
                                  ],
                                )

                              ],
                            ),
                          );
                        }
                    );
                  },
                  error: (err, stack) => Center(child: Text('$err')),
                  loading: () => Center(child:CircularProgressIndicator(
                    color: Colors.purple,
                  ) )
              );
            }
            )
    );
  }
}
