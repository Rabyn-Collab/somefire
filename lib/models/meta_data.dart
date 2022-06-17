


class Metas{

  final String email;
  final String userId;
  final String userToken;


  Metas({required this.userToken, required this.email, required this.userId});

  factory Metas.fromJson(Map<String, dynamic> json){
    return Metas(
    userToken: json['userToken'],
    email: json['email'],
    userId: json['userId']
  );

  }

}