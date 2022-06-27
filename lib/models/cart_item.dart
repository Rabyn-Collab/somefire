//String id, String title, int quantity, String imageUrl, int total, int price;



import 'package:hive/hive.dart';
part 'cart_item.g.dart';


@HiveType(typeId: 1)
class CartItem extends HiveObject{
  @HiveField(0)
   String id;

  @HiveField(1)
   String title;

  @HiveField(2)
   int quantity;

  @HiveField(3)
   String imageUrl;

  @HiveField(4)
   int price;

  @HiveField(5)
   int total;

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