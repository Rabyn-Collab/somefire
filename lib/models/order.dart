import 'cart_item.dart';



class Order{

  final int amount;
  final String dateTime;
  final List<CartItem> products;
  final String userId;


  Order({
    required this.dateTime,
    required this.userId,
    required this.products,
    required this.amount
});

  factory Order.fromJson(Map<String, dynamic> json){
    return Order(
        dateTime: json['dateTime'],
        userId: json['userId'],
        products: (json['products'] as List).map((e) => CartItem.fromJson(e)).toList(),
        amount: json['amount']
    );
  }


}