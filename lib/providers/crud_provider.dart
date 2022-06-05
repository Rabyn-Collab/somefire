import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firestart/models/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



final usersStream = StreamProvider((ref) => CrudProvider().getUsersStream());
final currentUserStream =StreamProvider.autoDispose((ref) => CrudProvider().getUserStream());

class CrudProvider{

  CollectionReference userDb = FirebaseFirestore.instance.collection('users');

  Stream<List<UserData>> getUsersStream(){
     return userDb.snapshots().map((event) => getData(event));
  }

  List<UserData>  getData(QuerySnapshot snapshot){
      return  snapshot.docs.map((e) => UserData.fromJson(e.data() as Map<String, dynamic>)).toList();
  }

  Stream<UserData> getUserStream(){
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final userSnap = userDb.where('userId', isEqualTo: uid).snapshots();
    return userSnap.map((event) => getDat(event));
  }

  UserData  getDat(QuerySnapshot snapshot){
    return  UserData.fromJson(snapshot.docs[0].data() as Map<String, dynamic>);
  }


}



