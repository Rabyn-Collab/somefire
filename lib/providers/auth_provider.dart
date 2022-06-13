import 'dart:io';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';

final authProvider = Provider((ref) => AuthProvider());
final authStream = StreamProvider.autoDispose((ref) => FirebaseAuth.instance.authStateChanges());

class AuthProvider{


  CollectionReference userDb = FirebaseFirestore.instance.collection('users');

    Future<String> userLogin({required String email, required String password}) async{
       try{
       final response =   await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
         return 'success';
       }on FirebaseAuthException catch (err){
          return '${err.message}';
       }
    }


    Future<String> userSignUp({required String email,
      required String password, required String userName, required XFile image}) async{
      try{
        final imageName = image.name;
        final imageFile = File(image.path);
        final ref = FirebaseStorage.instance.ref().child('userImage/$imageName');
        await ref.putFile(imageFile);
        final url = await ref.getDownloadURL();
        final response = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
        await FirebaseChatCore.instance.createUserInFirestore(
            types.User(
              firstName: userName,
                id: response.user!.uid,
              imageUrl: url,
              metadata: {
                'email': email,
                'userId': response.user!.uid
              }
            )
        );
        return 'success';
      }on FirebaseAuthException catch (err){
        return '${err.message}';
      }
    }


    Future<String> userLogOut() async{
      try{
        await FirebaseAuth.instance.signOut();
        return 'success';
      }on FirebaseAuthException catch (err){
        return '${err.message}';
      }
    }




}