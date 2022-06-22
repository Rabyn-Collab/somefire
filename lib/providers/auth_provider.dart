import 'package:dio/dio.dart';
import 'package:firestart/api.dart';
import 'package:firestart/main.dart';
import 'package:firestart/models/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';



final authProvider = StateNotifierProvider<AuthProvider, List<User>>((ref) => AuthProvider(ref.read(boxProvider)));

class AuthProvider extends StateNotifier<List<User>>{
  AuthProvider(super.state);


  Future<void> userSignUp({required String email, required String password, required String full_name}) async{
    final dio = Dio();
    try{
      final response = await dio.post(Api.register, data: {
        'email': email,
        'full_name': full_name,
        'password': password
      });

      final newUser = User.fromJson(response.data);
      Hive.box<User>('users').add(newUser);
      state = [newUser];

    }on DioError catch (err){
         print(err);
    }
  }

  Future<void> userLogin({required String email, required String password}) async{
    final dio = Dio();
    try{
      final response = await dio.post(Api.login, data: {
        'email': email,
        'password': password
      });

      final newUser = User.fromJson(response.data);
      Hive.box<User>('users').add(newUser);
      state = [newUser];

    }on DioError catch (err){
      print(err);
    }
  }

  Future<void> userLogOut() async{
    final dio = Dio();
    try{
      Hive.box<User>('users').clear();
      state = [];
    }on DioError catch (err){
      print(err);
    }
  }




}



