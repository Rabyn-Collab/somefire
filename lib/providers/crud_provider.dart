import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestart/models/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



final usersStream = StreamProvider((ref) => CrudProvider().getUsersStream());

class CrudProvider{

  CollectionReference userDb = FirebaseFirestore.instance.collection('users');

  Stream<List<UserData>> getUsersStream(){
     return userDb.snapshots().map((event) => getData(event));
  }

  List<UserData>  getData(QuerySnapshot snapshot){
      return  snapshot.docs.map((e) => UserData.fromJson(e.data() as Map<String, dynamic>)).toList();
  }















}



