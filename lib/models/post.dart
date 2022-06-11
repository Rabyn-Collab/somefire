
class Like{
  final int likes;
  final List<String> usernames;

  Like({required this.usernames, required this.likes});

  factory Like.fromJson(Map<String, dynamic> json){
    return Like(
        usernames: (json['usernames'] as List).map((e) => e as String).toList(),
        likes: json['likes']);
  }

  Map<String, dynamic> toJson(){
    return {
      'likes': this.likes,
      'usernames': this.usernames
    };
  }



}


class Comment{
  final String username;
  final String comment;
  final String userImage;

  Comment({required this.username, required this.comment,  required this.userImage});

  factory Comment.fromJson(Map<String, dynamic> json){
    return Comment(
       username: json['username'],
       comment: json['comment'],
      userImage: json['userImage']
    );
  }


  Map<String, dynamic> toJson(){
    return {
      'username': this.username,
      'comment': this.comment,
      'userImage': this.userImage
    };
  }



}





class Post{

  final String id;
  final String userId;
  final String title;
  final String imageUrl;
  final  String imageId;
  final String description;
  final List<Comment> comments;
  final Like like;

  Post({
    required this.like,
    required this.imageUrl,
    required this.title,
    required this.userId,
    required this.id,
    required this.imageId,
    required this.comments,
    required this.description
});





}