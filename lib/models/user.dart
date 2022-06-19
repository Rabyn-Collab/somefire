import 'package:hive/hive.dart';
part 'user.g.dart';


@HiveType(typeId: 0)
class User extends HiveObject{
  @HiveField(0)
  final String username;

  @HiveField(1)
  final String email;

  @HiveField(2)
  final String token;

  @HiveField(3)
  final String id;


  User({
    required this.id,
    required this.username,
    required this.email,
    required this.token
});

  factory User.fromJson(Map<String ,dynamic> json){
     return User(
         id: json['id'],
         username: json['username'],
         email: json['email'],
         token: json['token']
     );
  }


}