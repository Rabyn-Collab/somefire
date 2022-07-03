



import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firestart/api.dart';
import 'package:firestart/models/cart_item.dart';
import 'package:firestart/models/order.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/user.dart';

final orderProvider = Provider((ref) => OrderProvider());
final historyProvider = FutureProvider.family((ref, String id) => OrderProvider().getOrderHistory(id: id));
class OrderProvider {


  Future<List<Order>> getOrderHistory({required String id}) async{
    final box = Hive.box<User>('users').values.toList();
    final dio = Dio();
    try{
      final response = await dio.get('${Api.orderHistory}/$id', options: Options(
          headers: {
            HttpHeaders.authorizationHeader:  'Bearer ${box[0].token}',
          }
      ));
      final  data = (response.data as List).map((e) =>Order.fromJson(e)).toList();
      return data;
    }on DioError catch (err){
      throw '${err.message}';
    }
  }



  Future<String> addOrder({ required int total, required List<CartItem> carts}) async{
    final dio = Dio();
    final box = Hive.box<User>('users').values.toList();
    try{

      final response = await dio.post(Api.orderCreate, data: {
        'amount': total,
        'dateTime': DateTime.now().toString(),
       'products': carts.map((e) => e.toJson()).toList(),
        'id': box[0].id
      }, options: Options(
          headers: {
            HttpHeaders.authorizationHeader:  'Bearer ${box[0].token}',
          }
      )
      );
      return 'success';
    }on DioError catch (err){
      print(err.message);
      print(err.response);
      return '${err.message}';
    }
  }




}