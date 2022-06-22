import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firestart/api.dart';
import 'package:firestart/models/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';


final crudProvider = Provider((ref) => CrudProvider());


class CrudProvider {

  Future<String> productAdd({required String label, required String detail, required int price, required XFile image}) async{
    final dio = Dio();
    final box = Hive.box<User>('users').values.toList();
   print(box[0].token);
    try{
      final _formData = FormData.fromMap({
        'product_name': label,
        'product_detail':  detail,
        'price': price,
        'image':  await MultipartFile.fromFile(image.path, contentType: MediaType(
            'image', image.path.split('.').last)),
      });

     final response = await dio.post(Api.postAdd, data: _formData, options: Options(
       headers: {
         HttpHeaders.authorizationHeader:  'Bearer${box[0].token}',
       }
     ));
     return 'success';
    }on DioError catch (err){
      print(err.message);
      print(err.response);
     return '${err.message}';
    }
  }



}