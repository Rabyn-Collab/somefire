//String id, String title, int quantity, String imageUrl, int total, int price;



import 'package:hive/hive.dart';
part 'cart_item.g.dart';


@HiveType(typeId: 1)
class CartItem extends HiveObject{
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final int quantity;

  @HiveField(3)
  final String imageUrl;

  @HiveField(4)
  final int price;

  @HiveField(5)
  final int total;

  CartItem({
    required this.imageUrl,
    required this.id,
    required this.title,
    required this.quantity,
    required this.price,
    required this.total
  });

  factory CartItem.fromJson(Map<String ,dynamic> json){
    return CartItem(
        id: json['id'],
        imageUrl: json['imageUrl'],
        price: json['price'],
        title: json['title'],
        total: json['total'],
        quantity: json['quantity']
    );
  }


}