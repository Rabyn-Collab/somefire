import 'dart:io';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firestart/models/post.dart';
import 'package:firestart/models/user.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';



final usersStream = StreamProvider((ref) => CrudProvider().getUsers());
final currentUserStream =StreamProvider.autoDispose((ref) => CrudProvider().getSingleUser());
final crudProvider = Provider((ref) => CrudProvider());
final postStream = StreamProvider((ref) => CrudProvider().getPostsStream());

class CrudProvider{

  CollectionReference userDb = FirebaseFirestore.instance.collection('users');
  CollectionReference postDb = FirebaseFirestore.instance.collection('posts');

  Stream<types.User> getSingleUser(){
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final response = userDb.doc(uid).snapshots();

    final userType = response.map((event) {
      final json = event.data() as Map<String, dynamic>;
      return types.User(
        id: event.id,
        imageUrl: json['imageUrl'],
        metadata: {
          'email': json['metadata']['email'],
          'userToken': json['metadata']['userToken']
        },
        firstName: json['firstName'],
      );
    } );
    return userType;

  }


  Stream<List<types.User>> getUsers(){
    return userDb.snapshots().map((event) => getUserData(event));
  }

  List<types.User>  getUserData(QuerySnapshot snapshot){
    final response = snapshot.docs.map((event) {
      final json = event.data() as Map<String, dynamic>;
      return types.User(
        id: event.id,
        imageUrl: json['imageUrl'],
        metadata: {
          'email': json['metadata']['email'],
          'userToken': json['metadata']['userToken']
        },
        firstName: json['firstName'],
      );
    }).toList();

    return response;
  }


  Future<String> addPostData({required String title, required String description, required XFile image, required String userId}) async{
    try{
      final imageName = image.name;
      final imageFile = File(image.path);
      final ref = FirebaseStorage.instance.ref().child('postImage/$imageName');
      await ref.putFile(imageFile);
      final url = await ref.getDownloadURL();
      await postDb.add({
      'userId': userId,
      'title': title,
      'imageUrl': url,
        'imageId': imageName,
      'description': description,
      'comments': [],
      'like': {
        'likes': 0,
        'usernames': []
      }
      });
      return 'success';
    }on FirebaseException catch (err){
      return '${err.message}';
    }

  }


  Future<String> updateData({required String title, required String description, XFile? image, required String postId,
    String? photoId
  }) async{
    try{
      if(image == null){
        await postDb.doc(postId).update({
          'title': title,
          'description': description,
        });
      }else{
        final oldRef = FirebaseStorage.instance.ref().child('postImage/$photoId');
      await oldRef.delete();
        final imageName = image.name;
        final imageFile = File(image.path);
        final newRef = FirebaseStorage.instance.ref().child('postImage/$imageName');
        await newRef.putFile(imageFile);
        final url = await newRef.getDownloadURL();

        await postDb.doc(postId).update({
          'title': title,
          'description': description,
          'imageUrl': url,
          'imageId': imageName,
        });
      }
      return 'success';
    }on FirebaseException catch (err){
      return '${err.message}';
    }

  }


  Future<String> removeData({required String postId, required String photoId
  }) async{
    try{
        final oldRef = FirebaseStorage.instance.ref().child('postImage/$photoId');
        await oldRef.delete();
        await postDb.doc(postId).delete();
      return 'success';
    }on FirebaseException catch (err){
      return '${err.message}';
    }

  }


  Future<String> addLike({required String postId, required int like, required String username
  }) async{
    try{
      await postDb.doc(postId).update({
        'like': {
          'likes': like + 1,
          'usernames': FieldValue.arrayUnion([username])
        }
      });
      return 'success';
    }on FirebaseException catch (err){
      return '${err.message}';
    }

  }


  Future<String> addComment({required String postId, required Comment comment}) async{
    try{
      await postDb.doc(postId).update({
          'comments': FieldValue.arrayUnion([comment.toJson()])

      });
      return 'success';
    }on FirebaseException catch (err){
      return '${err.message}';
    }

  }




  Stream<List<Post>> getPostsStream(){
    return postDb.snapshots().map((event) => getPost(event));
  }

  List<Post>  getPost(QuerySnapshot snapshot){
    return  snapshot.docs.map((e) {
      final json = e.data() as Map<String, dynamic>;
      return Post(
          like: Like.fromJson(json['like']),
          imageUrl: json['imageUrl'],
          title: json['title'],
          userId: json['userId'],
          id: e.id,
          imageId: json['imageId'],
          comments: (json['comments'] as List).map((e) => Comment.fromJson(e)).toList(),
          description: json['description']
      );
    }).toList();
  }





}



