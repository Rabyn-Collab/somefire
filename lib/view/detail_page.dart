import 'package:firestart/models/post.dart';
import 'package:firestart/models/user.dart';
import 'package:firestart/providers/crud_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



class DetailPage extends StatelessWidget {
final Post post;
final UserData user;
DetailPage(this.post, this.user);
final commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
        body: Consumer(
          builder: (context, ref, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(post.imageUrl),
                SizedBox(height: 10,),
                Text(post.title),
                SizedBox(height: 10,),
                Text(post.description),
                Container(
                    height: 535,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: commentController,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'please provide comment';
                            }
                            return null;
                          },
                          onFieldSubmitted: (val) {
                            final newComment = Comment(
                                username: user.username,
                               comment: val,
                                userImage: user.userImageUrl);
                            ref.read(crudProvider).addComment(postId: post.id, comment: newComment);
                          },
                          decoration: InputDecoration(
                              hintText: 'add some comment'
                          ),
                        ),
                        SizedBox(height: 10,),


                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: post.comments.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                            leading: Image.network(post.comments[index].userImage),
                                title: Text(post.comments[index].username),
                                subtitle: Text(post.comments[index].comment),
                              );
                            }
                        )

                      ],
                    )
                )

              ],
            );
          }
        )
    );
  }
}
