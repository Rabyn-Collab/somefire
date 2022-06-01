



class UserData{
  final String username;
  final String userId;
  final String email;
  final String userImageUrl;


  UserData({
    required this.userId,
    required this.username,
    required this.email,
    required this.userImageUrl
});

  factory UserData.fromJson(Map<String ,dynamic> json){
     return UserData(
         userId: json['userId'],
         username: json['username'],
         email: json['email'],
         userImageUrl: json['userImageUrl']
     );
  }


}